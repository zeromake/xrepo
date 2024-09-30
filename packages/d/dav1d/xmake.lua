
local function getVersion(version)
    local versions = {
        ["2024.06.17-alpha"] = "archive/ca83ee6d9dd2c2210deb8e285de4fd72e929e390.tar.gz",
        ["2024.06.26-alpha"] = "archive/2355eeb8f254a1c34dbb0241be5c70cdf6ed46d1.tar.gz",
        ["2024.09.12-alpha"] = "archive/dd32cd5027c8c4bd43dc72d79df020186865bc7f.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("dav1d")
    set_homepage("https://code.videolan.org/videolan/dav1d/")
    set_description("dav1d is an AV1 cross-platform decoder, open-source, and focused on speed and correctness.")
    set_license("BSD-2-Clause")
    set_urls("https://github.com/videolan/dav1d/$(version)", {
        version = getVersion
    })
    --insert version
    add_versions("2024.09.12-alpha", "12ad1c6dca3c3b66dab0390d244725e46225c919cdc3f144dd795b5a065eac84")
    add_versions("2024.06.26-alpha", "b89413c7886db62f0cf38a3a8534b05ac265bef0827116e8a3b83f03ccf43e2d")
    add_versions("2024.06.17-alpha", "8e65990c24a8e5f67322c1c31817bfdff46f204f406f433104d90ab1e91562f2")
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
]], {encoding = "binary"})
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
]], {encoding = "binary"})

        io.writefile("vcs_version.h", [[
#define DAV1D_VERSION "ca076db"
]], {encoding = "binary"})
        if package:is_arch("x86", "x64", "x86_64") then
            io.writefile("config.asm.in", [[
%define ARCH_X86_32 ${ASM_ARCH_X86_32}
%define ARCH_X86_64 ${ASM_ARCH_X86_64}
%define FORCE_VEX_ENCODING ${ASM_FORCE_VEX_ENCODING}
%define PIC ${ASM_PIC}
%define STACK_ALIGNMENT ${ASM_STACK_ALIGNMENT}
%define private_prefix dav1d
]], {encoding = "binary"})
        end
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
