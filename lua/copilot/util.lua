local M = {}

local format_pos = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  return { character = pos[2], line = pos[1] - 1 }
end

local get_relfile = function()
  local file, _ = string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd() .. "/", "")
  return file
end

M.find_copilot_client = function()
  vim.lsp.get_active_clients({name="copilot"})
end

M.get_completion_params = function()
  local rel_path = get_relfile()
  local uri = vim.uri_from_bufnr(0)
  local params = {
    options = vim.empty_dict(),
    doc = {
      source = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"),
      relativePath = rel_path,
      languageId = vim.bo.filetype,
      insertSpaces = true,
      tabsize = vim.bo.shiftwidth,
      indentsize = vim.bo.shiftwidth,
      position = format_pos(),
      path = vim.api.nvim_buf_get_name(0),
      uri = uri,
    },
    textDocument = {
      languageId = vim.bo.filetype,
      relativePath = rel_path,
      uri = uri,
    }
  }
  return params
end

M.get_copilot_path = function()
  local plugin_path = vim.api.nvim_exec("echo expand('<sfile>:p:h:h:h')", true)
  return plugin_path .. "/copilot/index.js"
end

return M
