package("yasio")
    set_homepage("https://yasio.github.io/yasio")
    set_description("A multi-platform support c++11 library with focus on asio (asynchronous socket I/O) for any client applications.")
    set_license("MIT")
    set_urls("https://github.com/yasio/yasio/archive/refs/tags/v$(version).tar.gz")

    add_versions("4.1.0", "522738587a0e928346221a41fd169a8e5dabb580ac1b4af2fbba66a5db8e71d4")

    add_configs("http", {description = "Support http", default = false, type = "boolean"})

    add_deps("mbedtls")
    add_links("yasio")
    on_load(function (target)
        if target:is_plat("windows", "mingw") then
            target:add("deps", "wepoll")
        end
    end)
    on_install(function (package)
        local config_lines = io.readfile("yasio/config.hpp")
        local config_lines = config_lines:gsub("// #define YASIO_ENABLE_HPERF_IO 1", [[
#define YASIO_SSL_BACKEND 2
#define YASIO_ENABLE_HPERF_IO 1
]])
        io.writefile("yasio/config.hpp", config_lines)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        configs["http"] = package:config("http") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
    end)
