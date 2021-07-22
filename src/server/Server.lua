Server = {
    ---@type Router[]
    Routes = {},
    Middlewares = {},
    ---@type ServerSession[]
    Sessions = {}
}

function Server:Session(name)
    for k,v in pairs(self.Sessions) do
        if v.Name == name then
            self.Sessions[k] = ServerSession.new(name)
            return
        end
    end

    table.insert(self.Sessions, ServerSession.new(name))
end

function Server.listen()
    SetHttpHandler(function(req, res)
        print(req.method .. " => " .. req.path)
        ---@type string
        local path = req.path
        local method = req.method
        if method == "OPTIONS" then
            print('sending cors headers')
            local response = Response.new(res)
            response:SetHeader("Access-Control-Allow-Origin", "*")
            response:Send("", 200)
            return
        end
        for k,v in pairs(Server.Routes) do
            for b,z in pairs(v.Paths) do
                local data = exports["fivem-webbed"]:matchRoute(z._path, path)
                if data then
                    if type(data) == "table" then
                        print(json.encode(data))
                    end
                end
                if data then
                    if z.method == method then
                        local response = Response.new(res)
                        local request = Request.new(req)
                        if z.pathData then
                            for u,x in pairs(data) do
                                request:SetParam(u, Util:DecodeURI(x))
                            end
                        end

                        local tasks = {}

                        for midx, middleware in pairs(v.Middlewares) do
                            table.insert(tasks, function(cb)
                                middleware(request, response, cb)
                            end)
                        end

                        Citizen.Await(PromiseAsync:Series(tasks))

                        if z.method == "POST" then
                            req.setDataHandler(function(data)
                                request._Body = json.decode(data) or ""
                                local status, ret = z.handler(request, response)
                                if status ~= nil then
                                    if type(status) == "number" then
                                        if type(ret) ~= "table" then
                                            response:Send(ret, status)
                                        else
                                            response:SetHeader("Content-Type", "application/json")
                                            response:Send(json.encode(ret), status)
                                        end
                                    end
                                end
                            end)
                        else
                            local status, ret = z.handler(request, response)
                            if status ~= nil then
                                if type(status) == "number" then
                                    if type(ret) ~= "table" then
                                        response:Send(ret, status)
                                    else
                                        response:SetHeader("Content-Type", "application/json")
                                        response:Send(json.encode(ret), status)
                                    end
                                end
                            end
                        end
                        return
                    end
                end
            end
        end
        local response = Response.new(res)
        local request = Request.new(req)
        response:Send("Not Found: " .. request:Method() .. " " .. request:Path(), 404)
    end)
end

--- Specifies a handler/middleware for the server to use
---@param path string The path for this handler
---@param handler Router The router to handle this path
function Server.use(path, handler)
    if type(path) == "string" then
        if type(handler) == "function" then

        elseif type(handler) == "table" then
            local mt = getmetatable(handler)
            if mt == nil then print("^1Error^0: " + "failed to load route " + path + "expected route class") return end
            if mt.__call() ~= "Router" then print("^1Error^0: " + "failed to load route " + path + "expected route class") return end
            for k,v in pairs(handler.Paths) do
                print("Mounting: ", path .. v._path)
                v.path = path .. v.path
                v._path = path .. v._path
            end
            table.insert(Server.Routes, handler)
        end
    end
end
