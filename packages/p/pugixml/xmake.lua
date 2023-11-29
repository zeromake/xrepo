local options = {
    "wchar",
    "compact",
    "no_xpath",
    "no_stl",
    "no_exceptions"
}

package("pugixml")
    set_homepage("https://pugixml.org/")
    set_description("Light-weight, simple and fast XML parser for C++ with XPath support")
    set_license("MIT")
    set_urls("https://github.com/zeux/pugixml/releases/download/v$(version)/pugixml-$(version).tar.gz")
    
    add_configs('kind', {description = "static|shared|headeronly", default = "static", type = "string"})
    add_configs('wchar', {description = "Enable wchar_t mode", default = false, type = "boolean"})
    add_configs('compact', {description = "Enable compact mode", default = false, type = "boolean"})
    add_configs('no_xpath', {description = "Disable XPath", default = false, type = "boolean"})
    add_configs('no_stl', {description = "Disable STL", default = false, type = "boolean"})
    add_configs('no_exceptions', {description = "Disable Exceptions", default = false, type = "boolean"})

    add_versions("1.14", "2f10e276870c64b1db6809050a75e11a897a8d7456c4be5c6b2e35a11168a015")
    add_versions("1.13", "40c0b3914ec131485640fa57e55bf1136446026b41db91c1bef678186a12abbe")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for _, config in ipairs(options) do
            configs[config] = package:config(config) and "y" or 'n'
        end
        configs["kind"] = package:config("kind")
        io.writefile("pugiconfig.hpp.in", [[
#ifndef HEADER_PUGICONFIG_HPP
#define HEADER_PUGICONFIG_HPP

${define PUGIXML_WCHAR_MODE}
${define PUGIXML_COMPACT}
${define PUGIXML_NO_XPATH}
${define PUGIXML_NO_STL}
${define PUGIXML_NO_EXCEPTIONS}

${define PUGIXML_API}
${define PUGIXML_CLASS}
${define PUGIXML_FUNCTION}

${define PUGIXML_MEMORY_PAGE_SIZE}
${define PUGIXML_MEMORY_OUTPUT_STACK}
${define PUGIXML_MEMORY_XPATH_PAGE_SIZE}

${define PUGIXML_HEADER_ONLY}
${define PUGIXML_HAS_LONG_LONG}
#endif
]], {encoding = "binary"})
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
#include <pugixml.hpp>

static void test() {
    pugi::xml_document doc;
    doc.load_file("xxx.xml");
}
]]}))
    end)
