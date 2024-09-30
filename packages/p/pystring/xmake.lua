local function getVersion(version)
    local versions ={
        ["2020.02.04-alpha"] = "archive/281419de2f91f9e0f2df6acddfea3b06a43436be.tar.gz",
        ["2022.09.27-alpha"] = "archive/7d16bc814ccb4cad03c300dcb77440034caa84f7.tar.gz",
        ["2023.07.23-alpha"] = "archive/76a2024e132bcc83bec1ecfebeacd5d20d490bfe.tar.gz",
        ["2024.08.18-alpha"] = "archive/c5ca4f569d7d99ed42dfc54130f9cabd183ec657.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("pystring")
    set_homepage("https://github.com/imageworks/pystring")
    set_description("Pystring is a collection of C++ functions which match the interface and behavior of python's string class methods using std::string.")
    set_urls("https://github.com/imageworks/pystring/$(version)", {
        version = getVersion,
    })
    --insert version
    add_versions("2024.08.18-alpha", "3ccb200de50edbdcf32881db05c756ffa7a261cddaa387b0be0571453c2ed2af")
    add_versions("2023.07.23-alpha", "40a694bb42b41e245ff68712db59b67fcd59091cb7cb933c0873c20a75354f9d")
    add_versions("2020.02.04-alpha", "46161e75f85a3e8867233aebb6f4399f405c565db76dc07731a7ef662459609d")
    add_versions("2022.09.27-alpha", "4f38af53aebc35924699aa41482a44a31aa52e4c6f921acee37a52ebea7333d4")

    add_includedirs("include")
    add_includedirs("include/pystring")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

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
