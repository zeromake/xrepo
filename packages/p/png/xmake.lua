package("png")
    set_homepage("http://libpng.org/pub/png/libpng.html")
    set_description("The official PNG reference library")
    set_license("libpng-2.0")

    set_urls("https://github.com/glennrp/libpng/archive/refs/tags/v$(version).tar.gz")
    add_versions("1.6.40", "62d25af25e636454b005c93cae51ddcd5383c40fa14aa3dae8f6576feb5692c2")
    add_versions("1.6.38", "d4160037fa5d09fa7cff555037f2a7f2fefc99ca01e21723b19bfcda33015234")
    add_deps("zlib")

    if is_plat("linux") then
        add_syslinks("m")
    end

    on_load(function (package)
        if package:is_plat("windows") and package:config("shared") then
            package:add("defines", "PNG_BUILD_DLL")
        end
    end)

    on_install(function (package) 
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
add_requires("zlib", {system=false})
target("png")
    set_kind("$(kind)")
    add_files("*.c|example.c|pngtest.c")
    if is_arch("x86", "x64", "i386", "x86_64") then
        add_files("intel/*.c")
        add_defines("PNG_INTEL_SSE_OPT=1")
        add_vectorexts("sse", "sse2")
    elseif is_arch("arm.*") then
        add_files("arm/*.c")
        if is_plat("windows") then
            add_defines("PNG_ARM_NEON_OPT=1")
            add_defines("PNG_ARM_NEON_IMPLEMENTATION=1")
        else
            add_files("arm/*.S")
            add_defines("PNG_ARM_NEON_OPT=2")
        end
    elseif is_arch("mips.*") then
        add_files("mips/*.c")
        add_defines("PNG_MIPS_MSA_OPT=2")
    elseif is_arch("ppc.*") then
        add_files("powerpc/*.c")
        add_defines("PNG_POWERPC_VSX_OPT=2")
    end
    add_headerfiles("*.h")
    add_packages("zlib")
    if is_kind("shared") and is_plat("windows") then
        add_defines("PNG_BUILD_DLL")
    end]])

        if package:is_plat("android") and package:is_arch("armeabi-v7a") then
            io.replace("arm/filter_neon.S", ".func", ".hidden", {plain = true})
            io.replace("arm/filter_neon.S", ".endfunc", "", {plain = true})
        end
        local configs = {}
        os.cp("scripts/pnglibconf.h.prebuilt", "pnglibconf.h")
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("png_create_read_struct", {includes = "png.h"}))
    -- end)
