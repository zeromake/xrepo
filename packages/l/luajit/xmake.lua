

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
        ["2023.09.25-alpha"] = "archive/becf5cc65d966a8926466dd43407c48bfea0fa13.tar.gz",
        ["2024.02.04-alpha"] = "archive/0d313b243194a0b8d2399d8b549ca5a0ff234db5.tar.gz",
        ["2024.03.10-alpha"] = "archive/d06beb0480c5d1eb53b3343e78063950275aa281.tar.gz",
        ["2024.04.22-alpha"] = "archive/5790d253972c9d78a0c2aece527eda5b134bbbf7.tar.gz",
        ["2024.05.25-alpha"] = "archive/93e87998b24021b94de8d1c8db244444c46fb6e9.tar.gz",
        ["2024.07.03-alpha"] = "archive/04dca7911ea255f37be799c18d74c305b921c1a6.tar.gz",
        ["2024.09.04-alpha"] = "archive/87ae18af97fd4de790bb6c476b212e047689cc93.tar.gz",
        ["2024.09.29-alpha"] = "archive/f5fd22203eadf57ccbaa4a298010d23974b22fc0.tar.gz",
        ["2024.10.02-alpha"] = "archive/97813fb924edf822455f91a5fbbdfdb349e5984f.tar.gz",
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
    add_versions("2024.10.02-alpha", "cbf1647acbd340c62b9c342dae43290762efa1b26d8bf8457f143fabf8ed86c7")
    add_versions("2024.09.29-alpha", "8be67f0e7ad10201f634633731846e56a16392eae85b9c49c9274f17e85451b5")
    add_versions("2024.09.04-alpha", "7e34f3aac8cbfacfe8dada50140d4b89d708e0fde60f27ec0643226c2f38ab5f")
    add_versions("2024.07.03-alpha", "346b028d9ba85e04b7e23a43cc51ec076574d2efc0d271d4355141b0145cd6e0")
    add_versions("2024.05.25-alpha", "026eb4531cddff20acc72ec97378ccfc30326173c491d6c01834b48b42a80518")
    add_versions("2024.04.22-alpha", "a299cd389c4568cff4c900e9e86fb56b1f422bf38497a695f6a96e37607a6645")
    add_versions("2024.03.10-alpha", "6abd146a1dfa240a965748f63221633446affa2a715e3eb03879136e3efb95f4")
    add_versions("2024.02.04-alpha", "53731880dbc4adbbf82ba69a85b5dbe15266032b8b94a077c0835bc10ec75f12")
    add_versions("2023.09.25-alpha", "6d7e8fc691d45fe837d05e2a03f3a41b0886a237544d30f74f1355ce2c8d9157")
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
        else
            commonDefines = commonDefines.."    add_defines(\"TARGET_OS_IPHONE=0\")\n"
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
