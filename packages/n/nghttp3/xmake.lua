package("nghttp3")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/nghttp3/releases/download/v1.2.0/nghttp3-1.2.0.tar.gz")

    add_versions("1.2.0", "0cc9b943f61a135e08b80bdcc4c1181f695df18fbb5fa93509a58d7d971dca75")
    add_deps("sfparse")
    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "NGHTTP3_STATICLIB")
        else
            package:add("defines", "BUILDING_NGHTTP3")
        end
    end)
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}"
                    if name == 'ssize_t' then
                        line = '${define HAVE_SSIZE_T}\n\n#ifndef HAVE_SSIZE_T\n${define ssize_t}\n#endif'
                    end
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("cmakeconfig.h.in", "config.h.in")
        transforme_configfile("lib/includes/nghttp3/version.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
