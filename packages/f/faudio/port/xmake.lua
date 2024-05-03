includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

target("faudio")
    set_kind("$(kind)")
    add_headerfiles("include/*.h")
    add_files("src/*.c")
    add_includedirs("include", "src")
    if is_plat("windows") then
        add_defines(
            "FAUDIO_WIN32_PLATFORM",
            "HAVE_WMADEC",
            "DISABLE_XNASONG"
        )
        add_syslinks(
            "dxguid",
            "uuid",
            "ole32",
            "mfplat",
            "mfreadwrite",
            "mfuuid",
            "propsys"
        )
    end
