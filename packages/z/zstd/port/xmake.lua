if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

local sourceFiles = {
    "lib/common/*.c",
    "lib/compress/*.c",
    "lib/decompress/*.c",
    "lib/dictBuilder/*.c",
    -- "lib/deprecated/*.c"
}

option("legacy_support")
    set_default(5)
    set_showmenu(true)

target("zstd")
    set_kind("$(kind)")

    add_defines("ZSTD_MULTITHREAD=1")

    if is_plat("windows", "mingw") and is_kind("shared") then
        add_defines("ZSTD_DLL_EXPORT=1")
    end
    local legacySupport = 5
    if has_config("legacy_support") then 
        legacySupport= get_config("legacy_support")
    end
    add_defines("ZSTD_LEGACY_SUPPORT="..legacySupport)
    add_defines("ZSTD_DISABLE_ASM=1")
    for support = legacySupport, 7, 1 do
        add_files("lib/legacy/zstd_v0"..support..".c")
    end
    add_headerfiles("lib/*.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
