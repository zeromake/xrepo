local function getVersion(version)
    local versions ={
        ["2024.07.10-alpha"] = "archive/7b20c1936229370277d1c61bde950bce194de584.tar.gz",
        ["2024.09.10-alpha"] = "archive/1eb96dd0f96b9ea73065f9078244c2255c2b75d9.tar.gz",
        ["2024.09.15-alpha"] = "archive/f62817137961a1eedc3eac03f62012795d2c79c4.tar.gz",
        --insert getVersion
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

    --insert version
    add_versions("2024.09.15-alpha", "020a4ddc698ce25e00d67057d164142eb1837bb5337967b87be22131768c565f")
    add_versions("2024.09.10-alpha", "ea46acebdd11f84489654632ac441efd23bd31d6b18ca8e4dab48bd613a77028")
    add_versions("2024.07.10-alpha", "e157aab728f7f32c70254c2f9df21f8428e794769081d2758bb8c3dcfdaa8a4f")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
