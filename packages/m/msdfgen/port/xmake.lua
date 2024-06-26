add_rules("mode.debug", "mode.release")

set_languages("c++14")

add_requires(
    "tinyxml2",
    "png",
    "freetype"
)

add_includedirs("$(buildir)/config")

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

target("msdfgen-core")
    set_kind("$(kind)")
    add_files("core/*.cpp")
    set_configdir("$(buildir)/config/msdfgen")
    add_configfiles("msdfgen-config.h.in")
    set_configvar("MSDFGEN_PUBLIC", "", {quote = false})
    set_configvar("MSDFGEN_EXT_PUBLIC", "", {quote = false})
    set_configvar("MSDFGEN_VERSION", "1.11.0", {quote = false})
    set_configvar("MSDFGEN_VERSION_MAJOR", 1)
    set_configvar("MSDFGEN_VERSION_MINOR", 12)
    set_configvar("MSDFGEN_VERSION_REVISION", 0)
    set_configvar("MSDFGEN_COPYRIGHT_YEAR", 2024)
    set_configvar("MSDFGEN_USE_CPP11", 1)
    set_configvar("MSDFGEN_USE_OPENMP", 1)
    set_configvar("MSDFGEN_EXTENSIONS", 1)
    set_configvar("MSDFGEN_USE_LIBPNG", 1)
    set_configvar("MSDFGEN_USE_TINYXML2", 1)
    add_headerfiles("$(buildir)/config/msdfgen/msdfgen-config.h", {prefixdir = "msdfgen"})
    add_headerfiles("$(buildir)/config/msdfgen/msdfgen-config.h", {prefixdir = "msdfgen/msdfgen"})
    add_headerfiles("msdfgen.h", {prefixdir = "msdfgen"})
    add_headerfiles("core/*.h", {prefixdir = "msdfgen/core"})
    add_headerfiles("core/*.hpp", {prefixdir = "msdfgen/core"})


target("msdfgen-ext")
    set_kind("$(kind)")
    add_packages(
        "tinyxml2",
        "png",
        "freetype"
    )
    add_files("ext/*.cpp")
    add_headerfiles("msdfgen-ext.h", {prefixdir = "msdfgen"})
    add_headerfiles("ext/*.h", {prefixdir = "msdfgen/ext"})
    add_headerfiles("ext/*.hpp", {prefixdir = "msdfgen/ext"})

target("msdfgen")
    set_default(get_config("cli") or false)
    set_kind("binary")
    add_files("main.cpp")
    add_defines("MSDFGEN_VERSION_UNDERLINE=1_12_0")
    add_defines("MSDFGEN_STANDALONE")
    add_deps("msdfgen-core", "msdfgen-ext")
