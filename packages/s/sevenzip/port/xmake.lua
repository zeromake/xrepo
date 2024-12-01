add_rules("mode.debug", "mode.release")

set_languages("c++14")
set_rundir("$(projectdir)")

add_requires("zeromake.rules")

local exportSymbols = {
    "CreateArchiver",
    "CreateCoder",
    "CreateDecoder",
    "CreateEncoder",
    "CreateHasher",
    "CreateObject",
    "GetHandlerProperty",
    "GetHandlerProperty2",
    "GetHasherProp",
    "GetHashers",
    "GetIsArc",
    "GetMethodProperty",
    "GetModuleProp",
    "GetNumberOfFormats",
    "GetNumberOfMethods",
    "SetCaseSensitive",
    "SetCodecs",
    "SetLargePageMode",
}

local formatDirs = {
    "7z",
    "Cab",
    "Chm",
    "Common",
    "Iso",
    "Nsis",
    "Rar",
    "Tar",
    "Udf",
    "Wim",
    "Zip",
}
if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

set_encodings("utf-8")

target("7zip")
    set_kind("shared")
    add_defines("UNICODE", "_UNICODE", "Z7_EXTERNAL_CODECS", "Z7_PPMD_SUPPORT")
    add_files("C/*.c")
    add_files("CPP/7zip/Common/*.cpp")
    add_files("CPP/7zip/Archive/*.cpp|DllExports.cpp")
    for _, n in ipairs(formatDirs) do
        add_files(path.join("CPP/7zip/Archive", n, "*.cpp"))
    end
    add_files("CPP/7zip/Compress/*.cpp|DllExports2Compress.cpp|DllExportsCompress.cpp")
    add_files("CPP/7zip/Crypto/*.cpp")
    add_files(
        "CPP/Windows/FileDir.cpp",
        "CPP/Windows/FileFind.cpp",
        "CPP/Windows/FileIO.cpp",
        "CPP/Windows/FileName.cpp",
        "CPP/Windows/PropVariant.cpp",
        "CPP/Windows/PropVariantConv.cpp",
        "CPP/Windows/System.cpp",
        "CPP/Windows/TimeUtils.cpp",
        "CPP/Windows/PropVariantUtils.cpp",
        "CPP/Windows/PropVariant.cpp",
        "CPP/Windows/Synchronization.cpp"
    )
    add_files("CPP/Common/*.cpp")
    if is_plat("windows", "mingw") then
        add_syslinks("user32", "oleaut32", "advapi32")
    else
        add_cxflags("-Wno-parentheses-equality")
    end
    add_rules("@zeromake.rules/export_symbol", {export = exportSymbols})
