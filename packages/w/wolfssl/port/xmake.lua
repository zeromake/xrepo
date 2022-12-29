includes("check_cincludes.lua")
includes("check_csnippets.lua")
add_rules("mode.debug", "mode.release")

local options = {}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op, {system=false})
    end
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "src/crl.c",
    "src/dtls13.c",
    "src/dtls.c",
    "src/internal.c",
    "src/wolfio.c",
    "src/keys.c",
    "src/ocsp.c",
    "src/ssl.c",
    "src/tls.c",
    "src/tls13.c",
    "wolfcrypt/src/aes.c",
    "wolfcrypt/src/arc4.c",
    "wolfcrypt/src/asn.c",
    "wolfcrypt/src/blake2b.c",
    "wolfcrypt/src/blake2s.c",
    "wolfcrypt/src/camellia.c",
    "wolfcrypt/src/chacha.c",
    "wolfcrypt/src/chacha20_poly1305.c",
    "wolfcrypt/src/cmac.c",
    "wolfcrypt/src/coding.c",
    "wolfcrypt/src/curve25519.c",
    "wolfcrypt/src/curve448.c",
    "wolfcrypt/src/cpuid.c",
    "wolfcrypt/src/des3.c",
    "wolfcrypt/src/dh.c",
    "wolfcrypt/src/dsa.c",
    "wolfcrypt/src/ecc.c",
    "wolfcrypt/src/ed25519.c",
    "wolfcrypt/src/ed448.c",
    "wolfcrypt/src/error.c",
    "wolfcrypt/src/fe_448.c",
    "wolfcrypt/src/fe_low_mem.c",
    "wolfcrypt/src/fe_operations.c",
    "wolfcrypt/src/ge_448.c",
    "wolfcrypt/src/ge_low_mem.c",
    "wolfcrypt/src/ge_operations.c",
    "wolfcrypt/src/hash.c",
    "wolfcrypt/src/hmac.c",
    "wolfcrypt/src/integer.c",
    "wolfcrypt/src/kdf.c",
    "wolfcrypt/src/logging.c",
    "wolfcrypt/src/md2.c",
    "wolfcrypt/src/md4.c",
    "wolfcrypt/src/md5.c",
    "wolfcrypt/src/memory.c",
    "wolfcrypt/src/pkcs7.c",
    "wolfcrypt/src/pkcs12.c",
    "wolfcrypt/src/poly1305.c",
    "wolfcrypt/src/pwdbased.c",
    "wolfcrypt/src/random.c",
    "wolfcrypt/src/rc2.c",
    "wolfcrypt/src/ripemd.c",
    "wolfcrypt/src/rsa.c",
    "wolfcrypt/src/sha.c",
    "wolfcrypt/src/sha256.c",
    "wolfcrypt/src/sha3.c",
    "wolfcrypt/src/sha512.c",
    "wolfcrypt/src/signature.c",
    "wolfcrypt/src/sp_c32.c",
    "wolfcrypt/src/sp_c64.c",
    "wolfcrypt/src/sp_int.c",
    "wolfcrypt/src/sp_x86_64.c",
    "wolfcrypt/src/srp.c",
    "wolfcrypt/src/tfm.c",
    "wolfcrypt/src/wc_encrypt.c",
    "wolfcrypt/src/wc_pkcs11.c",
    "wolfcrypt/src/wc_port.c",
    "wolfcrypt/src/wolfmath.c",
    "wolfcrypt/src/wolfevent.c",
}


function check_sizeof(define_name, type_name)
    check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

target("wolfssl")
    set_kind("$(kind)")

    check_sizeof("SIZEOF_LONG_LONG", "long long")


    add_defines(
        "WOLFSSL_DES_ECB",
        "WOLFSSL_LIB",
        "WOLFSSL_USER_SETTINGS",
        "CYASSL_USER_SETTINGS",
        "WOLFSSL_NO_MD4",
        "OPENSSL_EXTRA",
        "WOLFSSL_SHA512"
    )

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    add_includedirs(".")
    if is_host("windows", "mingw") then
        add_includedirs("IDE/WIN")
        add_headerfiles("IDE/WIN/*.h")
    elseif is_host("macosx") then
        add_includedirs("IDE/XCODE")
        add_headerfiles("IDE/XCODE/*.h")
    end

    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end

    local files = {}
    if is_arch("arm.*") then
        table.join2(files, {
            "wolfcrypt/src/port/arm/armv8-aes.c",
            "wolfcrypt/src/port/arm/armv8-sha256.c",
            "wolfcrypt/src/port/arm/armv8-poly1305.c",
            "wolfcrypt/src/port/arm/armv8-chacha.c",
            "wolfcrypt/src/port/arm/armv8-curve25519.S",
            "wolfcrypt/src/sp_arm64.c",
            "wolfcrypt/src/port/arm/armv8-sha512.c",
            "wolfcrypt/src/port/arm/armv8-sha512-asm_c.c",
        })
    elseif is_arch("x86_64") then
        if is_plat("windows", "mingw") then
            table.join2(
                files,
                {
                    "wolfcrypt/src/aes_asm.asm",
                    "wolfcrypt/src/sp_x86_64_asm.asm",
                }
            )
        else
            table.join2(
                files,
                {
                    "wolfcrypt/src/aes_asm.S",
                    "wolfcrypt/src/sp_x86_64_asm.S",
                }
            )
        end
    end

    for _, f in ipairs(files) do
        add_files(f)
    end

    if is_plat("windows") then
        add_links("advapi32")
        add_files("wolfssl.rc")
    end
