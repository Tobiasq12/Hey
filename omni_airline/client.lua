------------------
-- CONFIG START --
------------------
local STATE = "none"
local ONDUTY = false
local drawCircle = false
local JobCooldown = 0
local quitJob = false
local current_job = {}
local prev_job = {}

local promptGoOnDuty = "Press ~g~E ~w~to ~g~Start Work ~w~as a ~y~Pilot"
local alreadyOnDutyText = "You are already on duty"

-- Blip Settings
local job_blip_settings = {
    start_blip = {id = 402, color = 4},
    pickup_blip = {id = 280, color = 69},
    destination_blip = {id = 538, color = 46},
    vehicle_blip = {id = 529, color = 48},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
    spawner_blip = {id = 524, color = 17},

}

local job_starts = {
    {name = "San Chianski Airport", x = 6452.345215, y = 2952.462402, z = 11.000142, h = 88.787300},
    {name = "Pacific Ocean", x = 3052.0178222656, y = -1171.9498291016, z = 19.438756942749, h = 128.758682},
    {name = "Mt. Gordo Airport", x = 2481.4245605469, y = 6672.2133789063, z = 21.01895904541, h = 173.118927},
    {name = "Paleto Bay Airport", x = -271.90991210938, y = 6584.4716796875, z = 10.761937141418, h = 135.791641},
    {name = "Chumash Island Airport", x = -5339.120117, y = 1146.926025, z = 11.000139, h = 359.246796},
    {name = "LSIA", x = -1343.6480712891, y = -2690.0434570313, z = 13.944941520691},
    {name = "LSIA", x = -1234.2884521484, y = -2885.0651855469, z = 13.941093444824},
    {name = "LSIA", x = -1298.6856689453, y = -2796.7189941406, z = 13.944936752319},
    {name = "LSIA", x = -963.37567138672, y = -2995.6298828125, z = 13.945066452026},
    {name = "FIA Terminal 1", x = -4252.838867, y = 6473.305176, z = 11.177495, h = 356.631531},
    {name = "SSIA Terminal 1", x = 825.649536, y = 3841.881836, z = 33.416058, h = 174.813766}, -- Collins (2)
}

local job_vehicles = {
    {name = "VESTRA", tier = 1, capacity = 60},
    {name = "VELUM", tier = 2, capacity = 88},
    {name = "NIMBUS", tier = 3, capacity = 132},
    {name = "SHAMAL", tier = 4, capacity = 176},
    {name = "LUXOR", tier = 5, capacity = 220},
    {name = "MILJET", tier = 6, capacity = 264},
    {name = "DASH8", tier = 7, capacity = 308},
    {name = "737200", tier = 8, capacity = 352},
    {name = "788", tier = 9, capacity = 396},
    {name = "a330neo", tier = 10, capacity = 440},
}

