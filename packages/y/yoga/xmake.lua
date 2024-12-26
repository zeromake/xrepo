package("yoga")
    set_homepage("https://yogalayout.com")
    set_description("Yoga is a cross-platform layout engine which implements Flexbox.")
    set_license("MIT")
    set_urls("https://github.com/facebook/yoga/archive/v$(version).tar.gz")

    --insert version
    add_versions("3.2.1", "86b399ac31fd820d8ffa823c3fae31bb690b6fc45301b2a8a966c09b5a088b55")
    add_versions("3.2.0", "a963392c6c120a35f097b5b793d2b9b6684b94443ff873b0e521649a69a0b607")
    add_versions("3.1.0", "06ff9e6df9b2388a0c6ef8db55ba9bc2ae75e716e967cd12cf18785f6379159e")
    add_versions("3.0.4", "ef3ce5106eed03ab2e40dcfe5b868936a647c5f02b7ffd89ffaa5882dca3ef7f")
    add_versions("3.0.3", "0ae44f7d30f8130cdf63e91293e11e34803afbfd12482fe4ef786435fc7fa8e7")
    add_versions("2.0.1", "4c80663b557027cdaa6a836cc087d735bb149b8ff27cbe8442fc5e09cec5ed92")
    add_versions("2.0.0", "29eaf05191dd857f76b6db97c77cce66db3c0067c88bd5e052909386ea66b8c5")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("YGNodeNew", {includes = {"yoga/Yoga.h"}}))
    end)
