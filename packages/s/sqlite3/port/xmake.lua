add_rules("mode.debug", "mode.release")

set_encodings("utf-8")

option("explain_comments", {default = false, defines = "SQLITE_ENABLE_EXPLAIN_COMMENTS"})
option("dbpage_vtab", {default = false, defines = "SQLITE_ENABLE_DBPAGE_VTAB"})
option("stmt_vtab", {default = false, defines = "SQLITE_ENABLE_STMTVTAB"})
option("dbstat_vtab", {default = false, defines = "SQLITE_ENABLE_DBSTAT_VTAB"})
option("math_functions", {default = false, defines = "SQLITE_ENABLE_MATH_FUNCTIONS"})
option("rtree", {default = false, defines = "SQLITE_ENABLE_RTREE"})
option("safe_mode", {default = "1"})

target("sqlite3")
    set_kind("$(kind)")
    add_files("sqlite3.c")
    add_headerfiles("sqlite3.h", "sqlite3ext.h")
    add_options(
        "explain_comments",
        "dbpage_vtab",
        "stmt_vtab",
        "dbstat_vtab",
        "math_functions",
        "rtree"
    )
    if has_config("safe_mode") then
        add_defines("SQLITE_THREADSAFE=" .. get_config("safe_mode"))
    end
    if is_kind("shared") and is_plat("windows", "mingw") then
        add_defines("SQLITE_API=__declspec(dllexport)")
    end

target("sqlite3_cli")
    set_basename("sqlite3")
    add_files("shell.c")
    add_deps("sqlite3")
