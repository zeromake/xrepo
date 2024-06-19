
local function getVersion(version)
    local versions = {
        ['2023.10.19-alpha'] = 'archive/fd4ecc2fd870fa267e1995600dddf212c6e49300.tar.gz',
        ["2024.02.29-alpha"] = "archive/85a10359cdfe904af58499716cfb5dbcbf5f14c7.tar.gz",
        ["2024.04.15-alpha"] = "archive/37d52435d1e839546e725b7b4116334d3b3a5bac.tar.gz",
        ["2024.05.14-alpha"] = "archive/d835c6bf69d074c57b416c867c2586940a39adbf.tar.gz",
        ["2024.05.27-alpha"] = "archive/da2cc7817cff218b30f2c813a8a142a43f9376bd.tar.gz",
        ["2024.06.17-alpha"] = "archive/ca83ee6d9dd2c2210deb8e285de4fd72e929e390.tar.gz",
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
    add_versions("2024.06.17-alpha", "8e65990c24a8e5f67322c1c31817bfdff46f204f406f433104d90ab1e91562f2")
    add_versions("2024.05.27-alpha", "0c01a46cce30eb30900f852291d8a7ecff9ecdeea7308e4614fdb67a1335ca2e")
    add_versions("2024.05.14-alpha", "a4ba426b36d196225d30f252505e0dc1c59a11b8ea8a6eb9113a6fb4d4ca3751")
    add_versions("2024.04.15-alpha", "a9a7df1ecc3f133ac48ce122e0da91c8cdc8007ad8a9aadc6bd3c38c9437fbf9")
    add_versions("2024.02.29-alpha", "ae3768efe4699423960f9d20c3efcd0cfd7f76e21fd0321d01b31f1645d0746d")
    add_versions("2023.10.19-alpha", "ca076dbca6683076011ebdd5d791342bb58575cc5a226caee05643096d4a7af9")
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
