local function getVersion(version)
    local versions ={
        ["2024.10.29-alpha"] = "archive/df81c9940f8f513116f0ef3f1e108c346243c477.tar.gz",
        ["2024.11.05-alpha"] = "archive/37fe427d59043d70f92c70d315592232ad8cb358.tar.gz",
        ["2024.11.15-alpha"] = "archive/706ba05fa6fc984e07e6b8b47d028a8ac729fd13.tar.gz",
        ["2024.11.26-alpha"] = "archive/c351133dcc4089e3f4de1bdb18286dcc2426072b.tar.gz",
        ["2024.12.03-alpha"] = "archive/a41771f7353b1db19b0498ecdd8f7807e5e29473.tar.gz",
        ["2024.12.13-alpha"] = "archive/7e292050a21d3dd5076f70116ae95cc5200c40c1.tar.gz",
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
    add_versions("2024.12.13-alpha", "c2bb828b04a55af42565384ad9c004f478cfc10b2aef98cb7dba37e0e1e2bbd6")
    add_versions("2024.12.03-alpha", "517578318241f45d45e437c912a9ae145e53b14c7fbce9058a38e07f4aa71cd4")
    add_versions("2024.11.26-alpha", "72de826ee4fed93a8a6d6ae6100aa92cc0ae18111820ff40f63c0d6148293dbc")
    add_versions("2024.11.15-alpha", "3050b295bccd4904906f8fe12caa8bfdb4decc97ae357412c75b471440dd78b4")
    add_versions("2024.11.05-alpha", "90ca133bb802813ecdcc2fc7b38966f22c5369301c58a9ab30c51267f7ddaee7")
    add_versions("2024.10.29-alpha", "5b31d4ac47741c58bd6b2eb4610d8af4775f8aca01f8e952c0839b3441147a8e")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})
    add_configs("libc", {description = "build libc", default = true, type = "boolean"})

    add_includedirs("include", "include/quickjs")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*"), "./")
        os.cp(path.join(os.scriptdir(), "rules"), "./")
        local configs = {
            cli = package:config("cli") and 'y' or 'n',
            libc = package:config("libc") and 'y' or 'n'
        }
        import("package.tools.xmake").install(package, configs)
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        assert(package:has_cfuncs("JS_NewContext", {includes = {"quickjs/quickjs.h"}}))
    end)
