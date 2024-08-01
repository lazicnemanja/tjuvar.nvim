local M = {}

M.config = {
  session_name = '.session.nvim',
  auto_load = false,
  events = {'BufWritePost', 'BufEnter', 'WinEnter', 'CmdlineLeave'},
}

local session_loaded = false

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})

  local function is_in_git_repo()
    return vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):find 'true'
  end

  local function get_project_root()
    if is_in_git_repo() then
      return vim.fn.trim(vim.fn.system 'git rev-parse --show-toplevel')
    else
      return vim.fn.getcwd()
    end
  end

  local project_root = get_project_root()
  local session_file = project_root .. '/' .. M.config.session_name

  local function save_session()
    if vim.fn.expand('%:p'):find(project_root, 1, true) then
      vim.cmd('mksession! ' .. session_file)
    end
  end

  local function load_session()
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('source ' .. session_file)
      session_loaded = true
    end
  end

  local function prompt_load_session()
    if vim.fn.filereadable(session_file) == 1 then
      if M.config.auto_load then
        load_session()
      else
        local choice = vim.fn.input 'Load existing session? (y/n): '
        if choice:lower() == 'y' or choice:lower() == 'yes' then
          load_session()
        end
      end
    end
  end

  vim.api.nvim_create_autocmd(M.config.events, {
    pattern = '*',
    callback = function()
      if session_loaded then
        save_session()
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
      vim.schedule(prompt_load_session)
    end,
  })
end

return M
