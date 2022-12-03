includes("check_cincludes.lua")
includes("check_cfuncs.lua")
includes("check_csnippets.lua")
add_rules("mode.debug", "mode.release")

local options = {}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op)
    end
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    'fribidi.c',
    'fribidi-arabic.c',
    'fribidi-bidi.c',
    'fribidi-bidi-types.c',
    'fribidi-char-sets.c',
    'fribidi-char-sets-cap-rtl.c',
    'fribidi-char-sets-cp1255.c',
    'fribidi-char-sets-cp1256.c',
    'fribidi-char-sets-iso8859-6.c',
    'fribidi-char-sets-iso8859-8.c',
    'fribidi-char-sets-utf8.c',
    'fribidi-deprecated.c',
    'fribidi-joining.c',
    'fribidi-joining-types.c',
    'fribidi-mirroring.c',
    'fribidi-brackets.c',
    'fribidi-run.c',
    'fribidi-shape.c',
}

local headers = {
    "fribidi-arabic.h",
    "fribidi-begindecls.h",
    "fribidi-bidi.h",
    "fribidi-bidi-types.h",
    "fribidi-bidi-types-list.h",
    "fribidi-common.h",
    "fribidi-char-sets.h",
    "fribidi-char-sets-list.h",
    "fribidi-deprecated.h",
    "fribidi-enddecls.h",
    "fribidi-flags.h",
    "fribidi-joining.h",
    "fribidi-joining-types.h",
    "fribidi-joining-types-list.h",
    "fribidi-mirroring.h",
    "fribidi-brackets.h",
    "fribidi-shape.h",
    "fribidi-types.h",
    "fribidi-unicode.h",
    "fribidi-unicode-version.h",
    "fribidi.h"
}

function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

target("fribidi")
    set_kind("$(kind)")
    
    for _, f in ipairs(headers) do
        add_headerfiles(path.join("lib", f), {prefixdir="fribidi"})
    end
    set_configdir("$(buildir)/config")
    add_includedirs(".", "lib", "$(buildir)/config")
    add_configfiles("config.h.in", "fribidi-config.h.in")

    add_headerfiles("$(buildir)/config/fribidi-config.h", {prefixdir="fribidi"})

    configvar_check_cincludes("HAVE_ASM_PAGE_H", "asm/page.h")
    configvar_check_cincludes("HAVE_DLFCN_H", "dlfcn.h")
    configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
    configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
    configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
    configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
    configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
    configvar_check_cincludes("HAVE_STRING_H", "string.h")
    configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
    configvar_check_cincludes("HAVE_SYS_TIMES_H", "sys/times.h")
    configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_cincludes("HAVE_WCHAR_H", "wchar.h")

    configvar_check_cfuncs("HAVE_MEMMOVE", "memmove", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_MEMSET", "memset", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRDUP", "strdup", {includes={"string.h"}})

    configvar_check_sizeof("SIZEOF_INT", 'int')
    configvar_check_sizeof("SIZEOF_SHORT", 'short')
    configvar_check_sizeof("SIZEOF_VOID_P", 'void *')
    configvar_check_sizeof("SIZEOF_WCHAR_T", 'wchar_t')
    configvar_check_sizeof("FRIBIDI_SIZEOF_INT", 'int')

    set_configvar("HAVE_STRINGIZE", 1)

    add_defines(
        "FRIBIDI_BUILD",
        "HAVE_CONFIG_H"
    )
    if not is_kind("shared") then
        add_defines("FRIBIDI_LIB_STATIC")
    end
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(path.join("lib", f))
    end
    