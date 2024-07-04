import("core.base.option")
import("core.base.bytes")

local options = {
    {'d', "download",  "k",  nil, "是否写入"}
,   {'w', "write",  "k",  nil, "是否写入"}
,   {'s', 'secret', "kv", nil, "github 认证"}
,   {nil, "packages", "vs", nil, "筛选包"}
}

local function sdl_version_transform(version)
    return version:sub(9):gsub('_', '.')
end

function string.rfind(str, substr, plain)
    assert(substr ~= "")
    local plain = plain or false
    local index = 0
    while true do
      local new_start, _ = string.find(str, substr, index, plain)
      if new_start == nil then
              if index == 0 then return nil end
        return #str - #str:sub(index)
      end
      index = new_start + 1
    end
end

local version_transform = {
    unibreak = function (version) return version:sub(13):gsub('_', '.') end,
    expat = function (version) return version:sub(3):gsub('_', '.') end,
    sdl2 = sdl_version_transform,
    sdl2_image = sdl_version_transform,
    sdl12_compat = sdl_version_transform,
    sdl2_ttf = sdl_version_transform,
    sdl2_mixer = sdl_version_transform,
    cppwinrt = function (version)
        local index = string.rfind(version, '.', true)
        return version:sub(1, index-1).."-release"..version:sub(index)
    end,
    spirv_reflect = function (version)
        local start = string.rfind(version, '-', true)
        local index = string.rfind(version, '.', true)
        return version:sub(start+1, index-1).."-release"..version:sub(index)
    end,
    curl = function (version) return version:sub(6):gsub('_', '.') end,
    pcre2 = function (version) return version:sub(7) end,
    wolfssl = function (version) return version:sub(1, version:find('-')-1) end,
    ssh2 = function (version) return version:sub(9) end,
    libressl = function (version)
        local start = 2
        local index = string.rfind(version, '.', true) - 1
        return version:sub(start, index)
    end,
    spirv_headers = function (version)
        version = version:sub(11)
        local index = string.rfind(version, '.', true)
        return version:sub(1, index-1).."-release"..version:sub(index)
    end
}

local function default_transform(opt, prefix, suffix)
    suffix = suffix or '.tar.gz'
    return 'https://github.com/'..opt.repo..'/releases/download/'..opt.tag..'/'..prefix..opt.version..suffix
end

local download_transform = {
    archive = function (opt) return default_transform(opt, 'libarchive-') end,
    cppwinrt = function (opt)
        return 'https://github.com/'..opt.repo..'/releases/download/'..opt.tag..'/Microsoft.Windows.CppWinRT.'..opt.tag..'.nupkg'
    end,
    curl = function (opt) return default_transform(opt, 'curl-', '.tar.bz2') end,
    expat = function (opt) return default_transform(opt, 'expat-', '.tar.bz2') end,
    fmt = function (opt) return default_transform(opt, 'fmt-', '.zip') end,
    fribidi = function (opt) return default_transform(opt, 'fribidi-', '.tar.xz') end,
    harfbuzz = function (opt) return default_transform(opt, 'harfbuzz-', '.tar.xz') end,
    pcre2 = function (opt) return default_transform(opt, 'pcre2-', '.tar.bz2') end,
    pugixml = function (opt) return default_transform(opt, 'pugixml-') end,
    raqm = function (opt) return default_transform(opt, 'raqm-', '.tar.xz') end,
    sdl2 = function (opt) return default_transform(opt, 'SDL2-') end,
    sdl2_mixer = function (opt) return default_transform(opt, 'SDL2_mixer-') end,
    sdl2_ttf = function (opt) return default_transform(opt, 'SDL2_ttf-') end,
    sdl2_image = function (opt) return default_transform(opt, 'SDL2_image-') end,
    tweeny = function (opt) return default_transform(opt, 'tweeny-') end,
    unibreak = function (opt) return default_transform(opt, 'libunibreak-') end,
    zlib = function (opt) return default_transform(opt, 'zlib-') end,
    zstd = function (opt) return default_transform(opt, 'zstd-') end,
    nghttp2 = function (opt) return default_transform(opt, 'nghttp2-') end,
    nghttp3 = function (opt) return default_transform(opt, 'nghttp3-') end,
    ngtcp2 = function (opt) return default_transform(opt, 'ngtcp2-') end,
}


local function load_packages(filters)
    local packageDirs = nil
    if #filters > 0 then
        packageDirs = {}
        for _, name in ipairs(filters) do
            table.insert(packageDirs, "packages/"..(name:sub(1, 1):lower()).."/"..name)
        end
    else
        packageDirs = os.dirs("packages/*/*")
    end
    return packageDirs
end

function string.split(input, delimiter)
    if (delimiter == "") then return false end
    local pos, arr = 0, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function get_release_latest(repo, secret)
    local outdata, errdata = os.iorunv('curl', {
        '-i',
        "-u",
        "my_client_id:"..secret,
        'https://github.com/'..repo..'/releases/latest'
    })
    local _start = string.find(outdata, 'location:')
    _start = string.find(outdata, 'releases/tag', _start + 9)
    if _start then
        _start = _start + 13
        local _end = string.find(outdata, '\n', _start)
        return outdata:sub(_start, _end-1)
    else
        local outdata, errdata = os.iorunv('curl', {
            '-L',
            "-u",
            "my_client_id:"..secret,
            'https://github.com/'..repo..'/tags'
        })
        _start = string.find(outdata, '/releases/tag/')
        if _start == nil then
            return nil
        end
        _start = _start + 14
        local _end = string.find(outdata, '"', _start)
        return outdata:sub(_start, _end-1)
    end
