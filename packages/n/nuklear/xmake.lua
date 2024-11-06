local function getVersion(version)
    local versions ={
        ["2024.07.23-alpha"] = "archive/2795d907078cfacd08695f6e1ad3f9c6e34b13f5.tar.gz",
        ["2024.09.08-alpha"] = "archive/18f7e7a948546ff36c3bfafa854b6a9cae1c6096.tar.gz",
        ["2024.09.14-alpha"] = "archive/4ffef5eb11b2f7a283bb63832884d0ea66e98705.tar.gz",
        ["2024.09.29-alpha"] = "archive/fa9f257c7b2b1c434fa03a99dac02ef760c56d14.tar.gz",
        ["2024.09.30-alpha"] = "archive/2ad47c08f104ab33d832307293df0b0910ce0791.tar.gz",
        ["2024.10.03-alpha"] = "archive/03198a016bc895f66c8b4b2811e0380f6ff4558f.tar.gz",
        ["2024.10.19-alpha"] = "archive/6566d9075d5fed48af014c93f87c4aed8c4bd21c.tar.gz",
        ["2024.11.05-alpha"] = "archive/985ddcbccb7b716b9318183b1dc8bec11df447ce.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("nuklear")
    set_kind("library", {headeronly = true})
    set_homepage("https://immediate-mode-ui.github.io/Nuklear/doc/index.html")
    set_description("A single-header ANSI C immediate mode cross-platform GUI library")
    set_license("MIT")
    set_urls("https://github.com/Immediate-Mode-UI/Nuklear/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.11.05-alpha", "2075f9385d9fd3c92f70c5388a7815532d8a35bd41a7e91f3f26f7487b178d06")
    add_versions("2024.10.19-alpha", "ca9d537cd0232a4c8ab58e1220e68972f906b314ac5de7b79e354f10859d9acf")
    add_versions("2024.10.03-alpha", "78c8f8876007f57f27841b1d56e7f10aa682b95609a0f73db672294c73c4f8d4")
    add_versions("2024.09.30-alpha", "a9d03859cb470be9b1ed4f0923274aa1ca989b7ee937bdb66eddf57d32d56f0c")
    add_versions("2024.09.29-alpha", "672f9fabd4d17047e99dbd27448ff19aad8c6dc97ef9c519da1fe61561942b77")
    add_versions("2024.09.14-alpha", "917f5ff902e21a0471a41973459397bc7242793f74bcf516efb691248b6e6028")
    add_versions("2024.09.08-alpha", "f7de0f5befbd5b0471a1aaf79a3a3720c0db7834a058fd1a054339f0a1f14e09")
    add_versions("2024.07.23-alpha", "da7d4e53a071e6f0afe1c304484ddc6152bee88e1fc732234020ac3699126a4d")
    add_versions("4.12.0", "4cb80084d20d20561548a2941b6d1eb7c30e6f0b9405e0d5df84bae3c1d7bbaf")
    on_install(function (package)
        os.cp("./nuklear.h", package:installdir("include/nuklear"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
