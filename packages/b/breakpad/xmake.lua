local function getVersion(version)
    local versions ={
        ["2025.01.17-alpha"] = "archive/41b6533e5f3dd7f0320ef58608ee32e8e4f132fb.tar.gz",
        ["2025.02.19-alpha"] = "archive/4fe678ef96050b2ed97afe3b27bb9f8b660755de.tar.gz",
        ["2025.03.15-alpha"] = "archive/87b8e4526a50a683672e51b3af413515ff2e4abd.tar.gz",
        ["2025.04.09-alpha"] = "archive/232a723f5096ab02d53d87931efa485fa77d3b03.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("breakpad")
    set_homepage("https://chromium.googlesource.com/breakpad/breakpad")
    set_description("Breakpad is a set of client and server components which implement a crash-reporting system.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/google/breakpad/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.04.09-alpha", "759d56b72860733a117d0b2b727ace0ab81d36fecfc17a9a7fa873dd68448adb")
    add_versions("2025.03.15-alpha", "ed9f52b115842c76c3d61ff8c04d57a8232bd0c7a8bbd08767d4ce3df42ff227")
    add_versions("2025.02.19-alpha", "709a5bed22857960a9c4b03907fdb3bd17c531a054ee53a224c7da26042f0356")
    add_versions("2025.01.17-alpha", "94bc8da487a76fafee778aa92caa679f98cc7ee585b9c1cb44e7debca285ee8c")
    add_patches("2025.01.17-alpha", path.join(os.scriptdir(), "patches/001-osx-skip-ppc.patch"), "7f5cff9067004a7321ca422c961e54970a1f1adf2035432de2c5b97d8364a487")
    if is_plat("macosx") then
        add_frameworks("CoreFoundation")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp(path.join(os.scriptdir(), "port", "compat"), "compat")
        local configs = {}
        local text = io.readfile("src/config.h.in")
        text = text:gsub("#undef +([%w_-]+)", "${define %1}")
        io.writefile("config.h.in", text..[[
#ifdef _WIN32
#include <_getopt.h>
typedef long long ssize_t;
#endif]], {encoding = "binary"})
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
