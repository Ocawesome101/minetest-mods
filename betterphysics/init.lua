local FOV_MODIFIER = 0.857
local FOV_TRANSITION_TIME = 0.1

playerstate.register_fields {
  speed_base = 1, jump_base = 1.05, gravity_base = 1,
  speed_mod = 1, jump_mod = 1, gravity_mod = 1 }

playerstate.foreach_onstep(function(player, name)
  -- FOV logic
  local speed = player:get_physics_override().speed
  player:set_fov(1 + ((speed - 1) * FOV_MODIFIER), true,
    FOV_TRANSITION_TIME)

  -- physics overrides
  local state = playerstate.get(name)
  player:set_physics_override {
    jump = state.jump_base * state.jump_mod,
    speed = state.speed_base * state.speed_mod,
    gravity = state.gravity_base * state.gravity_mod
  }
end)

local valid = {}

for _, a in pairs {"jump", "speed", "gravity"} do
  for _, b in pairs {"_base", "_mod"} do
    valid[a..b] = true
  end
end

-- special command
minetest.register_chatcommand("attribute", {
  params = "<attribute> [<value>]",

  description = "Modify attributes.\nspeed, jump, gravity\n_mod or _base",

  func = function(name, param)
    local p1, p2 = unpack(string.split(param, " "))
    if not valid[p1] then
      return false
    end
    local state = playerstate.get(name)
    if p2 == "get" then
      minetest.chat_send_player(name, p1 .. " is " .. state[p1])
      return true
    end
    state[p1] = tonumber(p2) or 1
    return true
  end
})

local api = {}

local function modify(n, a, v)
  n = tostring(n)
  a = tostring(a)
  v = tonumber(v) or 1
  local state = playerstate.get(n)
  if not state then
    return nil, "no player state"
  end

  if not state[a] then
    return nil, "bad attribute"
  end

  state[a] = v

  return true
end

function api.attribute_base(name, attribute, value)
  local aname = attribute .. "_base"
  return modify(name, aname, value)
end

function api.attribute_modifier(name, attribute, value)
  local aname = attribute .. "_mod"
  return modify(name, aname, value)
end

-- global api
_G.betterphysics = api
