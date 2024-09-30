package("uv")
    set_homepage("https://libuv.org")
    set_description("Cross-platform asynchronous I/O")
    set_license("MIT")
    set_urls("https://github.com/libuv/libuv/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.48.0", "8c253adb0f800926a6cbd1c6576abae0bc8eb86a4f891049b72f9e5b7dc58f33")
    if is_plat("windows", "mingw") then
        add_syslinks(
            "user32",
            "advapi32",
            "iphlpapi",
            "userenv",
            "ws2_32",
            "dbghelp",
            "ole32",
            "shell32"
        )
    end
    on_load(function (package)
        if package:config("shared") == true then
            package:add("defines", "USING_UV_SHARED=1")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("uv_run", {includes = {"uv.h"}}))
    end)
