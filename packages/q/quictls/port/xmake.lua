includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("crypto")
    set_kind("$(kind)")
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "user32", "crypt32", "advapi32")
    end
    

target("ssl")
    set_kind("$(kind)")
