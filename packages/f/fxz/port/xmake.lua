includes("check_cincludes.lua")
includes("check_csnippets.lua")
includes("check_cfuncs.lua")
includes("check_ctypes.lua")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

local checkHeades = {
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
}

local checkSymbols = {
    optreset = {"unistd.h"},
    PTHREAD_PRIO_INHERIT = {"pthread.h"},
}

local checkTypes = {
    SHA256_CTX = {"sha256.h"},
    SHA2_CTX = {"sha2.h"},
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
    
    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")

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

    set_configvar("ENABLE_NLS", 1)
    set_configvar("HAVE_CHECK_CRC32", 1)
    set_configvar("HAVE_CHECK_CRC64", 1)
    set_configvar("HAVE_CHECK_SHA256", 1)

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

    configvar_check_has_member("HAVE_STRUCT_STAT_ST_ATIMENSEC", )

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
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
