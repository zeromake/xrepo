add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

add_requires("vulkan")

target("vulkan_memory_allocator")
    set_kind("$(kind)")
    set_languages("c++17")
    add_packages("vulkan")
    add_headerfiles("include/vk_mem_alloc.h")
    add_files(
        "src/VmaUsage.cpp"
    )
