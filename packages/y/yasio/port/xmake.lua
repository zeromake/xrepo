add_rules("mode.debug", "mode.release")
set_languages("c++17")

option("cares")
    set_default(false)
    set_showmenu(true)
option_end()

option("http")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_defines("_CRT_SECURE_NO_WARNINGS")
    add_defines("UNICODE")
    add_defines("_UNICODE")
    add_cxflags("/utf-8")
elseif is_plat("mingw") then
    add_defines("__STDC_FORMAT_MACROS")
end

add_requires("mbedtls")

if is_plat("windows", "mingw") then
    add_requires("wepoll")
end

if get_config("cares") then
    add_requires("c-ares")
end


target("yasio")
    add_includedirs(".")
    set_kind("$(kind)")
    add_packages("mbedtls")
    if is_plat("windows", "mingw") then
        add_packages("wepoll")
    end
    add_files("yasio/*.cpp")
    add_headerfiles("yasio/*.hpp", {prefixdir = "yasio"})
    add_headerfiles("yasio/compiler/*.hpp", {prefixdir = "yasio/compiler"})
    add_headerfiles("yasio/impl/*.hpp", {prefixdir = "yasio/impl"})
    add_headerfiles("extensions/*.hpp", {prefixdir = "yasio/extensions"})
target_end()

if get_config("http") then
    add_requires("llhttp")
    target("yasio_http")
        set_kind("$(kind)")
        add_files("extensions/yasio_http/*.cpp")
        add_includedirs(".", "extensions")
        add_packages("llhttp")
        if is_plat("windows", "mingw") then
            add_packages("wepoll")
        end
        add_headerfiles("extensions/yasio_http/*.h", {prefixdir = "yasio_http"})
        add_deps("yasio")
    target_end()
end
