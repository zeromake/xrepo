local function getVersion(version)
    local versions ={
        ["2024.11.26-alpha"] = "archive/31c580725bcdf3884a3035f33bd84a722c94c26b.tar.gz",
        ["2024.11.30-alpha"] = "archive/2d3a10bb98db906b78852f9af0290a96f98c0c4d.tar.gz",
        ["2024.12.11-alpha"] = "archive/369d038990265bccf6fda83d80cdf67327d6acf0.tar.gz",
        ["2024.12.27-alpha"] = "archive/7f406eea126506925d012fb3c1d9b9a9002a99e4.tar.gz",
        ["2025.02.08-alpha"] = "archive/56ff40609d8c33feacc2c24fea5a3159a0df9ce1.tar.gz",
        ["2025.03.04-alpha"] = "archive/7408af0b8214fbef730d6c2c65537e3f23bfe1a2.tar.gz",
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
    add_versions("2025.03.04-alpha", "afa051cca06dc6bd7dfda5e4a7db252274faf9f885af5172a664d53e53163c70")
    add_versions("2025.02.08-alpha", "bdd7262bc6c7c938d618df5fe92038d854af500f3d846414c230626620e5d2bf")
    add_versions("2024.12.27-alpha", "90680a7e6889bc11d18352400b3327056a16e4378360ff295208370e18e9b9a8")
    add_versions("2024.12.11-alpha", "94a150e1f89f2b6327e2eef31785da93ed63358b9a50ace7c818267515085dee")
    add_versions("2024.11.30-alpha", "4e845369a89ce33d067bc7939f85f8f2e1ed7550861d5db7f460c94b8d4e9f86")
    add_versions("2024.11.26-alpha", "f83e0a97809007ea032f64671678a08357d7cc928319ad96ac5cd4ce7ad891f4")
    add_versions("4.12.4", "d698f78a44722fbc8617e6c749197d2b9d5f44b1a5adf3467ccbd8f9aa001411")
    add_versions("4.12.3", "93d32d02ac5c5b17ecc243bb6436da3dc79e656eaa9046e053b8a922e1ee1ad3")
    add_versions("4.12.2", "a705e626a7190722fc5bd3b298e0be35b3d3d92eccf017660ef251cab29fcc94")
    add_versions("4.12.0", "4cb80084d20d20561548a2941b6d1eb7c30e6f0b9405e0d5df84bae3c1d7bbaf")
    on_install(function (package)
        os.cp("./nuklear.h", package:installdir("include/nuklear"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
