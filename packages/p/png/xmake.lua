package("png")
    set_homepage("http://libpng.org/pub/png/libpng.html")
    set_description("The official PNG reference library")
    set_license("libpng-2.0")

    set_urls("https://github.com/pnggroup/libpng/archive/refs/tags/v$(version).tar.gz")
    --insert version
    add_versions("1.6.47", "631a4c58ea6c10c81f160c4b21fa8495b715d251698ebc2552077e8450f30454")
    add_versions("1.6.46", "767b01936f9620d4ab4cdf6ec348f6526f861f825648b610b1d604167dc738d2")
    add_versions("1.6.45", "7ff6898520645716ddc3d8381d97b6e02937b03da92e6fd0d7cf9d7d2b0da780")
    add_versions("1.6.44", "0ef5b633d0c65f780c4fced27ff832998e71478c13b45dfb6e94f23a82f64f7c")
    add_versions("1.6.43", "fecc95b46cf05e8e3fc8a414750e0ba5aad00d89e9fdf175e94ff041caf1a03a")
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

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

add_requires("zlib")
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
    end
]], {encoding = "binary"})

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
