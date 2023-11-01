import("core.base.option")

local packagesDir = path.join(os.scriptdir(), "../packages")

local options = {
    {nil, "packages",  "vs", nil, "The package name."},
    {"o", "options",  "k",  nil, "Enable options template."}
}

function package_script(opt)
    local out = io.open(opt.out, "w")
    if opt.options then
        out:write([[
local options = {}

]])
    end
    out:writef([[
package("%s")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("Todo")

    add_versions("0.0.0", "sha256")
]], opt.package)
    if opt.options then
        out:write([[
    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)
]])
    end
    out:write([[
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
]])
    if opt.options then
        out:write([[
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
]])
    end
    out:write([[
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)]])
    out:close()
end

function package_target_script(opt)
    local out = io.open(opt.out, "w")
    out:write([[
includes("check_cincludes.lua")
add_rules("mode.debug", "mode.release")

]])
    if opt.options then
        out:write([[
local options = {}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op, {system=false})
    end
end
]])
    end
    out:writef([[
if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

target("%s")
    set_kind("$(kind)")

    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")
]], opt.package)
    if opt.options then
        out:write([[
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end
]])
    end
    out:write([[
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
]])
end
-- the main entry
function main(...)
    -- parse arguments
    local argv = option.parse({...}, options, "create packages from template.")
    print(argv)
    for idx, package in ipairs(argv.packages) do
        local prefix = package:sub(1, 1):lower()
        local package_name = package:lower()
        local packageDir = path.join(packagesDir, prefix, package_name)
        local package_out = path.join(packageDir, "xmake.lua")
        local package_target_out = path.join(packageDir, "port", "xmake.lua")
        print(package_out)
        if not os.exists(package_out) then
            os.mkdir(path.join(packageDir, "port"))
            package_script({out=package_out, package=package_name, options=argv.options})
            package_target_script({out=package_target_out,package=package_name,options=argv.options})
            printf("generate %s done\n", package_name)
        end
    end
end
