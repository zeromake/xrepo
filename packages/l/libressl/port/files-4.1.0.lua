CRYPTO_INCLUDE_DIRS = {
    "crypto",
    "crypto/asn1",
    "crypto/bio",
    "crypto/bn",
    "crypto/bytestring",
    "crypto/dh",
    "crypto/dsa",
    "crypto/curve25519",
    "crypto/ec",
    "crypto/ecdh",
    "crypto/ecdsa",
    "crypto/evp",
    "crypto/hidden",
    "crypto/hmac",
    "crypto/modes",
    "crypto/ocsp",
    "crypto/pkcs12",
    "crypto/rsa",
    "crypto/sha",
    "crypto/x509",
    "crypto/lhash",
    "crypto/stack",
    "crypto/err",
    "crypto/conf",
    "include/compat",
    "include",
}

COMMON_INCLUDE_DIRS = {}

if is_arch("arm64.*") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/aarch64")
    table.insert(COMMON_INCLUDE_DIRS, "crypto/arch/aarch64")
elseif is_arch("arm.*") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/arm")
    table.insert(COMMON_INCLUDE_DIRS, "crypto/arch/arm")
elseif is_arch("x64", "x86_64") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/amd64")
    table.insert(COMMON_INCLUDE_DIRS, "crypto/arch/amd64")
elseif is_arch("x86", "i386") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/i386")
    table.insert(COMMON_INCLUDE_DIRS, "crypto/arch/i386")
end

CRYPTO_ASM_FILE = {
    ELF_ARMV4 = {
        "crypto/aes/aes-elf-armv4.S",
        "crypto/bn/mont-elf-armv4.S",
        "crypto/sha/sha1-elf-armv4.S",
        "crypto/sha/sha512-elf-armv4.S",
        "crypto/sha/sha256-elf-armv4.S",
        "crypto/modes/ghash-elf-armv4.S",
        "crypto/armv4cpuid.S",
        "crypto/armcap.c"
    },
    ELF_X86_64 = {
        "crypto/aes/aes-elf-x86_64.S",
        "crypto/aes/bsaes-elf-x86_64.S",
        "crypto/aes/vpaes-elf-x86_64.S",
        "crypto/aes/aesni-elf-x86_64.S",
        "crypto/bn/modexp512-elf-x86_64.S",
        "crypto/bn/mont-elf-x86_64.S",
        "crypto/bn/mont5-elf-x86_64.S",
        "crypto/modes/ghash-elf-x86_64.S",
        "crypto/rc4/rc4-elf-x86_64.S",
        "crypto/cpuid-elf-x86_64.S",
    
        "crypto/bn/arch/amd64/bignum_add.S",
        "crypto/bn/arch/amd64/bignum_cmadd.S",
        "crypto/bn/arch/amd64/bignum_cmul.S",
        "crypto/bn/arch/amd64/bignum_mul.S",
        "crypto/bn/arch/amd64/bignum_mul_4_8_alt.S",
        "crypto/bn/arch/amd64/bignum_mul_8_16_alt.S",
        "crypto/bn/arch/amd64/bignum_sqr.S",
        "crypto/bn/arch/amd64/bignum_sqr_4_8_alt.S",
        "crypto/bn/arch/amd64/bignum_sqr_8_16_alt.S",
        "crypto/bn/arch/amd64/bignum_sub.S",
        "crypto/bn/arch/amd64/word_clz.S",
        "crypto/bn/arch/amd64/bn_arch.c",
    },
    MACOSX_X86_64 = {
        "crypto/aes/aes-macosx-x86_64.S",
        "crypto/aes/bsaes-macosx-x86_64.S",
        "crypto/aes/vpaes-macosx-x86_64.S",
        "crypto/aes/aesni-macosx-x86_64.S",
        "crypto/bn/modexp512-macosx-x86_64.S",
        "crypto/bn/mont-macosx-x86_64.S",
        "crypto/bn/mont5-macosx-x86_64.S",
        "crypto/modes/ghash-macosx-x86_64.S",
        "crypto/rc4/rc4-macosx-x86_64.S",
    
        "crypto/bn/arch/amd64/bignum_add.S",
        "crypto/bn/arch/amd64/bignum_cmadd.S",
        "crypto/bn/arch/amd64/bignum_cmul.S",
        "crypto/bn/arch/amd64/bignum_mul.S",
        "crypto/bn/arch/amd64/bignum_mul_4_8_alt.S",
        "crypto/bn/arch/amd64/bignum_mul_8_16_alt.S",
        "crypto/bn/arch/amd64/bignum_sqr.S",
        "crypto/bn/arch/amd64/bignum_sqr_4_8_alt.S",
        "crypto/bn/arch/amd64/bignum_sqr_8_16_alt.S",
        "crypto/bn/arch/amd64/bignum_sub.S",
        "crypto/bn/arch/amd64/word_clz.S",
        "crypto/bn/arch/amd64/bn_arch.c",
    },
    MASM_X86_64 = {
        "crypto/aes/aes-masm-x86_64.S",
        "crypto/aes/bsaes-masm-x86_64.S",
        "crypto/aes/vpaes-masm-x86_64.S",
        "crypto/aes/aesni-masm-x86_64.S",
        "crypto/camellia/cmll-masm-x86_64.S",
        "crypto/modes/ghash-masm-x86_64.S",
        "crypto/rc4/rc4-masm-x86_64.S",
        "crypto/cpuid-masm-x86_64.S",
    },
    MINGW64_X86_64 = {
        "crypto/aes/aes-mingw64-x86_64.S",
		"crypto/aes/bsaes-mingw64-x86_64.S",
		"crypto/aes/vpaes-mingw64-x86_64.S",
		"crypto/aes/aesni-mingw64-x86_64.S",
		"crypto/modes/ghash-mingw64-x86_64.S",
		"crypto/rc4/rc4-mingw64-x86_64.S",
		"crypto/cpuid-mingw64-x86_64.S",
    }
}

