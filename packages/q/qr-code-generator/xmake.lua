package("qr-code-generator")
    set_homepage("https://github.com/nayuki/QR-Code-generator")
    set_description("High-quality QR Code generator library C++, C.")
    set_license("MIT")

    set_urls("https://github.com/nayuki/QR-Code-generator/archive/refs/tags/v$(version).tar.gz")
    add_configs("cpp", {description = "Support cpp link", default = false, type = "boolean"})

    add_versions("1.8.0", "2ec0a4d33d6f521c942eeaf473d42d5fe139abcfa57d2beffe10c5cf7d34ae60")
    on_load(function (package)
        if package:config("cpp") then
            package:add("links", "qr-code-generator-cpp")
        else
            package:add("links", "qr-code-generator-c")
        end
    end)
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
