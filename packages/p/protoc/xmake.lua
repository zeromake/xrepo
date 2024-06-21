package("protoc")
    set_kind("binary")
    set_homepage("https://developers.google.com/protocol-buffers/")
    set_description("Google's data interchange format compiler")
    if is_host("windows") then
        if is_arch("x64") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-win64.zip")
            add_versions("27.1", "da531c51ccd1290d8d34821f0ce4e219c7fbaa6f9825f5a3fb092a9d03fe6206")
        else
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-win32.zip")
            add_versions("27.1", "6263718ff96547b8392a079f6fdf02a4156f2e8d13cd51649a0d03fb7afa2de8")
        end
    elseif is_host("macosx") then
        add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-osx-universal_binary.zip")
        add_versions("27.1", "f14d3973cf13283d07c520ed6f4c12405ad41b9efd18089a1c74897037d742b5")
    elseif is_host("linux") then
        add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-linux-x86_64.zip")
        add_versions("27.1", "8970e3d8bbd67d53768fe8c2e3971bdd71e51cfe2001ca06dacad17258a7dae3")
    end

    on_install(function (package)
        os.cp("bin", package:installdir())
        os.cp("include", package:installdir())
    end)
    on_test(function (package)
        io.writefile("test.proto", [[
            syntax = "proto3";
            package test;
            message TestCase {
                string name = 4;
            }
            message Test {
                repeated TestCase case = 1;
            }
        ]])
        os.vrun("protoc test.proto --cpp_out=.")
    end)
