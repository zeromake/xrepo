
local function getVersion(version)
    local versions = {
        ["2024.10.29-alpha"] = "archive/e542f661d0946b6d40ea88c0c5bc50fa193fe7f1.tar.gz",
        ["2024.11.05-alpha"] = "archive/93f12c117a4e1c0cc2b129dcc52e84dbd9b84200.tar.gz",
        ["2024.11.15-alpha"] = "archive/f772f3e678ae0a38509b8ece0c894455f028432f.tar.gz",
        ["2024.11.26-alpha"] = "archive/767efeca0621ef7ecdfb8a83afdce54c86ed23fd.tar.gz",
        ["2024.12.02-alpha"] = "archive/d242c47b437c950b545e96e7872aa914edc50be5.tar.gz",
        ["2024.12.20-alpha"] = "archive/2ba57aa535896bcc8c450bbf7d0958791e38ec78.tar.gz",
        ["2025.01.02-alpha"] = "archive/b129d9f2cb897cedba77a60bd5e3621c14ee5484.tar.gz",
        ["2025.01.10-alpha"] = "archive/40ff2a12515e60853fb11da67ab04cdb5a08dea5.tar.gz",
        ["2025.01.19-alpha"] = "archive/42b2b24fb8819f1ed3643aa9cf2a62f03868e3aa.tar.gz",
        ["2025.02.28-alpha"] = "archive/caef968117eb2d6d7224e8d29ec67ff79b0025f8.tar.gz",
        ["2025.03.10-alpha"] = "archive/8d956180934f16244bdb58b39175824775125e55.tar.gz",
        ["2025.08.24-alpha"] = "archive/af5cf2b1e7f03d6f6de84477e1ca8eed1f3eb03d.tar.gz",
        ["2025.10.20-alpha"] = "archive/fcbc3d1b93f91c709293ed9faea8b7cbcac9030b.tar.gz",
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
    add_versions("2025.10.20-alpha", "c24b08b3cd38218184b7078ff5246ad59749f916aa0dd4ced39142b69e9ee0da")
    add_versions("2025.08.24-alpha", "b1680ff45dd04a6d8cc8e74df6e0efd25e3e2f034440fea3a088301b5ed07908")
    add_versions("2025.03.10-alpha", "58550122e4d171eac403f4b277a40443f25c05e8d180b9eb971e6f039be04297")
    add_versions("2025.02.28-alpha", "970b0159a5969fae5edfa6b191be2356bad2b041906c22f4f0e5cec004ee8904")
    add_versions("2025.01.19-alpha", "e26d41e2f496c1598f418726b871ce252ce9f18f8dbe3ad199349a42ed2cb02f")
    add_versions("2025.01.10-alpha", "be1864fc9bd9bd58e2307a0dcde4658abb0ebdb0aa8ab17c4c211d749d24d62f")
    add_versions("2025.01.02-alpha", "3403eede0160e56114dc1e09450444ade1e2e5f4521615107fe472c56d9a5303")
    add_versions("2024.12.20-alpha", "595ca5104fb0403753f709ede29395112257954d86a7cae71efabe220d816810")
    add_versions("2024.12.02-alpha", "ff62bab541c975b5ca05a670132318caaa6f688883171d03d6b23d44476130c0")
    add_versions("2024.11.26-alpha", "d71fe8dd1feb8c1d64672ff5fec848cf38df44730518a3c26b8235b8f352aa80")
    add_versions("2024.11.15-alpha", "804ae8f8c66fe37f49e5e09f3ce88d7f1b29af8fb47e20d7dd5924a6483ebf9e")
    add_versions("2024.11.05-alpha", "0da11d161beb294689847936abf240227ef3b08d02cdc3eb71b9e5cbff388416")
    add_versions("2024.10.29-alpha", "b6792d5d07c67292697e0dbe87e7680a7f6c0cc2c58777ccc35c86b4d4f4b867")
    on_install(function (package)
        io.writefile('config.h.in', [[
#ifdef __CONFIG_H__
#define __CONFIG_H__

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
${define HAVE_MEMALIGN}
${define HAVE_ALIGNED_ALLOC}
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
