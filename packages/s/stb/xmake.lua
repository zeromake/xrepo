
local function getVersion(version)
    local versions = {
        ["2024.07.29-alpha"] = "archive/f75e8d1cad7d90d72ef7a4661f1b994ef78b4e31.tar.gz",
        ["2024.10.02-alpha"] = "archive/31707d14fdb75da66b3eed52a2236a70af0d0960.tar.gz",
        ["2024.10.18-alpha"] = "archive/2e2bef463a5b53ddf8bb788e25da6b8506314c08.tar.gz",
        ["2024.11.09-alpha"] = "archive/5c205738c191bcb0abc65c4febfa9bd25ff35234.tar.gz",
        ["2025.03.14-alpha"] = "archive/f0569113c93ad095470c54bf34a17b36646bbbb5.tar.gz",
        ["2025.05.12-alpha"] = "archive/802cd454f25469d3123e678af41364153c132c2a.tar.gz",
        ["2025.05.26-alpha"] = "archive/f58f558c120e9b32c217290b80bad1a0729fbb2c.tar.gz",
        ["2025.10.25-alpha"] = "archive/f1c79c02822848a9bed4315b12c8c8f3761e1296.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("stb")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/nothings/stb")
    set_description("single-file public domain (or MIT licensed) libraries for C/C++")

    set_urls("https://github.com/nothings/stb/$(version)",{
        version = getVersion
    })
    --insert version
    add_versions("2025.10.25-alpha", "a39b0f2d96d9b64171ac1fd73295b7c5866f904e653b379da886d050a6900db9")
    add_versions("2025.05.26-alpha", "be1a5dad9ac38f42ef8abf00bd7db776101661b77603f832fcc0bae843d82846")
    add_versions("2025.05.12-alpha", "d7f870bbe53a4171d5d5526043926b2f26194e6b08de63fc3f1cf4b54e5d5249")
    add_versions("2025.03.14-alpha", "4d05c96640ae3a8cbdafdad8d344b50ce610802f78aee80154acdb8e266282e0")
    add_versions("2024.11.09-alpha", "cfeab9f800961882d6d22ddf36e965523b33002f4f937de08321304c9ba72af3")
    add_versions("2024.10.18-alpha", "4dc2ffa6c6c8d8a830e92fcdb97f8981701c229655df7d60e6fc0ff4e6b4bf66")
    add_versions("2024.10.02-alpha", "c0e74a95c942c47d746d7c2a5e9df96cc0a56d1f967dfe268f48c7f9367a419f")
    add_versions("2024.07.29-alpha", "bc6ccf08bec08fea8ef423c7117dca06d2f62d2b27c5485f6865584b533fa7fa")
    add_includedirs("include", "include/stb")

    on_install(function (package)
        os.cp("*.h", package:installdir("include/stb"))
        os.cp("*.c", package:installdir("include/stb"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("stbi_load_from_memory", {includes = "stb/stb_image.h"}))
        if package:version():gt("2019.02.07") then
            assert(package:has_cfuncs("stb_include_string", {includes = "stb/stb_include.h"}))
        end
    end)
