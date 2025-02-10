-- getgenv().whitelistKey = "myexamplekey"

-- Types are under the .vscode folder in the project root


-- \\ Luraph SDK Start // --
local assert = assert
local type = type
local setfenv = setfenv

local LPH_ENCNUM = function(toEncrypt, ...)
    assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
    return toEncrypt
end
LPH_NUMENC = LPH_ENCNUM

local LPH_ENCSTR = function(toEncrypt, ...)
    assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
    return toEncrypt
end
LPH_STRENC = LPH_ENCSTR

local LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
    -- not checking decKey value since this shim is meant to be used without obfuscation/whitelisting
    assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
    return toEncrypt
end
LPH_FUNCENC = LPH_ENCFUNC

local LPH_JIT = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
    return f
end
LPH_JIT_MAX = LPH_JIT

local LPH_NO_VIRTUALIZE = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
    return f
end

local LPH_NO_UPVALUES = function(f, ...)
    assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
    return f
end

local LPH_CRASH = function(...)
    assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
end
-- \\ Luraph SDK End // --


local key = getgenv().whitelistKey or LPH_CRASH()
local HttpService = game:GetService("HttpService")
local request = (http and http.request) or request or LPH_CRASH()

local response = request({
    Url = "http://localhost:3000/whitelist",
    Method = "POST",
    Body = HttpService:JSONEncode({
        whitelistkey = key
    }),
    Headers = {
        ["Content-Type"] = "application/json"
    }
})

if response.StatusCode == 200 then
    local body = HttpService:JSONDecode(response.Body)
    if body.valid then
        print("Whitelisted")
    else
        print("Not whitelisted")
        LPH_CRASH()
    end
else
    print("Server not responding")
    LPH_CRASH()
end
