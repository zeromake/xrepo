includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
    add_defines("WIN32_LEAN_AND_MEAN", "_SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING")
end

set_languages("c99", "c++17")
set_encodings("utf-8")

configvar_check_cincludes("HAVE_A_OUT_H", "a.out.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_PTHREAD", "pthread.h")
configvar_check_cincludes("HAVE_STDINT_H", "pthread.h")
configvar_check_cincludes("HAVE_STDIO_H", "pthread.h")
configvar_check_cincludes("HAVE_STDLIB_H", "pthread.h")
configvar_check_cincludes("HAVE_STRINGS_H", "pthread.h")
configvar_check_cincludes("HAVE_STRING_H", "pthread.h")
configvar_check_cincludes("HAVE_SYS_MMAN_H", "pthread.h")
configvar_check_cincludes("HAVE_SYS_RANDOM_H", "pthread.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "pthread.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "pthread.h")
configvar_check_cincludes("HAVE_UNISTD_H", "pthread.h")
configvar_check_cincludes("HAVE_SYS_RANDOM_H", "pthread.h")

configvar_check_cfuncs("HAVE_ARC4RANDOM", "arc4random", {includes = "stdlib.h"})
configvar_check_cfuncs("HAVE_GETCONTEXT",  "getcontext",  {includes = "ucontext.h"})
configvar_check_cfuncs("HAVE_GETRANDOM",  "getrandom",  {includes = "sys/random.h"})
configvar_check_cfuncs("HAVE_MEMFD_CREATE",  "memfd_create",  {includes = "sys/mman.h"})


set_configvar("PACKAGE", "breakpad")
set_configvar("PACKAGE_BUGREPORT", "google-breakpad-dev@googlegroups.com")
set_configvar("PACKAGE_NAME", "breakpad")
set_configvar("PACKAGE_STRING", "breakpad 0.1")
set_configvar("PACKAGE_TARNAME", "breakpad")
set_configvar("PACKAGE_URL", "")
set_configvar("PACKAGE_VERSION", "0.1")
set_configvar("VERSION", "0.1")
set_configvar("STDC_HEADERS", 1)
set_configvar("HAVE_CXX17", 1)
set_configdir("$(buildir)/config")

add_includedirs("$(buildir)/config")
add_defines("HAVE_CONFIG_H", "DISABLE_PPC_SUPPORT")
set_rundir(".")

target("breakpad")
    set_kind("static")
    add_includedirs("src")
    add_configfiles("config.h.in")
    if is_plat("windows") then
        add_files("compat/*.c")
        add_includedirs("compat")
    end
    add_files(
        "src/client/minidump_file_writer.cc",
        "src/common/convert_UTF.cc",
        "src/common/md5.cc",
        "src/common/string_conversion.cc",
        "src/common/path_helper.cc"
    )
    add_headerfiles(
        "src/(common/scoped_ptr.h)",
        "src/(google_breakpad/common/*.h)",
        "src/(google_breakpad/processor/*.h)"
    )

    if is_plat("windows", "mingw") then
        add_files(
            "src/client/windows/crash_generation/*.cc",
            "src/client/windows/handler/*.cc",
            "src/common/windows/guid_string.cc"
        )
        add_headerfiles(
            "src/(common/windows/string_utils-inl.h)",
            "src/(client/windows/crash_generation/*.h)",
            "src/(client/windows/handler/*.h)",
            "src/(client/windows/common/*.h)"
        )
    elseif is_plat("linux") then
        add_files(
            "src/client/linux/crash_generation/*.cc",
            "src/client/linux/handler/*.cc"
        )
    elseif is_plat("macosx") then
        add_files(
            "src/client/mac/crash_generation/*.cc",
            "src/client/mac/handler/*.cc",
            "src/common/mac/arch_utilities.cc",
            "src/common/mac/macho_walker.cc",
            "src/common/mac/macho_utilities.cc",
            "src/common/mac/string_utilities.cc",
            "src/common/mac/bootstrap_compat.cc",
            "src/common/mac/MachIPC.mm",
            "src/common/mac/macho_id.cc",
            "src/common/mac/file_id.cc"
        )
        add_headerfiles(
            "src/(client/mac/handler/exception_handler.h)",
            "src/(client/mac/crash_generation/*.h)",
            "src/(client/mac/handler/*.h)",
            "src/(common/mac/MachIPC.h)"
        )
        add_frameworks("CoreFoundation")
    end

