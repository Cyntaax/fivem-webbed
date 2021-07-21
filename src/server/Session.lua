---@class ServerSession
ServerSession = setmetatable({}, ServerSession)

ServerSession.__call = function()
    return "ServerSession"
end

ServerSession.__index = ServerSession

function ServerSession.new(name)
    local _ServerSession = {
        Name = name,
        _Data = {}
    }

    return setmetatable(_ServerSession, ServerSession)
end

function ServerSession:Get(key)
    return self._Data[key]
end

function ServerSession:Set(key, value)
    self._Data[key] = value
end

function ServerSession:ToBase64()
    return base64.encode(json.encode(self._Data))
end

function ServerSession:FromBase64(input)
    local data = base64.decode(input)
    local jdata = json.decode(data)
    if jdata then
        self._Data = jdata
    end
end
