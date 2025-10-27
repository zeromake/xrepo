package("turbojpeg")
    set_homepage("https://libjpeg-turbo.org/")
    set_description("libjpeg-turbo is a JPEG image codec that uses SIMD instructions to accelerate baseline JPEG compression and decompression")
    set_license("ZLIB")
    set_urls("https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("3.1.2", "560f6338b547544c4f9721b18d8b87685d433ec78b3c644c70d77adad22c55e6")
    add_versions("3.1.1", "304165ae11e64ab752e9cfc07c37bfdc87abd0bfe4bc699e59f34036d9c84f72")
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
        transforme_configfile("src/jversion.h.in", "build/jversion.h.in")
        transforme_configfile("src/jconfig.h.in", "build/jconfig.h.in")
        transforme_configfile("src/jconfigint.h.in", "build/jconfigint.h.in")
        transforme_configfile("simd/arm/neon-compat.h.in", "build/neon-compat.h.in")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
