if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end
if is_arch("x86", "i386", "x86_64", "x64") then
configvar_check_csnippets("OPUS_X86_MAY_HAVE_AVX", [[
#include <immintrin.h>
#include <time.h>
int main () {
    __m256 mtest;
    mtest = _mm256_set1_ps((float)time(NULL));
    mtest = _mm256_addsub_ps(mtest, mtest);
    return _mm_cvtss_si32(_mm256_extractf128_ps(mtest, 0));
    return 0;
}]])
configvar_check_csnippets("OPUS_X86_MAY_HAVE_SSE", [[
#include <immintrin.h>
#include <time.h>
int main () {
    __m128 mtest;
    mtest = _mm_set1_ps((float)time(NULL));
    mtest = _mm_mul_ps(mtest, mtest);
    return _mm_cvtss_si32(mtest);
}]])
configvar_check_csnippets("OPUS_X86_MAY_HAVE_SSE2", [[
#include <immintrin.h>
#include <time.h>
int main () {
    __m128i mtest;
    mtest = _mm_set1_epi32((int)time(NULL));
    mtest = _mm_mul_epu32(mtest, mtest);
    return _mm_cvtsi128_si32(mtest);
}]])
configvar_check_csnippets("OPUS_X86_MAY_HAVE_SSE4_1", [[
#include <immintrin.h>
#include <time.h>
int main () {
    __m128i mtest;
    mtest = _mm_set1_epi32((int)time(NULL));
    mtest = _mm_mul_epi32(mtest, mtest);
    return _mm_cvtsi128_si32(mtest);
}]])
end

configvar_check_cincludes("HAVE_ALLOCA_H", "alloca.h")
configvar_check_cincludes("STDC_HEADERS", "stddef.h")
configvar_check_cincludes("HAVE_DLFCN_H", "alloca.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
configvar_check_cincludes("HAVE_STRING_H", "string.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cfuncs("HAVE_LRINT", "lrint", {includes={"math.h"}})
configvar_check_cfuncs("HAVE_LRINTF", "lrintf", {includes={"math.h"}})
configvar_check_cfuncs("HAVE___MALLOC_HOOK", "__malloc_hook", {includes={"memory.h"}})

local function configvar_check_csnippets_many(defines, code, opt) 
    for _, define in ipairs(defines) do
        configvar_check_csnippets(define, code, opt)
    end
end

if is_arch("arm.*") then
    set_configvar("OPUS_ARM_ASM", 1)
    configvar_check_csnippets_many({
        "OPUS_ARM_INLINE_ASM",
        "OPUS_ARM_INLINE_NEON",
        "OPUS_ARM_PRESUME_NEON",
        "OPUS_ARM_MAY_HAVE_NEON"
    }, [[
int main() {
    __asm__("vorr d0,d0,d0");
    return 0;
}]])
    configvar_check_csnippets_many({"OPUS_ARM_MAY_HAVE_NEON_INTR", "OPUS_ARM_PRESUME_NEON_INTR"}, [[
#include <arm_neon.h>
int main() {
    static float32x4_t A0, A1, SUMM;
    SUMM = vmlaq_f32(SUMM, A0, A1);
    return (int)vgetq_lane_f32(SUMM, 0);
}]])
    configvar_check_csnippets("HAVE_ARM_NE10", [[
#include <NE10_dsp.h>
int main() {
    ne10_fft_cfg_float32_t cfg;
    cfg = ne10_fft_alloc_c2c_float32_neon(480);
}]])
    configvar_check_csnippets_many({
        "OPUS_ARM_INLINE_EDSP",
        "OPUS_ARM_PRESUME_EDSP",
        "OPUS_ARM_MAY_HAVE_EDSP"
    }, [[
int main() {
    __asm__("qadd r3,r3,r3");
    return 0;
}]])
    configvar_check_csnippets_many({
        "OPUS_ARM_INLINE_MEDIA",
        "OPUS_ARM_PRESUME_MEDIA",
        "OPUS_ARM_MAY_HAVE_MEDIA"
    }, [[
int main () {
    __asm__("shadd8 r3,r3,r3");
    return 0;
}]])
    configvar_check_csnippets("OPUS_ARM_PRESUME_AARCH64_NEON_INTR", [[
#include <arm_neon.h>
#include <stdint.h>
int main () {
    static int32_t IN;
    static int16_t OUT;
    OUT = vqmovns_s32(IN);
    return 0;
}]])
end

set_configvar("CPU_INFO_BY_ASM", 1)
set_configvar("ENABLE_HARDENING", 1)
set_configvar("OPUS_BUILD", 1)
set_configvar("OPUS_HAVE_RTCD", 1)
set_configvar("_FORTIFY_SOURCE", 2)
set_configvar("PACKAGE_BUGREPORT", "opus@xiph.org")
set_configvar("PACKAGE_NAME", "opus")
set_configvar("PACKAGE_STRING", "opus 1.4")
set_configvar("PACKAGE_TARNAME", "opus")
set_configvar("PACKAGE_URL", "")
set_configvar("PACKAGE_VERSION", "1.4")
configvar_check_csnippets("VAR_ARRAYS", [[
#include <alloca.h>
int main () {
    static int x;
    char a[++x];
    a[sizeof a - 1] = 0;
    int N;
    return a[0];
}]])
configvar_check_csnippets("USE_ALLOCA", [[
#include <alloca.h>
int main () {
    int foo = 10;
    int *array = alloca(foo);
    return 0;
}]])

if is_plat("windows", "mingw") and is_kind("shared") then
    set_configvar("DLL_EXPORT", 1)
end

add_configfiles("build/config.h.in")

target("opus")
    set_kind("$(kind)")
    add_includedirs("$(buildir)")
    add_defines("HAVE_CONFIG_H")
    add_includedirs(".", "include", "celt", "silk", "silk/float")
    add_files("src/*.c|opus_demo.c|repacketizer_demo.c|opus_compare.c")
    add_files("celt/*.c|opus_custom_demo.c")
    add_files("silk/*.c")
    add_files("silk/float/*.c")
    if is_arch("arm.*") then
        add_files("celt/arm/*.c|celt_fft_ne10.c")
        add_files("silk/arm/*.c|arm_silk_map.c")
    elseif is_arch("x86", "i386", "x86_64", "x64") then
        add_files("celt/x86/*.c")
        add_files("silk/x86/*.c")
    end
    add_headerfiles("include/*.h")
    add_vectorexts("all")
