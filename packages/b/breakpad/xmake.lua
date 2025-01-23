local function getVersion(version)
    local versions ={
        ["2025.01.17-alpha"] = "archive/41b6533e5f3dd7f0320ef58608ee32e8e4f132fb.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("breakpad")
    set_homepage("https://chromium.googlesource.com/breakpad/breakpad")
    set_description("Breakpad is a set of client and server components which implement a crash-reporting system.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/google/breakpad/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.01.17-alpha", "94bc8da487a76fafee778aa92caa679f98cc7ee585b9c1cb44e7debca285ee8c")
    add_patches("2025.01.17-alpha", path.join(os.scriptdir(), "patches/001-osx-skip-ppc.patch"), "7f5cff9067004a7321ca422c961e54970a1f1adf2035432de2c5b97d8364a487")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        local text = io.readfile("src/config.h.in")
        text = text:gsub("#undef +([%w_-]+)", "${define %1}")
        io.writefile("config.h.in", text, {encoding = "binary"})
        import("package.tools.xmake").install(package, configs)
        package:addenv("PATH", "bin")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
