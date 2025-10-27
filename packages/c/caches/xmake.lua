package("caches")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/vpetrigo/caches")
    set_description("C++ cache with LRU/LFU/FIFO policies implementation ")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/vpetrigo/caches/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.1.1", "ac822a2b3ff10f29e402dbbc3837fc0c7559e41b65157148e2caea1c4513e27b")
    add_versions("0.1.0", "306c5ed98838e1ccd88aa62ec054eba391c5d808b9e657306e07853fe980e3de")
    add_versions("0.0.5", "4f9175f87e7b3d2365f512ec66b7cd6712294f17befcc3607b1020a9729fcad3")
    on_install(function (package)
        os.cp("include/*.hpp", package:installdir("include"))
    end)
