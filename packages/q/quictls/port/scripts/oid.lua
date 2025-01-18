local oid_match = '[%w_%-]+ +OBJECT +IDENTIFIER +::= +{ *[^}]+ *}'
local oid_match_group = '([%w_%-]+) +OBJECT +IDENTIFIER +::= +{ *([^}]+) *}'
local link_match = '^[ \n]*[A-Za-z_][%w_%-]+ +'
local link_match_group = '^[ \n]*([A-Za-z_][%w_%-]+) +.*%(?(%d+)%)?'

local function encodeoid(oidcomponents)
    local deroid = {}
    local firstoctet = 40 * oidcomponents[1] + oidcomponents[2]
    table.insert(deroid, firstoctet)
    for i = 3, #oidcomponents do
        local value = oidcomponents[i]
        local bytes = {}
        while value > 0 do
            table.insert(bytes, value % 128)
            value = math.floor(value / 128)
        end
        for j = 1, #bytes - 1 do
            bytes[j] = bytes[j] | 0x80
        end

        for j = #bytes, 1, -1 do
            table.insert(deroid, bytes[j])
        end
    end
    return deroid
end

local registered_output = {
    c = {},
    h = {},
}

function main(inputs, output_type)
    local registered = {}
    local input_size = #inputs
    local result = ''
    for index, input in ipairs(inputs) do
        local content = io.readfile(path.join(os.scriptdir(), "..", input))
        for line in content:gmatch(oid_match) do
            local name, oid = line:match(oid_match_group)
            local current = {}
            local is_link = false
            if oid:match(link_match) then
                local link_name, sub = oid:match(link_match_group)
                assert(registered[link_name] ~= nil, "link name not found: " .. link_name)
                current = table.join(registered[link_name], {tonumber(sub)})
                registered[name] = current
                is_link = true
            else
                for v in oid:gmatch('%(?(%d+)%)?') do
                    table.insert(current, tonumber(v))
                end
                registered[name] = current
            end
            if registered_output[output_type][name] == nil then
                registered_output[output_type][name] = true
                local c_name = name:gsub('-', '_')
                local deroid = encodeoid(current)
                local arr = {}
                for _, v in ipairs(deroid) do
                    table.insert(arr, string.format('0x%02X', v))
                end
                local c_comment = ' * '..line:gsub('\n', '\n * ')
                -- print(string.format('/*\n%s\n */', c_comment))
                result = result..string.format('/*\n%s\n */\n', c_comment)
                if output_type == "h" then
                    local s = string.format('#define DER_OID_V_%s DER_P_OBJECT, %d, %s\n', c_name, #deroid, table.concat(arr, ', '))
                    s = s..string.format('#define DER_OID_SZ_%s %d\n', c_name, #deroid+2)
                    s = s..string.format('extern const unsigned char ossl_der_oid_%s[DER_OID_SZ_%s];\n\n', c_name, c_name)
                    result = result..s
                else
                    local s = string.format('const unsigned char ossl_der_oid_%s[DER_OID_SZ_%s] = {\n', c_name, c_name)
                    s = s..string.format('    DER_OID_V_%s\n};\n\n', c_name)
                    result = result..s
                end
            end
        end
    end
    return result
end
