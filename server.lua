local QBCore = exports['qb-core']:GetCoreObject()
local previousDutyStatus = {}

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
    if config.framework == 'qb' then
        return QBCore.Functions.GetPlayer(src)
    elseif config.framework == 'qbox' then
        return exports.qbx_core:GetPlayer(src)
    end
end

RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(playerData)
    local src = source
    local player = getFrameworkPlayer(src)
    local job = playerData.job.name
    local duty = playerData.job.onduty
    local webhookURL = jobWebhooks[job]

    if previousDutyStatus[src] ~= duty then
        previousDutyStatus[src] = duty

        local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")

        if webhookURL then
            if duty then
                sendToDiscord(webhookURL, "Player On Duty", playerData.name .. " | **" ..playerData.charinfo.firstname.. " " ..playerData.charinfo.lastname.. "** is now on duty as " .. job, 3066993, timestamp) -- Green color
            else
                sendToDiscord(webhookURL, "Player Off Duty", playerData.name .. " | **" ..playerData.charinfo.firstname.. " " ..playerData.charinfo.lastname.. "** is now off duty as " .. job, 15158332, timestamp) -- Red color
            end
        else
            print("No webhook URL configured for job: " .. job)
        end
    end
end)