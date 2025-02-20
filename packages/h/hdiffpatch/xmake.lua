package("hdiffpatch")
    set_kind("binary")
    set_homepage("https://github.com/sisong/HDiffPatch")
    set_description("a C\\C++ library and command-line tools for Diff & Patch between binary files or directories(folder); cross-platform; runs fast; create small delta/differential; support large files and limit memory requires when diff & patch.")
    set_license("MIT")
    local suffix = ""
    if is_host("windows") then
        suffix = "bin_windows64.zip"
        add_versions("4.8.0", "20882040c25ca53be00343281aea4606a0e1d304e4fe4d8d6e4fc1c2d13048eb")
    elseif is_plat("linux") then
        suffix = "bin_linux64.zip"
        add_versions("4.8.0", "2a5c9f487537582d21d8124ecdea0926bc6d2f6e74d48b963eb819172b5521b4")
    elseif is_plat("macosx") then
        suffix = "bin_macos.zip"
        add_versions("4.8.0", "2e855629479f400fe9afc7294966f5b964835e77025c558b10f973396033d635")
    end
    set_urls("https://github.com/sisong/HDiffPatch/releases/download/v$(version)/hdiffpatch_v$(version)_"..suffix)

    on_install(function (package)
        local ext = ""
        if is_host("windows") then
            ext = ".exe"
        end
        os.cp("hdiffz"..ext, package:installdir("bin"))
        os.cp("hpatchz"..ext, package:installdir("bin"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
