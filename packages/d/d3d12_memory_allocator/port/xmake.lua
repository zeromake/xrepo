add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("d3d12_memory_allocator")
    set_kind("$(kind)")
    add_headerfiles("include/D3D12MemAlloc.h")
    add_files("src/D3D12MemAlloc.cpp")
    if is_plat("windows") then
        add_files("src/D3D12MemAlloc.natvis")
    end
