local function StartMainScript()
    if not game:IsLoaded() then return end
    local CheatEngineMode = false
    if (not getgenv) or (getgenv and type(getgenv) ~= "function") then CheatEngineMode = true end
    if getgenv and not getgenv().shared then CheatEngineMode = true; getgenv().shared = {}; end
    if getgenv and not getgenv().debug then CheatEngineMode = true; getgenv().debug = {traceback = function(string) return string end} end
    if getgenv and not getgenv().require then CheatEngineMode = true; end
    if getgenv and getgenv().require and type(getgenv().require) ~= "function" then CheatEngineMode = true end

    local debugChecks = {
        Type = "table",
        Functions = {
            "getupvalue",
            "getupvalues",
            "getconstants",
            "getproto"
        }
    }

    -- Executor check removed blacklist
    local function checkExecutor()
        if identifyexecutor ~= nil and type(identifyexecutor) == "function" then
            pcall(function() identifyexecutor() end)
        end
    end
    task.spawn(checkExecutor)

    shared.CheatEngineMode = shared.CheatEngineMode or CheatEngineMode

    if game.PlaceId == 79546208627805 then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware | 99 Nights In The Forest",
                Text = "Go In Game for Voidware to load :D [You are in lobby currently]",
                Duration = 10
            })
        end)
        return
    end

    task.spawn(function()
        pcall(function()
            local Services = setmetatable({}, {
                __index = function(self, key)
                    local suc, service = pcall(game.GetService, game, key)
                    if suc and service then
                        self[key] = service
                        return service
                    else
                        warn(`[Services] Warning: "{key}" is not a valid Roblox service.`)
                        return nil
                    end
                end
            })

            local Players = Services.Players
            local TextChatService = Services.TextChatService
            local ChatService = Services.ChatService
            repeat task.wait() until game:IsLoaded() and Players.LocalPlayer ~= nil
            local chatVersion = TextChatService and TextChatService.ChatVersion or Enum.ChatVersion.LegacyChatService
            local TagRegister = shared.TagRegister or {}
            if not shared.CheatEngineMode then
                if chatVersion == Enum.ChatVersion.TextChatService then
                    TextChatService.OnIncomingMessage = function(data)
                        TagRegister = shared.TagRegister or {}
                        local properties = Instance.new("TextChatMessageProperties", game:GetService("Workspace"))
                        local TextSource = data.TextSource
                        local PrefixText = data.PrefixText or ""
                        if TextSource then
                            local plr = Players:GetPlayerByUserId(TextSource.UserId)
                            if plr then
                                local prefix = ""
                                if TagRegister[plr] then
                                    prefix = prefix .. TagRegister[plr]
                                end
                                if plr:GetAttribute("__OwnsVIPGamepass") and plr:GetAttribute("VIPChatTag") ~= false then
                                    prefix = prefix .. "<font color='rgb(255,210,75)'>[VIP]</font> "
                                end
                                local currentLevel = plr:GetAttribute("_CurrentLevel")
                                if currentLevel then
                                    prefix = prefix .. string.format("<font color='rgb(173,216,230)'>[</font><font color='rgb(255,255,255)'>%s</font><font color='rgb(173,216,230)'>]</font> ", tostring(currentLevel))
                                end
                                local playerTagValue = plr:FindFirstChild("PlayerTagValue")
                                if playerTagValue and playerTagValue.Value then
                                    prefix = prefix .. string.format("<font color='rgb(173,216,230)'>[</font><font color='rgb(255,255,255)'>#%s</font><font color='rgb(173,216,230)'>]</font> ", tostring(playerTagValue.Value))
                                end
                                prefix = prefix .. PrefixText
                                properties.PrefixText = string.format("<font color='rgb(255,255,255)'>%s</font>", prefix)
                            end
                        end
                        return properties
                    end
                elseif chatVersion == Enum.ChatVersion.LegacyChatService then
                    ChatService:RegisterProcessCommandsFunction("CustomPrefix", function(speakerName, message)
                        TagRegister = shared.TagRegister or {}
                        local plr = Players:FindFirstChild(speakerName)
                        if plr then
                            local prefix = ""
                            if TagRegister[plr] then
                                prefix = prefix .. TagRegister[plr]
                            end
                            if plr:GetAttribute("__OwnsVIPGamepass") and plr:GetAttribute("VIPChatTag") ~= false then
                                prefix = prefix .. "[VIP] "
                            end
                            local currentLevel = plr:GetAttribute("_CurrentLevel")
                            if currentLevel then
                                prefix = prefix .. string.format("[%s] ", tostring(currentLevel))
                            end
                            local playerTagValue = plr:FindFirstChild("PlayerTagValue")
                            if playerTagValue and playerTagValue.Value then
                                prefix = prefix .. string.format("[#%s] ", tostring(playerTagValue.Value))
                            end
                            prefix = prefix .. speakerName
                            return prefix .. " " .. message
                        end
                        return message
                    end)
                end
            end
        end)
    end)

    local commit = shared.CustomCommit and tostring(shared.CustomCommit) or shared.StagingMode and "staging" or "7b3fad2b46336a55beca73caa205fb49dac41165"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..tostring(commit).."/newnightsintheforest.lua", true))()
end

end
