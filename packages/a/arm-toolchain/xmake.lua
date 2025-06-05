local filename_template = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${host_arch}-${suffix}${ext}"

local toolchainOptions = {
    windows = {
        x86 = "mingw-w64-i686",
        x64 = "mingw-w64-x86_64",
        ext = ".zip",
    },
    macosx = {
        x86_64 = "darwin-x86_64",
        arm64 = "darwin-arm64",
        ext = ".tar.xz",
    },
    linux = {
        x86_64 = "x86_64",
        arm64 = "aarch64",
        ext = ".tar.xz",
    },
}
local filename_suffix_template = {
    {
        arm = "arm-none-eabi",
        arm64 = "aarch64-none-elf",
    },
    {
        arm = "arm-none-linux-gnueabihf",
        arm64 = "aarch64-none-linux-gnu",
    },
}

local hashsums = {
    ["14.2.0-rel1"] = {
        { 
            arm64 = {
                windows = {
                    x64 = "8c395a36849877d2f005fb1ac8c3611206f2f7930f15adfe95a21dd7969ca001",
                    x86 = "3143e2f0e401540cd5dc69a77d5b870ba0087f057236ea865624a0a911b7b462",
                },
                macosx = {
                    arm64 = "fc111bb4bb4871e521e3c8a89bd0af51cddfd00fe3f526f4faa09398b7c613f5",
                    x86_64 = "c02735606d69ed000cc8fae2c1467e489e1325c14a7874f553c42f7ef193fc21",
                },
                linux = {
                    arm64 = "c4f0daab43f78e0d56ec2bdad76b98a0223ce12ce7fc51a6ce82f9cc6c6dfba0",
                    x86_64 = "eb54c4727440d03199a6af9a6d021e77f45410cad39effce4e5a1c10a88b7f04",
                },
            },
            arm = {
                windows = {
                    x64 = "f074615953f76036e9a51b87f6577fdb4ed8e77d3322a6f68214e92e7859888f",
                    x86 = "6facb152ce431ba9a4517e939ea46f057380f8f1e56b62e8712b3f3b87d994e1",
                },
                macosx = {
                    arm64 = "c7c78ffab9bebfce91d99d3c24da6bf4b81c01e16cf551eb2ff9f25b9e0a3818",
                    x86_64 = "2d9e717dd4f7751d18936ae1365d25916534105ebcb7583039eff1092b824505",
                },
                linux = {
                    arm64 = "87330bab085dd8749d4ed0ad633674b9dc48b237b61069e3b481abd364d0a684",
                    x86_64 = "62a63b981fe391a9cbad7ef51b17e49aeaa3e7b0d029b36ca1e9c3b2a9b78823",
                },
            },
        },
        {
            arm64 = {
                linux = {
                    arm64 = "299c56db1644c135670afabbf801b97a42e5ef6069d73157ab869458cbda2096",
                    x86_64 = "47aeefc02b0ee39f6d4d1812110952975542d365872a7474b5306924bca4faa1" 
                },
                windows = {
                    x64 = "9428b2039923916418ec7037025be8cec3202926d65db9452519977834ad2a89",
                    x86 = "bd5f4808995af2ec647bd0fe8f62815e2c65abcf0558f38f183188d05328d0a0",
                },
            },
            arm = {
                linux = {
                    arm64 = "3fe832f9c831323a37ff54bfb5ac7a083acdd473f2c93feaf0cb3c1ac690d739",
                    x86_64 = "32301a5a33aab47810837cdab848a5a513ca22804d3168d3ada5833828b07912",
                },
                windows = {
                    x64 = "2cab956da2d1ce52ab7e7dbbef9d3689bea1c16647230cbf67414d555f043cec",
                    x86 = "ad4287244e6134b8aa232d95c3f3d9e543f599b87db19a1f5cfbbe7dda0d46aa",
                },
            },
        }
    },
}

package("arm-toolchain")
    set_homepage("https://developer.arm.com")
    set_description("Arm GNU Toolchain is a community supported pre-built GNU compiler toolchain for Arm based CPUs.")
    set_kind("toolchain")

    add_configs("gnu", {description = "Use GNU toolchain", default = false, type = "boolean"})

    on_source(function (package)
        local toolchainName = toolchainOptions[os.host()][os.arch()]
        local ext = toolchainOptions[os.host()].ext
        local key = package:is_arch("arm64.*") and "arm64" or "arm"
        local suffix_index = package:config("gnu") and 2 or 1
        local suffix = filename_suffix_template[suffix_index][key]
        local version = "14.2.0-rel1"
        local params = {
            host_arch = toolchainName,
            suffix = suffix,
            ext = ext,
            version = version:gsub("0%-rel", "rel"),
        }
        local template = filename_template
        for k, v in pairs(params) do
            template = template:gsub("%${" .. k .. "}", v)
        end
        package:set("urls", template)
        local hash = hashsums[version][suffix_index][key][os.host()][os.arch()]
        package:add("versions", version, hash)
    end)

    on_install(function (package)
        os.vcp("*", package:installdir())
        os.rm(path.join(package:installdir(), "manifest.txt"))
    end)

    on_test(function (package)
        local key = package:is_arch("arm64.*") and "arm64" or "arm"
        local suffix_index = package:config("gnu") and 2 or 1
        local exec = filename_suffix_template[suffix_index][key]
        exec = exec.."-gcc"
        if exec and is_host("windows") then
            exec = exec .. ".exe"
        end
        os.vrunv(exec, {"--version"})
    end)
