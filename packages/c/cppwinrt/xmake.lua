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
        os.execv(p7z.program, {"x", "../microsoft.windows.cppwinrt.2.0.230225.1.nupkg"})
        local vs = find_vstudio()["2022"]["vcvarsall"]["x86"]
        local winmds = {
            path.join(vs["VSInstallDir"], "VC", "Tools", "MSVC", vs["VCToolsVersion"], "lib/x86/store/references/platform.winmd")
        }
        local sdkWinmdDir = path.join(path.join(vs["WindowsSdkDir"], "References", vs["WindowsSDKVersion"]), "*", "*", "*.winmd")
        for _, winmd in ipairs(os.filedirs(path.join(sdkWinmdDir))) do
            table.insert(winmds, winmd)
        end
        os.execv("./bin/cppwinrt", {"-in", "local", "-out", "include"})
        os.execv("./bin/cppwinrt", table.join2({"-in"}, winmds, {"-out", "include"}))
        os.cp("include/*", package:installdir("include").."/")
        os.cp("bin/*.exe", package:installdir("bin").."/")
    end)
