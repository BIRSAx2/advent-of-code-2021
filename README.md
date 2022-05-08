# Advent of Code 2021 Elixir Solutions 

My [Advent of Code](https://www.adventofcode.com)'s solutions using Elixir!

## Usage

There are 25 modules, 25 tests, and 50 mix tasks.

- Run `mix d01.p1` to get the result of the part 1 of day 1
- Benchmark the solution by passing the `-b` flag, `mix d01.p1 -b`


### Automatic Input Retriever

This repo comes with a module that will automatically get the inputs to avoid to mess with copy/pasting. It automatically caches the inputs in order to avoid slamming the Advent of Code server. 
You will need to configure it with your cookie and make sure to enable it. You can do this by creating a `config/secrets.exs` file containing
the following:

```elixir
use Mix.Config

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  session_cookie: "..." # yours will be longer
```

After which, you can retrieve your inputs using the module:

```elixir
day = 1
year = 2020
AdventOfCode.Input.get!(day, year)
# or just have it auto-detect the current year
AdventOfCode.Input.get!(7)
# and if your input somehow gets mangled and you need a fresh one:
AdventOfCode.Input.delete!(7, 2019)
# and the next time you `get!` it will download a fresh one -- use this sparingly!
```

## Installation

```bash
# clone
$ git clone git@github.com:BIRSAx2/advent-of-code.git
$ cd advent-of-code
```
### Get started coding with zero configuration

#### Using Visual Studio Code

1. [Install Docker Desktop](https://www.docker.com/products/docker-desktop)
1. Open project directory in VS Code
1. Press F1, and select `Remote-Containers: Reopen in Container...`
1. Wait a few minutes as it pulls image down and builds Dev Conatiner Docker image (this should only need to happen once unless you modify the Dockerfile)
    1. You can see progress of the build by clicking `Starting Dev Container (show log): Building image` that appears in bottom right corner
    1. During the build process it will also automatically run `mix deps.get`
1. Once complete VS Code will connect your running Dev Container and will feel like your doing local development
1. If you would like to use a specific version of Elixir change the `VARIANT` version in `.devcontainer/devcontainer.json`
1. If you would like more information about VS Code Dev Containers check out the [dev container documentation](https://code.visualstudio.com/docs/remote/create-dev-container/?WT.mc_id=AZ-MVP-5003399)

#### Compatible with Github Codespaces
1. If you dont have Github Codespaces beta access, sign up for the beta https://github.com/features/codespaces/signup
1. On GitHub, navigate to the main page of the repository.
1. Under the repository name, use the  Code drop-down menu, and select Open with Codespaces.
1. If you already have a codespace for the branch, click  New codespace.
