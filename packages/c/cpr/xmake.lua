package("cpr")
    set_homepage("https://docs.libcpr.org/")
    set_description("C++ Requests is a simple wrapper around libcurl inspired by the excellent Python Requests project.")
    set_license("MIT")

    set_urls("https://github.com/libcpr/cpr/archive/refs/tags/$(version).tar.gz")

    add_versions("1.10.5", "c8590568996cea918d7cf7ec6845d954b9b95ab2c4980b365f582a665dea08d8")
    add_versions("1.10.0", "d669c028bd63a1c8827c32b348ecc85e46747bb33be3b00ce59b77717b91aee8")
    add_versions("1.8.3", "0784d4c2dbb93a0d3009820b7858976424c56578ce23dcd89d06a1d0bf5fd8e2")
    add_configs("ssl", {description = "Enable SSL.", default = false, type = "boolean"})

    local curlName = "curl"
    add_deps("cmake")
    if is_plat("mingw") then
        add_syslinks("pthread")
        curlName = "libcurl"
    end
    add_links("cpr")

    on_load(function (package)
        if package:config("ssl") then
            package:add("deps", curlName)
            package:add("deps", "libssh2")
        else
            package:add("deps", curlName)
        end
    end)

    on_install(function (package)
        local configs = {"-DCPR_BUILD_TESTS=OFF",
                         "-DCPR_USE_SYSTEM_CURL=ON"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DCPR_ENABLE_SSL=" .. (package:config("ssl") and "ON" or "OFF"))
        local shflags
        if package:config("shared") and package:is_plat("macosx") then
            shflags = {"-framework", "CoreFoundation", "-framework", "Security", "-framework", "SystemConfiguration"}
        end
        local packagedeps = {curlName}
        if package:config("ssl") then
            table.insert(packagedeps, "libssh2")
        end
        if package:is_plat("windows", "mingw") then
            -- fix find_package issue on windows
            io.replace("CMakeLists.txt", "find_package%(CURL COMPONENTS .-%)", "find_package(CURL)")
        end
        import("package.tools.cmake").install(package, configs, {shflags = shflags, packagedeps = packagedeps})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <cassert>
            #include <cpr/cpr.h>
            static void test() {
                cpr::Response r = cpr::Get(cpr::Url{"https://xmake.io"});
                assert(r.status_code == 200);
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
