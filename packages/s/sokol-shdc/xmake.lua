local function getVersion(version)
    local versions ={
        ["2024.05.17-alpha"] = "3162485457dbe6c7ca8d145bb26db172aed3e44e",
        ["2024.09.05-alpha"] = "0732ba3f61dcfd0d0988f4c351421d84ec8b67e4",
        ["2024.12.10-alpha"] = "d80b1d8f20fef813092ba37f26723d3880839651",
        ["2025.02.10-alpha"] = "339ff0314f19414c248cd540b7c72de1873f3a4b",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("sokol-shdc")
    set_kind("binary")
    set_license("MIT")
    set_homepage("https://github.com/floooh/sokol-tools")
    local url_prefix = "https://github.com/floooh/sokol-tools-bin/raw/$(version)/bin/"
    local versions = {
        ["2024.05.17-alpha"] = {
            ["osx"] = "59d13000d5aa94a4337ae88794b6c672b9ee654023b549de93e738685c0dda84",
            ["osx_arm64"] = "6633f4edf6427001b6a52c01e9d1a364ce0912e393c40a5179657da6da2ffbed",
            ["linux"] = "0331c07b47617a76af9ea8bd87fc103af1f09ea0ce82c991925e47b3887e0618",
            ["windows"] = "ccf08bc0d7cd96b83273340104728204ed2673ff1c47d782494313354eba2635",
        },
        ["2024.09.05-alpha"] = {
            ["osx"] = "c7bbc5b0c09a8a48731de2dfb8114bd20c6f89ffcf7a5584ffdb5a341300e4e6",
            ["osx_arm64"] = "e5562b4166a493c18c068014eab6b528f1d748289f0baecc7f678655804c7eea",
            ["linux"] = "82031a2c5efa7587b7d484fdefdbcc0ea65313e8aa3d6af8e989b0063cbdbd26",
            ["windows"] = "fb67d82fb3129de978d16ea2e2c6ce61cbaca2450d5a800d94da34a7b5532d7c",
        },
        ["2024.12.10-alpha"] = {
            ["osx"] = "5e94bca5f2dbb1ae431ed056e88dd251847c1cf657e3450f8dc3bd1d09dfe29e",
            ["osx_arm64"] = "244ec089b54e211110850087943765288898fb47e3e399dd74c7206ec9d5f68b",
            ["linux"] = "a37ef6f67fb280796968804e2eace5081affe4e6aabe741f28e1f603b5379a1c",
            ["windows"] = "18d3977e0dcdf5f093672a7d0b90e89b5e8e7d3d1533ca8208918a82f77d6881",
        },
        ["2025.02.10-alpha"] = {
            osx_arm64 = "58e6ddcbf87bd1f1ef9dc8d70eb494798367918c29263721b78ed93c0ff97d3d",
            osx = "955205131301bb37fdcab61fbe649e2d0b360d71b69666bb7f08baea861254cb",
            linux = "a43361773f6b21af550b67428cc7c382adce729c582c6cc2aee922cf9db17488",
            windows = "64138ba4fcf3317483efdacdeb04cb33f7c1776ceb29d9e5fb9f5284cdec7210",
        },
        ["2025.10.22-alpha"] = {
            osx = "e259a445968180c01f3f0ae9987e4b381a7afda1e3c342e38422d5f7e218b337",
            osx_arm64 = "effb4e459763b8581d53b2fd552fa52ee1cafeaae4a52a66a0a341e02868dcdb",
            linux = "8677d2c3cb9683be7d88440c6fd20b8dba25d2062669c628dfa6f6d2ae488a8c",
            windows = "44ecd7bb0101164fe6cc8d96130e0ffd6a3289dd4533e06fb02f176074d03176",
        },
    }
    local url_suffix = "win32/sokol-shdc.exe"
    if is_host("macosx") then
        if os.arch() == "arm64" then
            url_suffix = "osx_arm64/sokol-shdc"
        else
            url_suffix = "osx/sokol-shdc"
        end
    elseif is_host("linux") then
        url_suffix = "linux/sokol-shdc"
    end
    set_urls(url_prefix..url_suffix, {version = getVersion})
    for ver, hashs in pairs(versions) do
        local hash = hashs["windows"]
        if is_host("macosx") then
            if os.arch() == "arm64" then
                hash = hashs["osx_arm64"]
            else
                hash = hashs["osx"]
            end
        elseif is_host("linux") then
            hash = hashs["linux"]
        end
        add_versions(ver, hash)
    end
    on_install(function (package)
        local bin = package:installdir("bin")
        if is_host("windows") then
            os.cp("../sokol-shdc.exe", bin)
        else
            os.run("chmod 755 ../sokol-shdc")
            os.cp("../sokol-shdc", bin)
        end
    end)
    on_test(function (package)
        os.vrun("sokol-shdc --help")
    end)
