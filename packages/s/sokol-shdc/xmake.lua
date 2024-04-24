
package("sokol-shdc")
    set_kind("binary")
    set_license("MIT")
    set_homepage("https://github.com/floooh/sokol-tools")
    local hash = "74c6bb111d51121fa288f1787c9df5a56545bbfd"
    local url_prefix = "https://github.com/floooh/sokol-tools-bin/raw/"..hash.."/bin/"
    local url_suffix = "win32/sokol-shdc.exe"
    if is_host("macosx") then
        if os.arch() == "arm64" then
            url_suffix = "osx_arm64/sokol-shdc"
            add_versions("latest", "ae4064824ea079d10cdc5e0aef8e3a11308ef4acc0b64add651194620f5f7037")
        else
            url_suffix = "osx/sokol-shdc"
            add_versions("latest", "b8f263b9e08f6e62bd6f0c061922243c8b00cc2a02770f47185d65bf8f2eddfc")
        end
    elseif is_host("linux") then
        url_suffix = "linux/sokol-shdc"
        add_versions("latest", "fffc93a057ae27fbdf98822a87a7419cdcda3163a3842b65da2a14b886cc15a5")
    else
        add_versions("latest", "ff0faf3547996078b037816387b3c84874b447b29f0f1a09088b1c06822c91bd")
    end
    set_urls(url_prefix..url_suffix)
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
