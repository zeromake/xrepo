includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

configvar_check_cfuncs("HAVE_STRCASECMP", "strcasecmp", {includes={"strings.h"}})
configvar_check_cfuncs("HAVE_STRDUP", "strdup", {includes={"string.h"}} )
configvar_check_cfuncs("HAVE_STRICMP", "stricmp", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRNDUP", "strndup", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRLWR", "strlwr", {includes={"string.h"}})

configvar_check_sizeof("HAVE__BOOL", "_Bool")
configvar_check_sizeof("HAVE_CONST", "const char*")
set_configvar("PCRE2_STATIC", 1)
set_configvar("WIN32", 1)
set_configvar("UNIX", 1)
set_configvar("PROJECT_VERSION_MAJOR", 0)
set_configvar("PROJECT_VERSION_MINOR", 12)
set_configvar("PROJECT_VERSION_PATCH", 8)
set_configvar("PROJECT_VERSION_SUFFIX", "-development", {quote = false})
add_requires("pcre2")

target("editorconfig-core")
    set_kind("$(kind)")
    set_configdir("$(buildir)/config")
    add_includedirs("include", "$(buildir)/config")
    add_configfiles("config.h.in")
    add_headerfiles("include/editorconfig/*.h", {prefixdir = "editorconfig"})
    add_files("src/lib/*.c")
    add_packages("pcre2")
    if is_plat("windows", "mingw") then
        add_syslinks("shlwapi")
    end
