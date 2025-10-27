package("inja")
    set_kind("library", {headeronly = true})
    set_homepage("https://pantor.github.io/inja")
    set_description("A Template Engine for Modern C++")
    set_license("MIT")
    set_urls("https://github.com/pantor/inja/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("3.5.0", "a5f0266673c59028eab6ceeddd8b862c70abfeb32fb7a5387c16bf46f3269ab2")
    add_versions("3.4.0", "7155f944553ca6064b26e88e6cae8b71f8be764832c9c7c6d5998e0d5fd60c55")
    add_deps("nlohmann_json")

    on_install(function (package)
        os.cp("single_include/inja", package:installdir("include").."/")
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets([[
#include <inja/inja.hpp>

int main() {
    inja::Environment env;
    inja::json data;
    data["name"] = "world";
    env.render("Hello {{ name }}!", data);
    return 0;
}]], {configs = {languages = "c++17"}}))
    end)
