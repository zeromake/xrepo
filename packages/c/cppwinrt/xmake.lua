package("cppwinrt")
    set_homepage("https://github.com/microsoft/cppwinrt")
    set_description("C++/WinRT is an entirely standard C++ language projection for Windows Runtime (WinRT) APIs")
    set_license("MIT")
    set_urls("https://globalcdn.nuget.org/packages/microsoft.windows.cppwinrt.2.0.230225.1.nupkg")

    add_versions("latest", "83d2584bb63ea7180de73147a7e63e24371fa832fa79c00e500695a709d51749")
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
