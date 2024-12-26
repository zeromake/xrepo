local function getVersion(version)
    return tostring(version):gsub("%.", "")
end
package("scintilla")
    set_homepage("https://www.scintilla.org")
    set_description("Scintilla is a free source code editing component. It comes with complete source code and a license that permits use in any free project or commercial product.")
    set_license("MIT")
    set_urls("https://www.scintilla.org/scintilla$(version).tgz", {
        version = getVersion
    })

    --insert version
    add_versions("5.5.4", "7994a854a3012269f35ecc2cb725b8f7e209e410dc96fe141c9a15ccfebd41fc")
    add_versions("5.5.3", "a723be93a541fbdc4919e49ed29080c2a5124f6306d335aa720ca4234ce4b414")
    add_versions("5.5.0", "e553e95509f01f92aa157fa02d06a712642e13d69a11ec1a02a7ddf22c406231")

    add_configs("module", {default = nil, type = "string"})
    
    on_load(function (package)
        if package:config("module") == "win32" then
            package:add(
                "syslinks",
                "ole32",
                "gdi32",
                "oleaut32",
                "user32",
                "advapi32",
                "imm32"
            )
        end
    end)
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

option("module")
    set_default(nil)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("scintilla")
    set_kind("$(kind)")
    add_files("src/*.cxx", "call/*.cxx")
    add_includedirs("include", "src")
    add_headerfiles("include/*.h")
    set_languages("c++17")
    local module = get_config("module")
    if module == "win32" then
        add_files("win32/*.cxx")
        add_syslinks(
            "ole32",
            "gdi32",
            "oleaut32",
            "user32",
            "advapi32",
            "imm32"
        )
    elseif module == "qt" then
        add_files("qt/ScintillaEdit/*.cpp")
        add_files("qt/ScintillaEditBase/*.cpp")
    elseif module == "gtk" then
        add_files("gtk/*.cxx")
    elseif module == "cocoa" then
        add_files("cocoa/*.mm")
    end
]], {encoding = "binary"})
        local configs = {}
        if package:config("module") then
            table.insert(configs, "--module=" .. package:config("module"))
        end
        import("package.tools.xmake").install(package, configs)
    end)
