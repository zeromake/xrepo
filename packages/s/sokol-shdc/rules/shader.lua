rule("shader")
    set_extensions(".glsl")
    on_buildcmd_file(function (target, batchcmds, sourcefile, opt)
        import("lib.detect.find_tool")
        local sokolshdc = find_tool("sokol-shdc", {check = "--help"})
        local targetfile = path.relative(sourcefile, "$(projectdir)")
        if targetfile:startswith("..") then
            targetfile = targetfile:sub(4)
        end
        if targetfile:startswith("src") then
            targetfile = targetfile:sub(5)
        end
        batchcmds:mkdir(path.join("$(buildir)/sokol_shader", path.directory(targetfile)))
        local targetfile = vformat(path.join("$(buildir)/sokol_shader", targetfile..".h"))
        batchcmds:vrunv(sokolshdc.program, {
            "--ifdef",
            "-l",
            "hlsl5:glsl410:glsl300es:metal_macos:metal_ios:metal_sim:wgsl",
            "--input",
            sourcefile,
            "--output",
            targetfile,
        })
        batchcmds:show_progress(opt.progress, "${color.build.object}glsl %s", sourcefile)
        batchcmds:add_depfiles(sourcefile)
    end)
