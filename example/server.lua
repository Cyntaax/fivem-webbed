API = {
    Token = "",
    FileCache = {}
}

function API:GetFile(path)
    if not self.FileCache[path] then
        local file = LoadResourceFile(GetCurrentResourceName(), path)
        if file == "" then
            return
        end

        self.FileCache[path] = file
    end

    return self.FileCache[path]
end



--- create a new router
local base = Router.new()

base:Get("", function(req, res)
    local index = LoadResourceFile(GetCurrentResourceName(), "public/index.html")
    return 200, index
end)

base:Get("/static/*", function(req, res)
    local file = API:GetFile(req:Params("0"))
    if not file then
        return 404, {
            message = "file not found"
        }
    end

    return 200, file
end)

local player = Router.new()

player:Get("/:playerId", function(req, res)
    local target = tonumber(req:Param("playerId"))
    print('Player name', GetPlayerName(target))
    return 200, {
        name = GetPlayerName(target)
    }
end)

player:AddMiddleware(function(req, res, next)
    local token = req:Header("API_TOKEN")
    if token ~= "" then
        if token == API.Token then
            next()
        else
            res:Send({
                error = "Invalid Token"
            }, 403)
        end
    else
        res:Send({
            error = "Token Missing"
        }, 403)
    end
end)


--- mount the route at a given point
Server.use("/", base)
Server.use("/players", player)


--- load api token logic
local api_token = GetConvar("API_TOKEN", "")
if api_token == "" then
    print("^1[" .. GetCurrentResourceName() .. "]^3: failed to load api token. please ensure `api_token` is set in the server.cfg^7")
else
    API.Token = api_token
    Server.listen()
    print("^2[" .. GetCurrentResourceName() .. "]: API Server Listening^7")
end
