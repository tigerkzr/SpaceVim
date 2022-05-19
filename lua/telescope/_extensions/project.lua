local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function prepare_output_table()
  local lines = {}
  local projects = vim.api.nvim_eval('g:unite_source_menu_menus.Projects.command_candidates')

  for _, project in pairs(projects) do
      table.insert(lines, project)
  end
  return lines
end

local function show_changes(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = prepare_output_table(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          command = entry[2],
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        print(entry.display, entry.command)
      end)
      return true
    end,
  }):find()
end

local function run()
  show_changes()
end

return require("telescope").register_extension({
  exports = {
    -- Default when to argument is given, i.e. :Telescope project
    project = run,
  },
})
