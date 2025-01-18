
function string.split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function main(target)
    local openssl_target = {
        bn_ops = "BN_LLONG",
    }
    if target:is_arch("x86_64", "x64", "arm64.*") then
        if target:is_plat("windows") then
            openssl_target.bn_ops = "SIXTY_FOUR_BIT"
        else
            openssl_target.bn_ops = "SIXTY_FOUR_BIT_LONG"
        end
    end
    
    local config = {
        bn_ll = 0,
        rc4_int = "unsigned int",
        b64l = 0,
        b64 = 0,
        b32 = 1,
        FIPSKEY = 'f4556650ac31d35461610bac4ed81b1a181b2d8a43ea2854cbae22ca74560813',
        major = "3",
        minor = "3",
        patch = "0",
        prerelease = "",
        build_metadata = "+quic",
        shlib_version = "81.3",
        version = "3.3.0",
        full_version = "3.3.0+quic",
        release_date = "30 Jan 2024",
        processor = target:arch(),
    }
    config['api'] = tonumber(config['major']) * 10000 + tonumber(config['minor']) * 100
    for _, opt in ipairs(string.split(openssl_target.bn_ops, " ")) do
        if opt == "BN_LLONG" then
            config.bn_ll = 1
        end
        if opt == "RC4_CHAR" then
            config.rc4_int = "unsigned char"
        end
        if opt == "B64" then
            config.b64 = 1
        end
        if opt == "SIXTY_FOUR_BIT" then
            config.b64l = 0
            config.b64 = 1
            config.b32 = 0
        end
        if opt == "SIXTY_FOUR_BIT_LONG" then
            config.b64l = 1
            config.b64 = 0
            config.b32 = 0
        end
        if opt == "THIRTY_TWO_BIT" then
            config.b64l = 0
            config.b64 = 0
            config.b32 = 1
        end
    end
    if target:is_plat("windows") then
        config['perlasm_scheme'] = "nasm"
    elseif target:is_plat("mingw") then
        config['perlasm_scheme'] = "mingw64"
    elseif target:is_plat("macosx", "iphoneos") then
        config['perlasm_scheme'] = "macosx"
    else
        config['perlasm_scheme'] = "linux64"
    end
    if target:is_plat("windows") then
        config['asmext'] = ".asm"
    else
        config['asmext'] = ".s"
    end
    return config
end

