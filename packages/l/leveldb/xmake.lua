local function getVersion(version)
    local versions ={
        ["2023.04.20-alpha"] = "archive/068d5ee1a3ac40dabd00d211d5013af44be55bea.tar.gz",
        ["2024.08.23-alpha"] = "archive/23e35d792b9154f922b8b575b12596a4d8664c65.tar.gz",
        ["2025.01.02-alpha"] = "archive/578eeb702ec0fbb6b9780f3d4147b1076630d633.tar.gz",
        --insert getVersion
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

    --insert version
    add_versions("2025.01.02-alpha", "c58e40a01965df629f6c21790bce2c94426df47facbd347f50352d4b0b2f7519")
    add_versions("2024.08.23-alpha", "eebf7bdda256c7d6ae689c7db3400180ddb07852dbca187caad1f5a42299f56d")
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
