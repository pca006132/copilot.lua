local last_mark = nil
local ns = vim.api.nvim_create_namespace("copilot")
vim.api.nvim_set_hl(ns, "CopilotVirt", {fg = "#034560"})
vim.api.nvim_create_autocmd({"InsertChange"}, {
  callback=function ()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end,
  once = false
})
local opts = {
  handler = function(_, result, ctx, config)
    if not ctx or not result or vim.tbl_isempty(result.completions) then return end
    local position = ctx.params.doc.position
    local lnum = position.lnum
    local display = result.completions[1]
    vim.schedule(function()
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) 
      last_mark = vim.api.nvim_buf_set_extmark(ctx.bufnr,ns,display.position.line,display.range['end'].character, {
        virt_text = {
          {display['displayText'], "CopilotVirt"}
        },
        virt_text_pos = 'overlay',
        priority = 400,
      })
    end)
  end
}
local request_loop = require("copilot.request_loop"):new(opts)

request_loop:start()
-- create a new request_loop
