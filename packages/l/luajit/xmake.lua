

local ALL_LIB = {
    "src/lib_base.c",
    "src/lib_math.c",
    "src/lib_bit.c",
    "src/lib_string.c",
    "src/lib_table.c",
    "src/lib_io.c",
    "src/lib_os.c",
    "src/lib_package.c",
    "src/lib_debug.c",
    "src/lib_jit.c",
    "src/lib_ffi.c",
    "src/lib_buffer.c"
}

local function generateVm(package)
    local arr = {
        table.join({
            "-m",
            "bcdef",
            "-o",
            "src/lj_bcdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "ffdef",
            "-o",
            "src/lj_ffdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "libdef",
            "-o",
            "src/lj_libdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "recdef",
            "-o",
            "src/lj_recdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "vmdef",
            "-o",
            "src/jit/vmdef.lua"
        }, ALL_LIB),
        {
            "-m",
            "folddef",
            "-o",
            "src/lj_folddef.h",
            "src/lj_opt_fold.c"
        }
    }

    if package:is_plat("windows", "mingw") then
        table.insert(arr, {
            "-m",
            "peobj",
            "-o",
            "src/lj_vm.obj"
        })
    elseif package:is_plat("macosx", "iphoneos") then
        table.insert(arr, {
            "-m",
            "machasm",
            "-o",
            "src/lj_vm.S"
        })
    else
        table.insert(arr, {
            "-m",
            "elfasm",
            "-o",
            "src/lj_vm.asm"
        })
    end
    return arr
end

local function generateBuildvm(package) 
    local args = {
        "dynasm/dynasm.lua",
        "-D",
        "FFI",
    }
    if package:is_plat("windows", "mingw") then
        table.join2(args, {
            "-LN",
            "-D",
            "WIN",
            "-D",
            "JIT",
        })
    elseif package:is_plat("iphoneos") then
        table.join2(args, {
            "-D",
            "NO_UNWIND",
        })
    else
        table.join2(args, {
            "-D",
            "ENDIAN_LE",
            "-D",
            "FPU",
            "-D",
            "HFABI",
            "-D",
            "VER=80",
            "-D",
            "JIT",
        })
    end
    local dasc = nil
    if package:is_arch("x86") then
        dasc = "src/vm_x86.dasc"
    elseif package:is_arch("x86_64", "x64") then 
        table.join2(args, {"-D", "P64"})
        dasc = "src/vm_x64.dasc"
    elseif package:arch():startswith("arm64") then
        dasc = "src/vm_arm64.dasc"
        table.join2(args, {"-D", "DUALNUM", "-D", "ENDIAN_LE", "-D", "P64"})
    elseif package:arch():startswith("arm") then
        dasc = "src/vm_arm.dasc"
        table.join2(args, {"-D", "DUALNUM", "-D", "ENDIAN_LE"})
    end
    if package:is_plat("iphoneos") then
        table.join2(args, "-D", "IOS")
    end
    table.insert(args, "-o")
    table.insert(args, "src/host/buildvm_arch.h")
    table.insert(args, dasc)
    return args
end

local miniluaScript = [[
target("minilua")
    set_kind("binary")
    add_files("src/host/minilua.c")
    set_plat(os.host())
    set_arch(os.arch())
    %s
]]

local buildvmScript = [[
target("buildvm")
    set_kind("binary")
%s
    add_includedirs("dynasm")
    add_includedirs("src")
    add_files("src/host/buildvm*.c")
]]

