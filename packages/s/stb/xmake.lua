
local function getVersion(version)
    local versions = {
        ['2023.10.12-alpha'] = 'archive/beebb24b945efdea3b9bba23affb8eb3ba8982e7.tar.gz',
        ['2024.02.13-alpha'] = 'archive/ae721c50eaf761660b4f90cc590453cdb0c2acd0.tar.gz',
        ["2024.05.31-alpha"] = "archive/013ac3beddff3dbffafd5177e7972067cd2b5083.tar.gz",
        ["2024.07.29-alpha"] = "archive/f75e8d1cad7d90d72ef7a4661f1b994ef78b4e31.tar.gz",
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
    add_versions("2024.07.29-alpha", "bc6ccf08bec08fea8ef423c7117dca06d2f62d2b27c5485f6865584b533fa7fa")
    add_versions("2024.05.31-alpha", "b01aa93e1a968aed55f43e072c98ee401d2f20e897aabdb1a166c7166886ed11")
    add_versions("2024.02.13-alpha", "cd82be3ddc4146ef738f80a794a83f2ed45faab1c5b23278121788ef7b598e89")
    add_versions("2023.10.12-alpha", "2fb3c1bb1d796f159c08ae7bfc230f7b257fcacbd393fa67ad0f66f32070f741")
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
