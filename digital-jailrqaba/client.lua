VORPcore = exports.vorp_core:GetCore()
RegisterNetEvent('teleportToPrison')
AddEventHandler('teleportToPrison', function(prisonLocation)
    SetEntityCoordsNoOffset(PlayerId(), prisonLocation.x, prisonLocation.y, prisonLocation.z, true, true, true)
end)

RegisterNetEvent('teleportFromPrison')
AddEventHandler('teleportFromPrison', function(exitLocation)
    SetEntityCoordsNoOffset(PlayerId(), exitLocation.x, exitLocation.y, exitLocation.z, true, true, true)
end)