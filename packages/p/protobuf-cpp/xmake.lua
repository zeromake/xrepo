package("protobuf-cpp")

    set_homepage("https://developers.google.com/protocol-buffers/")
    set_description("Google's data interchange format for cpp")

    add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protobuf-$(version).tar.gz")

    add_versions("27.1", "6fbe2e6f703bcd3a246529c2cab586ca12a98c4e641f5f71d51fde09eb48e9e7")
    add_configs("zlib", {description = "Enable zlib", default = false, type = "boolean"})

    add_deps("cmake")

    if is_plat("windows") then
        add_links("libprotobuf", "libprotoc", "utf8_range", "utf8_validity")
    else
        add_links("protobuf", "protoc", "utf8_range", "utf8_validity")
    end

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_load(function (package)
        package:addenv("PATH", "bin")
        if package:config("zlib") then
            package:add("deps", "zlib")
        end
        package:add("deps", "abseil")
    end)

    on_install("windows", "linux", "macosx", function (package)
        io.replace("CMakeLists.txt", "set(protobuf_DEBUG_POSTFIX \"d\"", "set(protobuf_DEBUG_POSTFIX \"\"", {plain = true})
        io.replace("cmake/abseil-cpp.cmake", "BUILD_SHARED_LIBS AND MSVC", "FALSE", {plain = true})

        local configs = {"-Dprotobuf_BUILD_TESTS=OFF", "-Dprotobuf_BUILD_PROTOC_BINARIES=ON"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
      
        local packagedeps = {}
        table.insert(packagedeps, "abseil")
        table.insert(configs, "-Dprotobuf_ABSL_PROVIDER=package")

        if package:is_plat("windows") then
            table.insert(configs, "-DCMAKE_COMPILE_PDB_OUTPUT_DIRECTORY=''")
            table.insert(configs, "-Dprotobuf_MSVC_STATIC_RUNTIME=" .. (package:config("vs_runtime"):startswith("MT") and "ON" or "OFF"))
            if package:config("shared") then
                package:add("defines", "PROTOBUF_USE_DLLS")
            end
        end
        if package:config("zlib") then
            table.insert(configs, "-Dprotobuf_WITH_ZLIB=ON")
        end
        import("package.tools.cmake").install(package, configs, {buildir = "build", packagedeps = packagedeps})
        -- os.trycp("build/Release/protoc.exe", package:installdir("bin"))
    end)

    on_test(function (package)
        if package:is_cross() then
            return
        end
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
