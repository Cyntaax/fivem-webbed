---@class Router
Router = setmetatable({}, Router)

Router.__call = function()
    return "Router"
end

Router.__index = Router

function Router.new()
    local _Router = {
        Paths = {},
        Middlewares = {}
    }

    return setmetatable(_Router, Router)
end

---@param path string
---@param handler fun(req: Request, res: Response): void
function Router:Get(path, handler)
    local parsed = PatternToRoute(path)
    table.insert(self.Paths, {
        method = "GET",
        path = parsed.route,
        handler = handler,
        pathData = parsed,
        _path = parsed._path,
        _route = parsed._route,
    })
end

---@param path string
---@param handler fun(req: Request, res: Response): void
function Router:Post(path, handler)
    local parsed = PatternToRoute(path)
    table.insert(self.Paths, {
        method = "POST",
        path = parsed.route,
        handler = handler,
        pathData = parsed,
        _path = parsed._path,
        _route = parsed._route,
    })
end

---@param middleware fun(req: Request, res: Response, next: fun(): void)
function Router:AddMiddleware(middleware)
    table.insert(self.Middlewares, middleware)
end
