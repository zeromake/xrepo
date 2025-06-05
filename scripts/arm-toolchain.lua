
local filename_template = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${host_arch}-${suffix}${ext}"

local toolchainOptions = {
    windows = {
        x86 = "mingw-w64-i686",
        x64 = "mingw-w64-x86_64",
        ext = ".zip",
    },
    macosx = {
        x86_64 = "darwin-x86_64",
        arm64 = "darwin-arm64",
        ext = ".tar.xz",
    },
    linux = {
        x86_64 = "x86_64",
        arm64 = "aarch64",
        ext = ".tar.xz",
    },
}
local filename_suffix_template = {
    {
        arm = "arm-none-eabi",
        arm64 = "aarch64-none-elf",
    },
    {
        arm = "arm-none-linux-gnueabihf",
        arm64 = "aarch64-none-linux-gnu",
    },
}

local function generateUrls(version)
    local gsub_version = version:gsub("0%-rel", "rel")
    local urls = {}
    local hosts = table.keys(toolchainOptions)
    table.sort(hosts)
    for _, host in ipairs(hosts) do
        local hostOpts = toolchainOptions[host]
        for _, suffix_index in ipairs({1, 2}) do
            for _, key in ipairs({"arm", "arm64"}) do
                local suffix = filename_suffix_template[suffix_index][key]
                local ext = hostOpts.ext or ""
                local archs = table.keys(hostOpts)
                table.sort(archs)
                for _, arch in ipairs(archs) do
                    local toolchainName = hostOpts[arch]
                    if arch == "ext" or (host == "macosx" and suffix_index == 2) then
                        goto continue
                    end
                    local params = {
                        host_arch = toolchainName,
                        suffix = suffix,
                        ext = ext,
                        version = gsub_version,
                    }
                    local template = filename_template
                    for k, v in pairs(params) do
                        template = template:gsub("%${" .. k .. "}", v)
                    end
                    -- print(host..'\t'..arch..'\t'..key..'\t'..(suffix_index-1)..'\t'..template)
                    urls[#urls + 1] = {
                        host = host,
                        arch = arch,
                        target = key,
                        gnu = suffix_index - 1,
                        url = template,
                    }
                    ::continue::
                end
            end
        end
    end
    return urls
end

function _download_file(url, out)
    print('download('..out..'): '..url)
    os.execv('curl', {
        '-L',
        '-o',
        out,
        url
    })
    if os.filesize(out) < 512 then
        os.rm(out)
        assert(false, '下载失败')
    end
end

function main()
    local version = "14.2.0-rel1"  -- Example version
    local urls = generateUrls(version)
    local dir = path.join(os.scriptdir(), "../downloads/arm-toolchain")
    os.mkdir(dir)
    local output = {
        {},
        {},
    }
    for _, url_info in ipairs(urls) do
        print(url_info.host, url_info.arch, url_info.target, url_info.gnu, url_info.url)
        local download_path = path.join(dir, path.filename(url_info.url))
        if not os.exists(download_path) then
            _download_file(url_info.url, download_path)
        end
        download_sha256 = hash.sha256(download_path)
        print(url_info.host, url_info.arch, url_info.target, url_info.gnu, download_sha256, url_info.url)
        if output[url_info.gnu + 1][url_info.target] == nil then
            output[url_info.gnu + 1][url_info.target] = {}
        end
        if output[url_info.gnu + 1][url_info.target][url_info.host] == nil then
            output[url_info.gnu + 1][url_info.target][url_info.host] = {}
        end
        output[url_info.gnu + 1][url_info.target][url_info.host][url_info.arch] = download_sha256
    end
    print("hashsums = ", output)
end

-- https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-aarch64-aarch64-none-eabi.tar.xz
-- https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-aarch64-aarch64-none-elf.tar.xz
