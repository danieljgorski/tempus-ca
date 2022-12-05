# Getting started with Julia and Pluto

## Julia

### Install

I installed the Julia language (version 1.8) from [https://julialang.org/downloads/](https://julialang.org/downloads/), then added a symlink from the its location in the applications folder to `/usr/local/bin/` to be able to launch Julia from the terminal as [as recommened](https://julialang.org/downloads/platform/):

```zsh
sudo ln -s /Applications/Julia-1.8.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
Password:
~ ❯ julia                                                                                                3s
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.3 (2022-11-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

## Pluto

[Pluto notebooks](https://github.com/fonsp/Pluto.jl) are lightweight reactive notebooks for Julia.

### Install

Start the Julia REPL, bring up the package manager with `]`, then add Pluto

```zsh
~ ❯ julia
julia> ]  
(v1.8) pkg> add Pluto
```

### First time use

```zsh
julia> import Pluto
julia> Pluto.run()
```

### Normal usage

```zsh
julia> using Pluto
julia> Pluto.run()
```
