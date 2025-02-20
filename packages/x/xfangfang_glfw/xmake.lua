local function getVersion(version)
    local versions = {
        ['2023.04.15-alpha'] = 'archive/288235ec228582bf2bc9cf7765261e4d12426cfb.tar.gz',
        ['2024.02.26-alpha'] = 'archive/823dd308d8c596ba9e9bbf77cdca0574d00ae5e2.tar.gz',
        ["2024.09.12-alpha"] = "archive/5af677b5dd7a43059747984b12e27c117601d304.tar.gz",
        ["2025.02.19-alpha"] = "archive/892256c3f630739fb02552544b8d83240883ec8a.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("xfangfang_glfw")
    set_homepage("https://github.com/xfangfang/glfw")
    set_description("glfw")
    set_license("MIT")
    set_urls("https://github.com/xfangfang/glfw/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.02.19-alpha", "4d325f5bec421537d563e3736ba2f508c5a09ce41393b7a921a5036a7018c504")
    add_versions("2024.09.12-alpha", "2ff9177caba83b4f4b10d88275e8a1b4f9b14cbe2b9936505fcbf727e4ca7759")
    add_versions("2023.04.15-alpha", "ec99f7a754be6e41de39ff4260ff2b3488691917abe9cdaef7fd818acd078165")
    add_versions("2024.02.26-alpha", "7f15797992f2c60689e169f0c1a8fc3c052e28f0a04c07da3442d7ee92aee6e7")
    add_deps("cmake")
    add_deps("opengl", {optional = true})
    if is_plat("macosx") then
        add_frameworks("Cocoa", "IOKit")
    elseif is_plat("windows") then
        add_syslinks("user32", "shell32", "gdi32")
    elseif is_plat("mingw") then
        add_syslinks("gdi32")
    elseif is_plat("linux") then
        -- TODO: add wayland support
        add_deps("libx11", "libxrandr", "libxrender", "libxinerama", "libxfixes", "libxcursor", "libxi", "libxext")
        add_syslinks("dl", "pthread")
        add_defines("_GLFW_X11")
    end
    on_install(function (package)
        local configs = {"-DGLFW_BUILD_DOCS=OFF", "-DGLFW_BUILD_TESTS=OFF", "-DGLFW_BUILD_EXAMPLES=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        if package:is_plat("windows") then
            table.insert(configs, "-DUSE_MSVC_RUNTIME_LIBRARY_DLL=" .. (package:config("vs_runtime"):startswith("MT") and "OFF" or "ON"))
        end
        if package:is_plat("linux") then
            import("package.tools.cmake").install(package, configs, {packagedeps = {"libxrender", "libxfixes", "libxext", "libx11"}})
        else
            import("package.tools.cmake").install(package, configs)
        end
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
