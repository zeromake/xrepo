rule('mcs51')
    on_config(function(target)
        assert(is_plat("cross"))
        local model = target:extraconf("rules", "@zeromake.rules/mcs51", "model") or "STC8H1K08"
        local envs = {
            ["STC8H1K08"] = {
                ["cflags"] = "--model-small --opt-code-size --std-sdcc99",
                ["ldflags"] = "--model-small --opt-code-size --iram-size 256 --xram-size 1024 --code-size 8192",
                ["defines"] = {
                    "__CONF_FOSC=36864000UL",
                    "__CONF_MCU_MODEL=MCU_MODEL_STC8H1K08",
                    "__CONF_CLKDIV=0x00",
                    "__CONF_IRCBAND=0x01",
                    "__CONF_VRTRIM=0x1F",
                    "__CONF_IRTRIM=0xB5",
                    "__CONF_LIRTRIM=0x00"
                },
            },
            ["STC8H8K64U"] = {
                ["cflags"] = "--model-small --opt-code-size --std-sdcc99",
                ["ldflags"] = "--model-small --opt-code-size --iram-size 256 --xram-size 8192 --code-size 65536",
                ["defines"] = {
                    "__CONF_FOSC=36864000UL",
                    "__CONF_MCU_MODEL=MCU_MODEL_STC8H8K64U",
                    "__CONF_CLKDIV=0x00",
                    "__CONF_IRCBAND=0x83",
                    "__CONF_VRTRIM=0x1B",
                    "__CONF_IRTRIM=0x5E",
                    "__CONF_LIRTRIM=0xA8"
                },
            },
            ["STC8G1K08"] = {
                ["cflags"] = "--model-small --opt-code-size --std-sdcc99",
                ["ldflags"] = "--model-small --opt-code-size --iram-size 256 --xram-size 1024 --code-size 8192",
                ["defines"] = {
                    "__CONF_FOSC=11059200UL",
                    "__CONF_MCU_MODEL=MCU_MODEL_STC8G1K08",
                    "__CONF_CLKDIV=0x00",
                    "__CONF_IRCBAND=0x01",
                    "__CONF_VRTRIM=0x1F",
                    "__CONF_IRTRIM=0xB5",
                    "__CONF_LIRTRIM=0x00"
                },
            },
        }
        local env = envs[model]
        if env == nil then
            raise("mcs51: unsupported model %s", model)
        end
        target:add("cflags", env.cflags, {force = true})
        target:add("ldflags", env.ldflags, {force = true})
        target:add("defines", table.unpack(env.defines))
    end)
