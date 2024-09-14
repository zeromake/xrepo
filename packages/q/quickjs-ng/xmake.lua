local function getVersion(version)
    local versions ={
        ["2024.08.19-alpha"] = "archive/3a583764853900a9a3c31735efa3b58541707dbb.tar.gz",
        ["2024.09.13-alpha"] = "archive/8557bd0a0a051d52d15a467a25b99bdc155d09a7.tar.gz",
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

    add_versions("2024.09.13-alpha", "db4ae6253fe715bb9d6c2b107e2cf8ddd251ae3e7aa79cff86bdddea99426cd8")
    add_versions("2024.08.19-alpha", "7bcbccc0123e07802b9fb3732addbd5b110a7630b66d2bbef7b791be5bfb99d4")
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
