includes("@builtin/check")
add_rules("mode.debug", "mode.release")

option("enable_asm")
    set_default(true)
    set_description("enable asm")
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cxflags("/utf-8")
    add_defines(
        "_CRT_SECURE_NO_WARNINGS",
        "_CRT_DEPRECATED_NO_WARNINGS",
        "_REENTRANT",
        "_POSIX_THREAD_SAFE_FUNCTIONS",
        "CPPFLAGS",
        "NO_SYSLOG",
        "NO_CRYPT",
        "WIN32_LEAN_AND_MEAN",
        "_WIN32_WINNT=0x0600",
        "inline=__inline"
    )
    add_syslinks("ws2_32", "ntdll", "bcrypt")
end

if is_plat("bsd") then
    add_defines(
        "HAVE_ATTRIBUTE__BOUNDED__",
        "HAVE_ATTRIBUTE__DEAD__"
    )
elseif is_plat("linux") then
    add_defines(
        "_DEFAULT_SOURCE",
        "_BSD_SOURCE",
        "_POSIX_SOURCE",
        "_GNU_SOURCE"
    )
    add_syslinks("pthread")
elseif is_plat("windows", "mingw") then
    add_defines(
        "_GNU_SOURCE",
        "_POSIX",
        "_POSIX_SOURCE",
        "__USE_MINGW_ANSI_STDIO"
    )
end

add_defines(
    "LIBRESSL_INTERNAL",
    "OPENSSL_NO_HW_PADLOCK",
    "__BEGIN_HIDDEN_DECLS=",
    "__END_HIDDEN_DECLS="
)

local HOST_ASM_ELF_X86_64 = false
local HOST_ASM_ELF_ARMV4 = false
local HOST_ASM_MACOSX_X86_64 = false
local HOST_ASM_MASM_X86_64 = false
local HOST_ASM_MINGW64_X86_64 = false

if is_plat("macosx") and is_arch("x64", "x86_64") then
    HOST_ASM_MASM_X86_64 = true
elseif is_plat("windows") and is_arch("x64", "x86_64") then
    HOST_ASM_MASM_X86_64 = true
elseif is_plat("mingw") and is_arch("x64", "x86_64") then
    HOST_ASM_MINGW64_X86_64 = true
else
    if is_arch("x64", "x86_64") then
        HOST_ASM_ELF_X86_64 = true
    elseif is_arch("arm.*") or is_arch("arm64.*") then
        HOST_ASM_ELF_ARMV4 = true
    end
end


