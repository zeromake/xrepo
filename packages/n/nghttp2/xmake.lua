package("nghttp2")
    set_homepage("https://nghttp2.org")
    set_description("nghttp2 - HTTP/2 C Library and tools")
    set_license("MIT")
    set_urls("https://github.com/nghttp2/nghttp2/releases/download/v1.60.0/nghttp2-1.60.0.tar.gz")

    add_versions("1.60.0", "ca2333c13d1af451af68de3bd13462de7e9a0868f0273dea3da5bc53ad70b379")
    add_defines("BUILDING_NGHTTP2", "NGHTTP2_STATICLIB")
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
