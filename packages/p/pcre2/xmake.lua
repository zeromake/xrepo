package("pcre2")
    set_homepage("https://www.pcre.org")
    set_description("The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.")
    set_license("BSD-2-Clause")
    set_urls("https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$(version)/pcre2-$(version).tar.bz2")

    --insert version
    add_versions("10.47", "47fe8c99461250d42f89e6e8fdaeba9da057855d06eb7fc08d9ca03fd08d7bc7")
    add_versions("10.46", "15fbc5aba6beee0b17aecb04602ae39432393aba1ebd8e39b7cabf7db883299f")
    add_versions("10.45", "21547f3516120c75597e5b30a992e27a592a31950b5140e7b8bfde3f192033c4")
    add_versions("10.44", "d34f02e113cf7193a1ebf2770d3ac527088d485d4e047ed10e5d217c6ef5de96")
    add_versions("10.43", "e2a53984ff0b07dfdb5ae4486bbb9b21cca8e7df2434096cc9bf1b728c350bcb")
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
        if package:is_plat("windows", "mingw") then
            if package:config("shared") then
                package:add("defines", "PCRE2_EXP_DECL=extern __declspec(dllexport)")
            else
                package:add("defines", "PCRE2_STATIC=1")
            end
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp("src/pcre2.h.generic", "src/pcre2.h")
        os.cp("src/pcre2_chartables.c.dist", "src/pcre2_chartables.c")
        io.writefile("config.h.in", [[
#define PCRE2_EXPORT
#define MAX_VARLOOKBEHIND 255
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
]], {encoding = "binary"})
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
