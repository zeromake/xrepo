local options = {}

local function getVersion(version) 
    return 'libunibreak_'..tostring(version):gsub('%.', '_')..'/libunibreak-'..tostring(version)..'.tar.gz'
end

package("unibreak")
    set_homepage("https://github.com/adah1972/libunibreak")
    set_description("The Unicode breaking library")
    set_license("zlib")
    set_urls("https://github.com/adah1972/libunibreak/releases/download/$(version)", {
        version = getVersion
    })

    add_versions("6.1", "cc4de0099cf7ff05005ceabff4afed4c582a736abc38033e70fdac86335ce93f")
    add_versions("6.0", "f189daa18ead6312c5db6ed3d0c76799135910ed6c06637c7eea20a7e5e7cc7f")
    add_versions("5.0", "58f2fe4f9d9fc8277eb324075ba603479fa847a99a4b134ccb305ca42adf7158")

    add_includedirs("include")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("init_linebreak()", {includes = "linebreak.h"}))
    end)
