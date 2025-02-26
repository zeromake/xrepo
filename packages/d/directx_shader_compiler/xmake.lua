
package("directx_shader_compiler")
    set_homepage("https://github.com/microsoft/DirectXShaderCompiler")
    set_description("DirectX Shader Compiler")
    set_license("MIT")

    if is_plat("windows", "mingw") then
        set_urls("https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2502/dxc_2025_02_20.zip")
        add_versions("1.8.2502", "70b1913a1bfce4a3e1a5311d16246f4ecdf3a3e613abec8aa529e57668426f85")
    elseif is_plat("macosx") then
        set_urls("https://github.com/zeromake/xrepo/releases/download/v0.0.1/darwin_dxc_2025_02_20.x86_64.7z")
        add_versions("1.8.2502", "d6118c69d442ce928e38f82feb09ce8abf371bdf7766fe7dfafb8d5d6e58af62")
    elseif is_plat("linux") then
        set_urls("https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2502/linux_dxc_2025_02_20.x86_64.tar.gz")
        add_versions("1.8.2502", "e0580d90dbf6053a783ddd8d5153285f0606e5deaad17a7a6452f03acdf88c71")
    end

    --insert version
    on_install(function (package)
        local arch = package:arch()
        if os.exists("bin") then
            os.cp("bin/"..arch.."/*", package:installdir("bin"))
            package:addenv("PATH", "bin")
        end
        os.cp("lib/"..arch.."/*", package:installdir("lib"))
        os.cp("inc/*", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
