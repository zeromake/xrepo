includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

target("leveldb")
    set_kind("$(kind)")
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("port_config.h.in")
    add_includedirs(".", "include")
    add_files(
        "db/*.cc|*_test.cc",
        "table/*.cc|*_test.cc",
        "util/*.cc|testutil.cc|env_posix.cc|env_windows.cc|*_test.cc",
        "helpers/memenv/*.cc|*_test.cc"
    )
    if is_plat("windows") then
        add_files("util/env_windows.cc")
        add_defines("LEVELDB_PLATFORM_WINDOWS=1")
        set_languages("c++14")
    else
        add_files("util/env_posix.cc")
        add_defines("LEVELDB_PLATFORM_POSIX=1")
        set_languages("c++11")
    end
    add_defines("LEVELDB_COMPILE_LIBRARY")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_csymbol_exists("HAVE_FDATASYNC", "fdatasync", {includes = {"unistd.h"}})
    configvar_check_csymbol_exists("HAVE_FULLFSYNC", "F_FULLFSYNC", {includes = {"fcntl.h"}})
    configvar_check_csymbol_exists("HAVE_O_CLOEXEC", "O_CLOEXEC", {includes = {"fcntl.h"}})
