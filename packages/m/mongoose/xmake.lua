package("mongoose")
    set_urls("https://github.com/xfangfang/mongoose/archive/8a9b6556816cd5ec8b90f451af7bafd93b000b89.zip")

    add_versions("latest", "01baf387a982e0c1ab32b12b41969d9f7ff05b5c834c1bc82a910572c119d115")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            target("mongoose")
                set_kind("$(kind)")
                add_headerfiles("mongoose.h")
                add_files("mongoose.c")
        ]])
        local configs = {}
        configs["kind"] = package:config("shared") and "shared" or "static"
        import("package.tools.xmake").install(package, configs)
    end)
