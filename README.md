[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">

<h3 align="center">FiveM Webbed</h3>

  <p align="center">
    <br />
    ·
    <a href="https://github.com/cyntaax/fivem-webbed/issues">Report Bug</a>
    ·
    <a href="https://github.com/cyntaax/fivem-webbed/issues">Request Feature</a>
  </p>
</p>




<!-- ABOUT THE PROJECT -->
## About The Project

This is a library for interacting with the Discord API in an object-oriented fashion. It is very fresh and still lacking
some features, but has proven useful for my personal cases. For the time being, most things are read-only, however this
will change.

<!-- ![product-screenshot](https://i.gyazo.com/268f17b6814049b8855ca3b9f384a68c.png) -->


## Features

- Familiar API to those that have worked with express.js
- Automatic conversion of tables to data in responses
- Object-Oriented approach makes things easier and self-documenting
- Middleware functions can be used! (see example)
- Supports only `GET` and `POST` for the time being


<!-- GETTING STARTED -->
## Getting Started

Simply download the [Latest Release](https://github.com/Cyntaax/fivem-webbed/releases/latest), place into your resources directory and start!

### Prerequisites

- Just a basic understanding of Lua and HTTP

### Configuration

- None Required outside of starting in the server.cfg

```ini

... (other resources)
ensure fivem-webbed
```

## Usage
The resource alone does nothing. It is a library to be included with another resource to create http endpoints/server files:

```lua
--- fxmanifest.lua

server_scripts {
    '@fivem-webbed/server/server.lua',
    'server/server.lua'
}
```


```lua
--- assume resource is named (api). Looks nice for the URL
--- server/server.lua

local player = Router.new()

player:Get("/:playerId", function(req, res)
    local target = tonumber(req:Param("playerId"))
    print('Player name', GetPlayerName(target))
    return 200, {
        name = GetPlayerName(target),
        target = target
    }
end)

Server.use("/players", player)
Server.listen()
```

```bash
curl -X GET http://localhost:30120/api/players/1
```

```json
{
  "name": "Cyntaax",
  "target": 1
}
```

<!-- ROADMAP -->
## Roadmap

- Include some pre-made middlewares
- Lots of examples for different tasks

See the [open issues](https://github.com/cyntaax/fivem-webbed/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'chore: added some amazing feature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

## Notable Mentions

- [Async](https://github.com/esx-framework/async) - Really helped for dealing with running all of the middlewares



<!-- CONTACT -->
## Contact

Cyntaax - [@cyntaax](https://twitter.com/cyntaax) - cyntaax@gmail.com

Project Link: [https://github.com/cyntaax/fivem-webbed](https://github.com/cyntaax/fivem-webbed)







<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/cyntaax/fivem-webbed.svg?style=for-the-badge
[contributors-url]: https://github.com/cyntaax/fivem-webbed/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/cyntaax/fivem-webbed.svg?style=for-the-badge
[forks-url]: https://github.com/cyntaax/fivem-webbed/network/members
[stars-shield]: https://img.shields.io/github/stars/cyntaax/fivem-webbed.svg?style=for-the-badge
[stars-url]: https://github.com/cyntaax/fivem-webbed/stargazers
[issues-shield]: https://img.shields.io/github/issues/cyntaax/fivem-webbed.svg?style=for-the-badge
[issues-url]: https://github.com/cyntaax/fivem-webbed/issues
[license-shield]: https://img.shields.io/github/license/cyntaax/fivem-webbed.svg?style=for-the-badge
[license-url]: https://github.com/cyntaax/fivem-webbed/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/cyntaax
