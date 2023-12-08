import("core.base.option")
local options = {
    {nil, "packages",  "vs", nil, "The package name."},
}

function main(...)
    local argv = option.parse({...}, options, "create packages from template.")
    local packages = argv.packages
    for idx, package in ipairs(argv.packages) do
        local dir = format('packages/n/nonstd.%s', package)
        os.mkdir(dir)
        local f = io.open(path.join(dir, "xmake.lua"), "wb")
        f:writef('package("nonstd.%s")\n', package)
        f:writef([[
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/%s-lite")
    set_description("expected lite - Expected objects in C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/%s-lite/archive/refs/tags/v$(version).tar.gz")

    add_versions("%s", "%s")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
]], package, package, "1.0.1", "xxx")
        f:close()
    end
end
