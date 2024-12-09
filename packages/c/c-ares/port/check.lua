local check = {}
local _instance = {}

function _instance.new(target)
    local instance    = table.inherit(_instance)
    local variables = target:get("configvar") or {}
    for _, opt in ipairs(target:orderopts()) do
        for name, value in pairs(opt:get("configvar")) do
            if variables[name] == nil then
                variables[name] = table.unwrap(value)
                variables["__extraconf_" .. name] = opt:extraconf("configvar." .. name, value)
            end
        end
    end
    instance._target    = target
    instance._variables = variables
    return instance
end

function _instance:get_configvar(k)
    return self._variables[k]
end

function _instance:get_configvars()
    return self._variables
end

function _instance:set_configvar(k, v)
    self._variables[k] = v
    self._target:set("configvar", k, v)
end

function _instance:_configvar_check(k, v)
    if v ~= nil then
        self:set_configvar(k, v)
    end
end

function _instance:configvar_check_csymbol_exists(var_name, opt)
    self:_configvar_check(var_name, self._target:check_csnippets('void* a = (void*)'..var_name..';', opt))
end

function _instance:configvar_check_cfuncs(var_name, check, opt)
    self:_configvar_check(var_name, self._target:has_cfuncs(check, opt))
end

function _instance:configvar_check_cincludes(var_name, check, opt)
    self:_configvar_check(var_name, self._target:has_cincludes(check, opt))
end

function _instance:configvar_check_ctypes(var_name, check, opt)
    self:_configvar_check(var_name, self._target:has_ctypes(check, opt))
end

function _instance:configvar_check_cflags(var_name, check, opt)
    self:_configvar_check(var_name, self._target:has_cflags(check, opt))
end

function _instance:configvar_check_features(var_name, check, opt)
    self:_configvar_check(var_name, self._target:has_features(check, opt))
end

function _instance:configvar_check_sizeof(var_name, check, opt)
    self:_configvar_check(var_name, self._target:check_sizeof(check, opt))
end

function _instance:configvar_check_csnippets(var_name, snippets, opt)
    self:_configvar_check(var_name, self._target:check_csnippets(snippets, opt))
end

function main(target)
    return _instance.new(target)
end
