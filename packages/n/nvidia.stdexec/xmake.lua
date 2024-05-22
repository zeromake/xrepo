local function getVersion(version)
    local versions ={
        ["2024.05.18-alpha"] = "archive/da6c3d49c4db18521fe11e1e6008d405ae434641.tar.gz",
    }
    return versions[tostring(version)]
end
package("nvidia.stdexec")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/NVIDIA/stdexec")
    set_description("`std::execution`, the proposed C++ framework for asynchronous and parallel programming")
    set_license("Apache-2.0")
    set_urls("https://github.com/NVIDIA/stdexec/$(version)", {
        version = getVersion
    })

    add_versions("2024.05.18-alpha", "7893985d06c3094462db417c882b9c97e7998dab488cf74f1b28ce0ab01c5efe")
    on_install(function (package)
        os.cp("include/*", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
#include <stdexec/execution.hpp>
#include <exec/static_thread_pool.hpp>
int main() {
    exec::static_thread_pool pool(3);
    auto sched = pool.get_scheduler();
    auto fun = [](int i) { return i*i; };
    auto work = stdexec::when_all(
        stdexec::on(sched, stdexec::just(0) | stdexec::then(fun)),
        stdexec::on(sched, stdexec::just(1) | stdexec::then(fun)),
        stdexec::on(sched, stdexec::just(2) | stdexec::then(fun))
    );
    auto [i, j, k] = stdexec::sync_wait(std::move(work)).value();
    std::printf("%d %d %d\n", i, j, k);
}
]]}, {
            configs = {languages = "c++20"},
        }))
    end)
