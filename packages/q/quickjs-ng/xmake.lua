local function getVersion(version)
    local versions ={
        ["2024.12.03-alpha"] = "archive/a41771f7353b1db19b0498ecdd8f7807e5e29473.tar.gz",
        ["2024.12.13-alpha"] = "archive/7e292050a21d3dd5076f70116ae95cc5200c40c1.tar.gz",
        ["2024.12.23-alpha"] = "archive/482291286b9960c255ff8765d18a618cc87d89a2.tar.gz",
        ["2024.12.30-alpha"] = "archive/99c02eb45170775a9a679c32b45dd4000ea67aff.tar.gz",
        ["2025.01.10-alpha"] = "archive/0f979361f53b590b3107212732331af8fcfb8cc0.tar.gz",
        ["2025.02.10-alpha"] = "archive/55db71e0d9337122763d98315521dfb96cd9f318.tar.gz",
        ["2025.02.14-alpha"] = "archive/22cd6ab711fffc471d7fde99536fb6bbb033184b.tar.gz",
        ["2025.03.03-alpha"] = "archive/e2f61ac35ccf6b7f80607950c62c0c030bd784c9.tar.gz",
        ["2025.03.15-alpha"] = "archive/bfc9e3cc0198a99abb3354a61935d8d18d8425e4.tar.gz",
        ["2025.04.08-alpha"] = "archive/28fa43d3ddff2c1ba91b6e3a788b2d7ba82d1465.tar.gz",
        ["2025.04.25-alpha"] = "archive/09d76edc2edf782ac2a7514549f55198b422260b.tar.gz",
        ["2025.05.13-alpha"] = "archive/3c9afc9943323ee9c7dbd123c0cd991448f4b6c2.tar.gz",
        ["2025.08.04-alpha"] = "archive/5299e09100b97a5dd0ea0e73fa5caa4aa0b2d97c.tar.gz",
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
    add_versions("2025.08.04-alpha", "3589fa853948156264a19d1989749037e89119404ca5a8507d509505eb2c152d")
    add_versions("2025.05.13-alpha", "0af6f985be7030a7a9d12b92c25c2bc9f7dd716829c5074a81d7c4a4452040c8")
    add_versions("2025.04.25-alpha", "b146aa982f01d0074534cd512947664a776ecc6ce5ddaa6cf1abc27d7a88ffea")
    add_versions("2025.04.08-alpha", "9fba7870547db75a2c43a931ff6dc24e7e59c63ae5268ee6fcedf32ca1ca4c2b")
    add_versions("2025.03.15-alpha", "78df1ea59812677910d53b6cf7c8bd0c73a050218d24ad23148d01847fb4d94e")
    add_versions("2025.03.03-alpha", "3a44faf903a44ea53eec08562abf70e5826cf43c0e55cdc43d1dfcd6a646a503")
    add_versions("2025.02.14-alpha", "b1e77aacd18fa7a33bb9c03b923b96c0a533e2cac1f0d95beaf479d68fee5e93")
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
