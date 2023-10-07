

package("raqm")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/HOST-Oman/libraqm/releases/download/v$(version)/raqm-$(version).tar.xz")

    add_versions("0.10.1", "4d76a358358d67c5945684f2f10b3b08fb80e924371bf3ebf8b15cd2e321d05d")
    add_versions("0.9.0", "9ed6fdf41da6391fc9bf7038662cbe412c330aa6eb22b19704af2258e448107c")

    add_includedirs("include")

    add_deps("freetype", "harfbuzz", "fribidi")

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("config.h.in", [[
${define RAQM_API}
${define RAQM_SHEENBIDI}
]])
        local version = package:version()
        local versionFile = io.open("raqm-version.h.in", "w")
        versionFile:write([[
#ifndef _RAQM_H_IN_
#error "Include <raqm.h> instead."
#endif

#ifndef _RAQM_VERSION_H_
#define _RAQM_VERSION_H_
]])

        versionFile:writef("#define RAQM_VERSION_MAJOR %d\n", version:major())
        versionFile:writef("#define RAQM_VERSION_MINOR %d\n", version:minor())
        versionFile:writef("#define RAQM_VERSION_MICRO %d\n", version:patch())
        versionFile:writef("#define RAQM_VERSION_STRING \"%s\"\n", package:version_str())
        versionFile:write([[
#define RAQM_VERSION_ATLEAST(major,minor,micro) \
	((major)*10000+(minor)*100+(micro) <= \
	 RAQM_VERSION_MAJOR*10000+RAQM_VERSION_MINOR*100+RAQM_VERSION_MICRO)

#endif /* _RAQM_VERSION_H_ */
]])
        versionFile:close()
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    -- end)
