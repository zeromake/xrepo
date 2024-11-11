local function getVersion(version)
    local versions ={
        ["2024.10.03-alpha"] = "archive/a76a28900a5349425e7640f65a839a71eb2f27ec.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("fdk-aac")
    set_homepage("https://android.googlesource.com/platform/external/aac")
    set_description("A standalone library of the Fraunhofer FDK AAC code from Android.")
    set_license("MIT")
    set_urls("https://github.com/zeromake/fdk-aac/$(version)", {version = getVersion})

    --insert version
    add_versions("2024.10.03-alpha", "d3abfe729a4588d58638439125728f2b4da124331b13747d5deede420a17bef2")
    add_patches("2024.10.03-alpha", path.join(os.scriptdir(), "patches/fix.patch"), "9deea84d11cd43b27b4db1c453c5fd5cbfd606b3020000b6d39131fc9773964b")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("aacDecoder_Open", {includes = {"fdk-aac/aacdecoder_lib.h"}}))
    end)
