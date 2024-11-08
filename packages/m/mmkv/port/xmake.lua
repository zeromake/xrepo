add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("mmkv")
    set_kind("$(kind)")
    set_languages("c++20")
    add_files(
        "Core/*.cpp",
        "Core/aes/*.cpp",
        "Core/aes/openssl/*.cpp",
        "Core/crc32/*.cpp",
        "Core/crc32/zlib/*.cpp"
    )
    add_defines("MMKV_EMBED_ZLIB=1")
    add_headerfiles(
        "Core/MMKV.h",
        "Core/MMKVPredef.h",
        "Core/MMBuffer.h",
        "Core/MiniPBCoder.h",
        {prefixdir = "MMKV"}
    )
    if is_plat("android") then
        add_defines("__ANDROID__")
    elseif is_plat("iphoneos", "watchos", "appletvos", "macosx") then
        add_defines("FORCE_POSIX")
    end
    if is_arch("arm.*") then
        local flags = "-march=armv7a"
        if is_arch("arm64.*") then
            flags = "-march=armv8+crypto"
        end
        add_files("Core/aes/openssl/*.S", {asflags = flags})
    end
