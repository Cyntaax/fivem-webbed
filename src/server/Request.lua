---@class Request
Request = setmetatable({}, Request)

Request.__call = function()
    return "Request"
end

Request.__index = Request

--- Creates a new Request class instance
---@param request table Expects a request object from the `SetHttpHandler` callback
function Request.new(request, session)

    local _Request = {
        _Raw = request,
        _Params = {},
        _Session = session,
        _Cookies = {}
    }

    request.body = request.body or ""

    if json.decode(request.body) then
        _Request._Body = json.decode(request.body)
    else
        _Request._Body = request.body
    end

    if request.headers.Cookie then
        local cookies = exports["fivem-webbed"]:parseCookie(request.headers.Cookie)
        _Request._Cookies = cookies
    end

    return setmetatable(_Request, Request)
end

--- Get the value for a named parameter. i.e. `/users/:id` to fetch "id" use `Request:Param("id")`
---@param name string Name of the parameter to get
---@return string
function Request:Param(name)
    return self._Params[name]
end

--- Returns all parameters as a table
---@return table
function Request:Params()
    return self._Params
end

--- Sets the value of a parameter. (internal)
---@private
---@param name string The name of the parameter to set
---@param val string The value of this parameter
function Request:SetParam(name, val)
    self._Params[name] = val
end

--- Returns the body of this request
---@return string|table
function Request:Body()
    return self._Body
end

--- Returns the path of this request
---@return string
function Request:Path()
    return self._Raw.path
end

--- Returns the method of this request
---@return string
function Request:Method()
    return self._Raw.method
end

--- Gets the value for the specified header
---@param name string
---@return string
function Request:Header(name)
    for k,v in pairs(self._Raw.headers) do
        if k == name then
            return v
        end
    end
end

---@return ServerSession
function Request:GetSession(name)
    for k,v in pairs(self._Session) do
        if v.Name == name then
            return v
        end
    end
end

function Request:Cookie(name)
    for k,v in pairs(self._Cookies) do
        if k == name then
            return v
        end
    end
end
