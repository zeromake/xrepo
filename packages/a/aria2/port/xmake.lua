includes("@builtin/check")
add_rules("mode.debug", "mode.release")

add_requires(
    "libressl",
    "ssh2",
    "expat",
    "zlib",
    "sqlite3",
    "c-ares"
)

local common_headers = {
    "argz.h",
    "arpa/inet.h",
    "fcntl.h",
    "float.h",
    "inttypes.h",
    "langinfo.h",
    "libintl.h",
    "limits.h",
    "libgen.h",
    "locale.h",
    "malloc.h",
    "math.h",
    "memory.h",
    "netdb.h",
    "netinet/in.h",
    "netinet/tcp.h",
    "poll.h",
    "port.h",
    "signal.h",
    "stddef.h",
    "stdint.h",
    "stdio_ext.h",
    "stdlib.h ",
    "string.h",
    "strings.h",
    "sys/epoll.h",
    "sys/event.h",
    "sys/ioctl.h",
    "sys/mman.h",
    "sys/param.h",
    "sys/resource.h",
    "sys/stat.h",
    "sys/signal.h",
    "sys/socket.h",
    "sys/time.h",
    "sys/types.h",
    "sys/uio.h",
    "sys/utsname.h",
    "termios.h",
    "time.h",
    "unistd.h",
    "utime.h",
    "wchar.h",
    "ifaddrs.h",
    "pwd.h",
    "stdbool.h",
    "pthread.h",

    "windows.h",
    "winsock2.h",
    "ws2tcpip.h",
    "mmsystem.h",
    "io.h",
    "iphlpapi.h",
    "winioctl.h",
    "share.h",
    "sys/utime.h",
    "wincrypt.h",
    "security.h",
}

for _, common_header in ipairs(common_headers) do
    local name = 'HAVE_'..common_header:gsub("/", "_"):gsub("%.", "_"):gsub("-", "_"):upper()
    configvar_check_cincludes(name, common_header)
end

set_configvar("ENABLE_METALINK", 1)
set_configvar("ENABLE_XML_RPC", 1)
set_configvar("ENABLE_BITTORRENT", 1)
set_configvar("USE_INTERNAL_ARC4", 1)
set_configvar("USE_INTERNAL_BIGNUM", 1)
set_configvar("ENABLE_SSL", 1)
set_configvar("HAVE_LIBCARES", 1)
set_configvar("HAVE_LIBSSH2", 1)
set_configvar("HAVE_OPENSSL", 1)
set_configvar("HAVE_EVP_SHA224", 1)
set_configvar("HAVE_EVP_SHA256", 1)
set_configvar("HAVE_EVP_SHA384", 1)
set_configvar("HAVE_EVP_SHA512", 1)
set_configvar("HAVE_SQLITE3", 1)
set_configvar("HAVE_SQLITE3_OPEN_V2", 1)
set_configvar("HAVE_LIBEXPAT", 1)
set_configvar("HAVE_ZLIB", 1)
set_configvar("HAVE_GZBUFFER", 1)
set_configvar("HAVE_GZSETPARAMS", 1)
set_configvar("ENABLE_WEBSOCKET", 1)
set_configvar("ENABLE_ASYNC_DNS", 1)
set_configvar("USE_INTERNAL_MD", 1)

if is_plat("windows", "mingw") then
    set_configvar("WIN32_LEAN_AND_MEAN", 1)
    add_defines("_POSIX_C_SOURCE=1")
else
    add_defines("_GNU_SOURCE=1")
    set_configvar("ENABLE_PTHREAD", 1)
end
local PROJECT_NAME = "aria2"
local PROJECT_VERSION = "1.36.0"
local PACKAGE_URL = "https://aria2.github.io"
local PACKAGE_BUGREPORT = "https://github.com/aria2/aria2/issues"

set_configvar("PACKAGE", PROJECT_NAME)
set_configvar("PACKAGE_NAME", PROJECT_NAME)
set_configvar("PACKAGE_STRING", PROJECT_NAME .. " " .. PROJECT_VERSION)
set_configvar("PACKAGE_TARNAME", PROJECT_NAME)
set_configvar("PACKAGE_URL", PACKAGE_URL)
set_configvar("PACKAGE_BUGREPORT", PACKAGE_BUGREPORT)
set_configvar("PACKAGE_VERSION", PROJECT_VERSION)
set_configvar("VERSION", PROJECT_VERSION)

local network_include = {}
if is_plat("windows", "mingw") then
    network_include = {"windows.h", "winsock2.h", "ws2tcpip.h"}
else
    network_include = {"sys/types.h", "sys/socket.h", "netdb.h"}
end

