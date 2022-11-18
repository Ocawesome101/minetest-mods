-- potions :)

local potions = {}
local effects = {}

playerstate.register_fields { effects = {} }

playerstate.foreach_onstep(function(player, name, state)
  for effect, callbacks in pairs(effects) do
    if state and state.effects[effect] then
      state.effects[effect] = state.effects[effect] - 1
      if state.effects[effect] == 0 then
        state.effects[effect] = nil
        callbacks.on_clear(player, name, state)
      else
        callbacks.on_step(player, name, state)
      end
    end
  end
end)

minetest.register_craftitem("potions:glass_bottle", {
  description = "Glass Bottle",
  inventory_image = "potion_overlay.png",
  stack_max = 16
})

minetest.register_node("potions:brewing_stand", {
  description = "Brewing Stand",
  inventory_image = "potions_brewing_stand.png",
  wield_image = "potions_brewing_stand.png",
  tiles = {"potions_brewing_stand.png", "potions_brewing_stand.png"},
  drawtype = "plantlike",
  groups = {oddly_breakable_by_hand=1},

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)

    local inv = meta:get_inventory()
    -- [[
    inv:set_lists {
      fuel = { ItemStack() },
      src = { ItemStack() },
      dst = { ItemStack() }
    }--]]
  end,

  on_rightclick = function(_, _, clicker)
    minetest.show_formspec(clicker:get_player_name(), "potions:bs", [[
size[8,9]
list[context;fuel;2,3;1,1;]
list[context;src;2,1;1,1;]
list[context;dst;5,1;2,2;]
list[current_player;main;0,5;8,4;]
    ]])
  end
})

-- API
local api = {}

function api.register_potion(pspec)
  if not effects[pspec.effect] then
    error("must register effect before potion")
  end

  local name, color, effect, duration, desc =
    pspec.name, pspec.color, pspec.effect, pspec.duration, pspec.desc

  potions[name] = pspec

  minetest.register_craftitem("potions:"..name, {
    description = "Potion of " .. desc,

    inventory_image = "potion_base.png",

    inventory_overlay = "potion_overlay.png",

    color = color,

    stack_max = 1,

    on_place = function() end,

    on_secondary_use = function(stack, player)
      playerstate.get(player:get_player_name()).effects[effect] = duration
      return ItemStack("potions:glass_bottle")
    end
  })
end

function api.register_effect(name, callbacks)
  effects[name] = callbacks
end

_G.betterpotions = api

-- built-in potions and effects
api.register_effect("speed", {
  on_step = function(_, _, state)
    state.speed_mod = 1.4
  end,

  on_clear = function(_, _, state)
    state.speed_mod = 1
  end
})

api.register_effect("jump_boost", {
  on_step = function(_, _, state)
    state.jump_mod = 1.4
  end,

  on_clear = function(_, _, state)
    state.jump_mod = 1
  end
})

api.register_potion {
  name = "speed",
  desc = "Swiftness",
  color = "#0f0",
  effect = "speed",
  duration = 1000
}

api.register_potion {
  name = "jump_boost",
  desc = "Jump Boost",
  color = "#0AF",
  effect = "jump_boost",
  duration = 1000
}
