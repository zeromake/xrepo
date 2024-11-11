add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

local dirs = {
    "libAACdec",
    "libAACenc",
    "libPCMutils",
    "libFDK",
    "libSYS",
    "libMpegTPDec",
    "libMpegTPEnc",
    "libSBRdec",
    "libSBRenc",
    "libArithCoding",
    "libDRCdec",
    "libSACdec",
    "libSACenc",
}

set_encodings("utf-8")
add_requires("zeromake.rules")

target("fdk-aac")
    set_kind("$(kind)")
    for _, dir in ipairs(dirs) do
        add_files(path.join(dir, "src/*.cpp"))
        add_includedirs(path.join(dir, "include"))
    end
    add_headerfiles(
        "libAACdec/include/*.h",
        "libAACenc/include/*.h",
        "libSYS/include/*.h",
        {prefixdir = "fdk-aac"}
    )
