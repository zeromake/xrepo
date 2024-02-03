if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
    includes("check_cfuncs.lua")
    includes("check_csnippets.lua")
end
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
    "lib/xmlparse.c",
    "lib/xmlrole.c",
    "lib/xmltok.c",
}

function configvar_check_bigendian(define_name) 
    configvar_check_csnippets(define_name, [[
union{long int l;char c[sizeof (long int)];} u;
u.l = 1;
int result = u.c[sizeof(long int)-1];
printf("%d", result);
return 0;
]], {output = true, number = true})
end

target("expat")
    set_kind("$(kind)")

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("expat_config.h.in")

    configvar_check_cfuncs("HAVE_ARC4RANDOM", "arc4random", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_ARC4RANDOM_BUF", "arc4random_buf", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_GETPAGESIZE", "getpagesize", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_GETRANDOM", "getrandom", {includes={"sys/random.h"}})
    configvar_check_cfuncs("HAVE_MMAP", "mmap", {includes={"sys/mman.h"}})
    configvar_check_cincludes("HAVE_DLFCN_H", "dlfcn.h")
    configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
    configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
    configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
    configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
    configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
    configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
    configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
    configvar_check_cincludes("HAVE_STRING_H", "string.h")
    configvar_check_cincludes("HAVE_SYS_PARAM_H", "sys/param.h")
    configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
    configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")

    configvar_check_bigendian("_HOST_BIGENDIAN")

    add_headerfiles(
        "lib/expat.h",
        "lib/expat_external.h"
    )

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end
    if not is_kind("shared") then
        add_defines("XML_STATIC")
    end
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
