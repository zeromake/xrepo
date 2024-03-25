package("iconv")
    set_homepage("https://www.gnu.org/software/libiconv")
    set_description("International text is mostly encoded in Unicode. For historical reasons, however, it is sometimes still encoded using a language or country dependent character encoding.")
    set_license("LGPL")
    set_urls("https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz")

    add_versions("1.17", "8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313")
    
    add_includedirs("include", "include/iconv")
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_%-]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#undef ") then
                    local name = line:split("%s+")[2]
                    line = '${define '..name..'}\n'
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("include/iconv.h.in")
        transforme_configfile("include/iconv.h.build.in")
        transforme_configfile("libcharset/include/libcharset.h.build.in")
        transforme_configfile("libcharset/include/libcharset.h.in")
        transforme_configfile("libcharset/include/localcharset.h.build.in")
        transforme_configfile("libcharset/include/localcharset.h.in")
        transforme_configfile("config.h.in")
        transforme_configfile("libcharset/config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("iconv_open", {includes = {"iconv/iconv.h"}}))
    end)
