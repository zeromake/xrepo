add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("vulkan_memory_allocator")
    set_kind("$(kind)")
    add_headerfiles("include/vk_mem_alloc.h")
