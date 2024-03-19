if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

add_requires(
    "boost",
    "rapidjson",
    "fmt",
    "nonstd.expected",
    "nonstd.variant",
    "nonstd.optional",
    "nonstd.string_view"
)

target("jinja2cpp")
    set_kind("$(kind)")
    add_packages(
        "boost",
        "rapidjson",
        "fmt",
        "nonstd.expected",
        "nonstd.variant",
        "nonstd.optional",
        "nonstd.string_view"
    )
    set_languages("c++14")
    add_files("src/*.cpp")
    add_files("src/binding/rapid_json_serializer.cpp")
    add_includedirs("include")
    add_headerfiles("include/jinja2cpp/*.h", {prefixdir = "jinja2cpp"})
    add_defines(
        "JINJA2CPP_USE_REGEX_BOOST",
        "BOOST_SYSTEM_NO_DEPRECATED",
        "BOOST_ERROR_CODE_HEADER_ONLY"
    )
    if is_kind("shared") then
        add_defines("JINJA2CPP_BUILD_AS_SHARED")
    end
