local function getVersion(version)
    local versions ={
        ["2025.01.06-alpha"] = "archive/129d553ba1621101941467a9cfc064d8649ef44d.tar.gz",
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
    add_versions("2025.01.06-alpha", "9006fa75f1b7ca0fc3d2cdff10069f29372dfd3a937c58da7d45ea4e69cc101e")
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
