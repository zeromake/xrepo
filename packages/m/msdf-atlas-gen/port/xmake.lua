includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("msdfgen", "artery-font")

set_languages("c++14")

target("msdf-atlas-gen")
    set_kind("$(kind)")
    add_packages("msdfgen", "artery-font")
    add_files("msdf-atlas-gen/*.cpp|main.cpp")
    add_includedirs("msdf-atlas-gen")
    add_defines(
        -- "MSDF_ATLAS_NO_ARTERY_FONT",
        "MSDF_ATLAS_VERSION=1.3.0",
        "MSDF_ATLAS_VERSION_MAJOR=1",
        "MSDF_ATLAS_VERSION_MINOR=3",
        "MSDF_ATLAS_VERSION_REVISION=0",
        "MSDF_ATLAS_COPYRIGHT_YEAR=2024"
    )
    add_headerfiles("msdf-atlas-gen/*.h", {prefixdir = "msdf-atlas-gen"})
    add_headerfiles("msdf-atlas-gen/*.hpp", {prefixdir = "msdf-atlas-gen"})

target("msdf-atlas-gen-cli")
    set_default(get_config("cli") or false)
    add_includedirs("msdf-atlas-gen")
    set_kind("binary")
    add_packages("msdfgen", "artery-font")
    add_deps("msdf-atlas-gen")
    add_files("msdf-atlas-gen/main.cpp")
    add_defines("MSDF_ATLAS_VERSION_UNDERLINE=1_3_0")
    add_defines("MSDF_ATLAS_STANDALONE")