target("dump_syms")
    set_kind("binary")
    add_includedirs("src")
    if is_plat("windows") then
        add_files("compat/*.c")
        add_includedirs("compat")
        add_syslinks("diaguids", "imagehlp", "dbghelp")
    end
    if is_plat("windows") then
        on_config(function (target)
            import("detect.sdks.find_vstudio")
            local vs = nil
            for _, vsinfo in pairs(find_vstudio()) do
                if vsinfo.vcvarsall then
                    vs = vsinfo.vcvarsall[target:arch()]
                    break
                end
            end
            if vs ~= nil then
                local VSInstallDir = vs['VSInstallDir']
                local archDir = "amd64"
                if target:is_arch("x86") then
                    archDir = "x86"
                elseif target:is_arch("arm64") then
                    archDir = "arm64"
                end
                target:add("includedirs", path.join(VSInstallDir, "DIA SDK/include"))
                target:add("linkdirs", path.join(VSInstallDir, "DIA SDK/lib/" .. archDir))
            end
        end)
    end
    if is_plat("windows", "mingw") then
        add_files(
            "src/tools/windows/dump_syms/dump_syms.cc",
            "src/common/windows/string_utils.cc",
            "src/common/windows/guid_string.cc",
            "src/common/windows/pdb_source_line_writer.cc",
            "src/common/windows/pe_source_line_writer.cc",
            "src/common/windows/omap.cc",
            "src/common/windows/dia_util.cc",
            "src/common/windows/pe_util.cc"
        )
    elseif is_plat("linux") then
        add_files("src/tools/linux/dump_syms/dump_syms.cc")
    elseif is_plat("macosx") then
        add_defines("HAVE_MACH_O_NLIST_H")
        add_files(
            "src/tools/mac/dump_syms/dump_syms_tool.cc",
            "src/common/dwarf/*.cc|*_unittest.cc|functioninfo.cc",
            "src/common/md5.cc",
            "src/common/dwarf_cfi_to_module.cc",
            "src/common/module.cc",
            "src/common/path_helper.cc",
            "src/common/dwarf_line_to_module.cc",
            "src/common/dwarf_range_list_handler.cc",
            "src/common/test_assembler.cc",
            "src/common/stabs_reader.cc",
            "src/common/stabs_to_module.cc",
            "src/common/dwarf_cu_to_module.cc",
            "src/common/language.cc",
            "src/common/mac/arch_utilities.cc",
            "src/common/mac/dump_syms.cc",
            "src/common/mac/file_id.cc",
            "src/common/mac/macho_reader.cc",
            "src/common/mac/macho_id.cc",
            "src/common/mac/macho_utilities.cc",
            "src/common/mac/macho_walker.cc"
        )
    end


target("minidump_stackwalk")
    set_kind("binary")
    add_includedirs("src")
    if is_plat("windows") then
        add_files("compat/*.c")
        add_includedirs("compat")
    end
    add_files("src/third_party/libdisasm/*.c")
    add_files(
        "src/processor/basic_source_line_resolver.cc",
        "src/processor/basic_code_modules.cc",
        "src/processor/call_stack.cc",
        "src/processor/cfi_frame_info.cc",
        "src/processor/disassembler_x86.cc",
        "src/processor/exploitability.cc",
        "src/processor/exploitability_win.cc",
        "src/processor/logging.cc",
        "src/processor/minidump.cc",
        "src/processor/minidump_processor.cc",
        "src/processor/minidump_stackwalk.cc",
        "src/processor/pathname_stripper.cc",
        "src/processor/process_state.cc",
        "src/processor/simple_symbol_supplier.cc",
        "src/processor/stackwalker.cc",
        "src/processor/stackwalker_amd64.cc",
        "src/processor/stackwalker_arm.cc",
        "src/processor/stackwalker_arm64.cc",
        "src/processor/stackwalker_ppc.cc",
        "src/processor/stackwalker_ppc64.cc",
        "src/processor/stackwalker_sparc.cc",
        "src/processor/stackwalker_x86.cc",
        "src/processor/stackwalker_mips.cc",
        "src/processor/stackwalker_riscv.cc",
        "src/processor/stackwalker_riscv64.cc",
        "src/processor/source_line_resolver_base.cc",
        "src/processor/tokenize.cc",
        "src/processor/dump_object.cc",
        "src/processor/dump_context.cc",
        "src/processor/proc_maps_linux.cc",
        "src/processor/symbolic_constants_win.cc",
        "src/processor/stackwalk_common.cc",
        "src/processor/exploitability_linux.cc",
        "src/processor/stack_frame_symbolizer.cc",
        "src/processor/convert_old_arm64_context.cc",
        "src/common/path_helper.cc"
    )
