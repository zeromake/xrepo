package("ngtcp2")
    set_homepage("https://nghttp2.org/ngtcp2")
    set_description("ngtcp2 project is an effort to implement IETF QUIC protocol")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/ngtcp2/releases/download/v$(version)/ngtcp2-$(version).tar.gz")

    add_versions("1.6.0", "0c6f140268ef80a86b146714f7dc7c03a94699d019cd1815870ba222cb112bf0")
    add_versions("1.5.0", "fbd9c40848c235736377ba3fd0b8677a05d39e7c39406769588a6595dda5636f")
    add_versions("1.4.0", "163e26e6e7531b8bbcd7ec53d2c6b4ff3cb7d3654fde37b091e3174d37a8acd7")
    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "NGTCP2_STATICLIB")
        else
            package:add("defines", "BUILDING_NGTCP2")
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
        transforme_configfile("lib/includes/ngtcp2/version.h.in")
        transforme_configfile("cmakeconfig.h.in", "config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
