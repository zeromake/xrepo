package("aria2-zero")
    set_homepage("https://github.com/zeromake/aria2-zero")
    set_description("fork aria2 support msvc ")
    set_license("GPL-2.0")
    set_urls("https://github.com/zeromake/aria2-zero/archive/refs/tags/v2025.04.06-release.1.tar.gz")
    add_versions("2025.04.06-release.1", "91b6a8acc9e325997c65e818f6a9ce1d1a82a1c50ef9b729551c5eebf72178d7")
    add_deps(
        "zlib",
        "ssh2",
        "c-ares",
        "expat",
        "quictls",
        "boost.intl"
    )
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "shell32", "iphlpapi")
        add_syslinks("crypt32", "secur32")
    elseif is_plat("macosx") then
        add_frameworks("CoreFoundation", "Security")
    end
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)
