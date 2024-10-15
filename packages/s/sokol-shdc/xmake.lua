local function getVersion(version)
    local versions ={
        ["2024.05.17-alpha"] = "3162485457dbe6c7ca8d145bb26db172aed3e44e",
        ["2024.09.05-alpha"] = "0732ba3f61dcfd0d0988f4c351421d84ec8b67e4",
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
