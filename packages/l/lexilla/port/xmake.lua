includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

target("lexilla")
    set_kind("$(kind)")

    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")
    add_files(f)
