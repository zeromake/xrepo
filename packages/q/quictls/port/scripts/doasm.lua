local arm64_asm = {
    "crypto/aes/asm/aesv8-armx.pl",
    "crypto/aes/asm/bsaes-armv8.pl",
    "crypto/aes/asm/vpaes-armv8.pl",

    "crypto/bn/asm/armv8-mont.pl",

    "crypto/chacha/asm/chacha-armv8-sve.pl",
    "crypto/chacha/asm/chacha-armv8.pl",

    "crypto/ec/asm/ecp_nistz256-armv8.pl",
    "crypto/ec/asm/ecp_sm2p256-armv8.pl",

    "crypto/md5/asm/md5-aarch64.pl",

    "crypto/modes/asm/aes-gcm-armv8_64.pl",
    "crypto/modes/asm/ghashv8-armx.pl",
    "crypto/modes/asm/aes-gcm-armv8-unroll8_64.pl",

    "crypto/sha/asm/keccak1600-armv8.pl",
    "crypto/sha/asm/sha1-armv8.pl",
    {"crypto/sha/asm/sha512-armv8.pl", "sha256-armv8"},
    "crypto/sha/asm/sha512-armv8.pl",

    "crypto/sm3/asm/sm3-armv8.pl",
    "crypto/sm4/asm/sm4-armv8.pl",
    "crypto/sm4/asm/vpsm4_ex-armv8.pl",
    "crypto/sm4/asm/vpsm4-armv8.pl",

    "crypto/arm64cpuid.pl",
}

local x86_64_asm = {
    "crypto/aes/asm/aes-x86_64.pl",
    "crypto/aes/asm/aesni-mb-x86_64.pl",
    "crypto/aes/asm/aesni-sha1-x86_64.pl",
    "crypto/aes/asm/aesni-sha256-x86_64.pl",
    "crypto/aes/asm/aesni-x86_64.pl",
    "crypto/aes/asm/bsaes-x86_64.pl",
    "crypto/aes/asm/vpaes-x86_64.pl",

    "crypto/bn/asm/rsaz-2k-avx512.pl",
    "crypto/bn/asm/rsaz-3k-avx512.pl",
    "crypto/bn/asm/rsaz-4k-avx512.pl",
    "crypto/bn/asm/rsaz-4k-avx512.pl",
    "crypto/bn/asm/rsaz-avx2.pl",
    "crypto/bn/asm/rsaz-x86_64.pl",
    "crypto/bn/asm/x86_64-gf2m.pl",
    "crypto/bn/asm/x86_64-mont.pl",
    "crypto/bn/asm/x86_64-mont5.pl",

    "crypto/camellia/asm/cmll-x86_64.pl",

    "crypto/chacha/asm/chacha-x86_64.pl",

    "crypto/ec/asm/ecp_nistz256-x86_64.pl",

    "crypto/ec/asm/x25519-x86_64.pl",

    "crypto/md5/asm/md5-x86_64.pl",

    "crypto/modes/asm/aes-gcm-avx512.pl",
    "crypto/modes/asm/aesni-gcm-x86_64.pl",
    "crypto/modes/asm/ghash-x86_64.pl",

    "crypto/poly1305/asm/poly1305-x86_64.pl",
    "crypto/rc4/asm/rc4-md5-x86_64.pl",
    "crypto/rc4/asm/rc4-x86_64.pl",

    "crypto/sha/asm/keccak1600-x86_64.pl",
    "crypto/sha/asm/sha1-mb-x86_64.pl",
    "crypto/sha/asm/sha1-x86_64.pl",
    "crypto/sha/asm/sha256-mb-x86_64.pl",
    "crypto/sha/asm/sha512-x86_64.pl",

    {"crypto/sha/asm/sha512-x86_64.pl", "sha256-x86_64"},

    "crypto/whrlpool/asm/wp-x86_64.pl",
    "crypto/x86_64cpuid.pl"
}

function main(target)
    local config = import("configuration")(target)
    local asm_files = target:is_arch("arm64.*") and arm64_asm or x86_64_asm
    local buildir = "build"
    for _, file in ipairs(asm_files) do
        local sourcefile = file
        local targetfile = ''
        if type(file) == "table" then
            sourcefile = file[1]
            targetfile = path.basename(file[2])..config['asmext']
        else
            targetfile = path.basename(file)..config['asmext']
        end
        local name = path.basename(targetfile)
        local targetdir = path.join(buildir, "generate", path.directory(sourcefile))
        if targetdir:endswith("/asm") or targetdir:endswith("\\asm") then
            targetdir = targetdir:sub(1, #targetdir - 4)
        end
        os.mkdir(targetdir)
        targetfile = path.join(targetdir, targetfile)
        os.vrunv("perl", {sourcefile, config['perlasm_scheme'], targetfile})
    end
end
