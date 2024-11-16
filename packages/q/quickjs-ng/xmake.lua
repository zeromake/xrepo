local function getVersion(version)
    local versions ={
        ["2024.10.29-alpha"] = "archive/df81c9940f8f513116f0ef3f1e108c346243c477.tar.gz",
        ["2024.11.05-alpha"] = "archive/37fe427d59043d70f92c70d315592232ad8cb358.tar.gz",
        ["2024.11.15-alpha"] = "archive/706ba05fa6fc984e07e6b8b47d028a8ac729fd13.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("quickjs-ng")
    set_homepage("https://github.com/quickjs-ng/quickjs")
    set_description("QuickJS, the Next Generation: a mighty JavaScript engine")
    set_license("MIT")
    set_urls("https://github.com/quickjs-ng/quickjs/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.11.15-alpha", "3050b295bccd4904906f8fe12caa8bfdb4decc97ae357412c75b471440dd78b4")
    add_versions("2024.11.05-alpha", "90ca133bb802813ecdcc2fc7b38966f22c5369301c58a9ab30c51267f7ddaee7")
    add_versions("2024.10.29-alpha", "5b31d4ac47741c58bd6b2eb4610d8af4775f8aca01f8e952c0839b3441147a8e")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})
    add_configs("libc", {description = "build libc", default = true, type = "boolean"})

    add_includedirs("include", "include/quickjs")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*"), "./")
        os.cp(path.join(os.scriptdir(), "rules"), "./")
        if package:config("cli") then
            os.cp("xmake-qjsc.lua", "xmake.lua")
            import("package.tools.xmake").install(package)
            local qjsc = "qjsc"..(os.host() == "windows" and ".exe" or "")
            os.cp(path.join(package:installdir("bin"), qjsc), "./")
            os.cp(path.join(os.scriptdir(), "port/xmake.lua"), "./")
            package:addenv("PATH", "bin")
        end
        local configs = {
            cli = package:config("cli") and 'y' or 'n',
            libc = package:config("libc") and 'y' or 'n'
        }
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("JS_NewContext", {includes = {"quickjs/quickjs.h"}}))
    end)
