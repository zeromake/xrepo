if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("with_arith")
    set_default(true)
    set_showmenu(true)
option_end()

option("with_simd")
    set_default(true)
    set_showmenu(true)
option_end()

local JPEG16_SOURCES = {
    "jcapistd.c",
    "jccolor.c",
    "jcdiffct.c",
    "jclossls.c",
    "jcmainct.c",
    "jcprepct.c",
    "jcsample.c",
    "jdapistd.c",
    "jdcolor.c",
    "jddiffct.c",
    "jdlossls.c",
    "jdmainct.c",
    "jdpostct.c",
    "jdsample.c",
    "jutils.c",
}

local JPEG12_SOURCES = table.join(JPEG16_SOURCES, {
    "jccoefct.c",
    "jcdctmgr.c",
    "jdcoefct.c",
    "jddctmgr.c",
    "jdmerge.c",
    "jfdctfst.c",
    "jfdctint.c",
    "jidctflt.c",
    "jidctfst.c",
    "jidctint.c",
    "jidctred.c",
    "jquant1.c",
    "jquant2.c",
})

local JPEG_SOURCES = table.join(JPEG12_SOURCES, {
    "jcapimin.c",
    "jchuff.c",
    "jcicc.c",
    "jcinit.c",
    "jclhuff.c",
    "jcmarker.c",
    "jcmaster.c",
    "jcomapi.c",
    "jcparam.c",
    "jcphuff.c",
    "jctrans.c",
    "jdapimin.c",
    "jdatadst.c",
    "jdatasrc.c",
    "jdhuff.c",
    "jdicc.c",
    "jdinput.c",
    "jdlhuff.c",
    "jdmarker.c",
    "jdmaster.c",
    "jdphuff.c",
    "jdtrans.c",
    "jerror.c",
    "jfdctflt.c",
    "jmemmgr.c",
    "jmemnobs.c",
})

if get_config("with_arith") then
    table.join2(JPEG_SOURCES, {
        "jaricom.c",
        "jcarith.c",
        "jdarith.c"
    })
end

local SIMD_SOURCES = {}
local SIMD_DIR = nil

if is_arch("x86_64", "x64") then
    SIMD_DIR = 'simd/x86_64'
    table.join2(SIMD_SOURCES, {
        "x86_64/jsimdcpu.asm",
        "x86_64/jfdctflt-sse.asm",
        "x86_64/jccolor-sse2.asm",
        "x86_64/jcgray-sse2.asm",
        "x86_64/jchuff-sse2.asm",
        "x86_64/jcphuff-sse2.asm",
        "x86_64/jcsample-sse2.asm",
        "x86_64/jdcolor-sse2.asm",
        "x86_64/jdmerge-sse2.asm",
        "x86_64/jdsample-sse2.asm",
        "x86_64/jfdctfst-sse2.asm",
        "x86_64/jfdctint-sse2.asm",
        "x86_64/jidctflt-sse2.asm",
        "x86_64/jidctfst-sse2.asm",
        "x86_64/jidctint-sse2.asm",
        "x86_64/jidctred-sse2.asm",
        "x86_64/jquantf-sse2.asm",
        "x86_64/jquanti-sse2.asm",
        "x86_64/jccolor-avx2.asm",
        "x86_64/jcgray-avx2.asm",
        "x86_64/jcsample-avx2.asm",
        "x86_64/jdcolor-avx2.asm",
        "x86_64/jdmerge-avx2.asm",
        "x86_64/jdsample-avx2.asm",
        "x86_64/jfdctint-avx2.asm",
        "x86_64/jidctint-avx2.asm",
        "x86_64/jquanti-avx2.asm",
        "x86_64/jsimd.c",
    })
