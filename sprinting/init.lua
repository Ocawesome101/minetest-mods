local SPRINT_MODIFIER = 1.4

playerstate.register_fields {
  timeSinceAux = 0, fwdWasDown = false, timeSinceFwdRelease = 0
}

playerstate.foreach_onstep(function(player, name)
  local state = playerstate.get(name)
  if not state then return end

  local keys = player:get_player_control()
  state.timeSinceAux = state.timeSinceAux + 1

  if keys.aux1 then
    state.timeSinceAux = 0
    state.speed_base = SPRINT_MODIFIER
  end

  if not keys.up then
    if state.fwdWasDown then
      state.speed_base = 1
      state.timeSinceFwdRelease = 0
      state.fwdWasDown = false

    else
      state.timeSinceFwdRelease = state.timeSinceFwdRelease + 1
    end
  elseif keys.up then

    if (not state.fwdWasDown) and state.timeSinceFwdRelease < 10 then
      state.speed_base = SPRINT_MODIFIER
      state.timeSinceAux = 0
    end
    state.fwdWasDown = true

    if (not keys.aux1) and state.timeSinceAux > 100 then
      state.speed_base = 1
    end
  end
end)
