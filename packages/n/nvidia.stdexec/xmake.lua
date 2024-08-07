local function getVersion(version)
    local versions ={
        ["2024.06.16-alpha"] = "archive/089c4613385f808c3b39c4f4915f658157013a36.tar.gz",
        ["2024.07.03-alpha"] = "archive/6d007d3f61384e45e16c837ecd67d0a0adc6e83f.tar.gz",
        ["2024.07.10-alpha"] = "archive/604b94d54e235a2d2a6b0c5bbdb7139d1834a9b5.tar.gz",
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

    add_versions("2024.07.10-alpha", "aeef43715e865d7ddb03402f8988c09fbb340d7af9da938a3ad44e3e41cc091a")
    add_versions("2024.07.03-alpha", "bdeacab677daba740cad65faa8e8bb72f8a167609b4bc1bf84a08b941f5a82d2")
    add_versions("2024.06.16-alpha", "928d1662ab9f3d9475ccad3e59e5badd788e406c2df81b8fb0dd513d598bd8bd")
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
