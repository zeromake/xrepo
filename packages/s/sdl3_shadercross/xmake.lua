local function getVersion(version)
    local versions ={
        ["2025.02.25-alpha"] = "archive/e1000de7d174af8f84935db9a59b365d1ae55d32.tar.gz",
        ["2025.03.05-alpha"] = "archive/db758697661c59718ae02786d667d24f94d3c88b.tar.gz",
        ["2025.03.10-alpha"] = "archive/63026450dedbf7d8aeee99d9086719f425b2bb4d.tar.gz",
        ["2025.04.07-alpha"] = "archive/3e4431a44027057fae06cecdc6819d5251896ea7.tar.gz",
        ["2025.04.18-alpha"] = "archive/378f742d3023f6be7d9278908d0e47bf33fac361.tar.gz",
        ["2025.05.06-alpha"] = "archive/a3aad1ced336ae18f0efc00fd48568f1954775f4.tar.gz",
        ["2025.08.25-alpha"] = "archive/4ce748310f57d405b4eb2a79fbbc7e974d6491ec.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("sdl3_shadercross")
    set_kind("binary")
    set_homepage("https://github.com/libsdl-org/SDL_shadercross")
    set_description("Shader translation library for SDL's GPU API. ")
    set_license("Zlib")
    set_urls("https://github.com/libsdl-org/SDL_shadercross/$(version)", {
        version = getVersion
    })
    --insert version
    add_versions("2025.08.25-alpha", "204897a5c4dba7bd3c9addf1a57f25fde42a7a63a84d73b8dce5ef82028a374d")
    add_versions("2025.05.06-alpha", "2427be9f9b2592151330469bb45067940ee058e4e9346d709edee26e2e11dc74")
    add_versions("2025.04.18-alpha", "0bc32ecb5ac9cff56048222943e0e4a9e9b36341c3466c777a132221d7c1c4e3")
    add_versions("2025.04.07-alpha", "996e31dba002bd74f1f6e7feea181ca6f6c6639d669c2214cc7c5f0661ad3fea")
    add_versions("2025.03.10-alpha", "6c7cddf99dc0dee5dbe4a50aac1c3e8c492072d69e3ca7f8ae7544867896e8ad")
    add_versions("2025.03.05-alpha", "e7069ac732a9a22fa70cd29689d93d5743e50751094c471f30a9cf5f4a7c55b6")
    add_versions("2025.02.25-alpha", "85d355fcb4414c343817675be821112bbbab6720dac717b433346796c1b5c007")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        os.cp("export_shared/*", package:installdir("bin"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
