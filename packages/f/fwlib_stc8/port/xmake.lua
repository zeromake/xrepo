add_rules("mode.debug", "mode.release")

set_encodings("utf-8")
add_requires("sdcc", "zeromake.rules")

option("model")
    set_default("STC8H1K08")
    set_showmenu(true)
option_end()
    

target("fwlib_stc8")
    set_kind("$(kind)")
    add_packages("sdcc", "zeromake.rules")
    set_toolchains("@sdcc")
    add_rules("@zeromake.rules/mcs51", {model = get_config("model")})
    add_files("src/*.c")
    add_includedirs("include")
    add_headerfiles("include/*.h")
