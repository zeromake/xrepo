local options = {}

package("unibreak")
    set_homepage("https://github.com/adah1972/libunibreak")
    set_description("The Unicode breaking library")
    set_license("zlib")
    set_urls("https://github.com/adah1972/libunibreak/releases/download/libunibreak_5_0/libunibreak-$(version).tar.gz")
    
    add_versions("5.0", "58f2fe4f9d9fc8277eb324075ba603479fa847a99a4b134ccb305ca42adf7158")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("init_linebreak()", {includes = "linebreak.h"}))
    end)