local function getVersion(version)
    local versions ={
        ["2024.09.29-alpha"] = "archive/f5fd22203eadf57ccbaa4a298010d23974b22fc0.tar.gz",
        ["2024.10.02-alpha"] = "archive/97813fb924edf822455f91a5fbbdfdb349e5984f.tar.gz",
        ["2024.11.14-alpha"] = "archive/fe71d0fb54ceadfb5b5f3b6baf29e486d97f6059.tar.gz",
        ["2024.11.28-alpha"] = "archive/19878ec05c239ccaf5f3d17af27670a963e25b8b.tar.gz",
        ["2024.12.16-alpha"] = "archive/f73e649a954b599fc184726c376476e7a5c439ca.tar.gz",
        ["2025.01.13-alpha"] = "archive/a4f56a459a588ae768801074b46ba0adcfb49eb1.tar.gz",
        ["2025.03.11-alpha"] = "archive/538a82133ad6fddfd0ca64de167c4aca3bc1a2da.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("luajit")
    set_homepage("https://luajit.org")
    set_description("LuaJIT is a Just-In-Time Compiler (JIT) for the Lua programming language. Lua is a powerful, dynamic and light-weight programming language. It may be embedded or used as a general-purpose, stand-alone language.")
    set_license("MIT")
    set_urls("https://github.com/LuaJIT/LuaJIT/$(version)",
        {
            version = getVersion
        }
    )
    --insert version
    add_versions("2025.03.11-alpha", "7acbc36be8f21072422eb9a5e5fc468d0eaa55bec1b70260d651e845684621e2")
    add_versions("2025.01.13-alpha", "b4120332a4191db9c9da2d81f9f11f0d4504fc4cff2dea0f642d3d8f1fcebd0e")
    add_versions("2024.12.16-alpha", "bc992b3ae0a8f5f0ebbf141626b7c99fac794c94ec6896d973582525c7ef868d")
    add_versions("2024.11.28-alpha", "e91acbe181cf6ffa3ef15870b8e620131002240ba24c5c779fd0131db021517f")
    add_versions("2024.11.14-alpha", "92325f209b21aaf0a67b099bc73cf9bbac5789a9749bdc3898d4a990abb4f36e")
    add_versions("2024.10.02-alpha", "cbf1647acbd340c62b9c342dae43290762efa1b26d8bf8457f143fabf8ed86c7")
    add_versions("2024.09.29-alpha", "8be67f0e7ad10201f634633731846e56a16392eae85b9c49c9274f17e85451b5")
    on_install(function (package)
        local lua_target = nil
        local lua_os = nil
        local lua_arch32 = 0
        if os.host() == "windows" then
            lua_os = "LUAJIT_OS_WINDOWS"
        elseif os.host() == "macosx" then 
            lua_os = "LUAJIT_OS_OSX"
        elseif os.host() == "linux" or os.host() == "android" then 
            lua_os = "LUAJIT_OS_LINUX"
        else
            lua_os = "LUAJIT_OS_OTHER"
        end
        if package:is_arch("x86") then
            lua_target = "LUAJIT_ARCH_x86"
        elseif package:is_arch("x86_64", "x64") then
            lua_target = "LUAJIT_ARCH_x64"
        elseif package:arch():startswith("arm64") then
            lua_target = "LUAJIT_ARCH_arm64"
        elseif package:arch():startswith("arm") then
            lua_target = "LUAJIT_ARCH_arm"
            lua_arch32 = 1
        end

        local commonDefines = string.format([[
    add_defines("LUAJIT_OS=%s")
    add_defines("LUAJIT_TARGET=%s")
    add_defines("LJ_ARCH_HASFPU=1")
    add_defines("LJ_ABI_SOFTFP=0")
]], lua_os, lua_target)
        if package:is_plat("iphoneos") then
            commonDefines = commonDefines.."    add_defines(\"TARGET_OS_IPHONE=1\")\n"
            commonDefines = commonDefines.."    add_defines(\"LUAJIT_NO_UNWIND\")\n"
        end
        io.writefile(
            "xmake.lua",
            string.format(miniluaScript, commonDefines, lua_arch32),
            {encoding = "binary"}
        )
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        local args = generateBuildvm(package)
        os.vrunv(
            package:installdir("bin").."/minilua",
            args
        )
        if os.exists("src/host/genversion.lua") and os.exists(".relver") then
            os.cp(".relver", "src/luajit_relver.txt")
            os.vrunv(
                package:installdir("bin").."/minilua",
                {
                    "host/genversion.lua"
                },
                {curdir = "src"}
            )
        end
        local _buildvmScript = string.format(buildvmScript, commonDefines)
        io.writefile(
            "xmake.lua",
            _buildvmScript,
            {encoding = "binary"}
        )
        print(_buildvmScript)
        local buildvmConfig = {
            plat=os.host(),
            arch=os.arch()
        }
        if lua_arch32 == 1 then
            buildvmConfig["arch"] = (os.host() == "windows" or os.host() == "macosx") and "x86" or "i386"
        end
        import("package.tools.xmake").install(package, buildvmConfig)
        local arr = generateVm(package)
        for _, args in ipairs(arr) do
            os.vrunv(package:installdir("bin").."/buildvm", args)
        end
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package, configs)
        os.tryrm(package:installdir("bin").."/buildvm")
        os.tryrm(package:installdir("bin").."/minilua")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
