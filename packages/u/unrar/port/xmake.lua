add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

includes("export_symbol.lua")

local commons = {
    "rarpch.cpp",
    "rar.cpp",
    "strlist.cpp",
    "strfn.cpp",
    "pathfn.cpp",
    "smallfn.cpp",
    "global.cpp",
    "file.cpp",
    "filefn.cpp",
    "filcreat.cpp",
    "archive.cpp",
    "arcread.cpp",
    "unicode.cpp",
    "system.cpp",
    "crypt.cpp",
    "crc.cpp",
    "rawread.cpp",
    "encname.cpp",
    "resource.cpp",
    "match.cpp",
    "timefn.cpp",
    "rdwrfn.cpp",
    "consio.cpp",
    "options.cpp",
    "errhnd.cpp",
    "rarvm.cpp",
    "secpassword.cpp",
    "rijndael.cpp",
    "getbits.cpp",
    "sha1.cpp",
    "sha256.cpp",
    "blake2s.cpp",
    "hash.cpp",
    "extinfo.cpp",
    "extract.cpp",
    "volume.cpp",
    "list.cpp",
    "find.cpp",
    "unpack.cpp",
    "headers.cpp",
    "threadpool.cpp",
    "rs16.cpp",
    "cmddata.cpp",
    "ui.cpp",
    "global.cpp"
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
    add_rules("export_symbol", {export = {
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
