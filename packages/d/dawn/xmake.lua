package("dawn")
    set_homepage("https://dawn.googlesource.com/dawn")
    set_description("Dawn, a WebGPU implementation")
    set_license("BSD-3-Clause")

    if is_plat("windows") then
        set_urls("https://github.com/hexops/mach-gpu-dawn/releases/download/release-1cce80c/x86_64-windows-gnu_release-fast.tar.gz")
        add_versions("2024.02.02", "53bb10448039686417fcb80b8f17ac9ab0a78f881a0795f6ffb8171ddef438b1")
    elseif is_plat("macosx") then
        set_urls("https://github.com/hexops/mach-gpu-dawn/releases/download/release-1cce80c/x86_64-macos-none_release-fast.tar.gz")
        add_versions("2024.02.02", "7bf657fc049073e9a62746b38c2e66014d4edd4a1835a47770e6b0ae25b551b5")
    elseif is_plat("linux") then
        set_urls("https://github.com/hexops/mach-gpu-dawn/releases/download/release-1cce80c/x86_64-linux-gnu_release-fast.tar.gz")
        add_versions("2024.02.02", "378131a019182ce005935140209fe64ce93d87827a14f85287b8f32955cfd65d")
    end
    on_install(function (package)
        os.cp("*.lib", package:installdir("lib"))
        os.cp("*.a", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("wgpuCreateInstance", {includes = {"webgpu/webgpu.h"}}))
    -- end)
