rule("embed-js")
    add_imports(
        "lib.detect.find_tool",
        "core.tool.compiler",
        "utils.progress",
        "core.project.depend"
    )
    set_extensions(".js")
    on_build_file(function (target, sourcefile, opt)
        local basename = path.join(target:autogendir(), path.basename(sourcefile))
        local sourcefile_c = basename..".c"
        local objectfile_o = target:objectfile(basename)
        local argv = target:extraconf("rules", "@quickjs-ng/embed-js", "argv") or {}

        depend.on_changed(function ()
            os.mkdir(path.directory(sourcefile_c))
            local qjsc = assert(find_tool("qjsc", {paths={"$(env PATH)", target:targetdir()}, norun = true}), "qjsc not found!")
            argv = table.join(argv, {"-o", sourcefile_c, sourcefile})
            progress.show(opt.progress, "compiling.$(mode) %s", sourcefile)
            os.vrunv(qjsc.program, argv)
            compiler.compile(sourcefile_c, objectfile_o, table.join(opt, {target = target}))
        end, {
            dependfile = target:dependfile(objectfile_o),
            files = sourcefile,
            changed = target:is_rebuilt()
        })
        table.insert(target:objectfiles(), objectfile_o)
    end)
