local function getVersion(version)
    local versions ={
        ["2024.11.18-alpha"] = "archive/999a11e0a82f9e4d0cedb29ed0b0282543b30805.tar.gz",
        ["2024.12.01-alpha"] = "archive/26d8565bc7660b4fb8b504e00cac6b0419ffa939.tar.gz",
        ["2024.12.19-alpha"] = "archive/ac27bebfc85560006cce7404e44fb7b1b73a26f0.tar.gz",
        ["2024.12.31-alpha"] = "archive/2e87822e5b4ea97c397e5c38accc4ea045d17685.tar.gz",
        ["2025.01.10-alpha"] = "archive/cab1814c7e4c039677f5aef3ab15c7d0e11f0697.tar.gz",
        ["2025.02.10-alpha"] = "archive/b888185d667f68b9a8bda5d0c81d03edf9ec3fe1.tar.gz",
        --insert getVersion
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

    --insert version
    add_versions("2025.02.10-alpha", "f8c8496bf9c1eba4a2ad42bf266328f7e487f421620ea400a0cf19cda11e90fd")
    add_versions("2025.01.10-alpha", "8356f534563bd576851d81b77806f6054fa4068f211825b77ccbce8572342a4d")
    add_versions("2024.12.31-alpha", "4c04be6bea5af078b61affc7d57ee13b8e3940464daddf000064eed8fd529d90")
    add_versions("2024.12.19-alpha", "83a2b25c6e48dc5edbfd9c63633007cf6b8214320a3fa738615f53707bcf7b80")
    add_versions("2024.12.01-alpha", "8279fbc73830d18df2afbe92c45b8d121099ad06e8920b9b79cf25ba066dea79")
    add_versions("2024.11.18-alpha", "355130e4ba9b8d7b670291cb5e528324946deb0667a7b478501a4b18efbc7b26")
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
