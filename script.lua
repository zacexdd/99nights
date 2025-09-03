--// KEY SYSTEM
local CorrectKey = "99 nights"

-- Function to start your main script AFTER key check
local function StartMainScript()
    --// ==== YOUR OLD SCRIPT START ====
    local Players = game:GetService("Players")
    local TextChatService = game:GetService("TextChatService")
    local ChatService = game:GetService("Chat")

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

    local commit = shared.CustomCommit and tostring(shared.CustomCommit)
        or shared.StagingMode and "staging"
        or "7b3fad2b46336a55beca73caa205fb49dac41165"

    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..tostring(commit).."/newnightsintheforest.lua", true))()
    --// ==== YOUR OLD SCRIPT END ====
end


--// GUI POPUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔑 Enter Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(0.8,0,0,40)
TextBox.Position = UDim2.new(0.1,0,0.35,0)
TextBox.PlaceholderText = "Enter the key"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
TextBox.BorderSizePixel = 0
TextBox.TextSize = 18

local Submit = Instance.new("TextButton", Frame)
Submit.Size = UDim2.new(0.45,-5,0,35)
Submit.Position = UDim2.new(0.05,0,0.7,0)
Submit.Text = "Submit"
Submit.TextColor3 = Color3.fromRGB(255,255,255)
Submit.BackgroundColor3 = Color3.fromRGB(70,70,70)
Submit.BorderSizePixel = 0
Submit.TextSize = 18

local GetKeyBtn = Instance.new("TextButton", Frame)
GetKeyBtn.Size = UDim2.new(0.45,-5,0,35)
GetKeyBtn.Position = UDim2.new(0.5,0,0.7,0)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.TextSize = 18

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,30)
Status.Position = UDim2.new(0,0,1,-30)
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 16

-- Button actions
Submit.MouseButton1Click:Connect(function()
    if TextBox.Text == CorrectKey then
        Status.Text = "✅ Key Accepted! Loading..."
        wait(1)
        ScreenGui:Destroy()
        StartMainScript()
    else
        Status.Text = "❌ Invalid Key!"
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://locked1.com/cl/i/kr7wml")
    Status.Text = "📋 Copied link to clipboard!"
end)

