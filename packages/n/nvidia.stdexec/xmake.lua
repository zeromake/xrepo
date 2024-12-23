local function getVersion(version)
    local versions ={
        ["2024.10.26-alpha"] = "archive/35e8941066ad5c69bcb82741914585a8611917c2.tar.gz",
        ["2024.11.04-alpha"] = "archive/c1508b1e46d5806a1c452c9c90821261716d1473.tar.gz",
        ["2024.11.11-alpha"] = "archive/15dcdbcc464891d369ab46a9e8d5521ddc7853d7.tar.gz",
        ["2024.11.18-alpha"] = "archive/999a11e0a82f9e4d0cedb29ed0b0282543b30805.tar.gz",
        ["2024.12.01-alpha"] = "archive/26d8565bc7660b4fb8b504e00cac6b0419ffa939.tar.gz",
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
    add_versions("2024.12.01-alpha", "8279fbc73830d18df2afbe92c45b8d121099ad06e8920b9b79cf25ba066dea79")
    add_versions("2024.11.18-alpha", "355130e4ba9b8d7b670291cb5e528324946deb0667a7b478501a4b18efbc7b26")
    add_versions("2024.11.11-alpha", "3dabc83539c85cd697ed33ad66cc847a867cabd258fd742985eacb371cc196b1")
    add_versions("2024.11.04-alpha", "8241469708636adaf07e927d61d681fe22cf7c1dc85e0c8856a4389f35fe2e8e")
    add_versions("2024.10.26-alpha", "14cc28a01ffc7938ae0ac19fa0292159a020e67a97ccd4c2380504f424ce3808")
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
