package("pcre2")
    set_homepage("https://www.pcre.org")
    set_description("The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.")
    set_license("BSD")
    set_urls("https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$(version)/pcre2-$(version).tar.bz2")

    add_versions("10.42", "8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840")
    add_configs("PCRE2_8", {description = "Support 8bit unicode", default = true, type = "boolean"})
    add_configs("PCRE2_16", {description = "Support 16bit unicode", default = false, type = "boolean"})
    add_configs("PCRE2_32", {description = "Support 32bit unicode", default = false, type = "boolean"})

    on_load(function (package) 
        if package:config("PCRE2_8") then
            package:add("defines", "PCRE2_CODE_UNIT_WIDTH=8")
        elseif package:config("PCRE2_16") then
            package:add("defines", "PCRE2_CODE_UNIT_WIDTH=16")
        elseif package:config("PCRE2_32") then
            package:add("defines", "PCRE2_CODE_UNIT_WIDTH=32")
        end
        if package:is_arch("windows", "mingw") then
            if package:config("shared") then
                package:add("defines", "PCRE2_EXP_DECL=extern __declspec(dllexport)")
            else
                package:add("defines", "PCRE2_STATIC=1")
            end
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp("src/pcre2.h.generic", "src/pcre2.h")
        os.cp("src/pcre2_chartables.c.dist", "src/pcre2_chartables.c")
        io.writefile("config.h.in", [[
${define HAVE_ATTRIBUTE_UNINITIALIZED}
${define HAVE_DIRENT_H}
${define HAVE_STRERROR}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_UNISTD_H}
${define HAVE_WINDOWS_H}

${define HAVE_BCOPY}
${define HAVE_MEMFD_CREATE}
${define HAVE_MEMMOVE}
${define HAVE_SECURE_GETENV}
${define HAVE_STRERROR}

${define PCRE2_CODE_UNIT_WIDTH}
${define SUPPORT_PCRE2_8}
${define SUPPORT_PCRE2_16}
${define SUPPORT_PCRE2_32}

${define SUPPORT_JIT}
${define SUPPORT_PCRE2GREP_JIT}
${define SUPPORT_PCRE2GREP_CALLOUT}
${define SUPPORT_PCRE2GREP_CALLOUT_FORK}
${define SUPPORT_UNICODE}

${define LINK_SIZE}
${define HEAP_LIMIT}
${define MATCH_LIMIT}
${define MATCH_LIMIT_DEPTH}
${define NEWLINE_DEFAULT}
${define PARENS_NEST_LIMIT}
${define PCRE2GREP_BUFSIZE}
${define PCRE2GREP_MAX_BUFSIZE}
${define MAX_NAME_SIZE}
${define MAX_NAME_COUNT}
]])
        local configs = {}
        if package:config("PCRE2_8") then
            table.insert(configs, "--PCRE2_8=y")
        elseif package:config("PCRE2_16") then
            table.insert(configs, "--PCRE2_16=y")
        elseif package:config("PCRE2_32") then
            table.insert(configs, "--PCRE2_32=y")
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("pcre2_config", {includes = {"pcre2.h"}}))
    end)
