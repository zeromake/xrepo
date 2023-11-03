if xmake.version():ge("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
    includes("check_csnippets.lua")
    includes("check_cfuncs.lua")
    includes("check_ctypes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "src/common/tuklib_cpucores.c",
    "src/common/tuklib_physmem.c",
    "src/liblzma/check/check.c",
    "src/liblzma/check/crc32_fast.c",
    "src/liblzma/check/crc32_table.c",
    "src/liblzma/check/crc64_fast.c",
    "src/liblzma/check/crc64_table.c",
    "src/liblzma/check/sha256.c",
    "src/liblzma/common/alone_decoder.c",
    "src/liblzma/common/alone_encoder.c",
    "src/liblzma/common/auto_decoder.c",
    "src/liblzma/common/block_buffer_decoder.c",
    "src/liblzma/common/block_buffer_encoder.c",
    "src/liblzma/common/block_decoder.c",
    "src/liblzma/common/block_encoder.c",
    "src/liblzma/common/block_header_decoder.c",
    "src/liblzma/common/block_header_encoder.c",
    "src/liblzma/common/block_util.c",
    "src/liblzma/common/common.c",
    "src/liblzma/common/easy_buffer_encoder.c",
    "src/liblzma/common/easy_decoder_memusage.c",
    "src/liblzma/common/easy_encoder.c",
    "src/liblzma/common/easy_encoder_memusage.c",
    "src/liblzma/common/easy_preset.c",
    "src/liblzma/common/file_info.c",
    "src/liblzma/common/filter_buffer_decoder.c",
    "src/liblzma/common/filter_buffer_encoder.c",
    "src/liblzma/common/filter_common.c",
    "src/liblzma/common/filter_decoder.c",
    "src/liblzma/common/filter_encoder.c",
    "src/liblzma/common/filter_flags_decoder.c",
    "src/liblzma/common/filter_flags_encoder.c",
    "src/liblzma/common/hardware_cputhreads.c",
    "src/liblzma/common/hardware_physmem.c",
    "src/liblzma/common/index.c",
    "src/liblzma/common/index_decoder.c",
    "src/liblzma/common/index_encoder.c",
    "src/liblzma/common/index_hash.c",
    "src/liblzma/common/outqueue.c",
    "src/liblzma/common/stream_buffer_decoder.c",
    "src/liblzma/common/stream_buffer_encoder.c",
    "src/liblzma/common/stream_decoder.c",
    "src/liblzma/common/stream_encoder.c",
    "src/liblzma/common/stream_encoder_mt.c",
    "src/liblzma/common/stream_flags_common.c",
    "src/liblzma/common/stream_flags_decoder.c",
    "src/liblzma/common/stream_flags_encoder.c",
    "src/liblzma/common/vli_decoder.c",
    "src/liblzma/common/vli_encoder.c",
    "src/liblzma/common/vli_size.c",
    "src/liblzma/delta/delta_common.c",
    "src/liblzma/delta/delta_decoder.c",
    "src/liblzma/delta/delta_encoder.c",
    "src/liblzma/lz/lz_decoder.c",
    "src/liblzma/lz/lz_encoder.c",
    "src/liblzma/lz/lz_encoder_mf.c",
    "src/liblzma/lzma/fastpos_table.c",
    "src/liblzma/lzma/lzma2_decoder.c",
    "src/liblzma/lzma/lzma2_encoder.c",
    "src/liblzma/lzma/lzma2_encoder_rmf.c",
    "src/liblzma/lzma/lzma_decoder.c",
    "src/liblzma/lzma/lzma_encoder.c",
    "src/liblzma/lzma/lzma_encoder_optimum_fast.c",
    "src/liblzma/lzma/lzma_encoder_optimum_normal.c",
    "src/liblzma/lzma/lzma_encoder_presets.c",
    "src/liblzma/lzma/lzma2_fast_encoder.c",
    "src/liblzma/radix/radix_bitpack.c",
    "src/liblzma/radix/radix_mf.c",
    "src/liblzma/radix/radix_struct.c",
    "src/liblzma/rangecoder/price_table.c",
    "src/liblzma/rangecoder/range_fast_enc.c",
    "src/liblzma/simple/arm.c",
    "src/liblzma/simple/armthumb.c",
    "src/liblzma/simple/ia64.c",
    "src/liblzma/simple/powerpc.c",
    "src/liblzma/simple/simple_coder.c",
    "src/liblzma/simple/simple_decoder.c",
    "src/liblzma/simple/simple_encoder.c",
    "src/liblzma/simple/sparc.c",
    "src/liblzma/simple/x86.c",
}

local checkHeaders = {
    "byteswap.h",
    "CommonCrypto/CommonDigest.h",
    "dlfcn.h",
    "fcntl.h",
    "getopt.h",
    "immintrin.h",
    "inttypes.h",
    "limits.h",
    "minix/config.h",
    "sha256.h",
    "sha2.h",
    "stdatomic.h",
    "stdio.h",
    "stdlib.h",
    "strings.h",
    "string.h",
    "sys/byteorder.h",
    "sys/capsicum.h",
    "sys/endian.h",
    "sys/param.h",
    "sys/stat.h",
    "sys/time.h",
    "sys/types.h",
    "unistd.h",
    "wchar.h",
    "stdbool.h",
}

local checkFuns = {
    bswap_16 = {"byteswap.h"},
    bswap_32 = {"byteswap.h"},
    bswap_64 = {"byteswap.h"},
    CC_SHA256_Init = {"sha256.h"},
    clock_gettime = {"time.h"},
    dcgettext = {"libintl.h"},
    futimens = {"fcntl.h", "sys/stat.h"},
    futimes = {"sys/time.h"},
    futimesat = {"fcntl.h", "sys/time.h"},
    getopt_long = {"getopt.h"},
    gettext = {"libintl.h"},
    iconv = {"iconv.h"},
    posix_fadvise = {"fcntl.h"},
    pthread_condattr_setclock = {"pthread.h"},
    SHA256Init = {"sha256.h"},
    SHA256_Init = {"sha256.h"},
    wcwidth = {"wchar.h"},
    _futime = {"sys/utime.h"},
}

local checkSymbols = {
    optreset = {"unistd.h"},
    PTHREAD_PRIO_INHERIT = {"pthread.h"},
    program_invocation_name = {"errno.h"},
    CLOCK_MONOTONIC = {"time.h"}
}

local checkTypes = {
    SHA256_CTX = {"sha256.h"},
    SHA2_CTX = {"sha2.h"},
    _Bool = {},
    uintptr_t = {},
}

local checkMembers = {
    {"struct stat", "st_atimensec", {"sys/stat.h"}},
    {"struct stat", "st_atimespec.tv_nsec", {"sys/stat.h"}},
    {"struct stat", "st_atim.st__tim.tv_nsec", {"sys/stat.h"}},
    {"struct stat", "st_atim.tv_nsec", {"sys/stat.h"}},
    {"struct stat", "st_uatime", {"sys/stat.h"}},
}


function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

function configvar_check_has_member(define_name, type_name, member, opt)
    configvar_check_csnippets(define_name, format([[
void has_member() {
    %s a;
    a.%s;
}]], type_name, member), opt)
end

target("fxz")
    set_kind("$(kind)")

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("config.h.in")

    add_includedirs(
        "src/liblzma/api",
        "src/liblzma/common",
        "src/liblzma/check",
        "src/liblzma/lz",
        "src/liblzma/rangecoder",
        "src/liblzma/lzma",
        "src/liblzma/delta",
        "src/liblzma/radix",
        "src/liblzma/simple",
        "src/common"
    )


    for _, checkHeader in ipairs(checkHeaders) do
        local defineName = "HAVE_"..(checkHeader:gsub("/", "_"):gsub("%.", "_"):upper())
        configvar_check_cincludes(defineName, checkHeader)
    end

    for checkFun, include in pairs(checkFuns) do
        local defineName = "HAVE_"..(checkFun:upper())
        configvar_check_cfuncs(defineName, checkFun, {includes=include})
    end

    for checkName, include in pairs(checkSymbols) do
        local defineName = "HAVE_"..(checkName:upper())
        configvar_check_csymbol_exists(defineName, checkName, {includes=include})
    end

    for checkName, include in pairs(checkTypes) do
        local defineName = "HAVE_"..(checkName:upper())
        configvar_check_ctypes(defineName, checkName, {includes=include})
    end

    for _, checkItem in ipairs(checkMembers) do
        local defineName = "HAVE_"..(checkItem[1]:gsub(" ", "_").."_"..checkItem[2]:gsub("%.", "_")):upper()
        configvar_check_has_member(defineName, checkItem[1], checkItem[2], {includes=checkItem[3]})
    end

    configvar_check_csnippets("HAVE_MBRTOWC", [[
#include <wchar.h>

int test() {
    wchar_t wc;
    const char s[]= "";
    size_t n = 1;
    mbstate_t state;
    if (sizeof(state)) {
        return mbrtowc(&wc, s, n, &state);
    }
    return 0;
}
]])
    configvar_check_csnippets("HAVE_CFLOCALECOPYPREFERREDLANGUAGES", [[
#include <CoreFoundation/CFLocale.h>
int test () {
    CFLocaleCopyPreferredLanguages();
    return 0;
}]])
    configvar_check_csnippets("HAVE_CFPREFERENCESCOPYAPPVALUE", [[
#include <CoreFoundation/CFPreferences.h>
int test () {
    CFPreferencesCopyAppValue(NULL, NULL);
    return 0;
}]])
    configvar_check_csnippets("HAVE__MM_MOVEMASK_EPI8", [[
#include <immintrin.h>
int test() {
    __m128i x = { 0 };
    _mm_movemask_epi8(x);
    return 0;
}]])

    set_configvar("ENABLE_NLS", 1)
    set_configvar("HAVE_CHECK_CRC32", 1)
    set_configvar("HAVE_CHECK_CRC64", 1)
    set_configvar("HAVE_CHECK_SHA256", 1)
    set_configvar("ASSUME_RAM", 128)
    if is_plat("windows", "mingw") then
        set_configvar("MYTHREAD_VISTA", 1)
    else
        set_configvar("MYTHREAD_POSIX", 1)
    end

    -- coders
    local coders = {
        "ARM",
        "ARMTHUMB",
        "DELTA",
        "IA64",
        "LZMA1",
        "LZMA2",
        "POWERPC",
        "SPARC",
        "X86",
    }
    set_configvar("HAVE_DECODERS", 1)
    set_configvar("HAVE_ENCODERS", 1)
    for _, coder in ipairs(coders) do
        set_configvar("HAVE_DECODER_"..coder, 1)
        set_configvar("HAVE_ENCODER_"..coder, 1)
    end

    local finders = {
        "hc3",
        "hc4",
        "bt2",
        "bt3",
        "bt4",
        "rad",
    }

    for _, finder in ipairs(finders) do
        set_configvar("HAVE_MF_"..finder:upper(), 1)
    end

    set_configvar("PACKAGE", "fxz")
    set_configvar("PACKAGE_BUGREPORT", "conor.mccarthy.444@gmail.com")
    set_configvar("PACKAGE_NAME", "FXZ Utils")
    set_configvar("PACKAGE_STRING", "FXZ Utils 1.1.0alpha")
    set_configvar("PACKAGE_TARNAME", "fxz")
    set_configvar("PACKAGE_URL", "https://github.com/conor42/fxz")
    set_configvar("PACKAGE_VERSION", "1.1.0alpha")
    set_configvar("STDC_HEADERS", 1)
    set_configvar("_ALL_SOURCE", 1)
    set_configvar("_DARWIN_C_SOURCE", 1)
    set_configvar("_GNU_SOURCE", 1)
    set_configvar("_HPUX_ALT_XOPEN_SOCKET_API", 1)
    set_configvar("_NETBSD_SOURCE", 1)
    set_configvar("_OPENBSD_SOURCE", 1)
    set_configvar("_POSIX_PTHREAD_SEMANTICS", 1)
    set_configvar("__STDC_WANT_IEC_60559_ATTRIBS_EXT__", 1)
    set_configvar("__STDC_WANT_IEC_60559_BFP_EXT__", 1)
    set_configvar("__STDC_WANT_IEC_60559_DFP_EXT__", 1)
    set_configvar("__STDC_WANT_IEC_60559_FUNCS_EXT__", 1)
    set_configvar("__STDC_WANT_IEC_60559_TYPES_EXT__", 1)
    set_configvar("__STDC_WANT_LIB_EXT2__", 1)
    set_configvar("__STDC_WANT_MATH_SPEC_FUNCS__", 1)
    set_configvar("_TANDEM_SOURCE", 1)
    set_configvar("VERSION", "1.1.0alpha")

    add_headerfiles("src/liblzma/api/*.h")
    add_headerfiles("src/liblzma/api/flzma/*.h", {prefixdir = "flzma"})
    add_defines("HAVE_CONFIG_H=1")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
