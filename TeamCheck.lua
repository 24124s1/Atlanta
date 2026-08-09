getgenv().cloneref = cloneref or function(...) return ... end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

local TeamManager = {
    Members = {},
}

if game.PlaceId == 79783567666809 then
    local SquadRemotes = ReplicatedStorage:WaitForChild("SquadRemotes")
    SquadRemotes.SquadUpdate.OnClientEvent:Connect(function(data)
        if data and data.members then
            TeamManager.Members = data.members
        end
    end)
end

local IsTeam = function(plr)
    if game.PlaceId == 112757576021097 then
        return LocalPlayer.PlayerStates.Team.Value == plr.PlayerStates.Team.Value
    end

    if game.PlaceId == 115872975504419 then
        return table.find(TeamManager.Members, plr.UserId)
    end

    return plr.Team == LocalPlayer.Team
end

return IsTeam
