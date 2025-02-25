rule('export_shared')
    after_build(function (target)
        local shareds = {}
        local dir = target:extraconf("rules", "@zeromake.rules/export_shared", "dir") or target:targetdir()
        if not os.exists(dir) then
            os.mkdir(dir)
        end
        for name, pkg in pairs(target:pkgs()) do
            local libfiles = pkg:libraryfiles()
            if type(libfiles) == "string" then
                libfiles = {libfiles}
            end
            for _, libfile in ipairs(libfiles) do
                if libfile:endswith(".so") or libfile:endswith(".dll") or libfile:endswith(".dylib") then
                    shareds[libfile] = 1
                end
            end
        end
        for shared, _ in pairs(shareds) do
            print("cp", shared, dir)
            os.cp(shared, dir)
        end
    end)
rule_end()
