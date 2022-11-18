-- very small utility mod

local default = {}
local states = {}
local foreach = {
  step = {}
}

minetest.register_globalstep(function()
  for _, player in ipairs(minetest.get_connected_players()) do
    for _, func in pairs(foreach.step) do
      local name = player:get_player_name()
      func(player, name, states[name])
    end
  end
end)

playerstate = {
  foreach_onstep = function(func)
    assert(type(func) == "function", "expected function")
    local id = math.random(100000, 999999)
    foreach.step[id] = func
    return id
  end,

  get = function(name)
    name = tostring(name)
    if not minetest.get_player_by_name(name) then
      return nil
    end

    if not states[name] then
      states[name] = table.copy(default)
    end

    return states[name]
  end,

  -- register fields and default values
  -- pass 'force' to override defaults set by other mods
  register_fields = function(tab, force)
    for k, v in pairs(tab) do
      default[k] = v
    end
  end
}