configvar_check_cfuncs("HAVE_GETADDRINFO", "getaddrinfo", {includes = network_include})
configvar_check_ctypes("HAVE_A2_STRUCT_TIMESPEC", "struct timespec", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_SLEEP", "sleep", {includes = {"unistd.h"}})
configvar_check_cfuncs("HAVE_USLEEP", "usleep", {includes = {"unistd.h"}})
configvar_check_cfuncs("HAVE_LOCALTIME_R", "localtime_r", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_GETTIMEOFDAY", "gettimeofday", {includes = {"sys/time.h"}})
configvar_check_cfuncs("HAVE_STRPTIME", "strptime", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_TIMEGM", "timegm", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_ASCTIME_R", "asctime_r", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_MMAP", "mmap", {includes = {"sys/mman.h"}})
configvar_check_cfuncs("HAVE_BASENAME", "basename", {includes = {"libgen.h"}})

target("aria2c")
    add_files("deps/wslay/lib/*.c")
    add_files("src/*.cc", "src/uri_split.c")
    add_defines("WSLAY_VERSION=\""..PROJECT_VERSION.."\"")
    on_config(function (target)
        local variables = target:get("configvar") or {}
        for _, opt in ipairs(target:orderopts()) do
            for name, value in pairs(opt:get("configvar")) do
                if variables[name] == nil then
                    variables[name] = table.unwrap(value)
                    variables["__extraconf_" .. name] = opt:extraconf("configvar." .. name, value)
                end
            end
        end
        local set_configvar = function(k, v)
            if v == nil then
                return
            end
            target:set("configvar", k, v)
            variables[k] = v
        end
        set_configvar("HOST", vformat("$(host)"))
        set_configvar("BUILD", vformat("$(arch)-pc-$(os)"))
        set_configvar("TARGET", vformat("$(arch)-pc-$(os)"))
        local compat_sources = {
            ["HAVE_ASCTIME_R"] = {"src/asctime_r.c"},
            ["HAVE_BASENAME"] = {"src/libgen.c"},
            ["HAVE_GETADDRINFO"] = {"src/getaddrinfo.c"},
            ["HAVE_GETTIMEOFDAY"] = {"src/gettimeofday.c"},
            ["HAVE_LOCALTIME_R"] = {"src/localtime_r.c"},
            ["HAVE_STRPTIME"] = {"src/strptime.c"},
            ["HAVE_TIMEGM"] = {"src/timegm.c"},
        }
        for k, v in pairs(compat_sources) do
            if not variables[k] then
                target:add("files", table.unpack(v))
            end
        end
    end)
    remove_files(
        "src/WinTLSContext.cc",
        "src/WinTLSSession.cc",

        "src/AppleTLSContext.cc",
        "src/AppleTLSSession.cc",
        "src/AppleMessageDigestImpl.cc",

        "src/LibgnutlsTLSContext.cc",
        "src/LibgnutlsTLSSession.cc",

        "src/Xml2XmlParser.cc",
        "src/LibgmpDHKeyExchange.cc",
        "src/a2gmp.cc",
        "src/LibnettleMessageDigestImpl.cc",
        "src/WinConsoleFile.cc",

        "src/LibgcryptARC4Encryptor.cc",
        "src/LibgcryptDHKeyExchange.cc",
        "src/LibgcryptMessageDigestImpl.cc",

        "src/LibnettleARC4Encryptor.cc",
        "src/LibnettleMessageDigestImpl.cc",

        -- 使用内部实现
        -- "src/InternalARC4Encryptor.cc",
        -- "src/InternalDHKeyExchange.cc",
        -- "src/InternalMessageDigestImpl.cc",

        "src/LibsslARC4Encryptor.cc",
        "src/LibsslDHKeyExchange.cc",
        "src/LibsslMessageDigestImpl.cc",

        -- "src/SelectEventPoll.cc",
        "src/KqueueEventPoll.cc",
        "src/LibuvEventPoll.cc",
        "src/PortEventPoll.cc",
        "src/EpollEventPoll.cc"
    )
    if is_plat("windows", "mingw") then
        add_files("src/PortEventPoll.cc")
    elseif is_plat("linux", "android") then
        add_files("src/EpollEventPoll.cc")
    elseif is_plat("macosx", "iphoneos", "bsd") then
        add_files("src/KqueueEventPoll.cc")
    end
    add_includedirs("src/includes", "deps/wslay/lib/includes")
    set_languages("c++17")
    add_defines("CXX11_OVERRIDE=override")
    add_packages(
        "libressl",
        "ssh2",
        "expat",
        "zlib",
        "sqlite3",
        "c-ares"
    )
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("config.h.in")
    add_defines("HAVE_CONFIG_H=1")
    if is_plat("macosx", "iphoneos") then
        add_frameworks("Security")
    end
