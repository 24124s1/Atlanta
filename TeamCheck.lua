getgenv().cloneref = cloneref or function(...) return ... end
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))
local Services = {
    LocalPlayer = Players.LocalPlayer
}

local TeamManager = {
    Members = {},
}

if game.PlaceId == 115872975504419 then
    local SquadRemotes = ReplicatedStorage:WaitForChild("SquadRemotes")
    SquadRemotes.SquadUpdate.OnClientEvent:Connect(function(data)
        if data and data.members then 
            TeamManager.Members = data.members 
        end
    end)
end

local function isTeammate(player)
    if not player or player == Services.LocalPlayer then return false end

    if game.PlaceId == 112757576021097 then
        if Services.LocalPlayer:FindFirstChild("PlayerStates") and player:FindFirstChild("PlayerStates") then
            return Services.LocalPlayer.PlayerStates.Team.Value == player.PlayerStates.Team.Value
        end
    end

    if game.PlaceId == 115872975504419 then
        if table.find(TeamManager.Members, player.UserId) then return true end
    end

    if player.Team and player.Team == Services.LocalPlayer.Team then return true end

    local character = player.Character
    if character and character:FindFirstChild("SquadBillboard") then return true end

    return false
end
