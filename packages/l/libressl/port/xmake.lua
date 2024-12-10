includes("@builtin/check")
add_rules("mode.debug", "mode.release")

option("asm")
    set_default(true)
    set_description("enable asm")
    set_showmenu(true)
option_end()

option("openssldir")
    set_default(nil)
    set_description("openssl dir")
    set_showmenu(true)
option_end()

option("installdir")
    if is_host("windows") then
        set_default("C:/Windows/libressl/ssl")
    else
        set_default("/usr/local")
    end
    set_description("openssl install dir")
    set_showmenu(true)
option_end()

option("export_prefix")
    set_default("")
    set_description("export prefix")
    set_showmenu(true)
option_end()

option("merge_archive")
    set_default(false)
    set_description("merge static to tls")
    set_showmenu(true)
option_end()

option("version4")
    set_default(true)
    set_description("version 4")
    set_showmenu(true)
option_end()

option("ca")
    set_default(nil)
    set_description("ca file path")
    set_showmenu(true)
option_end()

set_installdir(get_config('installdir'))

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
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
        "__USE_MINGW_ANSI_STDIO",
        "WIN32_LEAN_AND_MEAN"
    )
end

add_defines(
    "LIBRESSL_INTERNAL",
    "OPENSSL_NO_HW_PADLOCK",
    "__BEGIN_HIDDEN_DECLS=",
    "__END_HIDDEN_DECLS="
)
if get_config("version4") then
    includes("files4.lua")
else
    includes("files.lua")
