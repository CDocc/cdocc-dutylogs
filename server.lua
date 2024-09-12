local QBCore = exports['qb-core']:GetCoreObject()
local previousDutyStatus = {}
local lastLogTime = {}
local onDutyStartTimes = {}
local logCooldown = config.logCooldown

local function sendToDiscord(webhookURL, title, description, color, timestamp)
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {
                ["text"] = "Duty Logger by CDocc"
            },
            ["timestamp"] = timestamp
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Duty Logger", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local function getFrameworkPlayer(src)
    local src = source
    if Framework == 'qb' then
        return QBCore.Functions.GetPlayer(src)
    elseif Framework == 'qbox' then
        return exports.qbx_core:GetPlayer(src)
    end
end

RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(playerData)
    local src = source
    local player = getFrameworkPlayer(src)
    local job = playerData.job.name
    local duty = playerData.job.onduty
    local webhookURL = config.jobWebhooks[job]

    if previousDutyStatus[src] ~= duty then
        previousDutyStatus[src] = duty

        local currentTime = os.time()
        if not lastLogTime[src] or (currentTime - lastLogTime[src]) >= logCooldown then
            lastLogTime[src] = currentTime

            local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")

            if webhookURL then
                if duty then
                    onDutyStartTimes[src] = currentTime
                    sendToDiscord(webhookURL, "Player On Duty", playerData.name .. " | **" .. playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname .. "** is now on duty as " .. job, 3066993, timestamp)
                else
                    local onDutyStartTime = onDutyStartTimes[src]
                    if onDutyStartTime then
                        local totalTimeOnDuty = currentTime - onDutyStartTime
                        onDutyStartTimes[src] = nil

                        local hours = math.floor(totalTimeOnDuty / 3600)
                        local minutes = math.floor((totalTimeOnDuty % 3600) / 60)
                        local seconds = totalTimeOnDuty % 60

                        local totalTimeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
                        sendToDiscord(webhookURL, "Player Off Duty", playerData.name .. " | **" .. playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname .. "** is now off duty as " .. job .. ". Total time on duty: " .. totalTimeString, 15158332, timestamp)
                    else
                        sendToDiscord(webhookURL, "Player Off Duty", playerData.name .. " | **" .. playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname .. "** is now off duty as " .. job, 15158332, timestamp)
                    end
                end
            else
                print("No webhook URL configured for job: " .. job)
            end
        end
    end
end)
