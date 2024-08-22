add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

add_requires("zeromake.rules")
if is_plat("windows") then
    set_languages("c++14")
else 
    set_languages("c++11")
end

local commons = {
    "archive.cpp",
    "arcread.cpp",
    "blake2s.cpp",
    "cmddata.cpp",
    "consio.cpp",
    "crc.cpp",
    "crypt.cpp",
    "encname.cpp",
    "errhnd.cpp",
    "extinfo.cpp",
    "extract.cpp",
    "filcreat.cpp",
    "file.cpp",
    "filefn.cpp",
    "find.cpp",
    "getbits.cpp",
    "global.cpp",
    "hash.cpp",
    "headers.cpp",
    "list.cpp",
    "match.cpp",
    "options.cpp",
    "pathfn.cpp",
    "rar.cpp",
    "rarpch.cpp",
    "rarvm.cpp",
    "rawread.cpp",
    "rdwrfn.cpp",
    "resource.cpp",
    "rijndael.cpp",
    "rs16.cpp",
    "secpassword.cpp",
    "sha1.cpp",
    "sha256.cpp",
    "smallfn.cpp",
    "strfn.cpp",
    "strlist.cpp",
    "system.cpp",
    "threadpool.cpp",
    "timefn.cpp",
    "ui.cpp",
    "unicode.cpp",
    "unpack.cpp",
    "volume.cpp",
}

target("unrar")
    set_kind("$(kind)")
    add_defines("RARDLL")
    for _, file in ipairs(commons) do
        add_files(file)
    end
    add_files(
        "filestr.cpp",
        "scantree.cpp",
        "dll.cpp",
        "qopen.cpp"
    )
    
    add_packages("zeromake.rules")
    add_rules("@zeromake.rules/export_symbol", {export = {
        "RAROpenArchive",
        "RAROpenArchiveEx",
        "RARCloseArchive",
        "RARReadHeader",
        "RARReadHeaderEx",
        "RARProcessFile",
        "RARProcessFileW",
        "RARSetCallback",
        "RARSetChangeVolProc",
        "RARSetProcessDataProc",
        "RARSetPassword",
        "RARGetDllVersion",
    }})
    if is_plat("windows", "mingw") then
        add_syslinks("advapi32", "shell32", "powrprof", "ole32", "oleaut32")
        add_files("isnt.cpp", "dll.rc")
    end

target("unrar-cli")
    set_kind("binary")
    add_defines("UNRAR")
    for _, file in ipairs(commons) do
        add_files(file)
    end
    add_files(
        "filestr.cpp",
        "scantree.cpp",
        "qopen.cpp",
        "recvol.cpp",
        "rs.cpp"
    )
    if is_plat("windows", "mingw") then
        add_syslinks("advapi32", "shell32", "powrprof", "ole32", "oleaut32")
        add_files("isnt.cpp", "dll.rc")
    end
