package("ffmpeg")
    set_homepage("https://ffmpeg.org")
    set_description("A complete, cross-platform solution to record, convert and stream audio and video.")
    set_license("GPL")

    if is_plat("windows") then
        set_urls("https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n7.0-latest-win64-gpl-shared-7.0.zip")
        add_versions("latest", "01ba93c050a29559dd0bbd686ad5a952a1d3aba3754e799265f074e4dc251b7c")
    end
    on_install(function (package)
        os.cp("bin/*", package:installdir("bin"))
        os.cp("lib/*.lib", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
