local function getVersion(version)
    return tostring(version):gsub('-release', '')
end

package("vulkan_loader")
    set_homepage("https://vulkan.lunarg.com")
    set_description("vulkan runtime")
    set_license("MIT")
    set_urls("https://sdk.lunarg.com/sdk/download/$(version)/windows/VulkanRT-$(version)-Components.zip", {
        version = getVersion
    })
    add_versions("1.4.304-release.0", "671f956c12ec0042d82c934ed47d146812b181459389f63666a95b702195437c")
    
    if is_plat("mingw") then
        add_links("vulkan-1.dll")
    else
        add_links("vulkan-1")
    end
    on_install("windows", "mingw", function (package)
        import("detect.sdks.find_vstudio")
        import("lib.detect.find_tool")
        local archDir = package:is_arch("x64", "x86_64") and "x64" or "x86"
        for _, f in ipairs({
            "vulkan-1.dll",
            "vulkaninfo.exe",
        }) do
            os.cp(path.join(archDir, f), package:installdir("bin"))
        end
        package:addenv("PATH", "bin")
        local vsPath = ""
        for _, vsinfo in pairs(find_vstudio()) do
            if vsinfo.vcvarsall then
                vsPath = path.join(
                    vsinfo.vcvarsall[os.arch()]["VCToolsInstallDir"],
                    string.format("bin/Host%s/%s", archDir, archDir)
                )
                break
            end
        end
        os.cp(path.join(os.scriptdir(), "port", "vulkan.def"), "vulkan.def")
        local _libFile = path.join(archDir, "vulkan-1.dll")
        local libFile = "vulkan-1.dll"
        os.cp(_libFile, ".")
        local libArch = package:is_arch("x64", "x86_64") and "X64" or "X86"
        local lib = find_tool("lib", {paths={"$(env PATH)", vsPath}, norun = true})
        if lib then
            os.vrunv(lib.program, {"/name:"..libFile, "/def:vulkan.def", "/out:vulkan-1.lib", "/MACHINE:"..libArch})
            os.cp("vulkan-1.lib", package:installdir("lib"))
        end
        local dlltool = find_tool("dlltool", {norun = true})
        if dlltool then
            os.vrunv(dlltool.program, {"-D", libFile, "-d", "vulkan.def", "-l", path.join(package:installdir("lib"), "libvulkan-1.dll.a")})
        end
    end)
