local function getVersion(version)
    local versions ={
        ["2020.02.04-alpha"] = "archive/281419de2f91f9e0f2df6acddfea3b06a43436be.tar.gz",
        ["2022.09.27-alpha"] = "archive/7d16bc814ccb4cad03c300dcb77440034caa84f7.tar.gz",
    }
    return versions[tostring(version)]
end


package("pystring")
    set_homepage("https://github.com/imageworks/pystring")
    set_description("Pystring is a collection of C++ functions which match the interface and behavior of python's string class methods using std::string.")
    set_urls("https://github.com/imageworks/pystring/$(version)", {
        version = getVersion,
    })
    add_versions("2020.02.04-alpha", "46161e75f85a3e8867233aebb6f4399f405c565db76dc07731a7ef662459609d")
    add_versions("2022.09.27-alpha", "4f38af53aebc35924699aa41482a44a31aa52e4c6f921acee37a52ebea7333d4")
    add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

    add_includedirs("include")
    add_includedirs("include/pystring")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("pystring")
    set_kind("static")
    add_files("pystring.cpp")
    add_headerfiles("pystring.h", {prefixdir = "pystring"})
]], {encoding = "binary"})
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                bool res = pystring::endswith("abcdef", "cdef");
            }
        ]]}, {configs = {languages = "c++20"}, includes = "pystring/pystring.h"}))
    end)
