rule('export_symbol')
    on_config(function(target)
        if target:kind() ~= "shared" then
            return
        end
        local function generateWindowsExportSymbol(out, syms)
            local f = io.open(out..".def", "wb")
            if f == nil then
                return
            end
            f:write("EXPORTS\n")
            for _, sym in ipairs(syms) do
                    f:write('\t')
                    f:write(sym)
                    f:write('\n')
            end
            f:close()
        end
        local function generateAppleExportSymbol(out, syms)
            local f = io.open(out..".exp", "wb")
            if f == nil then
                return
            end
            for _, sym in ipairs(syms) do
                f:write('_')
                f:write(sym)
                f:write('\n')
            end
            f:close()
        end
        local function generateGccExportSymbol(out, syms)
            local f = io.open(out..".ver", "wb")
            if f == nil then
                return
            end
            f:write("{\nglobal:\n")
            for _, sym in ipairs(syms) do
                f:write('\t')
                f:write(sym)
                f:write(';\n')
            end
            f:write("local:\n\t*;\n")
            f:close()
        end
        local sym_list = nil
        local unsym_list = nil
        local sym_file = nil
        opt = nil
        if opt == nil then
            sym_list = target:extraconf("rules", "@zeromake.rules/export_symbol", "export") or {}
            unsym_list = target:extraconf("rules", "@zeromake.rules/export_symbol", "unexport") or {}
            sym_file = target:extraconf("rules", "@zeromake.rules/export_symbol", "file")
        else
            sym_list = opt.export or {}
            unsym_list = opt.unexport or {}
            sym_file = opt.file
        end
        local syms = {}
        if sym_file then
            local _syms = io.readfile(sym_file):split('\n')
            for _, s in ipairs(_syms) do
                if s ~= '' and not s:startswith('#') then
                    table.insert(syms, s)
                end
            end
            table.join2(syms, sym_list)
        elseif sym_list and #sym_list > 0 then
            syms = sym_list
        end
        if #unsym_list > 0 then
            local syms_p = {}
            local unsym_list_p = {}
            for _, s in ipairs(unsym_list) do
                unsym_list_p[s] = 1
            end
            for _, s in ipairs(syms) do
                if not unsym_list_p[s] then
                    table.insert(syms_p, s)
                end
            end
            syms = syms_p
        end
        if #syms > 0 then
            local out = vformat('$(buildir)/.gens/$(host)-$(arch)/'..target:name())
            if is_plat("windows") then
                generateWindowsExportSymbol(out, syms)
                target:add('shflags', '/DEF:'..out..'.def', {force = true})
            elseif is_plat("mingw") then
                generateWindowsExportSymbol(out, syms)
                target:add('files', out..'.def')
            elseif is_plat("macosx") then
                generateAppleExportSymbol(out, syms)
                target:add('shflags', '-exported_symbols_list '..out..'.exp', {force = true})
            else
                generateGccExportSymbol(out, syms)
                target:add('shflags', '-Wl,--version-script,"'..out..'.ver"', {force = true})
            end
        end
    end)
rule_end()
