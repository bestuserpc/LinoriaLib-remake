local LinoriaLib = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local FileService = game:GetService("FileService")

function LinoriaLib:OpenDiscordLink()
    local url = "https://discord.gg/REG77bCwJh"
    game:GetService("HttpService"):GetAsync(url)
end

function LinoriaLib:CreateWindow(title)
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "LinoriaGUI"
    gui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, 500, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topBar.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local tabsFrame = Instance.new("Frame", mainFrame)
    tabsFrame.Size = UDim2.new(0, 120, 1, -30)
    tabsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabsFrame.BorderSizePixel = 0

    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -120, 1, -30)
    contentFrame.Position = UDim2.new(0, 120, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentFrame.BorderSizePixel = 0

    local tabs = {}

    function tabs:CreateTab(name)
        local button = Instance.new("TextButton", tabsFrame)
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.Text = name
        button.Font = Enum.Font.Gotham
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 12
        button.BorderSizePixel = 0

        local tabContent = Instance.new("Frame", contentFrame)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1

        button.MouseButton1Click:Connect(function()
            for _, child in ipairs(contentFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabContent.Visible = true
        end)

        return {
            Content = tabContent,
            Button = button
        }
    end

    return tabs
end

local function GetKeyFromUser()
    local userKey = ""
    local input = Instance.new("TextBox", playerGui)
    input.Size = UDim2.new(0, 300, 0, 50)
    input.Position = UDim2.new(0.5, -150, 0.5, -25)
    input.Text = "Введите ключ"
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.BorderSizePixel = 0
    input.TextChanged:Connect(function()
        userKey = input.Text
    end)

    local submitButton = Instance.new("TextButton", playerGui)
    submitButton.Size = UDim2.new(0, 100, 0, 50)
    submitButton.Position = UDim2.new(0.5, -50, 0.5, 30)
    submitButton.Text = "Подтвердить"
    submitButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Font = Enum.Font.Gotham
    submitButton.TextSize = 14
    submitButton.BorderSizePixel = 0

    submitButton.MouseButton1Click:Connect(function()
        if userKey == "valid_key" then
            print("Ключ принят!")
            writefile("LinoriaLibKey.txt", userKey)
            input:Destroy()
            submitButton:Destroy()
        else
            print("Неверный ключ!")
            input.Text = "Неверный ключ"
        end
    end)
end

function LinoriaLib:HandleKeySystem()
    local keyPath = "LinoriaLibKey.txt"
    local savedKey = nil

    if isfile(keyPath) then
        savedKey = readfile(keyPath)
        print("Ключ найден: " .. savedKey)
    else
        GetKeyFromUser()
    end
end

LinoriaLib:OpenDiscordLink()
LinoriaLib:HandleKeySystem()

function LinoriaLib:CreateToggle(parent, text, defaultState, callback)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 150, 0, 40)
    toggle.Position = UDim2.new(0, 10, 0, 10)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = text .. (defaultState and " (On)" or " (Off)")
    toggle.Font = Enum.Font.Gotham
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 14
    toggle.BorderSizePixel = 0

    toggle.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        toggle.Text = text .. (defaultState and " (On)" or " (Off)")
        callback(defaultState)
    end)
end

function LinoriaLib:CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(0, 150, 0, 40)
    sliderFrame.Position = UDim2.new(0, 10, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = text .. ": " .. default
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    local slider = Instance.new("TextButton", sliderFrame)
    slider.Size = UDim2.new(1, 0, 0.5, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    slider.Text = ""
    slider.BorderSizePixel = 0

    slider.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = slider.AbsolutePosition
        local sliderSize = slider.AbsoluteSize
        local newValue = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        local value = math.floor((min + (max - min) * newValue) + 0.5)
        label.Text = text .. ": " .. value
        callback(value)
    end)
end

function LinoriaLib:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 110)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.BorderSizePixel = 0

    button.MouseButton1Click:Connect(function()
        callback()
    end)
end

function LinoriaLib:CreateDropdown(parent, text, options, callback)
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(0, 150, 0, 40)
    dropdownFrame.Position = UDim2.new(0, 10, 0, 160)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", dropdownFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    local dropdownButton = Instance.new("TextButton", dropdownFrame)
    dropdownButton.Size = UDim2.new(1, 0, 0.5, 0)
    dropdownButton.Position = UDim2.new(0, 0, 0.5, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    dropdownButton.Text = "Select"
    dropdownButton.BorderSizePixel = 0

    local dropdownList = Instance.new("Frame", dropdownButton)
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.Visible = false

    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton", dropdownList)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Text = option
        optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        optionButton.BorderSizePixel = 0

        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end

    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
end

function LinoriaLib:CreateColorPicker(parent, text, callback)
    local colorPickerFrame = Instance.new("Frame", parent)
    colorPickerFrame.Size = UDim2.new(0, 150, 0, 40)
    colorPickerFrame.Position = UDim2.new(0, 10, 0, 210)
    colorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", colorPickerFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    local colorButton = Instance.new("TextButton", colorPickerFrame)
    colorButton.Size = UDim2.new(1, 0, 0.5, 0)
    colorButton.Position = UDim2.new(0, 0, 0.5, 0)
    colorButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    colorButton.Text = "Pick Color"
    colorButton.BorderSizePixel = 0

    colorButton.MouseButton1Click:Connect(function()
        local color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        colorButton.BackgroundColor3 = color
        callback(color)
    end)
end

function LinoriaLib:CreateKeybind(parent, text, defaultKey, callback)
    local keybindFrame = Instance.new("Frame", parent)
    keybindFrame.Size = UDim2.new(0, 150, 0, 40)
    keybindFrame.Position = UDim2.new(0, 10, 0, 260)
    keybindFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", keybindFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = text .. ": " .. defaultKey
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    local keyButton = Instance.new("TextButton", keybindFrame)
    keyButton.Size = UDim2.new(1, 0, 0.5, 0)
    keyButton.Position = UDim2.new(0, 0, 0.5, 0)
    keyButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    keyButton.Text = "Set Key"
    keyButton.BorderSizePixel = 0

    keyButton.MouseButton1Click:Connect(function()
        local input = UserInputService.InputBegan:Wait()
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode.Name
            label.Text = text .. ": " .. key
            callback(key)
        end
    end)
end

return LinoriaLib