target("crypto")
    set_kind("$(kind)")
    add_defines("LIBRESSL_CRYPTO_INTERNAL")
    local crypto_asm_files = {}
    if is_plat("windows", "mingw") then
        add_defines("OPENSSLDIR=\"C:/Windows/libressl/ssl\"")
    else
        add_defines("OPENSSLDIR=\"/etc/ssl\"")
    end

    if HOST_ASM_ELF_ARMV4 then
        table.join(crypto_asm_files, {
            "aes/aes-elf-armv4.S",
            "bn/mont-elf-armv4.S",
            "sha/sha1-elf-armv4.S",
            "sha/sha512-elf-armv4.S",
            "sha/sha256-elf-armv4.S",
            "modes/ghash-elf-armv4.S",
            "armv4cpuid.S",
            "armcap.c",
        })
        add_defines(
            "AES_ASM",
            "OPENSSL_BN_ASM_MONT",
            "GHASH_ASM",
            "SHA1_ASM",
            "SHA256_ASM",
            "SHA512_ASM",
            "OPENSSL_CPUID_OBJ"
        )
    elseif HOST_ASM_ELF_X86_64 then
        table.join(crypto_asm_files, {
            "aes/aes-elf-x86_64.S",
            "aes/bsaes-elf-x86_64.S",
            "aes/vpaes-elf-x86_64.S",
            "aes/aesni-elf-x86_64.S",
            "aes/aesni-sha1-elf-x86_64.S",
            "bn/modexp512-elf-x86_64.S",
            "bn/mont-elf-x86_64.S",
            "bn/mont5-elf-x86_64.S",
            "camellia/cmll-elf-x86_64.S",
            "md5/md5-elf-x86_64.S",
            "modes/ghash-elf-x86_64.S",
            "rc4/rc4-elf-x86_64.S",
            "rc4/rc4-md5-elf-x86_64.S",
            "sha/sha1-elf-x86_64.S",
            "sha/sha256-elf-x86_64.S",
            "sha/sha512-elf-x86_64.S",
            "whrlpool/wp-elf-x86_64.S",
            "cpuid-elf-x86_64.S",

            "bn/arch/amd64/bignum_add.S",
            "bn/arch/amd64/bignum_cmadd.S",
            "bn/arch/amd64/bignum_cmul.S",
            "bn/arch/amd64/bignum_mul.S",
            "bn/arch/amd64/bignum_mul_4_8_alt.S",
            "bn/arch/amd64/bignum_mul_8_16_alt.S",
            "bn/arch/amd64/bignum_sqr.S",
            "bn/arch/amd64/bignum_sqr_4_8_alt.S",
            "bn/arch/amd64/bignum_sqr_8_16_alt.S",
            "bn/arch/amd64/bignum_sub.S",
            "bn/arch/amd64/word_clz.S",
            "bn/arch/amd64/bn_arch.c",
        })
        add_defines(
            "AES_ASM",
            "BSAES_ASM",
            "VPAES_ASM",
            "OPENSSL_IA32_SSE2",
            "OPENSSL_BN_ASM_MONT",
            "OPENSSL_BN_ASM_MONT5",
            "MD5_ASM",
            "GHASH_ASM",
            "RSA_ASM",
            "SHA1_ASM",
            "SHA256_ASM",
            "SHA512_ASM",
            "WHIRLPOOL_ASM",
            "OPENSSL_CPUID_OBJ"
        )
    elseif HOST_ASM_MACOSX_X86_64 then
        table.join(crypto_asm_files, {
            "aes/aes-macosx-x86_64.S",
            "aes/bsaes-macosx-x86_64.S",
            "aes/vpaes-macosx-x86_64.S",
            "aes/aesni-macosx-x86_64.S",
            "aes/aesni-sha1-macosx-x86_64.S",
            "bn/modexp512-macosx-x86_64.S",
            "bn/mont-macosx-x86_64.S",
            "bn/mont5-macosx-x86_64.S",
            "camellia/cmll-macosx-x86_64.S",
            "md5/md5-macosx-x86_64.S",
            "modes/ghash-macosx-x86_64.S",
            "rc4/rc4-macosx-x86_64.S",
            "rc4/rc4-md5-macosx-x86_64.S",
            "sha/sha1-macosx-x86_64.S",
            "sha/sha256-macosx-x86_64.S",
            "sha/sha512-macosx-x86_64.S",
            "whrlpool/wp-macosx-x86_64.S",
            "cpuid-macosx-x86_64.S",

            "bn/arch/amd64/bignum_add.S",
            "bn/arch/amd64/bignum_cmadd.S",
            "bn/arch/amd64/bignum_cmul.S",
            "bn/arch/amd64/bignum_mul.S",
            "bn/arch/amd64/bignum_mul_4_8_alt.S",
            "bn/arch/amd64/bignum_mul_8_16_alt.S",
            "bn/arch/amd64/bignum_sqr.S",
            "bn/arch/amd64/bignum_sqr_4_8_alt.S",
            "bn/arch/amd64/bignum_sqr_8_16_alt.S",
            "bn/arch/amd64/bignum_sub.S",
            "bn/arch/amd64/word_clz.S",
            "bn/arch/amd64/bn_arch.c",
        })
        add_defines(
            "AES_ASM",
            "BSAES_ASM",
            "VPAES_ASM",
            "OPENSSL_IA32_SSE2",
            "OPENSSL_BN_ASM_MONT",
            "OPENSSL_BN_ASM_MONT5",
            "MD5_ASM",
            "GHASH_ASM",
            "RSA_ASM",
            "SHA1_ASM",
            "SHA256_ASM",
            "SHA512_ASM",
            "WHIRLPOOL_ASM",
            "OPENSSL_CPUID_OBJ"
        )
    elseif HOST_ASM_MASM_X86_64 then
        table.join(crypto_asm_files, {
            "aes/aes-masm-x86_64.S",
            "aes/bsaes-masm-x86_64.S",
            "aes/vpaes-masm-x86_64.S",
            "aes/aesni-masm-x86_64.S",
            "aes/aesni-sha1-masm-x86_64.S",
            "camellia/cmll-masm-x86_64.S",
            "md5/md5-masm-x86_64.S",
            "modes/ghash-masm-x86_64.S",
            "rc4/rc4-masm-x86_64.S",
            "rc4/rc4-md5-masm-x86_64.S",
            "sha/sha1-masm-x86_64.S",
            "sha/sha256-masm-x86_64.S",
            "sha/sha512-masm-x86_64.S",
            "whrlpool/wp-masm-x86_64.S",
            "cpuid-masm-x86_64.S",
        })
        add_defines(
            "endbr64=",
            "AES_ASM",
            "BSAES_ASM",
            "VPAES_ASM",
            "OPENSSL_IA32_SSE2",
            "MD5_ASM",
            "GHASH_ASM",
            "RSA_ASM",
            "SHA1_ASM",
            "SHA256_ASM",
            "SHA512_ASM",
            "WHIRLPOOL_ASM",
            "OPENSSL_CPUID_OBJ"
        )
    elseif HOST_ASM_MINGW64_X86_64 then

    end
    if not HOST_ASM_ELF_X86_64 and 
        not HOST_ASM_MACOSX_X86_64 and
        not HOST_ASM_MASM_X86_64 and
        not HOST_ASM_ELF_ARMV4 then
        add_files("crypto/aes/aes_core.c")
    end

    if not HOST_ASM_ELF_X86_64 and 
        not HOST_ASM_MACOSX_X86_64 and
        not HOST_ASM_MASM_X86_64 then
        add_files(
            "crypto/aes/aes_cbc.c",
            "crypto/camellia/camellia.c",
            "crypto/camellia/cmll_cbc.c",
            "crypto/rc4/rc4_enc.c",
            "crypto/rc4/rc4_skey.c",
            "crypto/whrlpool/wp_block.c"
        )
    end
    for _, f in ipairs({
        "cpt_err.c",
        "cryptlib.c",
        "crypto_init.c",
        "cversion.c",
        "ex_data.c",
        "malloc-wrapper.c",
        "mem_clr.c",
        "mem_dbg.c",
        "o_fips.c",
        "o_init.c",
        "o_str.c",
    }) do
        add_files(path.join("crypto", f))
    end
    for _, f in ipairs({
        "asn1/*.c",
        "bf/*.c",
        "bio/*.c|b_win.c|b_posix.c|bss_log.c",
        "bn/*.c",
        "buffer/*.c",
        "bytestring/*.c",
        "camellia/*.c",
        "cast/*.c",
        "chacha/*.c|chacha-merged.c",
        "cmac/*.c",
        "conf/*.c",
        "ct/*.c",
        "curve25519/*.c",
        "des/*.c",
        "dh/*.c",
        "dsa/*.c",
        "ec/*.c",
        "ecdh/*.c",
        "ecdsa/*.c",
        "engine/*.c",
        "err/*.c",
        "evp/*.c",
        "gost/*.c",
        "hkdf/*.c",
        "hmac/*.c",
        "idea/*.c",
        "kdf/*.c",
        "lhash/*.c",
        "md4/*.c",
        "md5/*.c",
        "modes/*.c",
        "objects/*.c",
        "ocsp/*.c",
        "pem/*.c",
        "pkcs12/*.c",
        "pkcs7/*.c",
        "poly1305/*.c",
        "rand/*.c",
        "rc2/*.c",
        "ripemd/*.c",
        "rsa/*.c",
        "sha/*.c",
        "sm3/*.c",
        "sm4/*.c",
        "stack/*.c",
        "ts/*.c",
        "txt_db/*.c",
        "ui/*.c|ui_openssl.c|ui_openssl_win.c",
        "whrlpool/*.c",
        "x509/*.c",
    }) do
        add_files(path.join("crypto", f))
    end
    on_config(function (target)
        local check = import("check")(target)
        if not check.HAVE_ASPRINTF then
            add_files("crypto/compat/bsd-asprintf.c")
        end
        if not check.HAVE_FREEZERO then
            add_files("crypto/compat/freezero.c")
        end
        if not check.HAVE_GETOPT then
            add_files("crypto/compat/getopt_long.c")
        end
        if not check.HAVE_GETPAGESIZE then
            add_files("crypto/compat/getpagesize.c")
        end
        if not check.HAVE_GETPROGNAME then
            if is_plat("windows", "mingw") then
                add_files("crypto/compat/getprogname_windows.c")
            elseif is_plat("linux") then
                add_files("crypto/compat/getprogname_linux.c")
            else
                add_files("crypto/compat/getprogname_unimpl.c")
            end
        end
        if not check.HAVE_REALLOCARRAY then
            add_files("crypto/compat/reallocarray.c")
        end
        if not check.HAVE_RECALLOCARRAY then
            add_files("crypto/compat/recallocarray.c")
        end
        if not check.HAVE_STRCASECMP then
            add_files("crypto/compat/strcasecmp.c")
        end
        if not check.HAVE_STRLCAT then
            add_files("crypto/compat/strlcat.c")
        end
        if not check.HAVE_STRLCPY then
            add_files("crypto/compat/strlcpy.c")
        end
        if not check.HAVE_STRNDUP then
            add_files("crypto/compat/strndup.c")
        end
        if not check.HAVE_STRNLEN then
            add_files("crypto/compat/strnlen.c")
        end
        if not check.HAVE_STRSEP then
            add_files("crypto/compat/strsep.c")
        end
        if not check.HAVE_STRTONUM then
            add_files("crypto/compat/strtonum.c")
        end
        if not check.HAVE_SYSLOG_R then
            add_files("crypto/compat/syslog_r.c")
        end
        if not check.HAVE_TIMEGM then
            add_files("crypto/compat/timegm.c")
        end
        if not check.HAVE_EXPLICIT_BZERO then
            if is_plat("windows", "mingw") then
                add_files("crypto/compat/explicit_bzero_win.c")
            else
                add_files("crypto/compat/explicit_bzero.c")
            end
        end
        if not check.HAVE_ARC4RANDOM_BUF then
            add_files("crypto/compat/arc4random.c")
            add_files("crypto/compat/arc4random_uniform.c")
        end
        if not check.HAVE_GETENTROPY then
            if is_plat("windows", "mingw") then
                add_files("crypto/compat/getentropy_win.c")
            elseif is_plat("linux", "android") then
                add_files("crypto/compat/getentropy_linux.c")
            elseif is_plat("bsd") then
                add_files("crypto/compat/getentropy_freebsd.c")
            else
                add_files("crypto/compat/getentropy_osx.c")
            end
            add_files("crypto/compat/getentropy_win.c")
        end
        if not check.HAVE_TIMINGSAFE_BCMP then
            add_files("crypto/compat/timingsafe_bcmp.c")
        end
        if not check.HAVE_TIMINGSAFE_MEMCMP then
            add_files("crypto/compat/timingsafe_memcmp.c")
        end
    end)

target("ssl")
    set_kind("$(kind)")

target("tls")
    set_kind("$(kind)")
