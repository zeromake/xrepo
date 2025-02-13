package("gettext-tools")
    set_kind("binary")
    set_homepage("https://github.com/vslavik/gettext-tools-windows")
    set_description("GNU gettext tools compiled binaries for Windows")
    set_license("GPL-3.0")
    set_urls("https://github.com/vslavik/gettext-tools-windows/releases/download/v$(version)/gettext-tools-windows-$(version).zip")

    --insert version
    add_versions("0.23.1", "b73c6b0c09906eb147bd7aadf8e5ae2aa682117c163c1cf4a2964c03e579be07")
    add_versions("0.23", "7242cc9caee95fb3e2dbbf7ee0fbdcea00ed1024256e54bfea4d52275605d7a7")
    on_install(function (package)
        os.cp("*", package:installdir())
    end)
