local files = {
    "crypto/params_idx.c.in",

    "include/crypto/bn_conf.h.in",
    "include/crypto/dso_conf.h.in",

    "include/internal/param_names.h.in",

    "include/openssl/configuration.h.in",
    "include/openssl/asn1.h.in",
    "include/openssl/asn1t.h.in",
    "include/openssl/bio.h.in",
    "include/openssl/cmp.h.in",
    "include/openssl/cms.h.in",
    "include/openssl/conf.h.in",
    "include/openssl/core_names.h.in",
    "include/openssl/crmf.h.in",
    "include/openssl/crypto.h.in",
    "include/openssl/ct.h.in",
    "include/openssl/err.h.in",
    "include/openssl/ess.h.in",
    "include/openssl/fipskey.h.in",
    "include/openssl/lhash.h.in",
    "include/openssl/ocsp.h.in",
    "include/openssl/opensslv.h.in",
    "include/openssl/pkcs12.h.in",
    "include/openssl/pkcs7.h.in",
    "include/openssl/safestack.h.in",
    "include/openssl/srp.h.in",
    "include/openssl/ssl.h.in",
    "include/openssl/ui.h.in",
    "include/openssl/x509.h.in",
    "include/openssl/x509_vfy.h.in",
    "include/openssl/x509v3.h.in",


    "providers/common/include/prov/der_digests.h.in",
    "providers/common/include/prov/der_dsa.h.in",
    "providers/common/include/prov/der_ec.h.in",
    "providers/common/include/prov/der_ecx.h.in",
    "providers/common/include/prov/der_rsa.h.in",
    "providers/common/include/prov/der_sm2.h.in",
    "providers/common/include/prov/der_wrap.h.in",

    "providers/common/der/der_digests_gen.c.in",
    "providers/common/der/der_ec_gen.c.in",
    "providers/common/der/der_rsa_gen.c.in",
    "providers/common/der/der_wrap_gen.c.in",
    "providers/common/der/der_dsa_gen.c.in",
    "providers/common/der/der_ecx_gen.c.in",
    "providers/common/der/der_sm2_gen.c.in",
}

