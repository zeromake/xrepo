package("msdfgen")
    set_homepage("https://github.com/Chlumsky/msdfgen")
    set_description("Multi-channel signed distance field generator ")
    set_license("MIT")
    set_urls("https://github.com/Chlumsky/msdfgen/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.12", "f058117496097217d12e4ea86adbff8467adaf6f12af793925d243b86b0c4f57")
    add_versions("1.11", "fad74e33274f591e72511bc0546189e7aec439f2a512ef1b2fde243554d457cb")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})
    add_includedirs("include", "include/msdfgen")

    add_deps("tinyxml2", "png", "freetype")
    on_install(function (package)
        io.writefile('msdfgen-config.h.in', [[
#pragma once

${define MSDFGEN_PUBLIC}
${define MSDFGEN_EXT_PUBLIC}

${define MSDFGEN_VERSION}
${define MSDFGEN_VERSION_MAJOR}
${define MSDFGEN_VERSION_MINOR}
${define MSDFGEN_VERSION_REVISION}
${define MSDFGEN_COPYRIGHT_YEAR}
${define MSDFGEN_USE_CPP11}
${define MSDFGEN_USE_OPENMP}
${define MSDFGEN_USE_LIBPNG}
${define MSDFGEN_USE_TINYXML2}
${define MSDFGEN_EXTENSIONS}
]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            cli = package:config("cli") and 'y' or 'n'
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
