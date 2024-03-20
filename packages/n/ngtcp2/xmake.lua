package("ngtcp2")
    set_homepage("https://nghttp2.org/ngtcp2")
    set_description("ngtcp2 project is an effort to implement IETF QUIC protocol")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/ngtcp2/releases/download/v$(version)/ngtcp2-$(version).tar.gz")

    add_versions("1.4.0", "163e26e6e7531b8bbcd7ec53d2c6b4ff3cb7d3654fde37b091e3174d37a8acd7")
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    line = "${define "..line:split("%s+")[2].."}"
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("lib/includes/ngtcp2/version.h.in")
        transforme_configfile("cmakeconfig.h.in", "config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
