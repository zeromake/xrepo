add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("d3d12_memory_allocator")
    set_kind("$(kind)")
    add_includedirs("include")
    add_headerfiles("include/D3D12MemAlloc.h")
    add_files("src/D3D12MemAlloc.cpp")
