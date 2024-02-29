package("d3d12_memory_allocator")
    set_homepage("https://github.com/GPUOpen-LibrariesAndSDKs/D3D12MemoryAllocator")
    set_description("Easy to integrate memory allocation library for Direct3D 12")
    set_license("MIT")
    set_urls("https://github.com/GPUOpen-LibrariesAndSDKs/D3D12MemoryAllocator/archive/refs/tags/v$(version).tar.gz")

    add_versions("2.0.1", "7ce1f1dfb8821d0116eccf425b3558e6d4b28d192f4efb6e6bdb3d916d853574")
    on_install("windows", "mingw", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        os.cp('src/D3D12MemAlloc.natvis', package:installdir('include'))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets([[
void test() {
    D3D12MA::Allocation* allocation;
}
]], {includes = {"D3D12MemAlloc.h"}}))
    end)
