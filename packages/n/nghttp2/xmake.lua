package("nghttp2")
    set_homepage("https://nghttp2.org")
    set_description("nghttp2 - HTTP/2 C Library and tools")
    set_license("MIT")
    set_urls("https://github.com/nghttp2/nghttp2/releases/download/v$(version)/nghttp2-$(version).tar.gz")

    add_versions("1.62.0", "482e41a46381d10adbdfdd44c1942ed5fd1a419e0ab6f4a5ff5b61468fe6f00d")
    add_versions("1.61.0", "aa7594c846e56a22fbf3d6e260e472268808d3b49d5e0ed339f589e9cc9d484c")
    add_versions("1.60.0", "ca2333c13d1af451af68de3bd13462de7e9a0868f0273dea3da5bc53ad70b379")
    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "NGHTTP2_STATICLIB")
        else
            package:add("defines", "BUILDING_NGHTTP2")
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
        transforme_configfile("lib/includes/nghttp2/nghttp2ver.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
