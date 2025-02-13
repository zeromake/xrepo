local function getVersion(version)
    local versions ={
        ["2024.12.03-alpha"] = "archive/a41771f7353b1db19b0498ecdd8f7807e5e29473.tar.gz",
        ["2024.12.13-alpha"] = "archive/7e292050a21d3dd5076f70116ae95cc5200c40c1.tar.gz",
        ["2024.12.23-alpha"] = "archive/482291286b9960c255ff8765d18a618cc87d89a2.tar.gz",
        ["2024.12.30-alpha"] = "archive/99c02eb45170775a9a679c32b45dd4000ea67aff.tar.gz",
        ["2025.01.10-alpha"] = "archive/0f979361f53b590b3107212732331af8fcfb8cc0.tar.gz",
        ["2025.02.10-alpha"] = "archive/55db71e0d9337122763d98315521dfb96cd9f318.tar.gz",
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
    add_versions("2025.02.10-alpha", "57dcf736a8df0b676f305789c866b81521a4c3abd80e302d770d4ed112ab3ea7")
    add_versions("2025.01.10-alpha", "7ae3218b3510b55128efe8a294c555e6b1262581fa85006eb48e6b29f8dfaecd")
    add_versions("2024.12.30-alpha", "24c22533cb073380687d7971c95840ee82005033a9c02491414cbf53e34e1091")
    add_versions("2024.12.23-alpha", "675ae02ad11aef3009da03824c7db8778468b65714ef04104687d3b049d4eef5")
    add_versions("2024.12.13-alpha", "c2bb828b04a55af42565384ad9c004f478cfc10b2aef98cb7dba37e0e1e2bbd6")
    add_versions("2024.12.03-alpha", "517578318241f45d45e437c912a9ae145e53b14c7fbce9058a38e07f4aa71cd4")
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
