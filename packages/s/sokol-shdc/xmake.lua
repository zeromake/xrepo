local function getVersion(version)
    local versions ={
        ["2024.05.17-alpha"] = "3162485457dbe6c7ca8d145bb26db172aed3e44e",
    }
    return versions[tostring(version)]
end


package("sokol-shdc")
    set_kind("binary")
    set_license("MIT")
    set_homepage("https://github.com/floooh/sokol-tools")
    local version = "2024.05.17-alpha"
    local url_prefix = "https://github.com/floooh/sokol-tools-bin/raw/$(version)/bin/"
    local url_suffix = "win32/sokol-shdc.exe"
    if is_host("macosx") then
        if os.arch() == "arm64" then
            url_suffix = "osx_arm64/sokol-shdc"
            add_versions(version, "6633f4edf6427001b6a52c01e9d1a364ce0912e393c40a5179657da6da2ffbed")
        else
            url_suffix = "osx/sokol-shdc"
            add_versions(version, "59d13000d5aa94a4337ae88794b6c672b9ee654023b549de93e738685c0dda84")
        end
    elseif is_host("linux") then
        url_suffix = "linux/sokol-shdc"
        add_versions(version, "0331c07b47617a76af9ea8bd87fc103af1f09ea0ce82c991925e47b3887e0618")
    else
        add_versions(version, "ccf08bc0d7cd96b83273340104728204ed2673ff1c47d782494313354eba2635")
    end
    set_urls(url_prefix..url_suffix, {version = getVersion})
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
