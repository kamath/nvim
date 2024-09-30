-- require('sg').setup()

local function add_plugin(plugin_url)
  -- Prefix with github if not already present
  if not plugin_url:match '^github' then
    plugin_url = 'https://github.com/' .. plugin_url
  end

  -- Extract plugin name from URL
  local plugin_name = plugin_url:match('([^/]+)$'):gsub('%.git$', '')

  -- Path to your plugins configuration file
  local config_file = vim.fn.stdpath 'config' .. '/lua/custom/plugins/init.lua'

  -- Read the current content of the file
  local file = io.open(config_file, 'r')
  if not file then
    print 'Error: Unable to open plugins configuration file'
    return
  end
  local content = file:read '*all'
  file:close()

  -- Check if the plugin is already in the file
  if content:find(plugin_url) then
    print("Plugin '" .. plugin_name .. "' is already in the configuration.")
    return
  end

  -- Add the new plugin entry
  local new_content = content:gsub('return%s*{', "return {\n  { '" .. plugin_url .. "' },")

  -- Write the updated content back to the file
  file = io.open(config_file, 'w')
  if not file then
    print 'Error: Unable to write to plugins configuration file'
    return
  end
  file:write(new_content)
  file:close()

  print("Plugin '" .. plugin_name .. "' added to lazy.nvim configuration.")
  print 'Restart Neovim or run :Lazy sync to install the new plugin.'
end

-- Create a Neovim command to add plugins
vim.api.nvim_create_user_command('Add', function(opts)
  add_plugin(opts.args)
end, { nargs = 1 })
