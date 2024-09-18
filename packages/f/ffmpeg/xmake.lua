package("ffmpeg")
    set_homepage("https://ffmpeg.org")
    set_description("A complete, cross-platform solution to record, convert and stream audio and video.")
    set_license("GPL")

    if is_plat("windows") then
        set_urls("https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-09-17-18-11/ffmpeg-n7.0.2-17-gf705bc5b73-win64-gpl-shared-7.0.zip")
        add_versions("latest", "ba968eeff56802e397b47d4fce0cbfe5296aea0e61fb35ed1f3ec7fcae7e20d8")
    end
    on_install(function (package)
        os.cp("bin/*", package:installdir("bin"))
        os.cp("lib/*.lib", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
