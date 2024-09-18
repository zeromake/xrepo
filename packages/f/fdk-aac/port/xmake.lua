add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")
add_requires("zeromake.rules")

target("fdk-aac")
    set_kind("$(kind)")
    add_rules("@zeromake.rules/export_symbol", {export = {
        "aacDecoder_AncDataGet",
        "aacDecoder_AncDataInit",
        "aacDecoder_Close",
        "aacDecoder_ConfigRaw",
        "aacDecoder_DecodeFrame",
        "aacDecoder_Fill",
        "aacDecoder_GetFreeBytes",
        "aacDecoder_GetLibInfo",
        "aacDecoder_GetStreamInfo",
        "aacDecoder_Open",
        "aacDecoder_SetParam",
        "aacEncClose",
        "aacEncEncode",
        "aacEncGetLibInfo",
        "aacEncInfo",
        "aacEncOpen",
        "aacEncoder_GetParam",
        "aacEncoder_SetParam",
    }})
    add_includedirs(
        "libAACdec/include",
        "libAACenc/include",
        "libArithCoding/include",
        "libDRCdec/include",
        "libFDK/include",
        "libMpegTPDec/include",
        "libMpegTPEnc/include",
        "libPCMutils/include",
        "libSACdec/include",
        "libSACenc/include",
        "libSBRdec/include",
        "libSBRenc/include",
        "libSYS/include"
    )
    add_headerfiles(
        "libAACdec/include/*.h",
        "libAACenc/include/*.h",
        "libSYS/include/*.h",
        {prefixdir = "fdk-aac"}
    )
    add_files(
        "libAACdec/src/*.cpp",
        "libAACenc/src/*.cpp",
        "libArithCoding/src/*.cpp",
        "libDRCdec/src/*.cpp",
        "libFDK/src/*.cpp",
        "libMpegTPDec/src/*.cpp",
        "libMpegTPEnc/src/*.cpp",
        "libPCMutils/src/*.cpp",
        "libSACdec/src/*.cpp",
        "libSACenc/src/*.cpp",
        "libSBRdec/src/*.cpp",
        "libSBRenc/src/*.cpp",
        "libSYS/src/*.cpp"
    )
