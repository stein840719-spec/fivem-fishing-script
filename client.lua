ESX = exports["es_extended"]:getSharedObject()
local isFishing = false

function IsInFishingZone()
    local coords = GetEntityCoords(PlayerPedId())
    for _, zone in pairs(Config.Zones) do
        if #(coords - zone.coords) < zone.radius then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(0)

        if IsInFishingZone() then

            if not isFishing then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um zu angeln")

                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback('esx_fishing:checkRod', function(hasRod)
                        if hasRod then
                            StartFishing()
                        else
                            ESX.ShowNotification("Du brauchst eine Angel!")
                        end
                    end)
                    Wait(1000)
                end
            else
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um aufzuhören")

                if IsControlJustPressed(0, 38) then
                    StopFishing()
                end
            end

        else
            Wait(1000)
        end
    end
end)

function StartFishing()
    isFishing = true
    ESX.ShowNotification("Du beginnst zu angeln...")

    -- Animation nur EINMAL starten
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)

    CreateThread(function()
        while isFishing do
            Wait(Config.FishingTime * 1000)

            if isFishing then
                TriggerServerEvent("esx_fishing:catchFish")
            end
        end
    end)
end

function StopFishing()
    isFishing = false
    ClearPedTasks(PlayerPedId())
    ESX.ShowNotification("Du hast aufgehört zu angeln.")
end


-- NPC + Blip
CreateThread(function()
    local model = GetHashKey(Config.SellNPC.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = CreatePed(4, model,
        Config.SellNPC.coords.x,
        Config.SellNPC.coords.y,
        Config.SellNPC.coords.z - 1.0,
        Config.SellNPC.coords.w,
        false, true)

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- Blip
    local blip = AddBlipForCoord(Config.SellNPC.coords.x, Config.SellNPC.coords.y, Config.SellNPC.coords.z)
    SetBlipSprite(blip, 356)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fisch Verkäufer")
    EndTextCommandSetBlipName(blip)

    -- Verkauf Interaction
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(Config.SellNPC.coords.x, Config.SellNPC.coords.y, Config.SellNPC.coords.z))

        if distance < 3.0 then
            ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ (E) um Fische zu verkaufen")

            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("esx_fishing:sellFish")
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)
