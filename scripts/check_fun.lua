import("net.http")
import("core.base.option")

local options = {
    {nil, "funcs",   "vs", nil, "The funcs list."                          }
}

local matchs = {
    [[<p><b>#include &lt;<.*>(.*%.h)</a>&gt;]],
    [[<p><b>#include &lt;(.*%.h)&gt;]],
}

function main(...)
    local argv = option.parse({...}, options, "Test all the given or changed packages.")
    local funcs = argv.funcs or {}
    local cache_dir = path.join(".xmake/cache/checks")
    os.mkdir(cache_dir)
    for idx,func in irpairs(funcs) do
        local out = path.join(cache_dir, format("%s.html", func))
        if not os.exists(out) then
            local url = format("https://linux.die.net/man/3/%s", func)
            print(url)
            http.download(url, out)
        end
        local content = io.readfile(out)
        local header = nil
        for _, m in ipairs(matchs) do
            header = string.match(content, m)
            if header then
                break
            end
        end
        printf("%s: %s\n", func, header)
    end
end
