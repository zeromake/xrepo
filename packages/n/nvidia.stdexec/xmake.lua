local function getVersion(version)
    local versions ={
        ["2024.11.18-alpha"] = "archive/999a11e0a82f9e4d0cedb29ed0b0282543b30805.tar.gz",
        ["2024.12.01-alpha"] = "archive/26d8565bc7660b4fb8b504e00cac6b0419ffa939.tar.gz",
        ["2024.12.19-alpha"] = "archive/ac27bebfc85560006cce7404e44fb7b1b73a26f0.tar.gz",
        ["2024.12.31-alpha"] = "archive/2e87822e5b4ea97c397e5c38accc4ea045d17685.tar.gz",
        ["2025.01.10-alpha"] = "archive/cab1814c7e4c039677f5aef3ab15c7d0e11f0697.tar.gz",
        ["2025.02.10-alpha"] = "archive/b888185d667f68b9a8bda5d0c81d03edf9ec3fe1.tar.gz",
        ["2025.03.01-alpha"] = "archive/46f8c6368dc419260e19f585de35ca3c1bb47ee0.tar.gz",
        ["2025.03.14-alpha"] = "archive/c7ae38cbdcaa53144300f490716901a74a6ffe0b.tar.gz",
        ["2025.04.08-alpha"] = "archive/954159ad82386b3564ea4125d9f4b7a68ccb912c.tar.gz",
        ["2025.04.29-alpha"] = "archive/0242ad9a5ac172324ff51803a1c79facca36b229.tar.gz",
        ["2025.05.10-alpha"] = "archive/35a3e31590e736fbb7dd55324b3a7f991a059ce3.tar.gz",
        ["2025.08.29-alpha"] = "archive/ac2d378944b68021a3c51ed98987b6d4cf05b989.tar.gz",
        ["2025.10.26-alpha"] = "archive/712953b245412bf8ebdfdf369136d637beb43aec.tar.gz",
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
    add_versions("2025.10.26-alpha", "70ef00339d1506154525e4c89c42f42343ea3f0ed5caba7d016fa9c27a5cf40a")
    add_versions("2025.08.29-alpha", "1b16b1745bc3cc679be46b9866f13a016f66565207373f1bc14a0ff05a4bc794")
    add_versions("2025.05.10-alpha", "3ca125aeb61b18abe0b405787cf9c7d90ebe194b683bf5cd33a9e1d0c14a7656")
    add_versions("2025.04.29-alpha", "2749aecdf4114e442d5eb569271e55288a4c71a02cc1513f9aba8dd73ab5191f")
    add_versions("2025.04.08-alpha", "e4683966542ae8392a997d8ca88cb3225052800e13cf75f1fa70aa10f38717ea")
    add_versions("2025.03.14-alpha", "39715b8c680c44e973ecc7bab8398923b8042561a7f21eccdd776e752fab54dc")
    add_versions("2025.03.01-alpha", "002f37b6b7ce30bb1648743e00ff8a098ce551414b7bbc2a2ff71eb5f002c155")
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
