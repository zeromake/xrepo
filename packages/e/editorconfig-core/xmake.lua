package("editorconfig-core")
    set_homepage("https://editorconfig.org")
    set_description("EditorConfig core library written in C")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.12.9", "4aaa4e3883332aac7ec19c169dcf128f5f0f963f61d09beb299eb2bce5944e2c")
    add_versions("0.12.7", "f89d2e144fd67bdf0d7acfb2ac7618c6f087e1b3f2c3a707656b4180df422195")
    if is_plat("windows", "mingw") then
        add_syslinks("shlwapi")
    end
    add_deps("pcre2")
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}"
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("src/config.h.in", "config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("editorconfig_parse", {includes = {"editorconfig/editorconfig.h"}}))
    end)
