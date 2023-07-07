add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local dirs = {
    "core",
    "allocator",
    "objects",
    "shaders",
    "renderpass",
    "states",
    "descriptors",
    "barriers",
    "misc",
    "extensions",
    "auxiliary",
    "helpers",
    "packed",
}

add_requires("vulkan", "vulkan_memory_allocator ~2.0.1", "spirv_reflect")
target("magma")
    set_kind("$(kind)")
    set_languages("c++20")
    add_includedirs(".")
    set_pcxxheader("core/pch.h")
    add_vectorexts("avx2")
    -- if is_plat("windows") then
    --     add_cxxflags("/constexpr:depth2048")
    -- else
    --     add_cxxflags("-ftemplate-depth=2048")
    --     add_cxxflags("-fconstexpr-depth=2048")
    -- end
    add_packages("vulkan", "vulkan_memory_allocator", "spirv_reflect")
    add_headerfiles("magma.h")
    for _, dir in ipairs(dirs) do
        add_headerfiles(path.join(dir, "*.h"), {prefixdir = dir})
        add_files(path.join(dir, "*.cpp"))
    end
