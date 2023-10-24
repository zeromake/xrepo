
local function getVersion(version) 
    local versions = {
        ['2023.10.19'] = 'archive/fd4ecc2fd870fa267e1995600dddf212c6e49300.tar.gz'
    }
    return versions[tostring(version)]
end


package("dav1d")
    set_homepage("https://code.videolan.org/videolan/dav1d/")
    set_description("dav1d is an AV1 cross-platform decoder, open-source, and focused on speed and correctness.")
    set_license("BSD-2")
    set_urls("https://github.com/videolan/dav1d/$(version)", {
        version = getVersion
    })
    add_versions("2023.10.19", "ca076dbca6683076011ebdd5d791342bb58575cc5a226caee05643096d4a7af9")
    on_install(function (package)
        io.writefile('config.h.in', [[
${CONFIG_8BPC}
${CONFIG_16BPC}
${CONFIG_LOG}
${_GNU_SOURCE}

${_WIN32_WINNT}
${UNICODE}
${_UNICODE}
${__USE_MINGW_ANSI_STDIO}
${_CRT_DECLARE_NONSTDC_NAMES}
${__USE_MINGW_ANSI_STDIO}

${HAVE_FSEEKO}

#ifdef HAVE_FSEEKO
#define _FILE_OFFSET_BITS 64
#else
#define fseeko _fseeki64
#define ftello _ftelli64
#endif

${HAVE_CLOCK_GETTIME}
${HAVE_POSIX_MEMALIGN}
${HAVE_DLSYM}
${HAVE_UNISTD_H}
${HAVE_IO_H}
${HAVE_PTHREAD_NP_H}
]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
