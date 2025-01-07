local function getVersion(version)
    local versions ={
        ["2025.01.07-alpha"] = "archive/baf37b1b49847f18a5cd8f03310777487469a3b3.tar.gz",
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
        add_versions("2025.01.07-alpha", "79f76fa95234f7a7b2d6672fe78c458685bfe9f6d47fc2e89a415364d5661a14")
    end
    add_deps("nonstd.string-view")
    on_install(function (package)
        import("package.tools.xmake").install(package, {})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("boost_locale_gettext", {includes = {"boost/locale/libintl.h"}}))
    end)
