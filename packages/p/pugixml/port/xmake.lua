if xmake.version():ge("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cxxtypes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local options = {
    "wchar",
    "compact",
    "no_xpath",
    "no_stl",
    "no_exceptions"
}
for _, k in ipairs(options) do
option(k)
    set_default(false)
    set_showmenu(true)
option_end()
end
target("pugixml")
    set_kind("$(kind)")
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("pugiconfig.hpp.in")

    add_headerfiles("src/pugixml.hpp")
    add_headerfiles("$(buildir)/config/pugiconfig.hpp")

    configvar_check_cxxtypes("PUGIXML_HAS_LONG_LONG", "long long")
    if not is_kind("headeronly") then
        for i, k in ipairs(options) do
            if get_config(k) then
                if k == 'wchar' then
                    set_configvar("PUGIXML_WCHAR_MODE", 1)
                elseif k == 'compact' then
                    set_configvar("PUGIXML_COMPACT", 1)
                elseif k == 'no_xpath' then
                    set_configvar("PUGIXML_NO_XPATH", 1)
                elseif k == 'no_stl' then
                    set_configvar("PUGIXML_NO_STL", 1)
                elseif k == 'no_exceptions' then
                    set_configvar("PUGIXML_NO_EXCEPTIONS", 1)
                end
            end
        end
        if is_plat("windows", "mingw") and is_kind("shared") then
            add_defines("PUGIXML_API=__declspec(dllexport)")
        end
        add_files("src/*.cpp")
    else
        add_headerfiles("src/*.cpp")
        set_configvar("PUGIXML_HEADER_ONLY", 1)
    end
