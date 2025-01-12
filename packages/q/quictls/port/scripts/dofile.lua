import("core.base.option")

local options = {
    {'i', "input", "kv", nil, "输入文件"},
    {'o', "output", "kv", nil, "输出文件"},
}

function main(...)
    local argv = option.parse({...}, options, "Test all the given or changed packages.")
    local content = io.readfile(argv.input)
    local start = content:find("{%-")
    while start ~= nil do
        local stop = content:find("%-}", start + 2)
        if stop == nil then
            break
        end
        local perl_content = content:sub(start + 2, stop-1)
        print('-----------', start, stop, perl_content)
        start = content:find("{%-", stop + 2)
    end
end
