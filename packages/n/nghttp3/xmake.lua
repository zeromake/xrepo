package("nghttp3")
    set_homepage("https://nghttp2.org/nghttp3")
    set_description("HTTP/3 library written in C")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/nghttp3/releases/download/v$(version)/nghttp3-$(version).tar.gz")

    --insert version
    add_versions("1.12.0", "6bb92a886f57951ba836224f7c44c9e3b0bf527c3237601c265b1d355f6b6979")
    add_versions("1.11.0", "3cd20bda2a2de87b3715724a0c1633156b9926e93935a7f24a5daa7b0504ba11")
    add_versions("1.9.0", "dbc7ad9e5dfa4788439e1e5fe072345fe2a48f68516374937be95c6a893451bd")
    add_versions("1.8.0", "fb07eb37865a1ca7a608eae77034ffcbd91f4f4b4e50a6fcc1b8d9b056c4f63e")
    add_versions("1.7.0", "79a546ec23263b66f22dfcfce180eb51a7b09bb262afca0973f6e479884d3b26")
    add_versions("1.6.0", "a1f92f113c10faca2014b004eb97be363674e23546eb72591c1ac3533f93cba0")
    add_versions("1.5.0", "13d68a48867d2eb0679b81e2e6e065de074abc64246fb11417c3e40988e5ff23")
    add_versions("1.4.0", "43a78073b103acd4668c8d3314eb98e5d002095c1e49014e48ca20bd3094408f")
    add_versions("1.3.0", "2c1a40f770bee2ca2b0c7afc58f763f09f73715238a68d4f8e3c81d1dc1f277d")
    add_versions("1.2.0", "0cc9b943f61a135e08b80bdcc4c1181f695df18fbb5fa93509a58d7d971dca75")
    add_deps("sfparse")
    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "NGHTTP3_STATICLIB")
        else
            package:add("defines", "BUILDING_NGHTTP3")
        end
    end)
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}"
                    if name == 'ssize_t' then
                        line = '${define HAVE_SSIZE_T}\n\n#ifndef HAVE_SSIZE_T\n${define ssize_t}\n#endif'
                    end
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("cmakeconfig.h.in", "config.h.in")
        transforme_configfile("lib/includes/nghttp3/version.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
