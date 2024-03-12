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
    "include/compat",
    "include",
}


if is_arch("arm64.*") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/aarch64")
elseif is_arch("arm.*") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/arm")
elseif is_arch("x64", "x86_64") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/amd64")
elseif is_arch("x86", "i386") then
    table.insert(CRYPTO_INCLUDE_DIRS, "crypto/bn/arch/i386")
end

CRYPTO_ELF_ARMV4_FILE = {
    "crypto/aes/aes-elf-armv4.S",
    "crypto/bn/mont-elf-armv4.S",
    "crypto/sha/sha1-elf-armv4.S",
    "crypto/sha/sha512-elf-armv4.S",
    "crypto/sha/sha256-elf-armv4.S",
    "crypto/modes/ghash-elf-armv4.S",
    "crypto/armv4cpuid.S",
    "crypto/armcap.c"
}

CRYPTO_ELF_X86_64_FILE = {
    "crypto/aes/aes-elf-x86_64.S",
    "crypto/aes/bsaes-elf-x86_64.S",
    "crypto/aes/vpaes-elf-x86_64.S",
    "crypto/aes/aesni-elf-x86_64.S",
    "crypto/aes/aesni-sha1-elf-x86_64.S",
    "crypto/bn/modexp512-elf-x86_64.S",
    "crypto/bn/mont-elf-x86_64.S",
    "crypto/bn/mont5-elf-x86_64.S",
    "crypto/camellia/cmll-elf-x86_64.S",
    "crypto/md5/md5-elf-x86_64.S",
    "crypto/modes/ghash-elf-x86_64.S",
    "crypto/rc4/rc4-elf-x86_64.S",
    "crypto/rc4/rc4-md5-elf-x86_64.S",
    "crypto/sha/sha1-elf-x86_64.S",
    "crypto/sha/sha256-elf-x86_64.S",
    "crypto/sha/sha512-elf-x86_64.S",
    "crypto/whrlpool/wp-elf-x86_64.S",
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
}

CRYPTO_MACOSX_X86_64_FILE = {
    "crypto/aes/aes-macosx-x86_64.S",
    "crypto/aes/bsaes-macosx-x86_64.S",
    "crypto/aes/vpaes-macosx-x86_64.S",
    "crypto/aes/aesni-macosx-x86_64.S",
    "crypto/aes/aesni-sha1-macosx-x86_64.S",
    "crypto/bn/modexp512-macosx-x86_64.S",
    "crypto/bn/mont-macosx-x86_64.S",
    "crypto/bn/mont5-macosx-x86_64.S",
    "crypto/camellia/cmll-macosx-x86_64.S",
    "crypto/md5/md5-macosx-x86_64.S",
    "crypto/modes/ghash-macosx-x86_64.S",
    "crypto/rc4/rc4-macosx-x86_64.S",
    "crypto/rc4/rc4-md5-macosx-x86_64.S",
    "crypto/sha/sha1-macosx-x86_64.S",
    "crypto/sha/sha256-macosx-x86_64.S",
    "crypto/sha/sha512-macosx-x86_64.S",
    "crypto/whrlpool/wp-macosx-x86_64.S",
    "crypto/cpuid-macosx-x86_64.S",

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
}

CRYPTO_MASM_X86_64_FILE = {
    "crypto/aes/aes-masm-x86_64.S",
    "crypto/aes/bsaes-masm-x86_64.S",
    "crypto/aes/vpaes-masm-x86_64.S",
    "crypto/aes/aesni-masm-x86_64.S",
    "crypto/aes/aesni-sha1-masm-x86_64.S",
    "crypto/camellia/cmll-masm-x86_64.S",
    "crypto/md5/md5-masm-x86_64.S",
    "crypto/modes/ghash-masm-x86_64.S",
    "crypto/rc4/rc4-masm-x86_64.S",
    "crypto/rc4/rc4-md5-masm-x86_64.S",
    "crypto/sha/sha1-masm-x86_64.S",
    "crypto/sha/sha256-masm-x86_64.S",
    "crypto/sha/sha512-masm-x86_64.S",
    "crypto/whrlpool/wp-masm-x86_64.S",
    "crypto/cpuid-masm-x86_64.S",
}

CRYPTO_COMMON_DEFINE = {
    "AES_ASM",
    "SHA1_ASM",
    "SHA256_ASM",
    "SHA512_ASM",
    "OPENSSL_CPUID_OBJ",
}

CRYPTO_ELF_ARMV4_DEFINE = table.join({
    "OPENSSL_BN_ASM_MONT",
    "GHASH_ASM",
}, CRYPTO_COMMON_DEFINE)

CRYPTO_ELF_X86_64_DEFINE = table.join({
    "BSAES_ASM",
    "VPAES_ASM",
    "OPENSSL_IA32_SSE2",
    "OPENSSL_BN_ASM_MONT",
    "OPENSSL_BN_ASM_MONT5",
    "MD5_ASM",
    "GHASH_ASM",
    "RSA_ASM",
    "WHIRLPOOL_ASM"
}, CRYPTO_COMMON_DEFINE)

CRYPTO_ELF_X86_64_DEFINE = table.join({
    "BSAES_ASM",
    "VPAES_ASM",
    "OPENSSL_IA32_SSE2",
    "OPENSSL_BN_ASM_MONT",
    "OPENSSL_BN_ASM_MONT5",
    "MD5_ASM",
    "GHASH_ASM",
    "RSA_ASM",
    "SHA1_ASM",
    "WHIRLPOOL_ASM"
}, CRYPTO_COMMON_DEFINE)

CRYPTO_MACOSX_X86_64_DEFINE = table.join({
    "BSAES_ASM",
    "VPAES_ASM",
    "OPENSSL_IA32_SSE2",
    "OPENSSL_BN_ASM_MONT",
    "OPENSSL_BN_ASM_MONT5",
    "MD5_ASM",
    "GHASH_ASM",
    "RSA_ASM",
    "WHIRLPOOL_ASM",
}, CRYPTO_COMMON_DEFINE)

CRYPTO_MASM_X86_64_DEFINE = table.join({
    "endbr64=",
    "BSAES_ASM",
    "VPAES_ASM",
    "OPENSSL_IA32_SSE2",
    "MD5_ASM",
    "GHASH_ASM",
    "RSA_ASM",
    "WHIRLPOOL_ASM",
}, CRYPTO_COMMON_DEFINE)
