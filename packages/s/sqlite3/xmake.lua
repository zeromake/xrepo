package("sqlite3")
    set_homepage("https://sqlite.org/index.html")
    set_description("SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine.")
    set_license("MIT")

    set_urls("https://sqlite.org/$(version)", {version = function (version)
        local year = tostring(version):match("+(%d+)%.%d+$")
        version_str = version:gsub(year, ""):gsub("[.+]", "")
        if #version_str < 7 then
            version_str = version_str .. "00"
        end
        return year .. "/sqlite-autoconf-" .. version_str .. ".tar.gz"
    end})

    --insert version
    add_versions("3.50.0+2025.400", "a3db587a1b92ee5ddac2f66b3edb41b26f9c867275782d46c3a088977d6a5b18")

    add_versions("3.50.0+2025.100", "00a65114d697cfaa8fe0630281d76fd1b77afcd95cd5e40ec6a02cbbadbfea71")
    add_versions("3.50.0+2025.000", "3bc776a5f243897415f3b80fb74db3236501d45194c75c7f69012e4ec0128327")
    add_versions("3.49.0+2025.200", "5c6d8697e8a32a1512a9be5ad2b2e7a891241c334f56f8b0fb4fc6051e1652e8")
    add_versions("3.49.0+2025.100", "106642d8ccb36c5f7323b64e4152e9b719f7c0215acf5bfeac3d5e7f97b59254")
    add_versions("3.49.0+2025.000", "4d8bfa0b55e36951f6e5a9fb8c99f3b58990ab785c57b4f84f37d163a0672759")
    add_versions("3.48.0+2025.000", "ac992f7fca3989de7ed1fe99c16363f848794c8c32a158dafd4eb927a2e02fd5")
    add_versions("3.47.0+2024.200", "f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b")
    add_versions("3.46.0+2024.100", "67d3fe6d268e6eaddcae3727fce58fcc8e9c53869bdd07a0c61e38ddf2965071")
    add_versions("3.40.0+2022.0", "0333552076d2700c75352256e91c78bf5cd62491589ba0c69aed0a81868980e7")

    add_configs("explain_comments", { description = "Inserts comment text into the output of EXPLAIN.", default = true, type = "boolean"})
    add_configs("dbpage_vtab",      { description = "Enable the SQLITE_DBPAGE virtual table.", default = true, type = "boolean"})
    add_configs("stmt_vtab",        { description = "Enable the SQLITE_STMT virtual table logic.", default = true, type = "boolean"})
    add_configs("dbstat_vtab",      { description = "Enable the dbstat virtual table.", default = true, type = "boolean"})
    add_configs("math_functions",   { description = "Enable the built-in SQL math functions.", default = true, type = "boolean"})
    add_configs("rtree",            { description = "Enable R-Tree.", default = false, type = "boolean"})
    add_configs("safe_mode",        { description = "Use thread safe mode in 0 (single thread) | 1 (serialize) | 2 (mutli thread).", default = "1", type = "string", values = {"0", "1", "2"}})
    add_configs("cli",              { description = "Build the sqlite3 command line shell.", default = false, type = "boolean"})

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for opt, value in pairs(package:configs()) do
            if not package:extraconf("configs", opt, "builtin") then
                configs[opt] = value
            end
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sqlite3_libversion_number()", {includes = "sqlite3.h"}))
    end)
