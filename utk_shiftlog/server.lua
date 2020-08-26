ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local timers = { -- if you want more job shifts add table entry here same as the examples below
    ambulance = {
        {} -- don't edit inside
    },
    police = {
        {} -- don't edit inside
    },
    -- fbi = {}
}
local dcname = "Shift Logger" -- bot's name
local http = "" -- webhook
local avatar = "" -- bot's avatar

function DiscordLog(name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "utkforeva",
            },
        }
    }
    PerformHttpRequest(http, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("utk_sl:userjoined")
AddEventHandler("utk_sl:userjoined", function(job)
    print("triggered: userjoined | job: "..tostring(job))
    local xPlayer = ESX.GetPlayerFromId(source)

    table.insert(timers[job], {id = xPlayer.identifier, time = os.time(), date = os.date("%d/%m/%Y %X")})
end)

RegisterServerEvent("utk_sl:jobchanged")
AddEventHandler("utk_sl:jobchanged", function(old, new, method)
    local xPlayer = ESX.GetPlayerFromId(source)
    local header = nil
    local color = nil

    if old == "police" then
        header = "Police Shift" -- Header
        color = 3447003 -- Color
    elseif old == "ambulance" then
        header = "EMS Shift"
        color = 15158332
    --elseif job == "fbi" then
        --header = "FBI Shift"
        --color = 3447003
    end
    if method == 1 then
        for i = 1, #timers[old], 1 do
            if timers[old][i].id == xPlayer.identifier then
                local duration = os.time() - timers[old][i].time
                local date = timers[old][i].date
                local timetext = nil

                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header , "Steam Name: **"..xPlayer.name.."**, Hex: **"..xPlayer.identifier.."** \n Shift duration: **__"..timetext.."__** \n Start date: **"..date.."** \n End date: **"..os.date("%d/%m/%Y %X").."**", color)
                table.remove(timers[old], i)
                break
            end
        end
    end
    if not (timers[new] == nil) then
        for t, l in pairs(timers[new]) do
            if l.id == xPlayer.identifier then
                table.remove(table[new], l)
            end
        end
    end
    if new == "police" or new == "ambulance" then
        table.insert(timers[new], {id = xPlayer.identifier, time = os.time(), date = os.date("%d/%m/%Y %X")})
    end
end)

RegisterServerEvent("playerDropped")
AddEventHandler("playerDropped", function(reason)
    print("triggered: playerDropped")
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local header = nil
    local color = nil

    if job == "police" then
        header = "Police Shift" -- Header
        color = 3447003 -- Color
    elseif job == "ambulance" then
        header = "EMS Shift"
        color = 15158332
    --elseif job == "fbi" then
        --header = "FBI Shift"
        --color = 3447003
    end
    if job == "police" or job == "ambulance" then
        for i = 1, #timers[job], 1 do
            if timers[job][i].id == xPlayer.identifier then
                local duration = os.time() - timers[job][i].time
                local date = timers[job][i].date
                local timetext = nil

                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header ,"Steam Name: **"..xPlayer.name.."**, Hex: **"..xPlayer.identifier.."** \n Shift duration: **__"..timetext.."__** \n Start date: **"..date.."** \n End date: **"..os.date("%d/%m/%Y %X").."**", color)
                table.remove(timers[job], i)
                return
            end
        end
    end
end)