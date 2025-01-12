local openssl_target = {
    bn_ops = "BN_LLONG",
}
if is_arch("x86_64", "x64", "arm64.*") then
    if is_plat("windows") then
        openssl_target.bn_ops = "SIXTY_FOUR_BIT"
    else
        openssl_target.bn_ops = "SIXTY_FOUR_BIT_LONG"
    end
end

function string.split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local config = {
    bn_ll = 0,
    rc4_int = "unsigned int",
    b64l = 0,
    b64 = 0,
    b32 = 1,
}
for _, opt in string.split(openssl_target.bn_ops, " ") do
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

