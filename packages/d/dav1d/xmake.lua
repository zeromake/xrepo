
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
#pragma once

#ifdef __CONFIG_H
#define __CONFIG_H

${define CONFIG_8BPC}
${define CONFIG_16BPC}
${define CONFIG_LOG}
${define _GNU_SOURCE}
${define HAVE_ASM}

${define _WIN32_WINNT}
${define UNICODE}
${define _UNICODE}
${define __USE_MINGW_ANSI_STDIO}
${define _CRT_DECLARE_NONSTDC_NAMES}
${define __USE_MINGW_ANSI_STDIO}

${define HAVE_FSEEKO}

#ifdef HAVE_FSEEKO
#define _FILE_OFFSET_BITS 64
#else
#define fseeko _fseeki64
#define ftello _ftelli64
#endif

${define HAVE_CLOCK_GETTIME}
${define HAVE_POSIX_MEMALIGN}
${define HAVE_DLSYM}
${define HAVE_UNISTD_H}
${define HAVE_IO_H}
${define HAVE_PTHREAD_NP_H}

${define ARCH_AARCH64}
${define ARCH_ARM}
${define HAVE_AS_FUNC}
${define PIC}

#endif
]])
        io.writefile("version.h", [[
#ifndef DAV1D_VERSION_H
#define DAV1D_VERSION_H

#ifdef __cplusplus
extern "C" {
#endif

#define DAV1D_API_VERSION_MAJOR 7
#define DAV1D_API_VERSION_MINOR 0
#define DAV1D_API_VERSION_PATCH 0

/**
 * Extract version components from the value returned by
 * dav1d_version_int()
 */
#define DAV1D_API_MAJOR(v) (((v) >> 16) & 0xFF)
#define DAV1D_API_MINOR(v) (((v) >>  8) & 0xFF)
#define DAV1D_API_PATCH(v) (((v) >>  0) & 0xFF)

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* DAV1D_VERSION_H */
]])

        io.writefile("vcs_version.h", [[
#define DAV1D_VERSION "ca076db"
]])
        if package:is_arch("x86", "x64", "x86_64") then
            io.writefile("config.asm.in", [[
%define ARCH_X86_32 ${ASM_ARCH_X86_32}
%define ARCH_X86_64 ${ASM_ARCH_X86_64}
%define FORCE_VEX_ENCODING ${ASM_FORCE_VEX_ENCODING}
%define PIC ${ASM_PIC}
%define STACK_ALIGNMENT ${ASM_STACK_ALIGNMENT}
%define private_prefix dav1d
]])
        end
        for _, f in ipairs({
            'cdef_apply_tmpl',
            'cdef_tmpl',
            'fg_apply_tmpl',
            'filmgrain_tmpl',
            'ipred_prepare_tmpl',
            'ipred_tmpl',
            'itx_tmpl',
            'lf_apply_tmpl',
            'loopfilter_tmpl',
            'looprestoration_tmpl',
            'lr_apply_tmpl',
            'mc_tmpl',
            'recon_tmpl'
        }) do
            local content = io.readfile(path.join("src", f..".c"))
            local bpc8 = content:gsub('#include "config%.h"', '#include "config.8bpc.h"')
            io.writefile(path.join("src", f..".8bpc.c"), bpc8)
            local bpc16 = content:gsub('#include "config%.h"', '#include "config.16bpc.h"')
            io.writefile(path.join("src", f..".16bpc.c"), bpc16)
        end
        io.writefile("config.8bpc.h", [[
#ifdef __CONFIG_8BPC_H
#define __CONFIG_8BPC_H

#include "config.h"
#define BITDEPTH 8

#endif
]])
        io.writefile("config.16bpc.h", [[
#ifdef __CONFIG_16BPC_H
#define __CONFIG_16BPC_H

#include "config.h"
#define BITDEPTH 16

#endif
]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
