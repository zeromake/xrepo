local function getVersion(version)
    local versions ={
        ["2024.08.26-alpha"] = "archive/3abe2707606ee66e43cbc78c970a753dbfc4986c.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("fdk-aac")
    set_homepage("https://github.com/zeromake/fdk-aac")
    set_description("A standalone library of the Fraunhofer FDK AAC code from Android.")
    set_license("MIT")
    set_urls("https://github.com/zeromake/fdk-acc/$(version)", {version = getVersion})

    --insert version
    add_versions("2024.08.26-alpha", "67ce3b8dee444990e6494a2711c4b3a552fe53e21f2ef6a51ffd3877a70f29f4")
    add_patches("2024.08.26-alpha", path.join(os.scriptdir(), "patches/fix.patch"), "9deea84d11cd43b27b4db1c453c5fd5cbfd606b3020000b6d39131fc9773964b")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("aacDecoder_Open", {includes = {"fdk-aac/aacdecoder_lib.h"}}))
    end)
