local function getVersion(version)
    local versions ={
        ["2025.01.06-alpha"] = "archive/95f2752039cbdbfe216f1343def8238791f81a01.tar.gz",
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
    add_versions("2025.01.06-alpha", "ba2ff270e8612a65fb4afddfe7b226bd80d8920076b2595949a5b9e93b65ef23")
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
