package("shaderc")
    set_license("Apache-2.0")
    set_homepage("https://github.com/google/shaderc")
    set_description("A collection of tools, libraries, and tests for Vulkan shader compilation.")

    set_urls("https://github.com/google/shaderc/archive/refs/tags/v2024.1.tar.gz")

    --insert version
    add_versions("2024.1", "eb3b5f0c16313d34f208d90c2fa1e588a23283eed63b101edd5422be6165d528")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})

    on_install(function (package)
        io.writefile("build-version.inc", [["shaderc 2024.1\n"
"spirv-tools 2024.1\n"
"glslang 14.2.0\n"]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        configs["cli"] = package:config("cli") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
    end)
