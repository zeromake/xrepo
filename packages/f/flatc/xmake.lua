package("flatc")
    set_kind("binary")
    set_homepage("https://developers.google.com/protocol-buffers/")
    set_description("Google's data interchange format compiler")
    if is_host("windows") then
            add_urls("https://github.com/google/flatbuffers/releases/download/v24.3.25/Windows.flatc.binary.zip")
            add_versions("24.3.25", "6455f5b6272b908dad073721e21b11720a9fddbae06e28b5c75f8ec458e7fe30")
    elseif is_host("macosx") then
        if is_arch("arm.*") then
            add_urls("https://github.com/google/flatbuffers/releases/download/v24.3.25/Mac.flatc.binary.zip")
            add_versions("24.3.25", "277274f4e1037dbb57b1b95719721fe3d58c86983d634103284ad8c1d9cf19dd")
        else
            add_urls("https://github.com/google/flatbuffers/releases/download/v24.3.25/MacIntel.flatc.binary.zip")
            add_versions("24.3.25", "e38512a1acbda17692fb6381fe42d16929755403d5a26aa26ea26428b6138485")
        end
    elseif is_host("linux") then
        add_urls("https://github.com/google/flatbuffers/releases/download/v24.3.25/Linux.flatc.binary.g++-13.zip")
        add_versions("24.3.25", "af4783514309c833216b280914ecc1c993aedb1c2b476f4d499ecbf8c372920e")
    end

    on_install(function (package)
        local suffix = ""
        if is_host("windows", "mingw") then
            suffix = ".exe"
        end
        os.cp("flatc"..suffix, package:installdir("bin"))
    end)
    on_test(function (package)
        os.vexec("flatc --version")
    end)
