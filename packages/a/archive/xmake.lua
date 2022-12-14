local options = {
    -- tls lib
    "mbedtls",
    "nettle",
    "openssl",

    -- decrypt lib
    -- "b2",
    "cng",

    -- compression lib
    "lz4",
    "lzo",
    "lzma",
    "zstd",
    "zlib",
    "bzip2",

    -- xml lib
    "xml2",
    "expat",
    "pcre2",

    -- other lib
    "iconv",
}

package("archive")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/libarchive/libarchive/releases/download/v$(version)/libarchive-$(version).tar.xz")
    
    add_versions("3.6.1", "9e2c1b80d5fbe59b61308fdfab6c79b5021d7ff4ff2489fb12daf0a96a83551d")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    -- end)
