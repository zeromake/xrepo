package("jinja2cpp")
    set_homepage("https://jinja2cpp.github.io")
    set_description("Jinja2 C++ (and for C++) almost full-conformance template engine implementation")
    set_license("MIT")
    set_urls("https://github.com/jinja2cpp/Jinja2Cpp/archive/refs/tags/$(version).tar.gz")

    add_versions("1.3.1", "3188b95127b4cd628fa33430704fd8e07b3c311202ed51b9e2796b0f99342037")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
