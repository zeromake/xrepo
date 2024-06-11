local function getVersion(version)
    local versions ={
        ["2023.04.20-alpha"] = "archive/068d5ee1a3ac40dabd00d211d5013af44be55bea.tar.gz",
    }
    return versions[tostring(version)]
end
package("leveldb")
    set_homepage("https://github.com/google/leveldb")
    set_description("LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/google/leveldb/$(version)", {
        version = getVersion
    })

    add_versions("2023.04.20-alpha", "8f6106a84eb6f22d1b28029741b1879081c38bd53722e5938f720397104ebc80")
    on_install(function (package)
        io.writefile("port_config.h.in", [[
#ifndef STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
#define STORAGE_LEVELDB_PORT_PORT_CONFIG_H_

${define HAVE_FDATASYNC}
${define HAVE_FULLFSYNC}
${define HAVE_O_CLOEXEC}
${define HAVE_CRC32C}
${define HAVE_SNAPPY}
${define HAVE_ZSTD}

#endif  // STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
]])
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
