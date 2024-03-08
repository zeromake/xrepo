local checkFuns = {
    asprintf = {"stdio.h"},
    getopt = {"getopt.h"},
    reallocarray = {"stdlib.h"},
    strcasecmp = {"strings.h"},
    strlcat = {"bsd/string.h"},
    strlcpy = {"bsd/string.h"},
    strndup = {"string.h"},
    strnlen = {"string.h"},
    strsep = {"string.h"},
    timegm = {"time.h"},
    arc4random_buf = {"stdlib.h"},
    arc4random_uniform = {"stdlib.h"},
    explicit_bzero = {"strings.h"},
    getauxval = {"sys/auxv.h"},
    getentropy = {"unistd.h"},
    getpagesize = {"unistd.h"},
    getprogname = {"stdlib.h"},
    syslog_r = {"syslog.h"},
    syslog = {"syslog.h"},
    timespecsub = {"sys/time.h"},
    timingsafe_bcmp = {"string.h"},
    timingsafe_memcmp = {"string.h"},
    memmem = {"string.h"},
}


local checkHeaders = {
    "endian.h",
    "machine/endian.h",
    "err.h",
    "netinet/ip.h",
}

local checkSymbols = {
    clock_gettime = {"time.h"},
}

local checkSizeOfs = {
    time_t = {"time.h"},
}

function check_csymbol_exists(target, var_name, opt)
    return target:check_csnippets('void* a = (void*)'..var_name..';', opt)
end

function main(target)
    local check = {}
    for checkFun, headers in pairs(checkFuns) do
        local define_name = "HAVE_"..(checkFun:upper())
        check[define_name] = false
        if target:check_cfuncs(checkFun, {includes=headers}) then
            target:add('defines', define_name)
            check[define_name] = true
        end
    end
    for _, checkHeader in pairs(checkHeaders) do
        local define_name = "HAVE_"..(checkHeader:gsub("/", "_"):gsub("%.", "_"):upper()).."_H"
        check[define_name] = false
        if target:check_cincludes(checkHeader) then
            target:add('defines', define_name)
            check[define_name] = true
        end
    end
    for checkSymbol, headers in pairs(checkSymbols) do
        local define_name = "HAVE_"..(checkSymbol:upper())
        check[define_name] = false
        if check_csymbol_exists(target, checkSymbol, {includes=headers}) then
            target:add('defines', define_name)
            check[define_name] = true
        end
    end

    for checkSizeOf, headers in pairs(checkSizeOfs) do
        local define_name = "SIZEOF_"..(checkSizeOf:upper())
        check[define_name] = false
        local size = target:check_sizeof(checkSizeOf, {includes=headers})
        if size then
            target:add('defines', define_name.."="..size)
            check[define_name] = size
        end
    end
    return check
end
