package("directstorage")
    set_homepage("https://github.com/microsoft/DirectStorage")
    set_description("DirectStorage for Windows is an API that allows game developers to unlock the full potential of high speed NVMe drives for loading game assets.")
    set_license("MIT")
    set_urls("https://globalcdn.nuget.org/packages/microsoft.direct3d.directstorage.$(version).nupkg")

    add_versions("1.2.2", "25cab8bce31d6a044caaa255b416b22d91e47fe98916a631d9f7cb7017fc011d")
    on_install("windows", "mingw", function (package)
        import("lib.detect.find_tool")
        local p7z = find_tool("7z")
        os.execv(p7z.program, {"x", package:originfile()})
        local p = "x86"
        if package:is_arch("x64", "x86_64") then
            p = "x64"
        elseif package:is_arch("arm.*") then
            p = "ARM64"
        end
        os.cp("native/lib/"..p.."/*.lib", package:installdir("lib"))
        os.cp("native/bin/"..p.."/*.dll", package:installdir("bin"))
        os.cp("native/include/*.h", package:installdir("include"))
        -- local cppwinrt = find_tool("cppwinrt", {check = "-help"})
        -- os.vexecv(cppwinrt.program, {"-in", "./native/winmd/Microsoft.Direct3D.DirectStorage.winmd", "-out", package:installdir("include")})
        -- Todo cppwinrt generate 
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
