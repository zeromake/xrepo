add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
add_includedirs("library", "include")

target("mbedtls")
    set_kind("$(kind)")
    add_headerfiles("include/mbedtls/*.h", {prefixdir = "mbedtls"})
    add_headerfiles("include/psa/*.h", {prefixdir = "psa"})
    add_includedirs("3rdparty/everest/include")
    add_files(
        "library/*.c",
        "3rdparty/everest/library/*.c|Hacl_Curve25519.c",
        "3rdparty/p256-m/*.c",
        "3rdparty/p256-m/p256-m/*.c"
    )
