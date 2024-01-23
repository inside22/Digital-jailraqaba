VorpCore = {}
TriggerEvent("getCore", function(core) VorpCore = core end)

local CircleCenter = {
    vector3(2608.9504, -1263.2504, 52.7219, 2.2981),
    vector3(-848.0875, -1300.7173, 43.3505, 359.9598),
    vector3(-309.8729, 788.6967, 117.6332, 95.9109)
}
local CircleRadius = 70.0
local PrisonLocations = {
    vector3(3358.8569, -668.3077, 45.7074, 118.9370),
}
local ExitLocations = {
    vector3(2717.5898, -1436.9850, 46.2164, 21.6894),
}
local ImprisonmentDuration = 300 ---مدة السجن بالثواني
local isEnabled = false 

function IsInCircularArea(playerPos)
    local distance = #(playerPos - CircleCenter)
    return distance <= CircleRadius
end

function GetPlayerGroup(player)
    return "admin"
end

RegisterCommand("toggleImprisonment", function(source, args, rawCommand)
    local player = source
    local user = VorpCore.getUser(player)
    local playerGroup = GetPlayerGroup(player)

    local allowedGroups = {"admin"} 
    if table.contains(allowedGroups, playerGroup) then
        isEnabled = not isEnabled
        local state = isEnabled and "enabled" or "disabled"
        VorpCore.NotifyRightTop(player, "Imprisonment system is now " .. state, 5000)
    else
        VorpCore.NotifyRightTop(player, "You don't have the required group to toggle the imprisonment system.", 5000)
    end
end)

RegisterServerEvent('playerKilled')
AddEventHandler('playerKilled', function(victim)
    local killer = source
    local killerPos = VorpCore.getUser(killer).getUsedCharacter.location.coords

    if isEnabled and IsInCircularArea(killerPos) then
        local randomIndex = math.random(1, #PrisonLocations)
        local prisonLocation = PrisonLocations[randomIndex]
        local exitLocation = ExitLocations[randomIndex]
        TriggerClientEvent('imprisonPlayer', killer, prisonLocation, exitLocation, ImprisonmentDuration)
        VorpCore.NotifyRightTip(killer, 'Player ' .. killer .. ' killed ' .. victim .. ' in a restricted area. Player imprisoned for 5 minutes.', 4000)
    elseif isEnabled then
        VorpCore.NotifyRightTip(killer, 'Player ' .. killer .. ' killed ' .. victim .. '. No action taken.', 4000)
    end
end)

RegisterServerEvent('imprisonPlayer')
AddEventHandler('imprisonPlayer', function(prisonLocation, exitLocation, duration)
    local player = source
    local user = VorpCore.getUser(player)
    TriggerClientEvent('teleportToPrison', player, prisonLocation)

    SetTimeout(duration * 1000, function()
        TriggerClientEvent('teleportFromPrison', player, exitLocation)
        VorpCore.NotifyRightTip(player, 'Player ' .. player .. ' released from imprisonment.', 4000)
    end)

    print('Imprisoning player...')
    VorpCore.NotifyRightTip(player, 'Imprisoning player...', 4000)
end)