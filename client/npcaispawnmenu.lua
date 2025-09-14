---------------
--By Hallkezz--
---------------

-----------------------------------------------------------------------------------
--Script
class 'NPCAISpawnMenu'

function NPCAISpawnMenu:__init()
    self.window = Window.Create()
    self.window:SetTitle("NPC Spawn Menu")
    self.window:SetSize(Vector2(200, 140))
    self.window:SetPosition(Render.Size / 2 - self.window:GetSize() / 2)
    self.window:SetVisible(false)
    self.window:Subscribe("WindowClosed", self, self.ToggleWindow)

    local window = self.window

    self.target = self:AddItem(window, "Target (Player ID)")
    self.model = self:AddItem(window, "Model ID", 1, 103)
    self.weapon = self:AddItem(window, "Weapon ID")

    local removeall_button = self:AddButton(window, "Remove All")
    removeall_button:Subscribe("Press", function() Network:Send("RemoveAllNPCs") end)

    local spawn_button = self:AddButton(window, "Spawn")
    spawn_button:Subscribe("Press", self, self.SpawnNPC)

    Events:Subscribe("KeyUp", self, self.KeyUp)
end

function NPCAISpawnMenu:AddItem(parent, text, minValue, maxValue)
    local window = BaseWindow.Create(parent)
    window:SetDock(GwenPosition.Top)
    window:SetHeight(20)

    local label = Label.Create(window)
    label:SetText(text)
    label:SetDock(GwenPosition.Left)
    label:SetAlignment(GwenPosition.CenterV)
    label:SetMargin(Vector2.Zero, Vector2(10, 0))
    label:SizeToContents()

    local numeric = Numeric.Create(window)
    numeric:SetDock(GwenPosition.Fill)

    if minValue then
        numeric:SetMinimum(minValue)
        numeric:SetValue(minValue)
    end

    numeric:SetMaximum(maxValue or 200)

    return numeric
end

function NPCAISpawnMenu:AddButton(parent, text)
    local button = Button.Create(parent)
    button:SetText(text)
    button:SetDock(GwenPosition.Bottom)
    button:SetHeight(20)

    return button
end

function NPCAISpawnMenu:SpawnNPC()
    local state = LocalPlayer:GetState()
    local aimtarget = state == PlayerState.OnFoot or state == PlayerState.StuntPos
    local pos = aimtarget and LocalPlayer:GetAimTarget().position or LocalPlayer:GetPosition() + Vector3(2, 0, 2)

    Network:Send("SpawnNPC", {
        target = self.target:GetValue(),
        model = self.model:GetValue(),
        pos = pos,
        weapon = self.weapon:GetValue()
    })
end

function NPCAISpawnMenu:KeyUp(args)
    if args.key == string.byte("N") then
        self:ToggleWindow()
    end
end

function NPCAISpawnMenu:LocalPlayerInput()
    return false
end

function NPCAISpawnMenu:ToggleWindow()
    local windowVisible = self.window:GetVisible()

    self.window:SetVisible(not windowVisible)
    Mouse:SetVisible(not windowVisible)

    if not windowVisible then
        self.LocalPlayerInputEvent = Events:Subscribe("LocalPlayerInput", self, self.LocalPlayerInput)
    else
        Events:Unsubscribe(self.LocalPlayerInputEvent)
        self.LocalPlayerInputEvent = nil
    end
end

local npcaispawnmenu = NPCAISpawnMenu()
-----------------------------------------------------------------------------------
--Script Version
--v1.0--

--Release Date
--13.09.25--
-----------------------------------------------------------------------------------