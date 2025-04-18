package("tinyxml2")
    set_homepage("http://www.grinninglizard.com/tinyxml2/")
    set_description("simple, small, efficient, C++ XML parser that can be easily integrating into other programs.")
    set_urls("https://github.com/leethomason/tinyxml2/archive/$(version).tar.gz")

    --insert version
    add_versions("11.0.0", "5556deb5081fb246ee92afae73efd943c889cef0cafea92b0b82422d6a18f289")
    add_versions("10.0.0", "3bdf15128ba16686e69bce256cc468e76c7b94ff2c7f391cc5ec09e40bff3839")
    add_versions("9.0.0", "cc2f1417c308b1f6acc54f88eb70771a0bf65f76282ce5c40e54cfe52952702c")
    add_versions("8.0.0", "6ce574fbb46751842d23089485ae73d3db12c1b6639cda7721bf3a7ee862012c")

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("tinyxml2")
    set_kind("$(kind)")
    set_languages("cxx11")
    add_headerfiles("tinyxml2.h")
    add_files("tinyxml2.cpp")
]], {encoding = "binary"})
        local configs = {}
        if package:config("shared") then
            configs["kind"] = "shared"
        else
            configs["kind"] = "static"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test(int argc, char** argv) {
                static const char* xml = "<element/>";
                tinyxml2::XMLDocument doc;
                doc.Parse(xml);
            }
        ]]}, {configs = {languages = "c++11"}, includes = "tinyxml2.h"}))
    end)
