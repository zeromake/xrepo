includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("_do")
    set_kind("object")
    on_build(function (target) 
        import("scripts.dofile")(target)
        import("scripts.doasm")(target)
        io.writefile("buildinf.h", string.format([[
#define PLATFORM "platform: %s-%s"
#define DATE "built on: %s"

static const char compiler_flags[] = "compiler: cc -DL_ENDIAN -DOPENSSL_PIC -D_REENTRANT -DOPENSSL_BUILDING_OPENSSL";
]], target:plat(), target:arch(), os.date('!%Y-%m-%d %H:%M:%S +00:00', os.time())))
    end)
