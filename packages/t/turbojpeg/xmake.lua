package("turbojpeg")
    set_homepage("https://libjpeg-turbo.org/")
    set_description("libjpeg-turbo is a JPEG image codec that uses SIMD instructions to accelerate baseline JPEG compression and decompression")
    set_license("ZLIB")
    set_urls("https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("3.0.4", "0270f9496ad6d69e743f1e7b9e3e9398f5b4d606b6a47744df4b73df50f62e38")
    add_versions("3.0.3", "a649205a90e39a548863a3614a9576a3fb4465f8e8e66d54999f127957c25b21")
    add_versions("3.0.2", "29f2197345aafe1dcaadc8b055e4cbec9f35aad2a318d61ea081f835af2eebe9")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.mkdir("build")
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    line = "${define "..line:split("%s+")[2].."}"
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("jversion.h.in", "build/jversion.h.in")
        transforme_configfile("jconfig.h.in", "build/jconfig.h.in")
        transforme_configfile("jconfigint.h.in", "build/jconfigint.h.in")
        transforme_configfile("simd/arm/neon-compat.h.in", "build/neon-compat.h.in")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
