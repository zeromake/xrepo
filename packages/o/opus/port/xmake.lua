if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("opus")
    set_kind("$(kind)")
    add_includedirs(".", "include", "celt", "silk", "silk/float")
    add_files("src/*.c|opus_demo.c|repacketizer_demo.c|opus_compare.c")
    add_files("celt/*.c|opus_custom_demo.c")
    add_files("silk/*.c")
    add_files("silk/float/*.c")
    if is_arch("arm.*") then
        add_files("celt/arm/*.c|celt_fft_ne10.c")
        add_files("silk/arm/*.c|arm_silk_map.c")
        add_defines(
            "OPUS_ARM_ASM",
            "OPUS_ARM_MAY_HAVE_NEON_INTR",
            "OPUS_ARM_MAY_HAVE_NEON",
            "OPUS_ARM_PRESUME_NEON"
        )
    elseif is_arch("x86", "i386", "x86_64", "x64") then
        add_files("celt/x86/*.c")
        add_files("silk/x86/*.c")
        add_defines(
            "OPUS_X86_MAY_HAVE_AVX",
            "OPUS_X86_MAY_HAVE_SSE",
            "OPUS_X86_MAY_HAVE_SSE2",
            "OPUS_X86_MAY_HAVE_SSE4_1",
            "OPUS_X86_PRESUME_SSE",
            "OPUS_X86_PRESUME_SSE2"
        )
    end
    add_headerfiles("include/*.h")
    add_defines(
        "CPU_INFO_BY_ASM",
        "ENABLE_HARDENING",
        "HAVE_ALLOCA_H",
        "HAVE_LRINT",
        "HAVE_LRINTF",
        "OPUS_BUILD",
        "OPUS_HAVE_RTCD",
        "VAR_ARRAYS",
        "_FORTIFY_SOURCE=2"
    )
    add_vectorexts("all")
    if is_plat("windows", "mingw") and is_kind("shared") then
        add_defines("DLL_EXPORT")
    end 
