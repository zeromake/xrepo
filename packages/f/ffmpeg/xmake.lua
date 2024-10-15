package("ffmpeg")
    set_homepage("https://ffmpeg.org")
    set_description("A complete, cross-platform solution to record, convert and stream audio and video.")
    set_license("GPL")

    if is_plat("windows") then
        set_urls("https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-10-01-12-55/ffmpeg-n7.1-1-g12682eba2e-win64-gpl-shared-7.1.zip")
        add_versions("latest", "6b216295a1ec4b4b7b7c55f1760d8601c54b2c7ef62f6324f9096ba7901ae0e0")
    end
    on_install(function (package)
        os.cp("bin/*.exe", package:installdir("bin"))
        os.cp("bin/*.dll", package:installdir("bin"))
        os.cp("lib/*.lib", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
