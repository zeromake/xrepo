add_rules("mode.debug", "mode.release")

set_languages("c99", "c++17")

option("opencl")
    set_default(false)
    set_showmenu(true)
    set_description("Enable OpenCL support")
option_end()

add_requires("zstd")

if get_config("opencl") then
    add_requires("opencl")
    add_defines("BASISU_SUPPORT_OPENCL=1")
end

add_defines(
    "BASISD_SUPPORT_KTX2=1",
    "BASISD_SUPPORT_KTX2_ZSTD=1",
    "BASISD_SUPPORT_UASTC_HDR=1",
    "BASISD_SUPPORT_UASTC=1",
    "BASISD_SUPPORT_BC7=1",
    "BASISU_SUPPORT_ENCODING=1"
)

target("transcoder")
    set_kind("$(kind)")
    add_packages("zstd")
    add_files("transcoder/*.cpp")

target("basisu")
    if get_config("opencl") then
        add_packages("opencl")
    end
    add_packages("zstd")
    add_files(
        "basisu_tool.cpp",
        "encoder/*.cpp",
        "encoder/3rdparty/*.cpp",
        "transcoder/*.cpp"
    )
