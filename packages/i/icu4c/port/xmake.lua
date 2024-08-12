includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

add_includedirs("source/common", "source/i18n", "source/io")

set_languages("c++17")

add_defines(
    'U_BUILD="$(os)-$(arch)"',
    'U_HOST="$(os)-$(arch)"',
    "U_ALL_IMPLEMENTATION",
    "U_ATTRIBUTE_DEPRECATED="
)

check_cfuncs("U_HAVE_STRTOD_L", "strtod_l", {includes = "stdlib.h"})
check_cincludes("U_HAVE_XLOCALE_H", "xlocale.h")

target("icudata")
    set_kind("$(kind)")
    add_files("source/stubdata/*.cpp")

target("icuuc")
    set_kind("$(kind)")
    add_files("source/common/*.cpp")
    add_defines("U_COMMON_IMPLEMENTATION")
    add_headerfiles("source/common/unicode/*.h", {prefixdir = "unicode"})
    add_deps("icudata")

target("icui18n")
    set_kind("$(kind)")
    add_files("source/i18n/*.cpp")
    add_defines("U_I18N_IMPLEMENTATION")
    add_headerfiles("source/i18n/unicode/*.h", {prefixdir = "unicode"})
    add_deps("icuuc")

target("icuio")
    set_kind("$(kind)")
    add_files("source/io/*.cpp")
    add_defines("U_IO_IMPLEMENTATION")
    add_headerfiles("source/io/unicode/*.h", {prefixdir = "unicode"})
    add_deps("icuuc", "icui18n")

target("icutu")
    set_kind("$(kind)")
    add_defines("U_TOOLUTIL_IMPLEMENTATION")
    add_files("source/tools/toolutil/*.cpp")
    add_deps("icuuc", "icui18n")

local tools = {
    "icupkg",
    "pkgdata",
    "genrb",
}

for _, tool in ipairs(tools) do
    target(tool)
        add_files("source/tools/" .. tool .. "/*.cpp")
        add_deps("icuuc")
end

local otherTools = {
    "makeconv",
    "derb",
    "genbrk",
    "gencnval",
    "gensprep",
    "icuinfo",
    "genccode",
    "gencmn",
    "gentest",
    "gennorm2",
    "gencfu",
    "gendict",
    "icuexportdata",
    "escapesrc",
    "uconv",
}
