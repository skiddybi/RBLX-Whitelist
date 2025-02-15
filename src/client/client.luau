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


-- You should be creative with your RNG Sources
-- I'll provide 2 only for demonstration purposes | I'll also include how attackers can reverse those aswell
local rng1 = math.random(1, 100000)
local rng2 = Random.new():NextInteger(1, 100000)


local response = request({
    Url = "http://localhost:3000/whitelist",
    Method = "POST",
    Body = HttpService:JSONEncode({
        whitelistkey = key,
        firstValue = rng1,
        secondValue = rng2
    }),
    Headers = {
        ["Content-Type"] = "application/json"
    }
})

local JumpCounter = 0

if response.StatusCode == 200 then
    JumpCounter = JumpCounter + 1 -- 1
    local body = HttpService:JSONDecode(response.Body)
    if body.valid then
        JumpCounter = JumpCounter + 1 -- 2
        if (((body.newFirstValue + 32) / 2 ) == rng1) and ( ((body.newSecondValue - 256) / 5) == rng2) then
            JumpCounter = JumpCounter + 1 -- 3

            -- Jumpcounter will not be 3 if a sudden jump had happened
            -- An attacker can easily get around this, it's just the most straightforward fix.
            if JumpCounter ~= 3 then
                LPH_CRASH()
            end

            -- Place this after the RNG check
            LPH_ENCFUNC(
                function()
                    print("Whitelisted")
                end,
             "d5e03252767d767f6aab5730663c4563ae0e72625102cba812846c289ab46a74", body.decKey .. "ae0e72625102cba812846c289ab46a74" -- Concat our received key with a constant one here
            )() -- Don't forget to call the function
        else 
            print("Incorrect data")
            LPH_CRASH()
        end
    else
        print("Not whitelisted")
        LPH_CRASH()
    end
else
    print(`Server not responding with code {response.StatusCode}`)
    LPH_CRASH()
end
