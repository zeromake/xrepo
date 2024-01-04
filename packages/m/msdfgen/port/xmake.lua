add_rules("mode.debug", "mode.release")

set_languages("c++14")

add_requires(
    "tinyxml2",
    "png",
    "freetype"
)

add_includedirs("$(buildir)/config")

add_defines("MSDFGEN_EXTENSIONS")

target("msdfgen-core")
    set_kind("$(kind)")
    add_files("core/*.cpp")
    set_configdir("$(buildir)/config/msdfgen")
    add_configfiles("msdfgen-config.h.in")
    set_configvar("MSDFGEN_PUBLIC", "", {quote = false})
    set_configvar("MSDFGEN_EXT_PUBLIC", "", {quote = false})
    set_configvar("MSDFGEN_VERSION", "1.11.0", {quote = false})
    set_configvar("MSDFGEN_VERSION_MAJOR", 1)
    set_configvar("MSDFGEN_VERSION_MINOR", 11)
    set_configvar("MSDFGEN_VERSION_REVISION", 0)
    set_configvar("MSDFGEN_COPYRIGHT_YEAR", 2024)
    add_defines("MSDFGEN_USE_CPP11")
    add_defines("MSDFGEN_USE_OPENMP")

target("msdfgen-ext")
    set_kind("$(kind)")
    add_packages(
        "tinyxml2",
        "png",
        "freetype"
    )
    add_files("ext/*.cpp")
    add_defines("MSDFGEN_USE_LIBPNG")
    add_defines("MSDFGEN_EXT_PUBLIC")

target("msdfgen")
    set_kind("binary")
    add_files("main.cpp")
    add_defines("MSDFGEN_VERSION_UNDERLINE=1_11_0")
    add_defines("MSDFGEN_STANDALONE")
    add_deps("msdfgen-core", "msdfgen-ext")
