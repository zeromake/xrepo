package("microsoft_proxy")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/microsoft/proxy")
    set_description("Proxy: Easy Polymorphism in C++")
    set_license("MIT")
    set_urls("https://github.com/microsoft/proxy/archive/refs/tags/$(version).tar.gz")

    add_versions("2.3.1", "bfec45ada9cd3dc576df34bbe877c5d03a81906a00759970c0197c3fa041c5c7")
    add_versions("2.2.0", "a18ecc395e5f962c79e3231ad7492a267b61463a595220be118ceb00009c86cf")
    on_install(function (package)
        os.cp("*.h", package:installdir("include/proxy"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({
            test = [[
#include <iostream>
#include <map>
#include <string>
#include <vector>

#include <proxy/proxy.h>

namespace poly {

PRO_DEF_MEMBER_DISPATCH(at, std::string(int));
PRO_DEF_FACADE(Dictionary, at);

}  // namespace poly

void demo_print(pro::proxy<poly::Dictionary> dictionary) {
  std::cout << dictionary(1) << std::endl;
}

int main() {
  std::map<int, std::string> container1{{1, "hello"}};
  std::vector<std::string> container2{"hello", "world"};
  demo_print(&container1);  // print: hello\n
  demo_print(&container2);  // print: world\n
  return 0;
}
]]
        }, {configs = {languages = "c++20"}}))
    end)
