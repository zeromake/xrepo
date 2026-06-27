local function getVersion(version)
    local versions ={
        ["2026.06.12-alpha"] = "archive/1f86a5a7e2990a707107440c1381ff9534b0c0e3.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("zeromake.breakpad")
    set_homepage("https://chromium.googlesource.com/breakpad/breakpad")
    set_description("Google Breakpad is a set of client and server components which implement a crash-reporting system.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/zeromake/breakpad/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2026.06.12-alpha", "ff271bfc71902e00747c0ed3f2cf10faad1a46fef7283c4b7625d24f0629dd8c")
    if is_plat("macosx") then
        add_frameworks("CoreFoundation")
    end

    on_install(function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        if package:is_plat("windows") then
        -- 生成的 minidump 的报告命令
        -- dump_syms demo.pdb > demo.sym
        -- dir = `cat demo.sym | head -n 1 | cut -d ' ' -f 4`
        -- mkdir -p "demo.pdb/$dir"
        -- mv demo.sym "demo.pdb/$dir"
        -- ./demo
        -- minidump_stackwalk xxx.dmp .
        assert(package:check_cxxsnippets({
            test = [[
#include <iostream>
#include <client/windows/handler/exception_handler.h>

bool Callback(const wchar_t* dump_path,
    const wchar_t* minidump_id,
    void* context,
    EXCEPTION_POINTERS* exinfo,
    MDRawAssertionInfo* assertion,
    bool succeeded) {

    std::wcerr << L"Crash dump written to " << dump_path << L"\\" << minidump_id << std::endl;
    return succeeded;
}

int main() {
    google_breakpad::ExceptionHandler eh(
        L"dumps",
        NULL,
        Callback,
        NULL,
        -1);
    int* p = nullptr;
    *p = 42;
    return 0;
}]],
        }, {configs = {languages = "c++17"}}))
    elseif package:is_plat("macosx") then
    -- 生成的 minidump 的报告命令
    -- dsymutil demo -o demo.dSYM
    -- dump_syms -g demo.dSYM demo > demo.sym
    -- dir = `cat demo.sym | head -n 1 | cut -d ' ' -f 4`
    -- mkdir -p "demo/$dir"
    -- mv demo.sym "demo/$dir"
    -- ./demo
    -- minidump_stackwalk xxx.dmp .
    assert(package:check_cxxsnippets({
            test = [[
#include <iostream>
#include <client/mac/handler/exception_handler.h>

bool Callback(const char* dump_dir,  const char* minidump_id,
                                   void* context, bool succeeded) {
    std::cerr << "Crash dump written to " << dump_dir << minidump_id << std::endl;
    return succeeded;
}

int main() {
    google_breakpad::ExceptionHandler eh("dumps", NULL, Callback, NULL, true, NULL);
    int *p = nullptr;
    *p = 42;
    return 0;
}]],
        }, {configs = {languages = "c++17"}}))
    end
    end)

