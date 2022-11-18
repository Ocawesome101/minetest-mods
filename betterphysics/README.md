# Better Physics

A library for tweaking player physics.

Provides the `betterphysics` API:

  - `betterphysics.attribute_base(name:string, attribute:string, value:number)`: Changes the base for some player's physics value.
  - `betterphysics.attribute_modifier(name:string, attribute:string, value:number)`: Changes the modifier (multiplier) for some player's physics value.

Also provides the `/attribute` command:

### `/attribute <attribute> [<value>]`
  - `attribute`: one of the valid attributes (see below), plus `_base` or `_mod` to change the base value or modifier value respectively, e.g. `speed_base` or `gravity_mod`.
  - `value`: if this is `get`, then prints the value to the chat; otherwise, sets the value to `tonumber(value) or 1`.

## Attributes
  - `speed`: Changes the player's walking speed.  Dynamically modifies the FOV.
  - `jump`: Changes the player's jump power.
  - `gravity`: Changes the player's gravity.