CRYPTO_COMMON_DEFINE = {
    "AES_ASM",
    "SHA1_ASM",
    "SHA256_ASM",
    "SHA512_ASM",
    "OPENSSL_CPUID_OBJ",
}


CRYPTO_ASM_DEFINE = {
    ELF_ARMV4 = table.join({
        "OPENSSL_BN_ASM_MONT",
        "GHASH_ASM",
    }, CRYPTO_COMMON_DEFINE),
    ELF_X86_64 = table.join({
        "BSAES_ASM",
        "VPAES_ASM",
        "OPENSSL_IA32_SSE2",
        "OPENSSL_BN_ASM_MONT",
        "OPENSSL_BN_ASM_MONT5",
        "GHASH_ASM",
        "RSA_ASM",
        "WHIRLPOOL_ASM"
    }, CRYPTO_COMMON_DEFINE),
    MACOSX_X86_64 = table.join({
        "BSAES_ASM",
        "VPAES_ASM",
        "OPENSSL_IA32_SSE2",
        "OPENSSL_BN_ASM_MONT",
        "OPENSSL_BN_ASM_MONT5",
        "GHASH_ASM",
        "RSA_ASM",
        "WHIRLPOOL_ASM",
    }, CRYPTO_COMMON_DEFINE),
    MASM_X86_64 = table.join({
        "endbr64=",
        "BSAES_ASM",
        "VPAES_ASM",
        "OPENSSL_IA32_SSE2",
        "GHASH_ASM",
        "RSA_ASM",
        "WHIRLPOOL_ASM",
    }, CRYPTO_COMMON_DEFINE),
    MINGW64_X86_64 = table.join({
        "endbr32=endbr64",
        "endbr64=",
        "BSAES_ASM",
        "VPAES_ASM",
        "OPENSSL_IA32_SSE2",
        "GHASH_ASM",
        "RSA_ASM",
        "WHIRLPOOL_ASM",
    }, CRYPTO_COMMON_DEFINE),
}

CRYPTO_FILES = {
    "crypto/crypto_legacy.c",
    "crypto/crypto_err.c",
    "crypto/crypto_memory.c",
    "crypto/crypto_init.c",
    "crypto/crypto_ex_data.c",
    "crypto/asn1/*.c",
    "crypto/bf/*.c",
    "crypto/bn/*.c",
    "crypto/buffer/*.c",
    "crypto/bytestring/*.c",
    "crypto/cast/*.c",
    "crypto/cmac/*.c",
    "crypto/cms/*.c",
    "crypto/conf/*.c",
    "crypto/ct/*.c",
    "crypto/curve25519/*.c",
    "crypto/dh/*.c",
    "crypto/dsa/*.c",
    "crypto/ec/*.c",
    "crypto/ecdh/*.c",
    "crypto/ecdsa/*.c",
    "crypto/engine/*.c",
    "crypto/err/*.c",
    "crypto/evp/*.c",
    "crypto/hkdf/*.c",
    "crypto/hmac/*.c",
    "crypto/idea/*.c",
    "crypto/kdf/*.c",
    "crypto/lhash/*.c",
    "crypto/md4/*.c",
    "crypto/md5/*.c",
    "crypto/modes/*.c",
    "crypto/objects/*.c",
    "crypto/ocsp/*.c",
    "crypto/pem/*.c",
    "crypto/pkcs12/*.c",
    "crypto/pkcs7/*.c",
    "crypto/rand/*.c",
    "crypto/rc2/*.c",
    "crypto/ripemd/*.c",
    "crypto/rsa/*.c",
    "crypto/sha/*.c",
    "crypto/sm3/*.c",
    "crypto/sm4/*.c",
    "crypto/stack/*.c",
    "crypto/ts/*.c",
    "crypto/txt_db/*.c",
    "crypto/x509/*.c",
    "crypto/aes/*.c",
    "crypto/bio/*.c|b_win.c|b_posix.c|bss_log.c",
    "crypto/chacha/*.c|chacha-merged.c",
    "crypto/camellia/*.c",
    "crypto/des/*.c|ncbc_enc.c",
    "crypto/poly1305/*.c|poly1305-donna.c",
    "crypto/ui/*.c|ui_openssl.c|ui_openssl_win.c",
    "crypto/lhash/*.c",
    "crypto/stack/*.c",
    "crypto/rc4/*.c",
}

if is_arch("x86_64", "x64") then
    table.insert(CRYPTO_FILES, "crypto/arch/amd64/*.c")
elseif is_arch("i386", "x86") then
    table.insert(CRYPTO_FILES, "crypto/arch/i386/*.c")
elseif is_arch("arm64.*") then
    table.insert(CRYPTO_FILES, "crypto/arch/aarch64/*.c")
elseif is_arch("arm.*") then
    table.insert(CRYPTO_FILES, "crypto/arch/arm/*.c")
end
