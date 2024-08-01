# tjuvar
A simple session management plugin for Neovim.

## Installation

### Using [Lazy](https://github.com/folke/lazy.nvim)
```lua
{
  "lazicnemanja/tjuvar.nvim",
  config = function()
    require("tjuvar").setup({
      session_name = '.session.nvim', 
      auto_load = false, -- show prompt
      events = {'BufWritePost', 'BufEnter', 'WinEnter', 'CmdlineLeave'},
    })
  end,
}
```
## License
MIT
