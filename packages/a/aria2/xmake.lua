package("aria2")
    set_homepage("https://aria2.github.io")
    set_description("aria2 is a lightweight multi-protocol & multi-source, cross platform download utility operated in command-line. It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink.")
    set_license("GPL-2.0")
    set_urls("https://github.com/aria2/aria2/releases/download/release-$(version)/aria2-$(version).tar.xz")

    --insert version
    add_versions("1.37.0", "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b")
    add_patches("1.37.0", path.join(os.scriptdir(), "patches/socketcore-logger-fix.patch"), "6fdfde0c07bd096168167690d0d8405b5937f23dfbb641c5ace73fe51f5ecfe1")
    add_patches("1.37.0", path.join(os.scriptdir(), "patches/android-lock-fix.patch"), "97dd927493d53f36554f8dcca5c4fc03d51838e5ff87406e76f6ea8f8e29dcdb")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp(path.join(os.scriptdir(), "port", "config.h.in"), "config.h.in")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
