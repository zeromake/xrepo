add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("mbedtls")
    set_kind("$(kind)")

    add_headerfiles("include/mbedtls/*.h", {prefixdir = "mbedtls"})
    add_headerfiles("include/psa/*.h", {prefixdir = "psa"})
    add_includedirs("library", "include")
    add_files("library/*.c")
    add_includedirs("3rdparty/everest/include")
    add_includedirs("3rdparty/everest/include/everest")
    add_files("3rdparty/p256-m/**.c")
    add_files("3rdparty/everest/library/*.c")
