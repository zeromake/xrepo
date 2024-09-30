local options = {}

package("fribidi")
    set_homepage("https://github.com/fribidi/fribidi")
    set_description("GNU FriBidi")
    set_license("MIT")
    set_urls("https://github.com/fribidi/fribidi/releases/download/v$(version)/fribidi-$(version).tar.xz")

    --insert version
    add_versions("1.0.16", "1b1cde5b235d40479e91be2f0e88a309e3214c8ab470ec8a2744d82a5a9ea05c")
    add_versions("1.0.15", "0bbc7ff633bfa208ae32d7e369cf5a7d20d5d2557a0b067c9aa98bcbf9967587")
    add_versions("1.0.14", "76ae204a7027652ac3981b9fa5817c083ba23114340284c58e756b259cd2259a")
    add_versions("1.0.13", "7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2")
    add_versions("1.0.12", "0cd233f97fc8c67bb3ac27ce8440def5d3ffacf516765b91c2cc654498293495")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include", "include/fribidi")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
        if package:config("shared") ~= true then
            package:add("defines", "FRIBIDI_LIB_STATIC")
        end
    end)

    add_defines(
        "FRIBIDI_BUILD",
        "HAVE_CONFIG_H"
    )

    on_install(function (package)
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
#define PACKAGE_STRING "GNU FriBidi 1.0.13"
#define PACKAGE_TARNAME "fribidi"
#define PACKAGE_URL "http://fribidi.org/"
#define PACKAGE_VERSION "1.0.13"

#define RETSIGTYPE void

${define SIZEOF_INT}
${define SIZEOF_SHORT}
${define SIZEOF_VOID_P}
${define SIZEOF_WCHAR_T}

#define STDC_HEADERS 1
]], {encoding = "binary"})
        io.writefile("fribidi-config.h.in", [[
#ifndef FRIBIDI_CONFIG_H
#define FRIBIDI_CONFIG_H

#define FRIBIDI "fribidi"
#define FRIBIDI_NAME "GNU FriBidi"
#define FRIBIDI_BUGREPORT "https://github.com/fribidi/fribidi/issues/new"
#define FRIBIDI_VERSION "1.0.13"
#define FRIBIDI_MAJOR_VERSION 1
#define FRIBIDI_MINOR_VERSION 0
#define FRIBIDI_MICRO_VERSION 13
#define FRIBIDI_INTERFACE_VERSION 4
#define FRIBIDI_INTERFACE_VERSION_STRING "4"

${define FRIBIDI_SIZEOF_INT}

#endif /* FRIBIDI_CONFIG_H */
]], {encoding = "binary"})
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("fribidi_log2vis", {includes = {"fribidi/fribidi.h"}}))
    end)
