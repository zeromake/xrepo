package("opus")
    set_homepage("https://opus-codec.org")
    set_description("Modern audio compression for the internet.")
    set_license("MIT")
    set_urls("https://github.com/xiph/opus/releases/download/v$(version)/opus-$(version).tar.gz")

    --insert version
    add_versions("1.5.2", "9480e329e989f70d69886ded470c7f8cfe6c0667cc4196d4837ac9e668fb7404")
    add_versions("1.4", "c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f")
    
    -- add_includedirs("include")
    -- add_includedirs("include/opus")
    on_install(function (package)
        local transforme_configfile = function (input, output)
            local out = io.open(output, 'wb')
            for line in io.lines(input) do
                if line:startswith("#undef ") then
                    local name = line:sub(8)
                    if name ~= "restrict" or name ~= "inline" or name ~= "const" then
                        line = "${define "..name.."}"
                        if name:startswith("OPUS_X86_PRESUME") then
                            line = "#ifdef OPUS_X86_MAY_HAVE_"..name:sub(17).."\n"..line.."\n#endif"
                        end
                    end
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("config.h.in", "build/config.h.in")
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("opus_decoder_create", {includes = {"opus/opus.h"}}))
    end)
