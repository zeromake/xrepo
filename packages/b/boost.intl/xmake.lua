local function getVersion(version)
    local versions ={
        ["2025.01.06-alpha"] = "archive/be8e046e841dc7938c4254bf95f2221c0980bcdc.tar.gz",
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
    add_versions("2025.01.06-alpha", "9928ca1c2ca62cf6254ff302f70c2da106a5ff12ba65113864cbeb51f73c41e1")
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
