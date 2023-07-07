package("magma")
    set_homepage("https://github.com/vcoda/magma")
    set_description("Abstraction layer over Khronos Vulkan API")
    set_license("GPLv3")
    set_urls("https://github.com/vcoda/magma/archive/905d7cb99d77961d22bd3dbdd5fec8e7171feeb5.zip")

    add_versions("latest", "76c385e7bd1f240552d69f6c8408e64b0c059f924c329dc8f2b8d38de14ffc6d")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("pch.h", "#define strcpy_s(p1, p2, p3) strncpy(p1, p3, p2)")
        for _, f in ipairs({
            "allocator/vmaImplementation.cpp",
            "allocator/deviceMemoryAllocator.cpp"
        }) do
            local context = io.readfile(f)
            context = context:gsub('"%.%./third%-party/VulkanMemoryAllocator/include/vk_mem_alloc%.h"', '<vk_mem_alloc.h>')
            io.writefile(f, context)
        end
        for _, f in ipairs({
            "helpers/stringize.h",
            "helpers/spirvReflectionTypeCast.h",
            "shaders/shaderReflection.h",
            "exceptions/reflectionErrorResult.h",
        }) do
            local context = io.readfile(f)
            context = context:gsub('"%.%./third%-party/SPIRV%-Reflect/spirv_reflect%.h"', '<spirv_reflect.h>')
            io.writefile(f, context)
        end
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
