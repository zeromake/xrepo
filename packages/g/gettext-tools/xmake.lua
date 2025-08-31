package("gettext-tools")
    set_kind("binary")
    set_homepage("https://github.com/vslavik/gettext-tools-windows")
    set_description("GNU gettext tools compiled binaries for Windows")
    set_license("GPL-3.0")
    set_urls("https://github.com/vslavik/gettext-tools-windows/releases/download/v$(version)/gettext-tools-windows-$(version).zip")

    --insert version
    add_versions("0.26", "31b0d12d16f4e6655bb4922332f931d69a2e105d17c5e2ebadc7a5b0735d37ff")
    add_versions("0.23.1", "0e940e04aeeba0f9e7e46977e5de1273b67fe27309afda385a0e03de6ea3d713")
    add_versions("0.23", "7242cc9caee95fb3e2dbbf7ee0fbdcea00ed1024256e54bfea4d52275605d7a7")
    on_install(function (package)
        os.cp("*", package:installdir())
    end)
