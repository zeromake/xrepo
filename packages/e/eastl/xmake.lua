package("eastl")
    set_homepage("https://github.com/electronicarts/EASTL")
    set_description("EASTL stands for Electronic Arts Standard Template Library.")
    set_license("BSD-3-Clause")

    set_urls("https://github.com/electronicarts/EASTL/archive/refs/tags/$(version).tar.gz")
    --insert version
    add_versions("3.27.00", "5606643e41ab12fd7c209755fe04dca581ed01f43dec515288b1544eea22623f")
    add_versions("3.21.23", "2bcb48f88f7daf9f91c165aae751c10d11d6959b6e10f2dda8f1db893e684022")
    add_versions("3.21.12", "2a4d77e5eda23ec52fea8b22abbf2ea8002f38396d2a3beddda3ff2e17f7db2e")

    add_deps("eabase")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package)
        os.cp("include/EASTL", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                eastl::vector<int> testInt{};
            }
        ]]},{configs = {languages = "c++17"}, includes = "EASTL/vector.h"}))
    end)