elseif is_arch("i386", "x86") then
    SIMD_DIR = 'simd/i386'
    table.join2(SIMD_SOURCES, {
        "i386/jsimdcpu.asm",
        "i386/jfdctflt-3dn.asm",
        "i386/jidctflt-3dn.asm",
        "i386/jquant-3dn.asm",
        "i386/jccolor-mmx.asm",
        "i386/jcgray-mmx.asm",
        "i386/jcsample-mmx.asm",
        "i386/jdcolor-mmx.asm",
        "i386/jdmerge-mmx.asm",
        "i386/jdsample-mmx.asm",
        "i386/jfdctfst-mmx.asm",
        "i386/jfdctint-mmx.asm",
        "i386/jidctfst-mmx.asm",
        "i386/jidctint-mmx.asm",
        "i386/jidctred-mmx.asm",
        "i386/jquant-mmx.asm",
        "i386/jfdctflt-sse.asm",
        "i386/jidctflt-sse.asm",
        "i386/jquant-sse.asm",
        "i386/jccolor-sse2.asm",
        "i386/jcgray-sse2.asm",
        "i386/jchuff-sse2.asm",
        "i386/jcphuff-sse2.asm",
        "i386/jcsample-sse2.asm",
        "i386/jdcolor-sse2.asm",
        "i386/jdmerge-sse2.asm",
        "i386/jdsample-sse2.asm",
        "i386/jfdctfst-sse2.asm",
        "i386/jfdctint-sse2.asm",
        "i386/jidctflt-sse2.asm",
        "i386/jidctfst-sse2.asm",
        "i386/jidctint-sse2.asm",
        "i386/jidctred-sse2.asm",
        "i386/jquantf-sse2.asm",
        "i386/jquanti-sse2.asm",
        "i386/jccolor-avx2.asm",
        "i386/jcgray-avx2.asm",
        "i386/jcsample-avx2.asm",
        "i386/jdcolor-avx2.asm",
        "i386/jdmerge-avx2.asm",
        "i386/jdsample-avx2.asm",
        "i386/jfdctint-avx2.asm",
        "i386/jidctint-avx2.asm",
        "i386/jquanti-avx2.asm",
        "i386/jsimd.c"
    })
elseif is_arch("arm64.*") then
    SIMD_DIR = 'simd/arm'
    table.join2(SIMD_SOURCES, {
        "arm/jcgray-neon.c",
        "arm/jcphuff-neon.c",
        "arm/jcsample-neon.c",
        "arm/jdmerge-neon.c",
        "arm/jdsample-neon.c",
        "arm/jfdctfst-neon.c",
        "arm/jidctred-neon.c",
        "arm/jquanti-neon.c",
        "arm/jccolor-neon.c",
        "arm/jidctint-neon.c",
        "arm/jidctfst-neon.c",
        "arm/aarch64/jsimd.c",
    })
elseif is_arch("arm.*") then
    SIMD_DIR = 'simd/arm'
    table.join2(SIMD_SOURCES, {
        "arm/jcgray-neon.c",
        "arm/jcphuff-neon.c",
        "arm/jcsample-neon.c",
        "arm/jdmerge-neon.c",
        "arm/jdsample-neon.c",
        "arm/jfdctfst-neon.c",
        "arm/jidctred-neon.c",
        "arm/jquanti-neon.c",
        "arm/jccolor-neon.c",
        "arm/jidctint-neon.c",
        "arm/aarch32/jchuff-neon.c",
        "arm/jdcolor-neon.c",
        "arm/jfdctint-neon.c",
        "arm/aarch32/jsimd.c",
    })
end