end

function get_alpha_latest(repo, secret)
    local url = 'https://api.github.com/repos/'..repo..'/commits?per_page=1'
    local outdata, errdata = os.iorunv('curl', {
        "-u",
        "my_client_id:"..secret,
        url
    })
    local _sha_start = string.find(outdata, '"sha":')
    local _sha_start = string.find(outdata, '"', _sha_start+6)
    local _sha_end = string.find(outdata, '"', _sha_start+1)
    local sha = outdata:sub(_sha_start+1, _sha_end-1)

    local _commit_start = string.find(outdata, '"commit":')
    local _committer_start = string.find(outdata, '"committer":', _commit_start)
    local _date_start = string.find(outdata, '"date":', _committer_start)
    local _date_start = string.find(outdata, '"', _date_start + 7)
    local _date_end = string.find(outdata, 'T', _date_start)

    local _date = outdata:sub(_date_start+1, _date_end-1):gsub('-', '.')
    return sha, _date
end

function download_file(repo, opt)
    local is_release = opt.release or false
    local download_url = nil
    if opt.url then
        download_url = opt.url
    elseif is_release then
        download_url = 'https://github.com/'..repo..'/archive/refs/tags/'..opt.tag..'.tar.gz'
    else
        download_url = 'https://github.com/'..repo..'/archive/'..opt.sha..'.tar.gz'
    end
    if not os.exists('downloads') then
        os.mkdir('downloads')
    end
    local filename = hash.md5(bytes(download_url))
    local filepath = 'downloads/'..filename
    print('download', download_url, filepath)
    if not os.exists(filepath) and opt.download then
        os.runv('curl', {
            '-L',
            '-o',
            filepath,
            download_url
        })
        if os.filesize(filepath) < 512 then
            os.rm(filepath)
            assert(false, '下载失败')
        end
    end
    return filepath
end

function main(...)
    -- parse arguments
    local argv = option.parse({...}, options, "检查是否有包需要更新")
    local packageDirs = load_packages(argv.packages or {})
    for _, packageDir in ipairs(packageDirs) do
        local packageName = path.filename(packageDir)
        local xmakePath = path.join(packageDir, "xmake.lua")
        if not os.exists(xmakePath) then
            goto continue
        end
        local xmakeContext = io.readfile(xmakePath)
        local urls = {}
        local _prev = 0
        while true do
            local _start = string.find(xmakeContext, 'set_urls%("https://github%.com', _prev)
            if _start == nil then break end
            _start = _start + 29
            local _end = string.find(xmakeContext, '"', _start)
            if _end == nil then break end
            table.insert(urls, xmakeContext:sub(_start, _end-1))
            _prev = _end
        end
        if #urls ~= 1 then
            goto continue
        end
        local versions = {}
        _prev = 0
        local has_release = false
        local has_alpha = false
        while true do
            local _start = string.find(xmakeContext, 'add_versions%("', _prev)
            if _start == nil then break end
            _start = _start + 14
            local _end = string.find(xmakeContext, '"', _start)
            if _end == nil then break end
            local version_string = xmakeContext:sub(_start, _end-1)
            if not version_string:match('20%d%d%.') then
                has_release = true
            else
                has_alpha = true
            end
            versions[version_string] = true
            _prev = _end
        end
        local url = string.split(urls[1], "/")
        has_alpha = #url == 3 and has_alpha
        -- 先获取版本
        local repo = url[1].."/"..url[2]
        -- print('check', repo, string.serialize(versions))
        if has_release then
            -- print("fetch "..repo.." latest version")
            local latest_version = get_release_latest(repo, argv.secret)
            if latest_version ~= nil then
                local latest_tag = latest_version
                if latest_version:startswith('v') then
                    latest_version = latest_version:sub(2)
                end
                if version_transform[packageName] then
                    latest_version = version_transform[packageName](latest_version)
                end
                if versions[latest_version] == nil then
                    local filename = latest_tag..'.tar.gz'
                    local option = {
                        repo = repo,
                        release = true,
                        tag = latest_tag,
                        version = latest_version,
                        download = argv.download
                    }
                    if download_transform[packageName] ~= nil then
                        option.url = download_transform[packageName](option)
                    end
                    local download_path = download_file(repo, option)
                    local download_sha256 = nil
                    if os.exists(download_path) then
                        download_sha256 = hash.sha256('./'..download_path)
                    end
                    print('\n', packageDir, '-------------release new-------------')
                    print('add_versions("'..latest_version..'", "'..(download_sha256 or 'nil')..'")')
                end
            end
        end
        if has_alpha then
            -- print("fetch "..repo.." alpha version")
            local alpha_sha, alpha_date = get_alpha_latest(repo, argv.secret)
            local alpha_version = alpha_date.."-alpha"
            if versions[alpha_version] == nil then
                local option = {
                    sha = alpha_sha,
                    download = argv.download
                }
                local download_path = download_file(repo, option)
                local download_sha256 = nil
                if os.exists(download_path) then
                    download_sha256 = hash.sha256('./'..download_path)
                end
                print('\n', packageDir, '-------------alpha new-------------')
                print('["'..alpha_version..'"] = "archive/'..alpha_sha..'.tar.gz",')
                print('add_versions("'..alpha_version..'", "'..(download_sha256 or 'nil')..'")')
            end
        end
        ::continue::
    end
end
