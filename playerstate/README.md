# Player States

Makes maintaining player states simpler.

Provides the `playerstate` API:

  - `playerstate.foreach_onstep(function): number`: Registers a function to run for each player on every server tick.
  - `playerstate.get(name: string): table`: Retrieve the state for a given player by name.  Returns `nil` if that player does not exist.
  - `playerstate.register_fields(fields: table)`: Registers default fields for all player states.  Keys in the `fields` table are field names and values are default values - they may be overridden per-player.

For some example usage, see the other mods in this repository.
