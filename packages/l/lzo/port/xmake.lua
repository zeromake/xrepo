includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "src/*.c"
}

local checkHeades = {
    "assert.h",
    "ctype.h",
    "dirent.h",
    "errno.h",
    "fcntl.h",
    "float.h",
    "limits.h",
    "malloc.h",
    "memory.h",
    "setjmp.h",
    "signal.h",
    "stdarg.h",
    "stddef.h",
    "stdint.h",
    "stdio.h",
    "stdlib.h",
    "string.h",
    "strings.h",
    "time.h",
    "unistd.h",
    "utime.h",
    "sys/mman.h",
    "sys/resource.h",
    "sys/stat.h",
    "sys/time.h",
    "sys/types.h",
    "sys/wait.h",
}

local checkSizeOfs = {
    "short",
    "int",
    "long",
    "long long",
    "__int16",
    "__int32",
    "__int64",
    "void *",
    "size_t",
    "ptrdiff_t",
    "intmax_t",
    "uintmax_t",
    "intptr_t",
    "uintptr_t",
    "float",
    "double",
    "long double",
    "dev_t",
    "fpos_t",
    "mode_t",
    "off_t",
    "ssize_t",
    "time_t",
}

local checkFuns = {
    access = {"unistd.h"},
    alloca = {"alloca.h"},
    atexit = {"stdlib.h"},
    atoi = {"stdlib.h"},
    atol = {"stdlib.h"},
    chmod = {"sys/stat.h"},
    chown = {"unistd.h"},
    clock_getcpuclockid = {"time.h"},
    clock_getres = {"time.h"},
    clock_gettime = {"time.h"},
    ctime = {"time.h"},
    difftime = {"time.h"},
    fstat = {"sys/stat.h"},
    getenv = {"stdlib.h"},
    getpagesize = {"unistd.h"},
    getrusage = {"sys/resource.h"},
    gettimeofday = {"sys/time.h"},
    gmtime = {"time.h"},
    isatty = {"unistd.h"},
    localtime = {"time.h"},
    longjmp = {"setjmp.h"},
    lstat = {"sys/stat.h"},
    memcmp = {"string.h"},
    memcpy = {"string.h"},
    memmove = {"string.h"},
    memset = {"string.h"},
    mkdir = {"sys/stat.h"},
    mktime = {"time.h"},
    mmap = {"sys/mman.h"},
    mprotect = {"sys/mman.h"},
    munmap = {"sys/mman.h"},
    qsort = {"stdlib.h"},
    raise = {"signal.h"},
    rmdir = {"unistd.h"},
    setjmp = {"setjmp.h"},
    signal = {"signal.h"},
    snprintf = {"stdio.h"},
    strcasecmp = {"strings.h"},
    strchr = {"string.h"},
    strdup = {"string.h"},
    strerror = {"string.h"},
    strftime = {"time.h"},
    stricmp = {"string.h"},
    strncasecmp = {"strings.h"},
    strnicmp = {"string.h"},
    strrchr = {"string.h"},
    strstr = {"string.h"},
    time = {"time.h"},
    umask = {"sys/stat.h"},
    utime = {"utime.h"},
    vsnprintf = {"stdio.h"},
}


function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

target("lzo")
    set_kind("$(kind)")
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config", "include")
    add_configfiles("config.h.in")

    for _, checkHeader in ipairs(checkHeades) do
        local defineName = "HAVE_"..(checkHeader:gsub("/", "_"):gsub("%.", "_"):upper())
        configvar_check_cincludes(defineName, checkHeader)
    end
    for _, checkSizeOf in ipairs(checkSizeOfs) do
        local defineName = "SIZEOF_"..(checkSizeOf:gsub(" ", "_"):gsub("%*", "p"):upper())
        configvar_check_sizeof(defineName, checkSizeOf)
    end

    for checkFun, include in pairs(checkFuns) do
        local defineName = "HAVE_"..(checkFun:upper())
        configvar_check_cfuncs(defineName, checkFun, {includes=include})
    end

    add_headerfiles("include/lzo/*.h", {prefixdir = "lzo"})
    add_defines("LZO_HAVE_CONFIG_H=1")
    if is_plat("windows", "mingw") and is_kind("shared") then
        add_defines("__LZO_EXPORT1=__declspec(dllexport)")
    end

    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
