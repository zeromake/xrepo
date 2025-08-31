package("ogg")
    set_homepage("https://www.xiph.org/ogg")
    set_description("Reference implementation of the Ogg media container ")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/xiph/ogg/releases/download/v$(version)/libogg-$(version).tar.gz")

    --insert version
    add_versions("1.3.6", "95b643da661155d79db9de2fca55daed3a8d491039829def246aacb3d9201c81")
    add_versions("1.3.5", "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664")
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
        transforme_configfile("include/ogg/config_types.h.in", "build/config_types.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("oggpack_writeinit", {includes = {"ogg/ogg.h"}}))
    end)
