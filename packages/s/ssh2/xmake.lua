package("ssh2")
    set_homepage("https://libssh2.org")
    set_description("libssh2 is a client-side C library implementing the SSH2 protocol")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/libssh2/libssh2/releases/download/libssh2-$(version)/libssh2-$(version).tar.gz")

    --insert version
    add_versions("1.11.1", "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7")
    add_versions("1.11.0", "3736161e41e2693324deb38c26cfdc3efe6209d634ba4258db1cecff6a5ad461")
    add_configs("quictls", {description = "use quictls", default = false, type = "boolean"})
    if is_plat("windows", "mingw") then
        add_syslinks("user32")
    end

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
        transforme_configfile("src/libssh2_config_cmake.h.in", "src/libssh2_config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        if package:config("quictls") then
            table.insert(configs, "--quictls=y")
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
