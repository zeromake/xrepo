package("rxcpp")
    set_homepage("https://github.com/ReactiveX/RxCpp")
    set_description("Reactive Extensions for C++")
    set_license("MIT")
    set_urls("https://github.com/ReactiveX/RxCpp/archive/refs/tags/v$(version).tar.gz")

    add_versions("4.1.1", "054a9be63e66904ecaa552ce56d6458b4545d6da5ea32f5103c7fc379cebb374")
    on_install(function (package)
        os.cp("Rx/v2/src/rxcpp", package:installdir("include").."/")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