local dropoff_locations = {
    -- P.O Custom Airport -- Collins (2)
    {name = "San Chianski Airport Terminal 1", x = 6452.345215, y = 2952.462402, z = 12.000142, h = 88.787300}, -- Collins (2)
    {name = "San Chianski Airport Terminal 2", x = 6452.173828, y = 3052.468018, z = 12.000145, h = 91.254181}, -- Collins (2)
    {name = "San Chianski Airport Terminal 3", x = 6452.255371, y = 3152.511475, z = 12.000142, h = 89.752083}, -- Collins (2)
    {name = "San Chianski Airport Terminal 4", x = 5952.173828, y = 3152.538574, z = 12.000142, h = 88.832268}, -- Collins (2)
    {name = "San Chianski Airport Terminal 5", x = 5952.335449, y = 3052.499512, z = 12.000143, h = 90.067215}, -- Collins (2)
    {name = "San Chianski Airport Terminal 6", x = 5952.260254, y = 2952.531250, z = 12.000142, h = 89.755920}, -- Collins (2)
    -- non custom PO -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    -- {name = "Pacific Ocean Terminal 1", x = 2911.239014, y = -903.791504, z = 8.486864, h = 128.758682}, -- Collins (2)
    {name = "Pacific Ocean Terminal S-1", x = 3095.0859375, y = -1453.4041748047, z = 19.438787460327, h = 180.92518615723}, -- glitchdetector (3)
    {name = "Pacific Ocean Terminal S-3", x = 3018.0270996094, y = -1369.6495361328, z = 19.43878364563, h = 87.219444274902}, -- glitchdetector (3)
    {name = "Pacific Ocean Terminal W-4", x = 2942.259765625, y = -1162.8835449219, z = 19.438772201538, h = 85.092544555664}, -- glitchdetector (3)
    {name = "Pacific Ocean Terminal W-6", x = 2974.9826660156, y = -998.66003417969, z = 19.43878364563, h = 56.638175964355}, -- glitchdetector (3)
    {name = "Pacific Ocean Terminal N-8", x = 3018.5310058594, y = -546.08996582031, z = 19.438787460327, h = 47.063835144043}, -- glitchdetector (3)
    {name = "Pacific Ocean Terminal N-9", x = 3078.392578125, y = -509.25531005859, z = 19.438785552979, h = 25.456996917725}, -- glitchdetector (3)
    -- PIA
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- {name = "Procopio International Terminal 1", x = 884.375610, y = 6720.441895, z = 5.993942, h = 173.118927}, -- Collins (2)
    -- PB
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    -- {name = "Paleto Bay Airport Terminal 1", x = -432.230164, y = 6539.273438, z = 7.685759, h = 135.791641}, -- Collins (2)
    {name = "Paleto Bay Airport Terminal 1", x = -60.132556915283, y = 6912.4936523438, z = 10.766198158264, h = 314.92614746094}, -- glitchdetector (3)
    {name = "Paleto Bay Airport Terminal 2", x = -103.89933013916, y = 6830.83203125, z = 10.766052246094, h = 257.56921386719}, -- glitchdetector (3)
    {name = "Paleto Bay Airport Terminal 3", x = -116.77157592773, y = 6710.7265625, z = 10.766059875488, h = 320.96539306641}, -- glitchdetector (3)
    -- {name = "Paleto Bay Airport Terminal 4", x = -174.31356811523, y = 6645.2998046875, z = 10.76619052887, h = 141.92622375488}, -- glitchdetector (3)
    {name = "Paleto Bay Airport Terminal 5", x = -264.98501586914, y = 6582.7094726563, z = 10.766192436218, h = 224.99545288086}, -- glitchdetector (3)
    {name = "Paleto Bay Airport Terminal 6", x = -336.15536499023, y = 6520.7983398438, z = 10.766051292419, h = 219.21603393555}, -- glitchdetector (3)
    {name = "Paleto Bay Airport Terminal 7", x = -405.65405273438, y = 6476.0537109375, z = 10.766003608704, h = 206.63900756836}, -- glitchdetector (3)
    -- West Coast Custom airport -- Collins (2)
    {name = "Chumash Island Airport Terminal 1", x = -5339.120117, y = 1146.926025, z = 12.000139, h = 359.246796}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 2", x = -5239.099121, y = 1146.950928, z = 12.000154, h = 359.701019}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 3", x = -5139.071289, y = 1146.947021, z = 12.000154, h = 359.763092}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 4", x = -4755.903320, y = 663.724304, z = 12.000139, h = 269.926270}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 5", x = -4755.859863, y = 563.654663, z = 12.000140, h = 270.013580}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 6", x = -4756.082520, y = 263.672516, z = 12.000141, h = 267.310089}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 7", x = -4756.033203, y = 163.650391, z = 12.000138, h = 268.870178}, -- Collins (2)
    {name = "Chumash Island Airport Terminal 8", x = -4755.981934, y = 63.680500, z = 12.000139, h = 269.415344}, -- Collins (2)
    -- LSIA
    {name = "LSIA terminal 8", x = -1212.608887, y = -2647.682373, z = 13.944932, h = 147.346954}, -- Collins (2)
    {name = "LSIA terminal 8", x = -1212.608887, y = -2647.682373, z = 13.944932, h = 147.346954}, -- Collins (2)
    {name = "LSIA terminal 8", x = -1212.608887, y = -2647.682373, z = 13.944932, h = 147.346954}, -- Collins (2)
    {name = "LSIA terminal 8", x = -1212.608887, y = -2647.682373, z = 13.944932, h = 147.346954}, -- Collins (2)
    {name = "LSIA terminal 2", x = -1343.6480712891, y = -2690.0434570313, z = 13.944941520691},
    {name = "LSIA terminal 2", x = -1343.6480712891, y = -2690.0434570313, z = 13.944941520691},
    {name = "LSIA terminal 2", x = -1343.6480712891, y = -2690.0434570313, z = 13.944941520691},
    {name = "LSIA terminal 2", x = -1343.6480712891, y = -2690.0434570313, z = 13.944941520691},
    -- LC
    {name = "FIA Terminal 1", x = -4252.838867, y = 6473.305176, z = 11.177495, h = 356.631531}, -- Collins (2)
    {name = "FIA Terminal 2", x = -4281.402344, y = 6467.981445, z = 11.177847, h = 357.815277}, -- Collins (2)
    {name = "FIA Terminal 3", x = -4344.358887, y = 6552.250977, z = 11.177855, h = 257.415222}, -- Collins (2)
    {name = "FIA Terminal 4", x = -4274.746094, y = 6588.265137, z = 11.200653, h = 149.268585}, -- Collins (2)
    {name = "FIA Terminal 5", x = -4247.850098, y = 6567.548828, z = 11.177491, h = 148.756699}, -- Collins (2)
    {name = "FIA Terminal 1", x = -4252.838867, y = 6473.305176, z = 11.177495, h = 356.631531}, -- Collins (2)
    {name = "FIA Terminal 2", x = -4281.402344, y = 6467.981445, z = 11.177847, h = 357.815277}, -- Collins (2)
    {name = "FIA Terminal 3", x = -4344.358887, y = 6552.250977, z = 11.177855, h = 257.415222}, -- Collins (2)

    -- SSIA
    {name = "SSIA Terminal 1", x = 825.649536, y = 3841.881836, z = 33.416058, h = 174.813766}, -- Collins (2)
    {name = "SSIA Terminal 2", x = 735.790527, y = 3838.831299, z = 33.416084, h = 175.816925}, -- Collins (2)
    {name = "SSIA Terminal 3", x = 658.861450, y = 3840.575684, z = 33.416084, h = 179.508789}, -- Collins (2)
    {name = "SSIA Terminal 4", x = 568.644226, y = 3842.442139, z = 33.416084, h = 176.775314}, -- Collins (2)
    {name = "SSIA Terminal 1", x = 825.649536, y = 3841.881836, z = 33.416058, h = 174.813766}, -- Collins (2)
    {name = "SSIA Terminal 2", x = 735.790527, y = 3838.831299, z = 33.416084, h = 175.816925}, -- Collins (2)
    {name = "SSIA Terminal 3", x = 658.861450, y = 3840.575684, z = 33.416084, h = 179.508789}, -- Collins (2)
    {name = "SSIA Terminal 4", x = 568.644226, y = 3842.442139, z = 33.416084, h = 176.775314}, -- Collins (2)

    -- MGA
    {name = "Mount Gordo Terminal 1", x = 2946.9311523438, y = 6633.6474609375, z = 20.511375427246},
    {name = "Mount Gordo Terminal 2", x = 2872.0876464844, y = 6514.75, z = 20.509511947632},
    {name = "Mount Gordo Terminal 3", x = 2777.1384277344, y = 6583.7412109375, z = 20.51197052002},
    {name = "Mount Gordo Terminal 4", x = 2686.6284179688, y = 6626.0380859375, z = 20.511350631714},
    -- {name = "Mount Gordo Terminal 5", x = 2577.8049316406, y = 6652.5458984375, z = 20.510654449463},
    {name = "Mount Gordo Terminal 6", x = 2491.1923828125, y = 6663.1083984375, z = 20.512058258057},
    {name = "Mount Gordo Terminal 7", x = 2334.681640625, y = 6768.0961914063, z = 20.511848449707},
    {name = "Mount Gordo Terminal 8", x = 2200.3930664063, y = 6807.224609375, z = 20.511043548584},


}
------------------
--  CONFIG END  --
------------------

