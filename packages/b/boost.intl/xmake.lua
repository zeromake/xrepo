local function getVersion(version)
    local versions ={
        ["2025.01.06-alpha"] = "archive/1bea766d3abffdae5933a16dae9144b27c07d630.tar.gz",
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
    add_versions("2025.01.06-alpha", "2ffe0e0924f07dbadd078b6a3aec0cc4e4dd982b53d6df1436daa9de11e33968")
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
