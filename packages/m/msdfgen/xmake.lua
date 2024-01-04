package("msdfgen")
    set_homepage("https://github.com/Chlumsky/msdfgen")
    set_description("Multi-channel signed distance field generator ")
    set_license("MIT")
    set_urls("https://github.com/Chlumsky/msdfgen/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.11", "fad74e33274f591e72511bc0546189e7aec439f2a512ef1b2fde243554d457cb")
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
]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
