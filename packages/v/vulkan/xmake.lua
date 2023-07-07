
package("vulkan")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://sdk.lunarg.com/sdk/download/1.3.250.1/windows/VulkanSDK-1.3.250.1-Installer.exe")

    add_versions("1.3.250", "fab945cdae8ab5d8f983ff9cda39d80cfe7ab644660e577e977566dd73380785")
    add_links("vulkan-1")
    on_install("windows", "mingw", function (package)
        import("lib.detect.find_tool")
        import("net.http")
        if not os.isfile("../vulkan-r.zip") then 
            http.download("https://sdk.lunarg.com/sdk/download/1.3.250.1/windows/VulkanRT-1.3.250.1-Components.zip", "../vulkan-r.zip")
        end
        local p7z = find_tool("7z")
        os.execv(p7z.program, {"x", "../vulkan-r.zip"})
        os.execv(p7z.program, {"x", package:originfile()})
        
        for _, d in ipairs({
            "vulkan",
            "vk_video",
            "shaderc",
        }) do
            os.cp(path.join("Include", d), package:installdir("include").."/")
        end
        for _, f in ipairs({
            "vulkan-1.lib",
            "shaderc.lib",
        }) do
            os.cp(path.join("Lib", f), package:installdir("lib").."/")
        end
        os.cp("VulkanRT-1.3.250.1-Components/x64/vulkan-1.dll", package:installdir("bin").."/")
        if package:is_plat("mingw") then
            os.cp("VulkanRT-1.3.250.1-Components/x64/vulkan-1.dll", "./")
            local outdata, errdata = os.iorunv("pexports", {"vulkan-1.dll"})
            if not errdata or errdata == "" then
                io.writefile("vulkan-1.def", outdata)
                os.execv("dlltool", {"-D", "vulkan-1.dll", "-d", "vulkan-1.def", "-l", path.join(package:installdir("lib"), "libvulkan-1.dll.a")})
            end
        end
        for _, f in ipairs({
            "dxc.exe",
            "dxcompiler.dll",
            "glslangValidator.exe",
            "glslc.exe",
            "spirv-cross.exe",
            "vkconfig.exe",
        }) do
            os.cp(path.join("Bin", f), package:installdir("bin").."/")
        end
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
