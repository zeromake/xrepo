

local function getVersion(version)
    local versions ={
        ["3.0.1"] = "archive/refs/tags/v3.0.1.tar.gz",
        ["2.0.1"] = "archive/895b080a3c2189feaea0919af8982e9a248ff7d6.zip",
    }
    return versions[tostring(version)]
end

package("vulkan_memory_allocator")
    set_homepage("https://gpuopen.com/vulkan-memory-allocator")
    set_description("Easy to integrate Vulkan memory allocation library ")
    set_license("MIT")
    set_urls(
        "https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/$(version)",
        {
            version = getVersion
        }
    )
    add_versions("3.0.1", "2a84762b2d10bf540b9dc1802a198aca8ad1f3d795a4ae144212c595696a360c")
    add_versions("2.0.1", "238a4b3afd16c934bc4e4035dee982ff85e47d6a80a409378f81f0cccdf599e3")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
