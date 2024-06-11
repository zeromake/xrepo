local function getVersion(version)
    local versions = {
        ["2023.12.16-alpha"] = "archive/322826bcee79cb9f288dd229a505d6c46784b047.tar.gz",
        ["2024.04.11-alpha"] = "archive/43836aa3a6226682b594a6ba818baf16c0538b81.tar.gz",
        ["2024.05.28-alpha"] = "archive/bdc7dd2a516b08715a56f8b8eecefe44c9d68f40.tar.gz",
    }
    if versions[tostring(version)] == nil then
        return "archive/refs/tags/v"..tostring(version)..".tar.gz"
    end
    return versions[tostring(version)]
end

package("handmade_math")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/HandmadeMath/HandmadeMath")
    set_description("A simple math library for games and computer graphics. Compatible with both C and C++.")
    set_license("MIT")
    set_urls("https://github.com/HandmadeMath/HandmadeMath/$(version)", {version = getVersion})

    add_versions("2024.05.28-alpha", "9cfe6f14375e284dbaa111650059609053a969767b90cf15ab3bba9495a564e0")
    add_versions("2024.04.11-alpha", "6dacbddf4838d7c809054182d42d2e584719a66ab669b027d7b22b3d18295b93")
    add_versions("2023.12.16-alpha", "3ab66f15970c8161b70958e23478a32ec447db148a446ef71f559b3dbc9f8453")
    add_versions("2.0.0", "3ec811fe2b082d33154e5a69944b47c63111483379f976093a17e773fe01437e")
    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("HMM_ToRad", {includes = {"HandmadeMath.h"}}))
    end)
