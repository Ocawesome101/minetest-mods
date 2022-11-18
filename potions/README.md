# Better Potions

/!\\ Not quite finished yet - the brewing stand does not work /!\\

Implements potions!  Provides two potions by default, swiftness and jump boost.

Provides the `betterpotions` API:

  - `betterpotions.register_potion(pspec)`: Registers a potion item.  See `pspec` below.
  - `betterpotions.register_effect(name:string, callbacks:table)`: Registers callbacks executed for a certain potion effect.  The `callbacks` table must contain an `on_step` and `on_clear` function, each of which is called with a player object, the player's name, and the player's state.

```lua
-- The default swiftness potion.
local pspec = {
  name = "speed",     -- Registers the CraftItem as `potions:speed`
  desc = "Swiftness", -- Sets the CraftItem's name to `Potion of Swiftness`
  color = "#0f0",     -- This is the overlay color for the potion
  effect = "speed",   -- The effect ID the potion provides
  duration = 1000     -- How many game ticks the effect is given for
}
```
