includes("@builtin/check")
add_rules("mode.debug", "mode.release")

option("asm")
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
includes("files.lua")
includes("util.lua")
includes("export_symbol.lua")

target("check.object")
    set_kind("object")
    on_config(function (target)
        local check = import("check")(target)
    end)


target("crypto")
    set_kind("$(kind)")
    add_defines("LIBRESSL_CRYPTO_INTERNAL")
    add_deps("check.object")
    
    for _, dir in ipairs(CRYPTO_INCLUDE_DIRS) do
        add_includedirs(dir)
    end
    local host_asm_check = CheckAsmPlat()
    local crypto_asm_files = {}
    local unexport = {}
    if is_plat("windows", "mingw") then
        add_defines("OPENSSLDIR=\"C:/Windows/libressl/ssl\"")
        add_files("crypto/crypto.def")
        table.insert(unexport, 'BIO_s_log')
    else
        add_defines("OPENSSLDIR=\"/etc/ssl\"")
    end
    add_rules("export_symbol", {file = 'crypto/crypto.sym', unexport = unexport})
    if not host_asm_check.HOST_ENABLE_ASM then
        add_defines("OPENSSL_NO_ASM")
    end
    if host_asm_check.HOST_ASM_ELF_ARMV4 then
        add_files(table.unpack(CRYPTO_ELF_ARMV4_FILE))
        add_defines(table.unpack(CRYPTO_ELF_ARMV4_DEFINE))
    elseif host_asm_check.HOST_ASM_ELF_X86_64 then
        add_files(table.unpack(CRYPTO_ELF_X86_64_FILE))
        add_defines(table.unpack(CRYPTO_ELF_X86_64_DEFINE))
    elseif host_asm_check.HOST_ASM_MACOSX_X86_64 then
        add_files(table.unpack(CRYPTO_MACOSX_X86_64_FILE))
        add_defines(table.unpack(CRYPTO_MACOSX_X86_64_DEFINE))
    elseif host_asm_check.HOST_ASM_MASM_X86_64 then
        add_files(table.unpack(CRYPTO_MASM_X86_64_FILE))
        add_defines(table.unpack(CRYPTO_MASM_X86_64_DEFINE))
    elseif host_asm_check.HOST_ASM_MINGW64_X86_64 then
        add_files(table.unpack(CRYPTO_MINGW64_X86_64_FILE))
        add_defines(table.unpack(CRYPTO_MINGW64_X86_64_DEFINE))
    end
    if not host_asm_check.HOST_ASM_ELF_X86_64 and 
        not host_asm_check.HOST_ASM_MACOSX_X86_64 and
        not host_asm_check.HOST_ASM_MASM_X86_64 and
        not host_asm_check.HOST_ASM_ELF_ARMV4 then
        add_files("crypto/aes/aes_core.c")
    end

    if not host_asm_check.HOST_ASM_ELF_X86_64 and 
        not host_asm_check.HOST_ASM_MACOSX_X86_64 and
        not host_asm_check.HOST_ASM_MASM_X86_64 then
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
        "empty.c",
    }) do
        add_files(path.join("crypto", f))
    end
    for _, f in ipairs({
        "aes/*.c|aes_cbc.c|aes_core.c",
        "asn1/*.c",
        "bf/*.c",
        "bio/*.c|b_win.c|b_posix.c|bss_log.c",
        "bn/*.c",
        "buffer/*.c",
        "bytestring/*.c",
        "cast/*.c",
        "chacha/*.c|chacha-merged.c",
        "camellia/*.c|camellia.c|cmll_cbc.c",
        "cmac/*.c",
        "cms/*.c",
        "conf/*.c",
        "ct/*.c",
        "curve25519/*.c",
        "des/*.c|ncbc_enc.c",
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
        "poly1305/*.c|poly1305-donna.c",
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
        "whrlpool/*.c|wp_block.c",
        "x509/*.c",
    }) do
        add_files(path.join("crypto", f))
    end
    local CRYPTO_UNEXPORT = {}
    local CRYPTO_EXTRA_EXPORT = {}
    if is_plat("windows", "mingw") then
        add_files(
            "crypto/compat/posix_win.c",
            "crypto/compat/crypto_lock_win.c",
            "crypto/bio/b_win.c",
            "crypto/ui/ui_openssl_win.c"
        )
        CRYPTO_UNEXPORT['BIO_s_log'] = true
        table.join2(CRYPTO_EXTRA_EXPORT, {
            'gettimeofday',
            'getuid',
            'posix_perror',
            'posix_fopen',
            'posix_fgets',
            'posix_open',
            'posix_rename',
            'posix_connect',
            'posix_close',
            'posix_read',
            'posix_write',
            'posix_getsockopt',
            'posix_setsockopt',
        })
    else
        add_files(
            "crypto/crypto_lock.c",
            "crypto/bio/b_posix.c",
            "crypto/bio/bss_log.c",
            "crypto/ui/ui_openssl.c"
        )
    end
    on_config(function (target)
        local check = import("check")(target)
        if not check.HAVE_ASPRINTF then
            target:add("files", "crypto/compat/bsd-asprintf.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'asprintf',
                'vasprintf',
            })
        end
        if not check.HAVE_FREEZERO then
            target:add("files", "crypto/compat/freezero.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'freezero',
            })
        end
        if not check.HAVE_GETOPT then
            target:add("files", "crypto/compat/getopt_long.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'getopt',
                'optarg',
                'optind',
            })
        end
        if not check.HAVE_GETPAGESIZE then
            target:add("files", "crypto/compat/getpagesize.c")
        end
        if not check.HAVE_GETPROGNAME then
            if is_plat("windows", "mingw") then
                target:add("files", "crypto/compat/getprogname_windows.c")
            elseif is_plat("linux") then
                target:add("files", "crypto/compat/getprogname_linux.c")
            else
                target:add("files", "crypto/compat/getprogname_unimpl.c")
            end
        end
        if not check.HAVE_REALLOCARRAY then
            target:add("files", "crypto/compat/reallocarray.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'reallocarray',
            })
        end
        if not check.HAVE_RECALLOCARRAY then
            target:add("files", "crypto/compat/recallocarray.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'recallocarray',
            })
        end
        if not check.HAVE_STRCASECMP then
            target:add("files", "crypto/compat/strcasecmp.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strcasecmp',
            })
        end
        if not check.HAVE_STRLCAT then
            target:add("files", "crypto/compat/strlcat.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strlcat',
            })
        end
        if not check.HAVE_STRLCPY then
            target:add("files", "crypto/compat/strlcpy.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strlcpy',
            })
        end
        if not check.HAVE_STRNDUP then
            target:add("files", "crypto/compat/strndup.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strndup',
            })
        end
        if not check.HAVE_STRNLEN then
            target:add("files", "crypto/compat/strnlen.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strnlen',
            })
        end
        if not check.HAVE_STRSEP then
            target:add("files", "crypto/compat/strsep.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strsep',
            })
        end
        if not check.HAVE_STRTONUM then
            target:add("files", "crypto/compat/strtonum.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'strtonum',
            })
        end
        if not check.HAVE_SYSLOG_R then
            target:add("files", "crypto/compat/syslog_r.c")
        end
        if not check.HAVE_TIMEGM then
            target:add("files", "crypto/compat/timegm.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'timegm',
            })
        end
        if not check.HAVE_EXPLICIT_BZERO then
            if is_plat("windows", "mingw") then
                target:add("files", "crypto/compat/explicit_bzero_win.c")
            else
                target:add("files", "crypto/compat/explicit_bzero.c")
            end
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'explicit_bzero',
            })
        end
        if not check.HAVE_ARC4RANDOM_BUF then
            target:add("files", "crypto/compat/arc4random.c")
            target:add("files", "crypto/compat/arc4random_uniform.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'arc4random',
                'arc4random_buf',
                'arc4random_uniform',
            })
        end
        if not check.HAVE_GETENTROPY then
            if is_plat("windows", "mingw") then
                target:add("files", "crypto/compat/getentropy_win.c")
            elseif is_plat("linux", "android") then
                target:add("files", "crypto/compat/getentropy_linux.c")
            elseif is_plat("bsd") then
                target:add("files", "crypto/compat/getentropy_freebsd.c")
            else
                target:add("files", "crypto/compat/getentropy_osx.c")
            end
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'getentropy',
            })
        end
        if not check.HAVE_TIMINGSAFE_BCMP then
            target:add("files", "crypto/compat/timingsafe_bcmp.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'timingsafe_bcmp',
            })
        end
        if not check.HAVE_TIMINGSAFE_MEMCMP then
            target:add("files", "crypto/compat/timingsafe_memcmp.c")
            table.join2(CRYPTO_EXTRA_EXPORT, {
                'timingsafe_memcmp',
            })
        end
        -- local syms = io.readfile("crypto/crypto.sym"):split('\n')
        -- local syms_p = {}
        -- for _, s in ipairs(syms) do
        --     if not CRYPTO_UNEXPORT[s] then
        --         table.insert(syms_p, s)
        --     end
        -- end
        -- table.join2(syms_p, CRYPTO_EXTRA_EXPORT)
        -- target:add('rules', 'export_symbol', {list = syms_p})
    end)

-- target("ssl")
--     set_kind("$(kind)")

-- target("tls")
--     set_kind("$(kind)")
