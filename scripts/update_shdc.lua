import("core.base.option")
import("core.base.bytes")

local options = {
    {'s', 'secret', "kv", nil, "github 认证"}
}


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




function main(...)
    -- parse arguments
    local argv = option.parse({...}, options, "检查 sokol-shdc 是否有需要更新")
    local secret = argv.secret
    local repo = 'floooh/sokol-tools-bin'
    local sha, date = get_alpha_latest(repo, secret)
    print('latest alpha: ', date, sha)
    local urls = {
        ['osx'] = 'https://github.com/floooh/sokol-tools-bin/raw/$(hash)/bin/osx/sokol-shdc',
        ['osx_arm64'] = 'https://github.com/floooh/sokol-tools-bin/raw/$(hash)/bin/osx_arm64/sokol-shdc',
        ['linux'] = 'https://github.com/floooh/sokol-tools-bin/raw/$(hash)/bin/linux/sokol-shdc',
        ['windows'] = 'https://github.com/floooh/sokol-tools-bin/raw/$(hash)/bin/win32/sokol-shdc.exe',
    }
    local result = {hash = sha}
    for platform, url in pairs(urls) do
        download_url = url:gsub('$%(hash%)', sha)
        local filename = hash.md5(bytes(download_url))
        local filepath = 'downloads/'..filename
        _download_file(download_url, filepath)
        local download_sha256 = ""
        if os.exists(filepath) then
            download_sha256 = hash.sha256('./'..filepath)
        end
        result[platform] = download_sha256
    end
    print(string.serialize({[date] = result}))
end
