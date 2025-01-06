local function getVersion(version)
    local versions ={
        ["2025.01.06-alpha"] = "archive/1ac92c5887ae07461fe8de79f4b824ead9f5e626.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("boost.intl")
    set_homepage("https://github.com/zeromake/boost.intl")
    set_description("拷贝 boost.locale 模块的 message 实现来作为跨平台的 libintl")
    set_license("BSL-1.0")
    set_urls("https://github.com/zeromake/boost.intl/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.01.06-alpha", "c4f299239151fc7cb32ec77834c01c8ba97325ea9556aa0b438c27fc5e011247")
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
