local function getVersion(version) 
    return tostring(version):gsub('-release', '')
end


package("cppwinrt")
    set_homepage("https://github.com/microsoft/cppwinrt")
    set_description("C++/WinRT is an entirely standard C++ language projection for Windows Runtime (WinRT) APIs")
    set_license("MIT")
    set_urls("https://github.com/microsoft/cppwinrt/releases/download/$(version)/Microsoft.Windows.CppWinRT.$(version).nupkg", {
        version = getVersion
    })
    add_versions("2.0.230706-release.1", "e4a827fee480291d4598ea3bb751cb5696a42ded0b795c16f52da729502e07e8")
    on_install("windows", "mingw", function (package)
        import("lib.detect.find_tool")
        import("detect.sdks.find_vstudio")
        local p7z = find_tool("7z")
        os.execv(p7z.program, {"x", package:originfile()})
        local vs
        for _, vsinfo in pairs(find_vstudio()) do
            if vsinfo.vcvarsall then
                vs = vsinfo.vcvarsall[os.arch()]
                break
            end
        end

        local winmds = {"-in"}
        for _, p in ipairs(vs["WindowsLibPath"]:split(";")) do
            for _, winmd in ipairs(os.filedirs(path.join(p, "*.winmd"))) do
                table.insert(winmds, winmd)
            end
        end
        os.execv("bin/cppwinrt", {"-in", "local", "-out", package:installdir("include")})
        os.execv("bin/cppwinrt", table.join(winmds, {"-out", package:installdir("include")}))
    end)
