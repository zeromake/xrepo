includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("artery-font-format")
    set_kind("$(kind)")

    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")
    add_files(f)
