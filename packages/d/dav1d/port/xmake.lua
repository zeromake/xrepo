includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("enable_asm")
    set_default(true)
    set_showmenu(true)
    set_description("enable asm")

option("bitdepths")
    set_default("8")
    set_showmenu(true)
    set_description("Enable only specified bitdepths")


option("logging")
    set_default(true)
    set_showmenu(true)
    set_description("Print error log messages using the provided callback function")

target("dav1d")
    set_kind("$(kind)")
    add_includedirs(".", "include", "include/dav1d", "src")

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("config.h.in")

    if get_config("bitdepths") then
        set_configvar(string.format("CONFIG_%sBPC", get_config("bitdepths")), 1)
    end
    if get_config('logging') then
        set_configvar("CONFIG_LOG", 1)
    end
    if is_plat("linux", "wasm") then
        set_configvar("_GNU_SOURCE", 1)
    end

    if is_plat("windows", "mingw") then
        add_defines("_WIN32_WINNT=0x0601")
        add_defines("UNICODE=1")
        add_defines("_UNICODE=1")
        add_defines("__USE_MINGW_ANSI_STDIO=1")
        add_defines("_CRT_DECLARE_NONSTDC_NAMES=1")
        configvar_check_cfuncs("HAVE_FSEEKO", "fseeko", {includes = {"stdio.h"}})
        add_files("src/win32/*.c")
    else
        configvar_check_cfuncs("HAVE_CLOCK_GETTIME", "clock_gettime", {includes = {"time.h"}})
        configvar_check_cfuncs("HAVE_POSIX_MEMALIGN", "posix_memalign", {includes = {"stdlib.h"}})
    end
    configvar_check_cfuncs("HAVE_DLSYM", "dlsym", {includes = {"dlfcn.h"}})
    if is_plat("windows") then
        add_includedirs("include/compat")
        add_includedirs("include/compat/msvc")
        add_files("tools/compat/getopt.c")
    end

    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_cincludes("HAVE_IO_H", "io.h")
    configvar_check_cincludes("HAVE_PTHREAD_NP_H", "pthread_np.h")

    configvar_check_cfuncs("HAVE_GETAUXVAL", "getauxval", {includes = {'sys/auxv.h'}})
    configvar_check_cfuncs("HAVE_ELF_AUX_INFO", "elf_aux_info", {includes = {'sys/auxv.h'}})

    add_files(
        'src/cdf.c',
        'src/cpu.c',
        'src/data.c',
        'src/decode.c',
        'src/dequant_tables.c',
        'src/getbits.c',
        'src/intra_edge.c',
        'src/itx_1d.c',
        'src/lf_mask.c',
        'src/lib.c',
        'src/log.c',
        'src/mem.c',
        'src/msac.c',
        'src/obu.c',
        'src/pal.c',
        'src/picture.c',
        'src/qm.c',
        'src/ref.c',
        'src/refmvs.c',
        'src/scan.c',
        'src/tables.c',
        'src/thread_task.c',
        'src/warpmv.c',
        'src/wedge.c'
    )

    if is_arch("arm64.*") then
        set_configvar("PIC", 3)
        add_asflags("-fPIC")
        add_cxflags("-fPIC")
        set_configvar("ARCH_AARCH64", 1)
        add_files("src/arm/cpu.c")
        add_files(
            'src/arm/64/itx.S',
            'src/arm/64/looprestoration_common.S',
            'src/arm/64/msac.S',
            'src/arm/64/refmvs.S'
        )
        if get_config("bitdepths") == "8" then
            add_files(
                'src/arm/64/cdef.S',
                'src/arm/64/filmgrain.S',
                'src/arm/64/ipred.S',
                'src/arm/64/loopfilter.S',
                'src/arm/64/looprestoration.S',
                'src/arm/64/mc.S'
            )
        elseif get_config("bitdepths") == "16" then
            add_files(
                'src/arm/64/cdef16.S',
                'src/arm/64/filmgrain16.S',
                'src/arm/64/ipred16.S',
                'src/arm/64/itx16.S',
                'src/arm/64/loopfilter16.S',
                'src/arm/64/looprestoration16.S',
                'src/arm/64/mc16.S'
            )
        end
    elseif is_arch("arm.*") and not is_arch("arm64.*") then
        set_configvar("ARCH_ARM", 1)
        set_configvar("PIC", 3)
        add_asflags("-fPIC")
        add_cxflags("-fPIC")
        add_files("src/arm/cpu.c")
        add_files(
            'src/arm/32/itx.S',
            'src/arm/32/looprestoration_common.S',
            'src/arm/32/msac.S',
            'src/arm/32/refmvs.S'
        )

        if get_config("bitdepths") == "8" then
            add_files(
                'src/arm/32/cdef.S',
                'src/arm/32/filmgrain.S',
                'src/arm/32/ipred.S',
                'src/arm/32/loopfilter.S',
                'src/arm/32/looprestoration.S',
                'src/arm/32/mc.S'
            )
        elseif get_config("bitdepths") == "16" then
            add_files(
                'src/arm/32/cdef16.S',
                'src/arm/32/filmgrain16.S',
                'src/arm/32/ipred16.S',
                'src/arm/32/itx16.S',
                'src/arm/32/loopfilter16.S',
                'src/arm/32/looprestoration16.S',
                'src/arm/32/mc16.S'
            )
        end
    elseif is_arch("x86", "x64", "x86_64") then
        set_toolset("as", "nasm")
        add_files("src/x86/cpu.c")
        add_configfiles("config.asm.in")
        set_configvar("ASM_FORCE_VEX_ENCODING", 0)
        set_configvar("ASM_PIC", 1)
        set_configvar("ASM_PREFIX", 1)
        if is_arch("x86") then
            set_configvar("ASM_ARCH_X86_32", 1)
            set_configvar("ASM_ARCH_X86_64", 0)
            set_configvar("ASM_STACK_ALIGNMENT", 4)
        else
            set_configvar("ASM_ARCH_X86_32", 0)
            set_configvar("ASM_ARCH_X86_64", 1)
            set_configvar("ASM_STACK_ALIGNMENT", 16)
        end

        add_files(
            'src/x86/cpuid.asm',
            'src/x86/msac.asm',
            'src/x86/pal.asm',
            'src/x86/refmvs.asm',
            'src/x86/itx_avx512.asm',
            'src/x86/cdef_avx2.asm',
            'src/x86/itx_avx2.asm',
            'src/x86/looprestoration_avx2.asm',
            'src/x86/cdef_sse.asm',
            'src/x86/itx_sse.asm'
        )

        if get_config("bitdepths") == "8" then
            add_files(
                'src/x86/cdef_avx512.asm',
                'src/x86/filmgrain_avx512.asm',
                'src/x86/ipred_avx512.asm',
                'src/x86/loopfilter_avx512.asm',
                'src/x86/looprestoration_avx512.asm',
                'src/x86/mc_avx512.asm',
                'src/x86/filmgrain_avx2.asm',
                'src/x86/ipred_avx2.asm',
                'src/x86/loopfilter_avx2.asm',
                'src/x86/mc_avx2.asm',
                'src/x86/filmgrain_sse.asm',
                'src/x86/ipred_sse.asm',
                'src/x86/loopfilter_sse.asm',
                'src/x86/looprestoration_sse.asm',
                'src/x86/mc_sse.asm'
            )
        elseif get_config("bitdepths") == "16" then
            add_files(
                'src/x86/cdef16_avx512.asm',
                'src/x86/filmgrain16_avx512.asm',
                'src/x86/ipred16_avx512.asm',
                'src/x86/itx16_avx512.asm',
                'src/x86/loopfilter16_avx512.asm',
                'src/x86/looprestoration16_avx512.asm',
                'src/x86/mc16_avx512.asm',
                'src/x86/cdef16_avx2.asm',
                'src/x86/filmgrain16_avx2.asm',
                'src/x86/ipred16_avx2.asm',
                'src/x86/itx16_avx2.asm',
                'src/x86/loopfilter16_avx2.asm',
                'src/x86/looprestoration16_avx2.asm',
                'src/x86/mc16_avx2.asm',
                'src/x86/cdef16_sse.asm',
                'src/x86/filmgrain16_sse.asm',
                'src/x86/ipred16_sse.asm',
                'src/x86/itx16_sse.asm',
                'src/x86/loopfilter16_sse.asm',
                'src/x86/looprestoration16_sse.asm',
                'src/x86/mc16_sse.asm'
            )
        end
    end

    add_headerfiles("include/dav1d/*.h", {prefixdir = "dav1d"})
    add_headerfiles("version.h", {prefixdir = "dav1d"})
    
