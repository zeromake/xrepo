local options = {}

package("fribidi")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/fribidi/fribidi/releases/download/v$(version)/fribidi-$(version).tar.xz")
    
    add_versions("1.0.12", "0cd233f97fc8c67bb3ac27ce8440def5d3ffacf516765b91c2cc654498293495")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    add_defines(
        "FRIBIDI_BUILD",
        "HAVE_CONFIG_H"
    )

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("config.h.in", [[
${define HAVE_ASM_PAGE_H}
${define HAVE_DLFCN_H}
${define HAVE_INTTYPES_H}
${define HAVE_MEMORY_H}
${define HAVE_STDINT_H}
${define HAVE_STDLIB_H}
${define HAVE_STRING_H}
${define HAVE_STRINGS_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TIMES_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_UNISTD_H}
${define HAVE_WCHAR_H}

${define HAVE_MEMMOVE}
${define HAVE_MEMSET}
${define HAVE_STRDUP}

${define HAVE_STRINGIZE}

#define PACKAGE_BUGREPORT "https://github.com/fribidi/fribidi/issues/new"
#define PACKAGE_NAME "GNU FriBidi"
#define PACKAGE_STRING "GNU FriBidi 1.0.12"
#define PACKAGE_TARNAME "fribidi"
#define PACKAGE_URL "http://fribidi.org/"
#define PACKAGE_VERSION "1.0.12"

#define RETSIGTYPE void

${define SIZEOF_INT}
${define SIZEOF_SHORT}
${define SIZEOF_VOID_P}
${define SIZEOF_WCHAR_T}

#define STDC_HEADERS 1
]])
        io.writefile("fribidi-config.h.in", [[
#ifndef FRIBIDI_CONFIG_H
#define FRIBIDI_CONFIG_H

#define FRIBIDI "fribidi"
#define FRIBIDI_NAME "GNU FriBidi"
#define FRIBIDI_BUGREPORT "https://github.com/fribidi/fribidi/issues/new"
#define FRIBIDI_VERSION "1.0.12"
#define FRIBIDI_MAJOR_VERSION 1
#define FRIBIDI_MINOR_VERSION 0
#define FRIBIDI_MICRO_VERSION 12
#define FRIBIDI_INTERFACE_VERSION 4
#define FRIBIDI_INTERFACE_VERSION_STRING "4"

${define FRIBIDI_SIZEOF_INT}

#endif /* FRIBIDI_CONFIG_H */
        ]])
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("fribidi_log2vis", {includes = {"fribidi/fribidi.h"}}))
    end)
