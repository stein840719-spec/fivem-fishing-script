ESX = exports["es_extended"]:getSharedObject()

-- Angel prüfen (OX)
ESX.RegisterServerCallback('esx_fishing:checkRod', function(source, cb)
    local count = exports.ox_inventory:GetItemCount(source, Config.RodItem)

    if count and count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

-- Fisch fangen (OX)
RegisterServerEvent("esx_fishing:catchFish")
AddEventHandler("esx_fishing:catchFish", function()

    local source = source
    local randomFish = Config.Fishes[math.random(1, #Config.Fishes)]

    -- Item hinzufügen
    local success = exports.ox_inventory:AddItem(source, randomFish.item, 1)

    if success then
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Angeln",
            description = "Du hast gefangen: " .. randomFish.label,
            type = "success"
        })
    else
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Inventar voll",
            description = "Du kannst keinen Fisch mehr tragen.",
            type = "error"
        })
    end
end)

-- Fisch verkaufen (OX)
RegisterServerEvent("esx_fishing:sellFish")
AddEventHandler("esx_fishing:sellFish", function()

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalMoney = 0

    for fish, price in pairs(Config.FishPrices) do
        local count = exports.ox_inventory:GetItemCount(source, fish)

        if count and count > 0 then
            exports.ox_inventory:RemoveItem(source, fish, count)
            totalMoney = totalMoney + (count * price)
        end
    end

    if totalMoney > 0 then
        xPlayer.addMoney(totalMoney)

        TriggerClientEvent("ox_lib:notify", source, {
            title = "Fischverkauf",
            description = "Du hast $" .. totalMoney .. " verdient.",
            type = "success"
        })
    else
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Fischverkauf",
            description = "Du hast keine Fische dabei.",
            type = "error"
        })
    end
end)