end
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
    for _, dir in ipairs(COMMON_INCLUDE_DIRS) do
        add_includedirs(dir)
    end
    
    for _, dir in ipairs(CRYPTO_INCLUDE_DIRS) do
        add_includedirs(dir)
    end
    local host_asm_check = CheckAsmPlat()
    local crypto_asm_files = {}
    local unexport = {}
    if get_config('openssldir') then
        add_defines('OPENSSLDIR=$(openssldir)')
    else
        if is_plat("windows", "mingw") then
            add_defines('OPENSSLDIR="$(installdir)"')
        else
            add_defines('OPENSSLDIR="$(installdir)/etc/ssl"')
        end
    end
    add_rules("export_symbol", {file = 'crypto/crypto.sym'})
    if not host_asm_check.HOST_ENABLE_ASM then
        add_defines("OPENSSL_NO_ASM")
    end
    local asm_host = nil
    if host_asm_check.HOST_ASM_ELF_ARMV4 then
        asm_host = 'ELF_ARMV4'
    elseif host_asm_check.HOST_ASM_ELF_X86_64 then
        asm_host = 'ELF_X86_64'
    elseif host_asm_check.HOST_ASM_MACOSX_X86_64 then
        asm_host = 'MACOSX_X86_64'
    elseif host_asm_check.HOST_ASM_MASM_X86_64 then
        asm_host = 'MASM_X86_64'
    elseif host_asm_check.HOST_ASM_MINGW64_X86_64 then
        asm_host = 'MINGW64_X86_64'
    end
    if asm_host then
        add_files(table.unpack(CRYPTO_ASM_FILE[asm_host]))
        add_defines(table.unpack(CRYPTO_ASM_DEFINE[asm_host]))
    end
    if not get_config("version4") and
        not host_asm_check.HOST_ASM_ELF_X86_64 and 
        not host_asm_check.HOST_ASM_MACOSX_X86_64 and
        not host_asm_check.HOST_ASM_MASM_X86_64 and
        not host_asm_check.HOST_ASM_ELF_ARMV4 and
        not host_asm_check.HOST_ASM_MINGW64_X86_64 then
        add_files("crypto/aes/aes_core.c")
    end
    if not host_asm_check.HOST_ASM_ELF_X86_64 and 
        not host_asm_check.HOST_ASM_MACOSX_X86_64 and
        not host_asm_check.HOST_ASM_MASM_X86_64 and
        not host_asm_check.HOST_ASM_MINGW64_X86_64 then
        if get_config("version4") then
            add_files("crypto/camellia/camellia.c")
        else
            add_files(
                "crypto/aes/aes_cbc.c",
                "crypto/camellia/camellia.c",
                "crypto/camellia/cmll_cbc.c",
                "crypto/rc4/rc4_enc.c",
                "crypto/rc4/rc4_skey.c",
                "crypto/whrlpool/wp_block.c"
            )
        end
    end
    add_files(table.unpack(CRYPTO_FILES))
    local CRYPTO_UNEXPORT = {}
    local CRYPTO_EXTRA_EXPORT = {}
    local export_prefix = get_config('export_prefix') or ""
    local function extra_join(arr)
        for _, v in ipairs(arr) do
            table.insert(CRYPTO_EXTRA_EXPORT, export_prefix..v)
        end
    end
    if is_plat("windows", "mingw") then
        add_files(
            "crypto/compat/posix_win.c",
            "crypto/compat/crypto_lock_win.c",
            "crypto/bio/b_win.c",
            "crypto/ui/ui_openssl_win.c"
        )
        table.insert(CRYPTO_UNEXPORT, 'BIO_s_log')
        extra_join({
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
        add_syslinks("ws2_32", "bcrypt")
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
            extra_join({
                'asprintf',
                'vasprintf',
            })
        end
        if not check.HAVE_FREEZERO then
            target:add("files", "crypto/compat/freezero.c")
            extra_join({
                'freezero',
            })
        end
        if not check.HAVE_GETOPT then
            target:add("files", "crypto/compat/getopt_long.c")
            extra_join({
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
            extra_join({
                'reallocarray',
            })
        end
        if not check.HAVE_RECALLOCARRAY then
            target:add("files", "crypto/compat/recallocarray.c")
            extra_join({
                'recallocarray',
            })
        end
        if not check.HAVE_STRCASECMP then
            target:add("files", "crypto/compat/strcasecmp.c")
            extra_join({
                'strcasecmp',
            })
        end
        if not check.HAVE_STRLCAT then
            target:add("files", "crypto/compat/strlcat.c")
            extra_join({
                'strlcat',
            })
        end
        if not check.HAVE_STRLCPY then
            target:add("files", "crypto/compat/strlcpy.c")
            extra_join({
                'strlcpy',
            })
        end
        if not check.HAVE_STRNDUP then
            target:add("files", "crypto/compat/strndup.c")
            extra_join({
                'strndup',
            })
        end
        if not check.HAVE_STRNLEN then
            target:add("files", "crypto/compat/strnlen.c")
            extra_join({
                'strnlen',
            })
        end
        if not check.HAVE_STRSEP then
            target:add("files", "crypto/compat/strsep.c")
            extra_join({
                'strsep',
            })
        end
        if not check.HAVE_STRTONUM then
            target:add("files", "crypto/compat/strtonum.c")
            extra_join({
                'strtonum',
            })
        end
        if not check.HAVE_SYSLOG_R then
            target:add("files", "crypto/compat/syslog_r.c")
        end
        if not check.HAVE_TIMEGM then
            target:add("files", "crypto/compat/timegm.c")
            extra_join({
                'timegm',
            })
        end
        if not check.HAVE_EXPLICIT_BZERO then
            if is_plat("windows", "mingw") then
                target:add("files", "crypto/compat/explicit_bzero_win.c")
            else
                target:add("files", "crypto/compat/explicit_bzero.c")
            end
            extra_join({
                'explicit_bzero',
            })
        end
        if not check.HAVE_ARC4RANDOM_BUF then
            target:add("files", "crypto/compat/arc4random.c")
            target:add("files", "crypto/compat/arc4random_uniform.c")
            extra_join({
                'arc4random',
                'arc4random_buf',
                'arc4random_uniform',
            })
        end
        if not check.HAVE_GETENTROPY then
            local skip = false
            if is_plat("windows", "mingw") then
                target:add("files", "crypto/compat/getentropy_win.c")
            elseif is_plat("linux") then
                target:add("files", "crypto/compat/getentropy_linux.c")
            elseif is_plat("bsd") then
                target:add("files", "crypto/compat/getentropy_freebsd.c")
            elseif is_plat("macosx") then
                target:add("files", "crypto/compat/getentropy_osx.c")
            else
                skip = true
            end
            if not skip then
                extra_join({
                    'getentropy',
                })
            end
        end
        if not check.HAVE_TIMINGSAFE_BCMP then
            target:add("files", "crypto/compat/timingsafe_bcmp.c")
            extra_join({
                'timingsafe_bcmp',
            })
        end
        if not check.HAVE_TIMINGSAFE_MEMCMP then
            target:add("files", "crypto/compat/timingsafe_memcmp.c")
            extra_join({
                'timingsafe_memcmp',
            })
        end
        import("export_symbol_imp")(target, {
            file = 'crypto/crypto.sym',
            export = CRYPTO_EXTRA_EXPORT,
            unexport = CRYPTO_UNEXPORT,
        })
    end)

target("ssl")
    -- if get_config("merge") and is_kind("static") then
    --     set_kind("object")
    -- else
    set_kind("$(kind)")
    add_deps("crypto")
    -- end
    add_rules("export_symbol", {file = 'ssl/ssl.sym'})
    add_files("ssl/*.c|empty.c")
    for _, dir in ipairs(COMMON_INCLUDE_DIRS) do
        add_includedirs(dir)
    end
    add_includedirs(
        "ssl",
        "ssl/hidden",
        "crypto",
        "crypto/bio",
        "include/compat",
        "include"
    )
    if is_kind("static") then
        remove_files("ssl/bs_ber.c")
        remove_files("ssl/bs_cbb.c")
        remove_files("ssl/bs_cbs.c")
    end
    on_config(function (target)
        local check = import("check")(target)
    end)
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt")
    end


target("tls")
    set_kind("$(kind)")
    add_deps("crypto", "ssl")
    add_rules("export_symbol", {file = 'tls/tls.sym'})
    add_files("tls/*.c|empty.c")
    add_includedirs(
        "tls",
        "include/compat",
        "include"
    )
    if get_config("ca") then
        add_defines('TLS_DEFAULT_CA_FILE="$(ca)"')
    else
        if get_config('openssldir') then
            add_defines('TLS_DEFAULT_CA_FILE="$(openssldir)/cert.pem"')
        else
            add_defines('TLS_DEFAULT_CA_FILE="$(installdir)/etc/ssl/cert.pem"')
        end
    end
    if is_plat("windows", "mingw") then
        add_files("tls/compat/*.c")
    end
    on_config(function (target)
        local check = import("check")(target)
        local arch_dir = nil
        if is_arch('arm64.*') then
            arch_dir = 'aarch64'
        elseif is_arch('arm.*') then
            arch_dir = 'arm'
        elseif is_arch("x64", "x86_64") then
            arch_dir = 'aarch64'
        elseif is_arch("i[3456]86", "x86") then
            arch_dir = 'amd64'
        end
        os.cp('include/arch/'..arch_dir..'/opensslconf.h', 'include/openssl/opensslconf.h')
    end)
    add_headerfiles("include/openssl/*.h", {prefixdir = "openssl"})
    add_headerfiles("include/tls.h")
    set_policy("build.merge_archive", get_config("merge_archive"))
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt")
    end