target("turbojpeg")
    set_kind("$(kind)")
    set_configvar("JPEG_LIB_VERSION", 80)
    set_configvar("COPYRIGHT_YEAR", "1991-2024")
    set_configvar("VERSION", 80)
    set_configvar("LIBJPEG_TURBO_VERSION_NUMBER", 3002003)
    set_configvar("C_ARITH_CODING_SUPPORTED", 1)
    set_configvar("D_ARITH_CODING_SUPPORTED", 1)
    -- set_configvar("RIGHT_SHIFT_IS_UNSIGNED", 0)
    set_configvar("BUILD", os.date("%Y%m%d"))
    set_configvar("PACKAGE_NAME", "jpegturbo")
    set_configvar("CMAKE_PROJECT_NAME", "jpegturbo")
    set_configvar("VERSION", "3.0.2")
    set_configvar("WITH_SIMD", 1)

    if is_plat("windows", "mingw") then
        set_configvar("HIDDEN", "")
        set_configvar("INLINE", "__forceinline")
        set_configvar("THREAD_LOCAL", "__declspec(thread)")
    else
        set_configvar("HIDDEN", "__attribute__((visibility(\"hidden\")))")
        set_configvar("INLINE", "inline __attribute__((always_inline))")
        set_configvar("THREAD_LOCAL", "__thread")
        add_defines("PIC")
    end
    configvar_check_sizeof("SIZE_T", "size_t", {includes = {"stddef.h"}})
    configvar_check_cincludes("HAVE_INTRIN_H", "intrin.h")
    configvar_check_csnippets("HAVE_BUILTIN_CTZL", [[
int main(int argc, char **argv) {
    unsigned long a = argc;
    return __builtin_ctzl(a);
}]])
    if is_arch("arm.*") then
    configvar_check_csnippets("RIGHT_SHIFT_IS_UNSIGNED", [[
#include <stdio.h>
#include <stdlib.h>
int is_shifting_signed (long arg) {
    long res = arg >> 4;
    if (res == -0x7F7E80CL)
        return 1; /* right shift is signed */
    /* see if unsigned-shift hack will fix it. */
    /* we can't just test exact value since it depends on width of long... */
    res |= (~0L) << (32-4);
    if (res == -0x7F7E80CL)
        return 0; /* right shift is unsigned */
    printf(\"Right shift isn't acting as I expect it to.\\\\n\");
    printf(\"I fear the JPEG software will not work at all.\\\\n\\\\n\");
    return 0; /* try it with unsigned anyway */
}
int main (void) {
    exit(is_shifting_signed(-0x7F7E80B1L));
}]])
    configvar_check_csnippets("HAVE_VLD1_S16_X3", [[
#include <arm_neon.h>
int main(int argc, char **argv) {
    int16_t input[] = {
        (int16_t)argc, (int16_t)argc, (int16_t)argc, (int16_t)argc,
        (int16_t)argc, (int16_t)argc, (int16_t)argc, (int16_t)argc,
        (int16_t)argc, (int16_t)argc, (int16_t)argc, (int16_t)argc
    };
    int16x4x3_t output = vld1_s16_x3(input);
    vst3_s16(input, output);
    return (int)input[0];
}]])
    configvar_check_csnippets("HAVE_VLD1_U16_X2", [[
#include <arm_neon.h>
int main(int argc, char **argv) {
    uint16_t input[] = {
      (uint16_t)argc, (uint16_t)argc, (uint16_t)argc, (uint16_t)argc,
      (uint16_t)argc, (uint16_t)argc, (uint16_t)argc, (uint16_t)argc
    };
    uint16x4x2_t output = vld1_u16_x2(input);
    vst2_u16(input, output);
    return (int)input[0];
}]])
    configvar_check_csnippets("HAVE_VLD1Q_U8_X4", [[
#include <arm_neon.h>
int main(int argc, char **argv) {
    uint8_t input[] = {
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc,
        (uint8_t)argc, (uint8_t)argc, (uint8_t)argc, (uint8_t)argc
    };
    uint8x16x4_t output = vld1q_u8_x4(input);
    vst4q_u8(input, output);
    return (int)input[0];
}]])
    end

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_includedirs(".")
    if SIMD_DIR then
        add_includedirs(SIMD_DIR)
    end
    add_configfiles("jversion.h.in")
    add_configfiles("jconfig.h.in")
    add_configfiles("jconfigint.h.in")
    add_configfiles("simd/arm/neon-compat.h.in")
    if is_plat("macosx") then
        add_defines("MACHO")
    end
    if get_config("with_simd") then
        if is_arch("x86", "x64", "i386", "x86_64") then
            add_vectorexts("avx2")
            set_toolset("as", "nasm")
            add_includedirs("simd/nasm")
            add_defines("__x86_64__")
        elseif is_arch("arm.*") then
            add_vectorexts("neon")
            add_defines("NEON_INTRINSICS")
        else
            add_vectorexts("all")
        end
    end
    for _, f in ipairs(JPEG_SOURCES) do
        add_files(f)
    end
    for _, f in ipairs(SIMD_SOURCES) do
        add_files(path.join("simd", f))
    end
