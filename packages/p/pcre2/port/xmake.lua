if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
    includes("check_csnippets.lua")
    includes("check_cfuncs.lua")
end
add_rules("mode.debug", "mode.release")

option("PCRE2_8")
    set_default(true)
    set_showmenu(true)
option_end()

option("PCRE2_16")
    set_default(false)
    set_showmenu(true)
option_end()

option("PCRE2_32")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "src/pcre2_auto_possess.c",
    "src/pcre2_compile.c",
    "src/pcre2_config.c",
    "src/pcre2_context.c",
    "src/pcre2_convert.c",
    "src/pcre2_dfa_match.c",
    "src/pcre2_error.c",
    "src/pcre2_extuni.c",
    "src/pcre2_find_bracket.c",
    "src/pcre2_jit_compile.c",
    "src/pcre2_maketables.c",
    "src/pcre2_match.c",
    "src/pcre2_match_data.c",
    "src/pcre2_newline.c",
    "src/pcre2_ord2utf.c",
    "src/pcre2_pattern_info.c",
    "src/pcre2_script_run.c",
    "src/pcre2_serialize.c",
    "src/pcre2_string_utils.c",
    "src/pcre2_study.c",
    "src/pcre2_substitute.c",
    "src/pcre2_substring.c",
    "src/pcre2_tables.c",
    "src/pcre2_ucd.c",
    "src/pcre2_valid_utf.c",
    "src/pcre2_xclass.c",
    "src/pcre2_chartables.c",
}

local checkHeaders = {
    "dirent.h",
    "sys/stat.h",
    "sys/types.h",
    "unistd.h",
    "windows.h",
}

local checkFuns = {
    bcopy = {"strings.h"},
    memfd_create = {"sys/mman.h"},
    memmove = {"string.h"},
    secure_getenv = {"stdlib.h"},
    strerror = {"string.h"}
}

target("pcre2")
    set_kind("$(kind)")
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config", "src")
    add_configfiles("config.h.in")

    for _, checkHeader in ipairs(checkHeaders) do
        local defineName = "HAVE_"..(checkHeader:gsub("/", "_"):gsub("%.", "_"):upper())
        configvar_check_cincludes(defineName, checkHeader)
    end

    for checkFun, include in pairs(checkFuns) do
        local defineName = "HAVE_"..(checkFun:upper())
        configvar_check_cfuncs(defineName, checkFun, {includes=include})
    end

    configvar_check_csnippets("HAVE_ATTRIBUTE_UNINITIALIZED", [[
int test() {
    char buf[128] __attribute__((uninitialized));
    (void)buf;
    return 0;
}
]])
    if get_config("PCRE2_8") then
        set_configvar("SUPPORT_PCRE2_8", 1)
        set_configvar("PCRE2_CODE_UNIT_WIDTH", 8)
    elseif get_config("PCRE2_16") then
        set_configvar("SUPPORT_PCRE2_16", 1)
        set_configvar("PCRE2_CODE_UNIT_WIDTH", 16)
    elseif get_config("PCRE2_32") then
        set_configvar("SUPPORT_PCRE2_32", 1)
        set_configvar("PCRE2_CODE_UNIT_WIDTH", 32)
    end

    set_configvar("SUPPORT_JIT", 1)
    set_configvar("SUPPORT_PCRE2GREP_JIT", 1)
    set_configvar("SUPPORT_PCRE2GREP_CALLOUT", 1)
    set_configvar("SUPPORT_PCRE2GREP_CALLOUT_FORK", 1)
    set_configvar("SUPPORT_UNICODE", 1)

    set_configvar("LINK_SIZE", 2)
    set_configvar("HEAP_LIMIT", 20000000)
    set_configvar("MATCH_LIMIT", 10000000)
    set_configvar("MATCH_LIMIT_DEPTH", "MATCH_LIMIT", {quote = false})
    set_configvar("NEWLINE_DEFAULT", 2)
    set_configvar("PARENS_NEST_LIMIT", 250)
    set_configvar("PCRE2GREP_BUFSIZE", 20480)
    set_configvar("PCRE2GREP_MAX_BUFSIZE", 1048576)
    set_configvar("MAX_NAME_SIZE", 32)
    set_configvar("MAX_NAME_COUNT", 10000)
    add_defines("HAVE_CONFIG_H=1")

    add_headerfiles("src/pcre2.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
