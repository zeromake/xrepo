
local suffixs = {
    ["4.5.0"] = {
        ["macosx"] = {
            ["x86_64"] = "40c303d34a7b00bc2330b77e079d512d04ef82c14ab7800a1e770b73914e4b76",
        },
        ["windows"] = {
            ["x64"] = "f459effe986f4c09f0efa64877a753d44d3b78355c36b5055854a032f543aec5",
        },
        ["linux"] = {
            ["x86_64"] = "3395722e3f8a31ce6a14c75fc419f586a3573b939f85efee5c88cdd35820a240",
        },
    }
}

local urls = {
    ["macosx"] = {
        ["x86_64"] = "https://phoenixnap.dl.sourceforge.net/project/sdcc/sdcc-macos-amd64/$(version)/sdcc-$(version)-x86_64-apple-macosx.tar.bz2?viasf=1",
    },
    ["windows"] = {
        ["x64"] = "https://phoenixnap.dl.sourceforge.net/project/sdcc/sdcc-win64/$(version)/sdcc-$(version)-x64-setup.exe?viasf=1",
    },
    ["linux"] = {
        ["x86_64"] = "https://phoenixnap.dl.sourceforge.net/project/sdcc/sdcc-linux-amd64/$(version)/sdcc-$(version)-amd64-unknown-linux2.5.tar.bz2?viasf=1",
    },
}

package("sdcc")
    set_kind("toolchains")
    set_homepage("https://sdcc.sourceforge.net/")
    set_description("Small Device C Compiler")
    local version = "4.5.0"
    set_urls(urls[os.host()][os.arch()])

    local suffix = suffixs[version][os.host()][os.arch()]
    add_versions(version, suffix)
    on_install(function (package)
        if os.host() == "windows" then
            import("lib.detect.find_tool")
            local p7z = find_tool("7z")
            os.execv(p7z.program, {"x", package:originfile()})
            os.rm(package:originfile())
            os.rm("$PLUGINSDIR")
        end
        os.cp("*", package:installdir())
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrunv("sdcc", {"--version"})
    end)
