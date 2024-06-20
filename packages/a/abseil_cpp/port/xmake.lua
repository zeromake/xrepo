includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

local modules = {
    "base",
    "algorithm",
    "cleanup",
    "container",
    "crc",
    "debugging",
    "flags",
    "functional",
    "hash",
    "log",
    "memory",
    "meta",
    "numeric",
    "profiling",
    "random",
    "status",
    "strings",
    "synchronization",
    "type",
    "utility",
}

add_includedirs(".")
set_languages("c++17")

local files = "*.cc|*test*.cc|*benchmark*.cc|*mock*.cc"
target("abseil_cpp")
    set_kind("$(kind)")
    add_files(path.join("absl/base", files))
    add_files(path.join("absl/base/internal", files))
    add_files(path.join("absl/crc", files))
    add_files(path.join("absl/crc/internal", files))
    add_files(path.join("absl/debugging", files))
    add_files(path.join("absl/debugging/internal", files))
    add_files(path.join("absl/flags", files))
    add_files(path.join("absl/flags/internal", files))
    add_files(path.join("absl/log", files))
    add_files(path.join("absl/log/internal", files))
    add_files(path.join("absl/numeric", files))
    add_files(path.join("absl/random", files))
    add_files(path.join("absl/random/internal", files.."|gaussian_distribution_gentables.cc|chi_square.cc"))
    add_files(path.join("absl/status", files))
    add_files(path.join("absl/status/internal", files))
    add_files(path.join("absl/strings", files))
    add_files(path.join("absl/strings/internal", files))
    add_files(path.join("absl/strings/internal/str_format", files))
    add_files(path.join("absl/synchronization", files))
    add_files(path.join("absl/synchronization/internal", files))
    add_files(path.join("absl/time", files))
    add_files(path.join("absl/time/internal", "get_current_time_*.inc"), {rule = "c++"})
    add_files(path.join("absl/time/internal/cctz/src", files))
    add_files(path.join("absl/container/internal", files))
    add_files(path.join("absl/hash/internal", files.."|print_hash_of.cc"))
    for _, module in ipairs(modules) do
        add_headerfiles(path.join("absl", module, "*.h"), {prefixdir = "absl/"..module})
        if os.exists(path.join("absl", module, "internal")) then
            add_headerfiles(path.join("absl", module, "internal", "*.h"), {prefixdir = "absl/"..module.."/internal"})
        end
    end
    if is_plat("macosx", "iphoneos") then
        add_frameworks("CoreFoundation")
    end
