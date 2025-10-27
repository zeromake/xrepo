local function getVersion(version)
    local versions ={
        ["2024.10.23-alpha"] = "archive/c25638026fc2fa23331ceae10cff056048b57db6.tar.gz",
        ["2024.10.27-alpha"] = "archive/76ded2def8d9914c1c7e1e6e7bdd8970c7b6e7c4.tar.gz",
        ["2024.11.15-alpha"] = "archive/2c6fc7470e9b9121a178e6e68c55f2f06fac4647.tar.gz",
        ["2024.11.23-alpha"] = "archive/eaa1ca79a4004750e58cb51e0100d27f23e3e1ff.tar.gz",
        ["2024.12.17-alpha"] = "archive/789d97071d17cbab4e3835a0b0b8b379e98c114f.tar.gz",
        ["2024.12.29-alpha"] = "archive/c1cc713a48669fb78c8fadc1a3cb9dd6c3bb97d3.tar.gz",
        ["2025.02.11-alpha"] = "archive/b0aa42fa061759908a6c68029703e0988a854b53.tar.gz",
        ["2025.02.23-alpha"] = "archive/123f30c5166f65844a201246d244bda83ddf5f69.tar.gz",
        ["2025.03.15-alpha"] = "archive/46d3c53d2485ce2eee67287931ff4a5c1d4c3563.tar.gz",
        ["2025.04.05-alpha"] = "archive/da9de496f938b7575eff7f01ab774d77469bd390.tar.gz",
        ["2025.04.22-alpha"] = "archive/41247ec237c1eebab46630caaadaf080ba1914a4.tar.gz",
        ["2025.05.11-alpha"] = "archive/202f41b1ce892e1a3fcd25b5c9497a5871ac57a3.tar.gz",
        ["2025.08.29-alpha"] = "archive/42640f062344e1df3b2b32d570e88be9bdf05757.tar.gz",
        ["2025.10.27-alpha"] = "archive/4f2386121c103eaf85960322872ea31c9120b85e.tar.gz",
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
    add_versions("2025.10.27-alpha", "2f908dd10cba3c1d0d40a434e8c3957f7eaccefdf8183ff2665eea03f6d47776")
    add_versions("2025.08.29-alpha", "3b23be965dcc6df97e6d689ff34be42d159cfe43f6779f4c8c52c1cda3de28a3")
    add_versions("2025.05.11-alpha", "0f335e55e5fdbc40ad10de9f920ae361e51d7c1eacb25c94a8660f9c8929dbd4")
    add_versions("2025.04.22-alpha", "372e34d309ba6c84119200fc77eb8a66638deeb4401d51be2a43b4e89b35d496")
    add_versions("2025.04.05-alpha", "7e8a0685b340628d0a3031b970ed77de0b2f6c542e14bedf0eb31ad3ef4aaf14")
    add_versions("2025.03.15-alpha", "506fe5599ab735dd8b4c6d1e5b06d53a24fd8f82b02872553cbe5430a65f64d6")
    add_versions("2025.02.23-alpha", "07bb88c2b086c58a7dcbc148167f013e6c0cf5259811741117d5e94f305d7500")
    add_versions("2025.02.11-alpha", "1f8ebef267a55e0db3ff95eb5b1162581927331a7930bc3ea90199b1373e9e3c")
    add_versions("2024.12.29-alpha", "70cc76ba99feac86a71bc5eb44b49b416a3c000ce676450d44bf8fa632514caf")
    add_versions("2024.12.17-alpha", "c67781879f4115587ecc1b31b1bc1e967d0d27f33266dc4d26ba077a51c1ad5c")
    add_versions("2024.11.23-alpha", "3e16252da1cc26ae2784b7ebd945dc70e8227bf986de2764b06ceddbe0bb7873")
    add_versions("2024.11.15-alpha", "e65fa0c8450def026cc44c05891bde76258fa99b79f342775377b937e88a9a68")
    add_versions("2024.10.27-alpha", "63c723f1573673541a9124e8c7e8c448cd42f220321d45ef087c6f3f2c53eb5a")
    add_versions("2024.10.23-alpha", "ad9fda561c017d4547cbc9ebdc3f9c1b661fa5f619b81e5b0887d5ee350c7525")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
