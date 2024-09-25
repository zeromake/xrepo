add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines(
        "UNICODE",
        "_UNICODE"
    )
end

set_encodings("utf-8")

local common_sources = {
    "src/fs-poll.c",
    "src/idna.c",
    "src/inet.c",
    "src/random.c",
    "src/strscpy.c",
    "src/strtok.c",
    "src/thread-common.c",
    "src/threadpool.c",
    "src/timer.c",
    "src/uv-common.c",
    "src/uv-data-getter-setters.c",
    "src/version.c",
}

local win32_sources = {
    "src/win/*.c",
}

local unix_sources = {
    "src/unix/async.c",
    "src/unix/core.c",
    "src/unix/dl.c",
    "src/unix/fs.c",
    "src/unix/getaddrinfo.c",
    "src/unix/getnameinfo.c",
    "src/unix/loop-watcher.c",
    "src/unix/loop.c",
    "src/unix/pipe.c",
    "src/unix/poll.c",
    "src/unix/process.c",
    "src/unix/random-devurandom.c",
    "src/unix/signal.c",
    "src/unix/stream.c",
    "src/unix/tcp.c",
    "src/unix/thread.c",
    "src/unix/tty.c",
    "src/unix/udp.c",
}

local android_sources = {
    "src/unix/linux.c",
    "src/unix/procfs-exepath.c",
    "src/unix/random-getentropy.c",
    "src/unix/random-getrandom.c",
    "src/unix/random-sysctl-linux.c",
}

local linux_or_apple_android_sources = {
    "src/unix/proctitle.c",
}

local bsd_sources = {
    "src/unix/freebsd.c",
    "src/unix/posix-hrtime.c",
    "src/unix/bsd-proctitle.c",
    "src/unix/random-getrandom.c",
    "src/unix/random-getentropy.c",
}

local bsd_or_apple_sources = {
    "src/unix/bsd-ifaddrs.c",
    "src/unix/kqueue.c",
    "src/unix/random-getentropy.c",
}

local apple_sources = {
    "src/unix/darwin.c",
    "src/unix/fsevents.c",
    "src/unix/darwin-proctitle.c",
}

local gnu_sources = {
    "src/unix/bsd-ifaddrs.c",
    "src/unix/no-fsevents.c",
    "src/unix/no-proctitle.c",
    "src/unix/posix-hrtime.c",
    "src/unix/posix-poll.c",
    "src/unix/hurd.c",
}

target("uv")
    set_kind("$(kind)")
    add_includedirs("include", "src")
    add_files(unpack(common_sources))
    add_headerfiles("include/*.h")
    add_headerfiles("include/uv/*.h", {prefixdir = "uv"})
    if is_plat("windows", "mingw") then
        add_defines(
            "WIN32_LEAN_AND_MEAN",
            "_WIN32_WINNT=0x0602",
            "_CRT_DECLARE_NONSTDC_NAMES=0"
        )
        add_syslinks(
            "psapi",
            "user32",
            "advapi32",
            "iphlpapi",
            "userenv",
            "ws2_32",
            "dbghelp",
            "ole32",
            "shell32"
        )
        add_files(unpack(win32_sources))
    else
        -- add_syslinks("pthread")
        add_files(unpack(unix_sources))
        add_defines(
            "_FILE_OFFSET_BITS=64",
            "_LARGEFILE_SOURCE"
        )
    end
    local is_apple = is_plat("macosx", "iphoneos")
    if is_plat("android") then
        add_defines("_GNU_SOURCE")
        add_files(unpack(android_sources))
    end
    if is_plat("linux", "android") or is_apple then
        add_files(unpack(linux_or_apple_android_sources))
    end
    if is_plat("bsd") then
        add_files(unpack(bsd_sources))
    end
    if is_plat("bsd") or is_apple then
        add_files(unpack(bsd_or_apple_sources))
    end
    if is_apple then 
        add_defines(
            "_DARWIN_UNLIMITED_SELECT=1",
            "_DARWIN_USE_64_BIT_INODE=1"
        )
        add_files(unpack(apple_sources))
    end
    if is_plat("linux", "bsd") then
        add_defines(
            "_GNU_SOURCE",
            "_POSIX_C_SOURCE=200112",
            "_XOPEN_SOURCE=500"
        )
        add_files(unpack(gnu_sources))
    end
    if is_kind("shared") then
        add_defines("BUILDING_UV_SHARED=1")
    end