local function dofile(target, sourcefile, targetfile)
    local config = import("configuration")(target)
    local paramnames = import("paramnames")
    local stackhash = import("stackhash")
    local generate_oid = import("oid")
    local fun_ctx = {
        generate_stack_macros = stackhash.generate_stack_macros,
        generate_const_stack_macros = stackhash.generate_const_stack_macros,
        generate_stack_string_macros = stackhash.generate_stack_string_macros,
        generate_stack_const_string_macros = stackhash.generate_stack_const_string_macros,
        generate_stack_block_macros = stackhash.generate_stack_block_macros,
        generate_lhash_macros = stackhash.generate_lhash_macros,
        generate_public_macros = paramnames.generate_public_macros,
        generate_internal_macros = paramnames.generate_internal_macros,
        produce_decoder = paramnames.produce_decoder,
    }
    local internal_processor = {
        ['include/crypto/dso_conf.h.in#1'] = function(f, n, perl_content)
            if target:is_plat("windows", "mingw") then
                return ""
            end
            return '#define DSO_DLFCN\n#define HAVE_DLFCN_H'
        end,
        ['include/crypto/dso_conf.h.in#2'] = function(f, n, perl_content)
            if target:is_plat("macosx") then
                return ".dylib"
            elseif target:is_plat("windows", "mingw") then
                return ".dll"
            end
            return ".so"
        end,
        ['include/openssl/fipskey.h.in#1'] = function()
            local FIPSKEY = config.FIPSKEY
            local result = ''
            local items = {}
            for i = 1, #FIPSKEY, 2 do
                table.insert(items, string.format("0x%s", FIPSKEY:sub(i, i+1)))
            end
            return table.concat(items, ", ")
        end,
        ['include/openssl/configuration.h.in#1'] = function ()
            local openssl_sys_defines = {
                string.format('OPENSSL_SYS_%s', target:plat():upper()),
            }
            local openssl_api_defines = {
                "OPENSSL_CONFIGURED_API "..config.api,
            }
            local openssl_feature_defines = {
                "OPENSSL_RAND_SEED_OS",
                "OPENSSL_THREADS",
                "OPENSSL_NO_KTLS",
                "OPENSSL_NO_SCTP",
                "OPENSSL_NO_BROTLI",
                "OPENSSL_NO_ZSTD",
                "OPENSSL_NO_UPLINK",
                "OPENSSL_NO_MD2",
                "OPENSSL_NO_RC5",
                "OPENSSL_NO_AFALGENG",
                "OPENSSL_NO_STATIC_ENGINE",
                "OPENSSL_NO_WINSTORE",
                "OPENSSL_NO_QUIC",
                "OPENSSL_NO_QLOG",
            }
            local result = {}
            for _, v in ipairs(openssl_sys_defines) do
                table.insert(result, string.format("# ifndef %s\n#  define %s 1\n# endif", v, v))
            end
            for _, v in ipairs(openssl_api_defines) do
                table.insert(result, string.format("# define %s", v))
            end
            for _, v in ipairs(openssl_feature_defines) do
                table.insert(result, string.format("# ifndef %s\n#  define %s\n# endif", v, v))
            end
            return table.concat(result, "\n")
        end,
        ['include/openssl/configuration.h.in#2'] = function ()
            return target:is_arch("x86", "i368") and '# define' or '# undef'
        end,
    }
    
    local processor = {
        ['join("\n",map { "/* $_ */" } @autowarntext)'] = function (f, n, perl_content)
            return string.format("/*\nWARNING: do not edit!\n* Generated by xmake from %s\n*/\n", f)
        end,
        ['join("\n * ", @autowarntext)'] = function (f, n, perl_content)
            return string.format("WARNING: do not edit!\n* Generated by xmake from %s\n", f)
        end,
        ['default'] = function (f, n, perl_content)
            local k = f .. "#" .. n
            if internal_processor[k] then
                return internal_processor[k](f, n, perl_content)
            end
            local k, v1, v2 = perl_content:match('%$config{(.*)} +%? +"(.*)" +: +"(.*)"')
            if k ~= nil then
                if config[k] == 1 then
                    return v1
                else
                    return v2
                end
            end
            if perl_content:startswith('use OpenSSL::paramnames qw(') then
                return ''
            end
            if perl_content:startswith('use OpenSSL::stackhash qw(') then
                return ''
            end
            if perl_content:find('process_leaves%(') then
                local inputs = {}
                for input in perl_content:gmatch("'([^']+.asn1)'") do
                    table.insert(inputs, input)
                end
                local output_type = f:endswith(".h.in") and "h" or "c"
                return generate_oid(inputs, output_type)
            end
            local config_result = {}
            for k in perl_content:gmatch('%$config{([%w_]+)}') do
                table.insert(config_result, config[k])
            end
            if #config_result > 0 then
                return table.concat(config_result, " ")
            end
            if perl_content:find('[%w_]+%(') ~= nil then
                local startpos = 1
                local result = ''
                while true do
                    local fstartpos, fendpos, fn = perl_content:find('([%w_]+)%(', startpos)
                    if not fstartpos then
                        break
                    end
                    local pstartpos, pendpos, param1 = perl_content:find('"([%w_]+)"%)', fendpos)
                    if param1 ~= nil then
                        startpos = pendpos+1
                    else
                        startpos = fendpos+1
                    end
                    if fun_ctx[fn] then
                        result = result..fun_ctx[fn](param1)
                    end
                end
                return result
            end
            return ''
        end,
    }
    local content = io.readfile(sourcefile)
    local output = io.open(targetfile, "wb")
    local start = content:find("{%-")
    local prev = 1
    local n = 0
    while start ~= nil do
        output:write(content:sub(prev, start-1))
        local stop = content:find("%-}", start + 2)
        if stop == nil then
            break
        end
        local perl_content = content:sub(start + 2, stop-1):trim()
        if processor[perl_content] then
            output:write(processor[perl_content](sourcefile, n, perl_content))
        else
            output:write(processor['default'](sourcefile, n, perl_content))
        end
        prev = stop + 2
        n = n + 1
        start = content:find("{%-", stop + 2)
        if start == nil then
            output:write(content:sub(prev))
        end
    end
    output:close()
end


function main(target)
    local buildir = "build"
    for _, sourcefile in ipairs(files) do
        local targetfile = sourcefile
        local name = path.basename(targetfile)
        local targetdir = path.join(buildir, "generate", path.directory(targetfile))
        targetfile = path.join(targetdir, name)
        os.mkdir(targetdir)
        dofile(target, sourcefile, targetfile)
        print("generate " .. targetfile)
    end
end
