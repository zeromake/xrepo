local function getVersion(version)
    local versions = {
        ['2024.02.20-alpha'] = 'archive/8cbe4cae93e29c64eec3262ab5deb8ca9a6f8fc2.tar.gz'
    }
    return versions[tostring(version)]
end

package("magma")
    set_homepage("https://github.com/vcoda/magma")
    set_description("Abstraction layer over Khronos Vulkan API")
    set_license("GPLv3")
    set_urls("https://github.com/vcoda/magma/$(version)", {version = getVersion})

    add_versions("2024.02.20-alpha", "76c385e7bd1f240552d69f6c8408e64b0c059f924c329dc8f2b8d38de14ffc6d")
    on_install(function (package)
        local function writefile(p, content) 
            local out = io.open(p, "wb")
            out:write(content)
            out:close()
        end
        local function replace(f, sub, target)
            local context = io.readfile(f)
            context = context:gsub(sub, target)
            writefile(f, context)
        end
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local pch = ""
        if not package:is_plat("windows", "mingw") then
            pch = "#define strcpy_s(p1, p2, p3) strncpy(p1, p3, p2)"
        end
        writefile("pch.h", pch)
        for _, f in ipairs({
            "allocator/vmaImplementation.cpp",
            "allocator/deviceMemoryAllocator.cpp"
        }) do
            replace(f, '"%.%./third%-party/VulkanMemoryAllocator/include/vk_mem_alloc%.h"', '<vk_mem_alloc.h>')
        end
        for _, f in ipairs({
            "helpers/stringize.h",
            "helpers/spirvReflectionTypeCast.h",
            "shaders/shaderReflection.h",
            "exceptions/reflectionErrorResult.h",
        }) do
            replace(f, '"%.%./third%-party/SPIRV%-Reflect/spirv_reflect%.h"', '<spirv_reflect.h>')
        end
        for _, f in ipairs({
            "states/vertexInputStructure.inl",
        }) do
            replace(f, '#ifdef _MSC_VER', '#if 0')
        end
        replace("core/hashing/fnv1.h", 'return %(Fnv1a<T, N, I%-1>%(%)%.hash%(a%) %^ a%[I%-1%]%) %* fnv::prime;', [[hash_t result = (fnv::basis ^ a[0]) * fnv::prime;
                    for (int i = 1; i < I; i++) {
                        result = (result ^ a[i]) * fnv::prime;
                    }
                    return result;]])
        replace("core/hashing/fnv1.h", 'return %(Fnv1<T, N, I%-1>%(%)%.hash%(a%) %* a%[I%-1%]%) %^ fnv::prime;', [[hash_t result = (fnv::basis * a[0]) ^ fnv::prime;
                    for (int i = 1; i < I; i++) {
                        result = (result * a[i]) ^ fnv::prime;
                    }
                    return result;]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
