# Shift Log UTK

Logs player shifts to Discord according to their job.

Built for ESX.

**IMPORTANT INFO:** When a player starts the shift and then ends the shift the next day, script miscalculates the duration. I will fix this but I'm too busy with main scripts. Don't worry when I fix this I will share the update to everyone.

## Installation

- Nothing much actually, just pust it in the resources file and start in server.cfg, starting line doesn't matter.

## Configuration

- First set discord webhook, bot's name and bot's avatar in server.lua

- It has police and ambulance job included, if you want to add more jobs just copy the police methods or ambulance. There are comment lines for you to easily find the places you need to edit in order to add more jobs.

## Using with off-duty, on-duty (NOT NEEDED ANYMORE)

If you are using an off-duty script, best way to implement this script is to create an serverevent and triggering it in the off-duty script when a player goes off-duty or on-duty.

Here is a basic example:

**IMPORTANT INFO:** Going on-duty or off-duty is done by changing a players job, therefore it will clash with setJob event. You need to make sure they don't clash and cause issues.

**BELOW USAGE IS DEPRECATED!** You don't need the below code anymore since "utk_sl:jobschanged" event also handles off-duty.

```lua
RegisterServerEvent("utk_sl:dutyChange")
AddEventHandler("utk_sl:dutyChange", function(plysource, method) -- it is very important to pass the source from the first server event to this one as an argument
    local xPlayer = ESX.GetPlayerFromId(plysource)
    local job = xPlayer.job.name -- this is the current player jop
    local header, color = nil, nil

    if method == 1 then -- let's say method 1 is going off-duty and method 2 is going on-duty
        if job == "police-off" then -- off duty name of the job
            header = "Police Shift"
            for k, v in pairs(timers.police) do
                if v.id == xPlayer.identifier then
                local duration = os.time() - v.time
                local date = v.date
                local timetext = nil

                if duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header ,"Steam Name: **"..xPlayer.name.."**, Hex: **"..xPlayer.identifier.."** \n Shift duration: **__"..timetext.."__** \n Start date: **"..date.."** \n End date: **"..os.date("%d/%m/%Y %X").."**", color)
                table.remove(timers.police, k)
                end
            end
        elseif job == "ambulance-off" then -- off duty name of the second job
            header = "EMS Shift"
            for k, v in pairs(timers.ambulance) do
                if v.id == xPlayer.identifier then
                local duration = os.time() - v.time
                local date = v.date
                local timetext = nil

                if duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header ,"Steam Name: **"..xPlayer.name.."**, Hex: **"..xPlayer.identifier.."** \n Shift duration: **__"..timetext.."__** \n Start date: **"..date.."** \n End date: **"..os.date("%d/%m/%Y %X").."**", color)
                table.remove(timers.ambulance, k)
                end
            end
        end
    elseif method == 2 then
        table.insert(timers[job], {id = xPlayer.identifier, time = os.time(), date = os.date("%d/%m/%Y %X")})
    end
end)
```

## Contact

[My Patreon](https://www.patreon.com/utkforeva) where you can see all my scripts.

[My Discord Channel](https://discord.gg/yqHmvcr) where you can see the details of my scripts and ask for help from me or reach me.
