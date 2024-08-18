local function getVersion(version)
    local versions ={
        ["2024.06.17-alpha"] = "archive/c970b0bb0768724f5be2ee7ee36bc07b01fc6a62.tar.gz",
        ["2024.07.02-alpha"] = "archive/78f07444c249deb47c7e6279b556c9dcf94d1cc7.tar.gz",
        ["2024.07.10-alpha"] = "archive/7b20c1936229370277d1c61bde950bce194de584.tar.gz",
    }
    return versions[tostring(version)]
end

package("sokol")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/floooh/sokol")
    set_description("Simple STB-style cross-platform libraries for C and C++, written in C.")
    set_license("zlib")

    set_urls("https://github.com/floooh/sokol/$(version)", {
        version = getVersion
    })

    add_versions("2024.07.10-alpha", "e157aab728f7f32c70254c2f9df21f8428e794769081d2758bb8c3dcfdaa8a4f")
    add_versions("2024.07.02-alpha", "7cd4561c85c2d0f50b09006934d2cf2e5533d81e9e5f4922caedc23aa9717a8d")
    add_versions("2024.06.17-alpha", "de9c9c1263521927db4d2463dc1ff5ff0100b4a6e8fe60ce32a726a4af5d14f1")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