-- Injection Protection Snippet --
--[[#INCLUDE W1ND3RGSNIP]]--
local AC_KEY = "\119\105\110\51\114\103\47\114\114\101\114\114"
RegisterNetEvent("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"]())
AddEventHandler("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"](), function(k)
	AC_KEY = k
end)
-- REMOVE BELOW IF MULTI-PURPOSE SCRIP
local _tse = TriggerServerEvent
local TriggerServerEvent = function(ev, ...)
	_tse(ev, AC_KEY, ...)
end
--[[#END W1ND3RGSNIP]]--
-- End of Injection Protection --

RegisterNetEvent("omni:plane:tryStartJob")
AddEventHandler("omni:plane:tryStartJob",
    function()
        startJob()
    end
)

function isInValidVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if IsVehicleAttachedToTrailer(veh) then
        _, veh = GetVehicleTrailerVehicle(veh)
    end
    if not veh then
        return false
    end
    local model = GetEntityModel(veh)
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return true
        end
    end
    return false
end

function isOnDuty()
    return ONDUTY == true
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

local function GetRandomDestination()
    local dest = dropoff_locations[math.random(#dropoff_locations)]
    local dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    while dist < 2000 do
        dest = GetRandomDestination()
        dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    end

    if prev_job.start == nil then
        prev_job.start = {x = 0, y = 0, z = 0}
    end

    if #(vec3(prev_job.start.x, prev_job.start.y, prev_job.start.z) - vec3(dest.x, dest.y, dest.z)) < 1000 then
        dest = GetRandomDestination()
        -- print("destination to close to previous start point, re rolling") -- ensures you aren't sent back to where you're came from the range is for multi terminal airports
    end

    dist = math.floor(dist)
    return dest, dist
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if #(pos - vec3(x, y, z)) < 50.0 then
        DrawMarker(1, x, y, z, 0,0,0,0,0,0,10.0,10.0,4.0,marker.r,marker.g,marker.b,marker.a,0,0,0,0)
    end
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (#(p - vec3(x, y, z)) < 24 and zDist < 24)
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function openDoors()
    playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        SetVehicleDoorOpen(playerVeh, 6, false)
        SetVehicleDoorOpen(playerVeh, 5, false)
        SetVehicleDoorOpen(playerVeh, 4, false)
        SetVehicleDoorOpen(playerVeh, 3, false)
        SetVehicleDoorOpen(playerVeh, 2, false)
        SetVehicleDoorOpen(playerVeh, 1, false)
        SetVehicleDoorOpen(playerVeh, 0, false)
    end
end

function closeDoors()
    playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        SetVehicleDoorShut(playerVeh, 6, false)
        SetVehicleDoorShut(playerVeh, 5, false)
        SetVehicleDoorShut(playerVeh, 4, false)
        SetVehicleDoorShut(playerVeh, 3, false)
        SetVehicleDoorShut(playerVeh, 2, false)
        SetVehicleDoorShut(playerVeh, 1, false)
        SetVehicleDoorShut(playerVeh, 0, false)
    end
end

function getCurrentTier()
    local tier = 0
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    if veh then
        for k,v in next, job_vehicles do
            if GetEntityModel(veh) == GetHashKey(v.name) then
                tier = v.tier
                capacity = v.capacity
                break
            end
        end
    end
    return tier, capacity
end

function startJob()
    if JobCooldown == 0 then
        if isInValidVehicle() then
            JobCooldown = 600
            ONDUTY = true
            STATE = "boarding"
            createMission()
        else
            TriggerEvent("gd_utils:notify","you need to be in the correct vehicle for this")
        end
    else
        TriggerEvent("gd_utils:notify", ("You can not start another route for~r~ %i ~w~seconds"):format(JobCooldown))
    end
end

function stopJob()
    if ONDUTY then
        TriggerEvent("boarding_timer", -1)
        TriggerEvent("lingering-info:addTimedInfo", "Boarding", 0)
        TriggerEvent("lingering-info:addTimedInfo", "Deboarding", 0)
        ONDUTY = false
        STATE = "none"
        quitJob = true
        drawCircle = false
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, false, false)
        RemoveBlip(current_job.dest_blip)
        current_job = {}
        prev_job = {}
        TriggerEvent("omni:status", "")
    end
end

AddEventHandler("omni:stop_job", function()
    stopJob()
end)

function createMission()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    current_job = {}
    if isOnDuty() and isInValidVehicle() then
        current_job.vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        local tier, capacity = getCurrentTier()
        local boarding = math.floor(tier * 5)
        TriggerEvent("boarding_timer", boarding, "Boarding")
        TriggerEvent("lingering-info:addTimedInfo", "Boarding", boarding)
        current_job.tier = tier
        current_job.capacity = capacity
        current_job.pos = pos
        local dest, dist = GetRandomDestination()
        current_job.dest = dest
        current_job.distance = dist
        openDoors()
        while boarding > 0 do
            if isInValidVehicle() then
                Wait(1000)
                if not current_job.dest then
                    return false
                end
                drawCircle = true
                exports['omni_common']:SetStatus("Airline Pilot", {"Status: ~y~Boarding ~r~(" .. boarding .. " seconds)","~g~Destination: ~w~".. current_job.dest.name, "~g~Distance to destination: ~w~" .. current_job.distance .. "m"},"")
                if #(GetEntityCoords(ped) - pos) < 10.0 then
                    boarding = boarding - 1
                else
                    stopJob()
                    return false
                end
            else
                stopJob()
                TriggerEvent("gd_utils:notify","~r~<C>Boarding aborted</C>")
                return false
            end
        end
        drawCircle = false
        closeDoors()
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, false, false)
        TriggerEvent("gd_utils:notify","~g~<C>Boarding complete ~n~Push back approved</C>")
        local blip = AddBlipForCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
        SetBlipSprite(blip, 385)
        SetBlipColour(blip, 3)
        SetBlipRoute(blip, true)
        SetBlipName(blip, current_job.dest.name)
        current_job.dest_blip = blip
        current_job.zoneName = GetLabelText(GetNameOfZone(current_job.dest.x, current_job.dest.y, current_job.dest.z))
        current_job.str, current_job.cross = GetStreetNameAtCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
        current_job.areaName = GetStreetNameFromHashKey(current_job.str)
        prev_job.start = current_job.pos
        STATE = "delivery"
    end
end

function promptDeliver()
    drawText("Press ~g~E ~w~to deliver the ~y~passengers")
    if IsControlJustPressed(0, 38) then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local veh = GetVehiclePedIsIn(ped, false)
        local tier, capacity = getCurrentTier()
        local deboarding = math.floor(tier * 5)
        TriggerEvent("boarding_timer", deboarding, "Deboarding")
        TriggerEvent("lingering-info:addTimedInfo", "Deboarding", deboarding)
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false), false, true, true)
        openDoors()
        while deboarding > 0 do
            Wait(1000)
            if not current_job.dest then
                return false
            end
            exports['omni_common']:SetStatus("Airline Pilot", "Status: ~y~Deboarding ~r~(" .. deboarding .. " seconds)")
            if #(GetEntityCoords(ped) - pos) < 10.0 then
                deboarding = deboarding - 1
            else
                stopJob()
            end
        end
        TriggerServerEvent("omni:plane:finishjob",current_job.vehicle, current_job.tier, current_job.capacity)
        RemoveBlip(current_job.dest_blip)
        createMission()
    end
end

------------------
--   Main Loop  --
------------------
Citizen.CreateThread(function()
    current_job.blips = {}
    airport_blips = 0
    while true do
        Wait(5)
        -- Off Duty
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            if isInValidVehicle() then
                if not isOnDuty() then
                    for k,v in next, job_starts do --  for each job starts
                        if STATE == "none" then
                            if not v.blip then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, 385)
                                SetBlipColour(v.blip, 38)
                                SetBlipName(v.blip, v.name)
                                SetBlipAsShortRange(v.blip, true)
                                airport_blips = airport_blips + 1
                            end
                        end
                        drawMarker(v.x, v.y, v.z, true) -- Draw the marker to go on duty
                        if nearMarker(v.x, v.y, v.z) then
                            if JobCooldown > 0 then
                                drawText("~r~Wait " .. math.floor(JobCooldown).. " seconds to start a new route.")
                            else
                                if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) < 1 then
                                    drawText(promptGoOnDuty)
                                    if isEPressed() then
                                        TriggerServerEvent("omni:plane:tryStartJob")
                                    end
                                else
                                    drawText("~r~You need to be stopped to do this")
                                end
                            end
                        end
                    end
                else
                    for k,v in next, job_starts do
                        if STATE == "boarding" then
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end
                    end
                end
            else
                for k,v in next, job_starts do
                    if v.blip then
                        if STATE == "none" then
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local playerPos = GetEntityCoords(PlayerPedId())
        local veh = GetVehiclePedIsIn(PlayerPedId())
        if isOnDuty() and STATE == "delivery" then
            if IsPedInVehicle(PlayerPedId(), current_job.vehicle, false) then
                local dist = #(playerPos - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                current_job.distance = math.floor(dist)
                exports['omni_common']:SetStatus("Airline Pilot", {"Status: ~y~On Route~w~","~g~Destination: ~w~".. current_job.dest.name, "~g~Distance to destination: ~w~" .. current_job.distance .. "m"},"")
                if dist <= 250.0 then
                    -- DrawMarker(36, current_job.dest.x, current_job.dest.y, current_job.dest.z + 0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, true, true, 0, false)
                    DrawMarker(1, current_job.dest.x, current_job.dest.y, current_job.dest.z - 1.0, 0, 0, 0, 0, 0, 0, 25.0, 25.0, 5.0, 255, 255, 255, 100, false, false, 0, false)
                end
                if dist <= 25.0 then
                    if GetEntitySpeed(veh) < 1 then
                        if IsPedInVehicle(PlayerPedId(), current_job.vehicle, false) then
                            promptDeliver()
                        end
                    else
                        drawText("You need to be stopped to do this")
                    end
                end
            else
                local _t = 60 * 4
                while not isInValidVehicle() do
                    if quitJob then
                        quitJob = false
                        break
                    end
                    drawText("~r~Get back in your plane! You have " .. math.floor(_t / 4) .. " seconds!")
                    Wait(250)
                    _t = _t - 1
                    if _t <= 0 then
                        TriggerEvent("gd_utils:notify","~r~You've abandoned your passengers")
                        stopJob()
                        break
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if drawCircle == true then
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), false, false, false)
            DrawMarker(1, current_job.pos.x, current_job.pos.y, current_job.pos.z - 1.0, 0, 0, 0, 0, 0, 0, 25.0, 25.0, 5.0, 255, 255, 255, 100, false, false, 0, false)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if(JobCooldown > 0) then
            JobCooldown = JobCooldown - 1
        end
    end
end)
