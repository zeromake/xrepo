local function getVersion(version)
    local versions ={
        ["2025.01.07-alpha"] = "archive/b5bd92f0175018588c06761ea9b6f7a20f2e886e.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("boost.intl")
    set_homepage("https://github.com/zeromake/boost.intl")
    set_description("拷贝 boost.locale 模块的 message 实现来作为跨平台的 libintl")
    set_license("BSL-1.0")
    local p = path.join(path.directory(os.projectfile()), "libs/boost.intl")
    if os.exists(p) and os.isdir(p) then
        set_sourcedir(p)
    else
        set_urls("https://github.com/zeromake/boost.intl/$(version)", {
            version = getVersion
        })
        --insert version
        add_versions("2025.01.07-alpha", "49c8177ec9ece6df0990a56ad17e52657f1979b4d17c263fb7cf399837c50984")
    end
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
