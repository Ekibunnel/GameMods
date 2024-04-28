--[[
CXXHeaderDump\Engine_enums.hpp
enum EMovementMode {
    MOVE_None = 0,
    MOVE_Walking = 1,
    MOVE_NavWalking = 2,
    MOVE_Falling = 3,
    MOVE_Swimming = 4,
    MOVE_Flying = 5,
    MOVE_Custom = 6,
    MOVE_MAX = 7,
};
--]]

local function DebugLog(String)
	print("[AutoBhop] "..tostring(String).."\n")
end

-- DebugLog("START OF FILE")

local preId = nil
local postId = nil


local ScriptFolderPath = debug.getinfo(1).source:sub(2):match("(.*[\\/])")
local function FileIsBhop(Value)
	local IsBhopFromFile = nil
	local File = nil
	
	if Value ~= nil then
		File = io.open(ScriptFolderPath.."IsBhop.cfg", "w+")
		local ValueStr = tostring(Value)
		File:write(ValueStr)
		File:close()
		IsBhopFromFile = ValueStr
	else
		File = io.open(ScriptFolderPath.."IsBhop.cfg", "r")
		if File ~= nil then
			IsBhopFromFile = File:read()
			File:close()
		end
	end
	
	-- DebugLog("Real IsBhopFromFile : "..tostring(IsBhopFromFile))
	
	if IsBhopFromFile == nil then IsBhopFromFile = 'true' end
	
	IsBhopFromFile = string.lower(IsBhopFromFile) == 'true'
	
	return IsBhopFromFile
end

local IsBhop = FileIsBhop()

local function SetupBhopHook()
	if preId ~= nil or postId ~= nil then
		return false
	end
	if pcall(function () -- Handle error when SetupBhopHook is being called before the BP_BPMPlayerCharacter_C was setup, should only happen once at the start of the game
			preId, postId = RegisterHook("/Game/Blueprints/BP_BPMPlayerCharacter.BP_BPMPlayerCharacter_C:K2_OnMovementModeChanged", function (self, PrevMovementMode, NewMovementMode, PrevCustomMode, NewCustomMode)
				if PrevMovementMode:get() == 3 and NewMovementMode:get() == 1 then -- see EMovementMode enum
					local ACharacter = self["bJumpDown"]
					if ACharacter:GetPropertyValue("bJumpDown") and IsBhop then
						ACharacter:OnJumpAction()
						-- DebugLog("BhopHook Jump function called !")
					end
				end
			end)
		end)
	then
		DebugLog("SetupBhopHook done ! (IsBhop:"..tostring(IsBhop)..")")
		return true
	end
	DebugLog("SetupBhopHook has failed")
	return false
end

local function HandleConsoleCmd(FullCommand, Parameters, OutputDevice)
	local NewBhop = nil
	for ParameterNumber, Parameter in pairs(Parameters) do
		local ParamToNum = tonumber(Parameter)
		if ParamToNum == nil then
			if string.lower(Parameter) == "true" or string.lower(Parameter) == "on" then
				NewBhop = true
			elseif string.lower(Parameter) == "false" or string.lower(Parameter) == "off" then
				NewBhop = false
			end
		else
			if ParamToNum > 0 then
				NewBhop = true
			else
				NewBhop = false
			end
		end
		break
    end
	if NewBhop == nil then
		OutputDevice:Log("AutoBhop is "..tostring(IsBhop).."\n")
	else
		IsBhop = NewBhop
		FileIsBhop(IsBhop)
		OutputDevice:Log("AutoBhop set to "..tostring(IsBhop).."\n")
	end
    return true
end

RegisterConsoleCommandHandler("AUTOBHOP", HandleConsoleCmd)
RegisterConsoleCommandHandler("AutoBhop", HandleConsoleCmd)
RegisterConsoleCommandHandler("autobhop", HandleConsoleCmd)
RegisterConsoleCommandHandler("BHOP", HandleConsoleCmd)
RegisterConsoleCommandHandler("BHop", HandleConsoleCmd)
RegisterConsoleCommandHandler("Bhop", HandleConsoleCmd)
RegisterConsoleCommandHandler("bhop", HandleConsoleCmd)

if not SetupBhopHook() then -- for Hot Reaload (Restart All mods)
	RegisterHook("/Script/Engine.PlayerController:ClientRestart", SetupBhopHook)
end

--DebugLog("END OF FILE")

---- AutoBhop v0.0.1
---- By Ekibunnel
