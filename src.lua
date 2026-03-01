--!nolint
--[[
<Place Metadata Begin>
Timestamp: 2026-03-01T08:59:16Z
Name: "Game A842E37E-1250-4C10-9FAC-78C58C9FF3EB"
Universe ID: 8242022627
Place ID: 103982238208526
Version: 298
Size: 356707 Character(s), 11663 Line(s)
</Place Metadata End>
]]

--[[
<Script #1 Begin>
<Metadata Begin>
Name: "ClearCreationButton"
Type: LocalScript
Path: StarterGui.Widgets.Bottom Bar.Body.Toolbar.Clear Creation.ClearCreationButton
Size: 4448 Character(s), 153 Line(s)
</Metadata End>
]]

--!strict
local DOUBLE_CLICK_MAX_INTERVAL = 4 ^ -1 -- Second(s)

local INTERACTABLE_TEXT_COLOR = Color3.fromRGB(204, 0, 0)
local UNINTERACTABLE_TEXT_TRANSPARENCY = .5

local HIDE_TWEEN_SPEED_MULTIPLIER = 3 / 2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local GRAY_COLOR = CONSTANTS.Gui.ColorScheme.GRAY

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local AssetPool = require(Services:WaitForChild("AssetPoolClient"))
local Plots = require(Services:WaitForChild("PlotsClient"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ToolsRemotes = Remotes:WaitForChild("Tools")
local DestructAssets = ToolsRemotes:WaitForChild("DestructAssets")

local MasterMixer = SoundService:WaitForChild("Master")
local ToolsMixer = MasterMixer:WaitForChild("Tools")
local DestructedSound = ToolsMixer:WaitForChild("Destructed")

local Button = script.Parent

local LocalPlayer = Players.LocalPlayer
local LocalOccupant = Plots.LocalOccupant

local Controls = Tools.Destruct

local Enabled = Controls.Enabled
local EnabledChangedDestructor = Destructor.new()

local TotalAssets = AssetPool.TotalAssets

Enabled.Predicates[HttpService:GenerateGUID(false)] = function()
	EnabledChangedDestructor:Destruct()

	return true
end

local IsVisible = ValueWrapper.new(false)

local TweenParameters1 = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParameters2 = TweenInfo.new(TWEENS.DURATION / HIDE_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)

local ShowTween = TweenService:Create(Button, TweenParameters1, {Size = UDim2.fromOffset(2 ^ 6, 2 ^ 4)})
local HideTween = TweenService:Create(Button, TweenParameters2, {Size = UDim2.fromOffset(2 ^ 6, 0)})

HideTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		Button.Visible = false
	end
end)

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		IsVisible:Set(false)

		return
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(enabled: boolean)
		if not enabled then
			task.defer(IsVisible.Set, IsVisible, false)

			return
		end

		local ownerChangedDestructor = LocalPlotChangedDestructor:Add(EnabledChangedDestructor):Add(Destructor.new())
		local owner = plot.Owner

		EnabledChangedDestructor:Add(Callback.CallAndConnect(function(owner: Player?)
			ownerChangedDestructor:Destruct()

			if owner ~= LocalPlayer then
				IsVisible:Set(false)

				return
			end

			ownerChangedDestructor:Add(Callback.CallAndConnect(function(value: number)
				IsVisible:Set(value > 0)
			end, TotalAssets.Changed, TotalAssets.Value))
		end, plot.OwnerChanged, owner and owner.Player))
	end, Enabled.Changed, Enabled.Value))
end, LocalOccupant.PlotChanged)

Callback.CallAndConnect(function(visible: boolean)
	Button.Interactable = visible

	if visible then
		Button.TextColor3 = INTERACTABLE_TEXT_COLOR
		Button.TextTransparency = 0
	else
		Button.TextColor3 = GRAY_COLOR
		Button.TextTransparency = UNINTERACTABLE_TEXT_TRANSPARENCY
	end

	if visible then
		Button.Visible = true

		ShowTween:Play()
	else
		HideTween:Play()
	end
end, IsVisible.Changed, IsVisible.Value)

local LastClickTimestamp = -math.huge

Button.MouseButton1Click:Connect(function()
	local timestamp = time()

	if timestamp - LastClickTimestamp < DOUBLE_CLICK_MAX_INTERVAL then
		print(`[{script}]: {Button} double-clicked. Firing signal to Server to wipe {LocalOccupant.Plot}`)

		DestructAssets:FireServer(nil)

		DestructedSound:Play()

		Enabled:Set(false)
	end

	LastClickTimestamp = timestamp
end)

-- </Script #1 End>
--[[
<Script #2 Begin>
<Metadata Begin>
Name: "LogicalProcessorCountWorkerClient"
Type: Script
Context: Client
Path: ReplicatedStorage.Modules.Values.LogicalProcessorCount.LogicalProcessorCountWorkerClient
Size: 439 Character(s), 17 Line(s)
</Metadata End>
]]

--!strict
--!native
--!optimize 2
local EXECUTION_TIME = (2 ^ 6) ^ -1 -- Second(s)

task.desynchronize()

local PreTimestamp = os.clock()

repeat until os.clock() - PreTimestamp >= EXECUTION_TIME

local PostTimestamp = os.clock()

task.synchronize()

local ReportStartStopTimestampsBindable: BindableEvent = script.Parent.Parent:WaitForChild("ReportStartStopTimestamps")
ReportStartStopTimestampsBindable:Fire(PreTimestamp, PostTimestamp)

-- </Script #2 End>
--[[
<Script #3 Begin>
<Metadata Begin>
Name: "DeviceType"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.DeviceType
Size: 423 Character(s), 11 Line(s)
</Metadata End>
]]

--!strict
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

return
	if GuiService:IsTenFootInterface() then "Console"
	elseif UserInputService.VREnabled and VRService.VREnabled then "VR"
	elseif not UserInputService.MouseEnabled then "Mobile"
	elseif UserInputService.KeyboardEnabled then "Desktop"
	else "Unknown"

-- </Script #3 End>
--[[
<Script #4 Begin>
<Metadata Begin>
Name: "IsPlayerExperienceOwner"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Functions.IsPlayerExperienceOwner
Size: 761 Character(s), 25 Line(s)
</Metadata End>
]]

--!strict
local VICE_OWNER_USER_IDS = {
	492110427, --[[ @Hooddragon_2010 ]]
	356891828 --[[ @Hooddragon2010 ]]
}

local CreatorType = game.CreatorType
local CreatorId = game.CreatorId

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Player</code> is the owner or a vice-owner of the <strong>Experience</strong>.
]=]
return function(player: Player): boolean
	local userId = player.UserId

	if userId == -1 then
		return true
	elseif CreatorType == Enum.CreatorType.User then
		return userId == CreatorId or not not table.find(VICE_OWNER_USER_IDS, userId)
	else
		return (select(2, xpcall(player.GetRankInGroup, function(message: string)
			warn(debug.traceback(message))
		end, player, CreatorId)) or 0) >= 254 -- Owner & Vice-Owner
	end
end

-- </Script #4 End>
--[[
<Script #5 Begin>
<Metadata Begin>
Name: "NumericalPrefixes"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.NumericalPrefixes
Size: 219 Character(s), 5 Line(s)
</Metadata End>
]]

--!strict
return {
	"Mono", "Dual", "Tri", "Tetra", "Penta", "Hexa", "Hepta", "Octa", "Nona", "Deca",
	"Undeca", "Dodeca", "Trideca", "Tetradeca", "Pentadeca", "Hexadeca", "Heptadeca", "Octadeca", "Nonadeca", "Icosa"
}

-- </Script #5 End>
--[[
<Script #6 Begin>
<Metadata Begin>
Name: "GetTextChatNametagColorForUsername"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Functions.GetTextChatNametagColorForUsername
Size: 913 Character(s), 39 Line(s)
</Metadata End>
]]

--!strict
--!native
--[[ Source (Edited by @SubParSuperCar): https://devforum.roblox.com/t/957515 ]]
local Colors = {
	BrickColor.new("Bright red").Color,
	BrickColor.new("Bright blue").Color,
	BrickColor.new("Earth green").Color,
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color
}

--[=[
	Returns the <strong>TextChatService</strong> nametag color for <code>Username</code>.
]=]
return function(username: string): Color3
	local length = #username
	local value = 0

	for index = 1, length do
		local inverse = length - index + 1

		if bit32.band(length, 1) == 1 then
			inverse -= 1
		end

		local code = username:byte(index, index)

		if bit32.band(inverse, 2) == 2 then
			code = -code
		end

		value += code
	end

	return Colors[value % #Colors + 1]
end

-- </Script #6 End>
--[[
<Script #7 Begin>
<Metadata Begin>
Name: "Platform"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.Platform
Size: 2556 Character(s), 89 Line(s)
</Metadata End>
]]

--!nolint
-- TODO: Refine Source Code.
local sub = string.sub
local match = string.match
local len = string.len
local lower = string.lower

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local TextService = game:GetService("TextService")

local TextSettings = {
	16,
	"SourceSans",
	Vector2.one * 1000
}

-- char(2 ^ 16 - 1)
local invalidSize = TextService:GetTextSize("\u{FFFF}", unpack(TextSettings))

local function isValidCharacter(character)
	local size = TextService:GetTextSize(character, unpack(TextSettings))

	return size.Magnitude ~= invalidSize.Magnitude
end

local function getArchitecture()
	local address = tonumber(sub(tostring{math.huge}, 8))

	if len(tostring(address)) <= 10 then
		return 32
	end

	return 64
end

local function GetPlatform()
	-- Grape juice?
	local version = version()

	local Desktop = match(version, "^0%.") ~= nil
	local Console = GuiService:IsTenFootInterface() or (match(version, "^1%.") ~= nil)
	local Mobile = match(version, "^2%.") ~= nil
	local VR = UserInputService.VREnabled and VRService.VREnabled

	if GuiService.IsWindows then
		if Mobile then
			return Enum.Platform.UWP
		elseif Console then -- Not sure if this works
			return Enum.Platform.XBoxOne
		elseif isValidCharacter("\u{E0FF}") then -- Not sure if this works either Lol (Ubuntu)
			return Enum.Platform.Linux
		end

		return Enum.Platform.Windows
	elseif Desktop then
		return Enum.Platform.OSX
	elseif Console then
		-- GetStringForKeyCode
		local ButtonSelect = lower(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect))

		if match(ButtonSelect, "ps4") then -- "rbxasset://textures/ui/Controls/PlayStationController/PS4/ButtonTouchpad@2x.png"
			return Enum.Platform.PS4
		elseif match(ButtonSelect, "ps5") then -- "rbxasset://textures/ui/Controls/PlayStationController/PS5/ButtonShare@2x.png"
			return Enum.Platform.PS5
		elseif match(ButtonSelect, "xbox") then -- "rbxasset://textures/ui/Controls/XboxController/ButtonSelect@2x.png"
			return Enum.Platform.XboxOne -- game:FindFirstChild("OneStatFrame", true)?
		end
	elseif Mobile then
		if VR then
			return Enum.Platform.MetaOS
		elseif getArchitecture() == 32 or not isValidCharacter("\u{F8FF}") then
			if not UserInputService.TouchEnabled then
				return Enum.Platform.Linux -- Sober
			end

			return Enum.Platform.Android
		end

		return Enum.Platform.IOS
	elseif VR then
		-- Other VR platform IDK
	end

	return Enum.Platform.None
end

return GetPlatform()

-- </Script #7 End>
--[[
<Script #8 Begin>
<Metadata Begin>
Name: "Hierarchy"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Libraries.Hierarchy
Size: 6208 Character(s), 260 Line(s)
</Metadata End>
]]

--!strict
--!native
local Hierarchy = {}

--[=[
	Returns an <strong>Instance</strong> from <code>Path</code>, yielding if <code>Yield</code> is <strong>true</strong>.
]=]
function Hierarchy.FromPath(path: string, instance: Instance?, yield: boolean?, expiryDelay: number?): Instance
	instance = instance or game

	local getter: (...any) -> (...any) = if yield then (instance :: any).WaitForChild else (instance :: any).FindFirstChild

	for _, name in path:split(".") do
		if not instance then
			break
		end

		instance = getter(instance, name, expiryDelay)
	end

	return instance :: any
end

--[=[
	Returns all ancestors of <code>Instance</code>.
]=]
function Hierarchy.GetAncestors(instance: Instance): {Instance}
	local ancestors: {Instance} = {}

	instance = instance.Parent :: any

	while instance do
		table.insert(ancestors, instance)

		instance = instance.Parent :: any
	end

	return ancestors
end

--[=[
	Returns all ancestors of <code>Instance</code> that fall under <code>Class</code>.
]=]
function Hierarchy.GetAncestorsWhichAreA(instance: Instance, class: string): {Instance}
	local ancestors: {Instance} = {}

	instance = instance.Parent :: any

	while instance do
		if instance:IsA(class) then
			table.insert(ancestors, instance)
		end

		instance = instance.Parent :: any
	end

	return ancestors
end

--[=[
	Returns the first ancestor of <code>Instance</code> that falls under <code>Class</code>.
]=]
function Hierarchy.FindFirstAncestorThatIsA(instance: Instance, class: string): Instance
	instance = instance.Parent :: any

	while instance do
		if instance:IsA(class) then
			return instance
		end

		instance = instance.Parent :: any
	end

	return nil :: any
end

--[=[
	Returns the last ancestor of <code>Instance</code> that falls under <code>Class</code>.
]=]
function Hierarchy.FindLastAncestorThatIsA(instance: Instance, class: string): Instance
	return select(-1, unpack(Hierarchy.GetAncestorsWhichAreA(instance, class)))
end

--[=[
	Returns all ancestors of <code>Instance</code> that are of <code>Class</code>.
]=]
function Hierarchy.GetAncestorsOfClass(instance: Instance, class: string): {Instance}
	local ancestors: {Instance} = {}

	instance = instance.Parent :: any

	while instance do
		if instance.ClassName == class then
			table.insert(ancestors, instance)
		end

		instance = instance.Parent :: any
	end

	return ancestors
end

--[=[
	Returns the first ancestor of <code>Instance</code> that is of <code>Class</code>.
]=]
function Hierarchy.FindFirstAncestorOfClass(instance: Instance, class: string): Instance
	instance = instance.Parent :: any

	while instance do
		if instance.ClassName == class then
			return instance
		end

		instance = instance.Parent :: any
	end

	return nil :: any
end

--[=[
	Returns the last ancestor of <code>Instance</code> that is of <code>Class</code>.
]=]
function Hierarchy.FindLastAncestorOfClass(instance: Instance, class: string): Instance
	return select(-1, unpack(Hierarchy.GetAncestorsOfClass(instance, class)))
end

--[=[
	Returns all ancestors of <code>Instance</code> that have <code>Tag</code>.
]=]
function Hierarchy.GetAncestorsWithTag(instance: Instance, tag: string): {Instance}
	local ancestors: {Instance} = {}

	instance = instance.Parent :: any

	while instance do
		if instance:HasTag(tag) then
			table.insert(ancestors, instance)
		end

		instance = instance.Parent :: any
	end

	return ancestors
end

--[=[
	Returns the first ancestor of <code>Instance</code> that has <code>Tag</code>.
]=]
function Hierarchy.FindFirstAncestorWithTag(instance: Instance, tag: string): Instance
	instance = instance.Parent :: any

	while instance do
		if instance:HasTag(tag) then
			return instance
		end

		instance = instance.Parent :: any
	end

	return nil :: any
end

--[=[
	Returns the last ancestor of <code>Instance</code> that has <code>Tag</code>.
]=]
function Hierarchy.FindLastAncestorWithTag(instance: Instance, tag: string): Instance
	return select(-1, unpack(Hierarchy.GetAncestorsWithTag(instance, tag)))
end

--[=[
	Returns all descendants of <code>Instance</code> that fall under <code>Class</code>.
]=]
function Hierarchy.GetDescendantsWhichAreA(instance: Instance, class: string): {Instance}
	local descendants: {Instance} = {}

	for _, descendant in instance:GetDescendants() do
		if descendant:IsA(class) then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

--[=[
	Returns all descendants of <code>Instance</code> that are of <code>Class</code>.
]=]
function Hierarchy.GetDescendantsOfClass(instance: Instance, class: string): {Instance}
	local descendants: {Instance} = {}

	for _, descendant in instance:GetDescendants() do
		if descendant.ClassName == class then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

--[=[
	Returns all descendants of <code>Instance</code> that have <code>Tag</code>.
]=]
function Hierarchy.GetDescendantsWithTag(instance: Instance, tag: string): {Instance}
	local descendants: {Instance} = {}

	for _, descendant in instance:GetDescendants() do
		if descendant:HasTag(tag) then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

--[=[
	Returns all children of <code>Instance</code> that fall under <code>Class</code>.
]=]
function Hierarchy.GetChildrenWhichAreA(instance: Instance, class: string): {Instance}
	local children: {Instance} = {}

	for _, child in instance:GetChildren() do
		if child:IsA(class) then
			table.insert(children, child)
		end
	end

	return children
end

--[=[
	Returns all children of <code>Instance</code> that are of <code>Class</code>.
]=]
function Hierarchy.GetChildrenOfClass(instance: Instance, class: string): {Instance}
	local children: {Instance} = {}

	for _, child in instance:GetChildren() do
		if child.ClassName == class then
			table.insert(children, child)
		end
	end

	return children
end

--[=[
	Returns all children of <code>Instance</code> that have <code>Tag</code>.
]=]
function Hierarchy.GetChildrenWithTag(instance: Instance, tag: string): {Instance}
	local children: {Instance} = {}

	for _, child in instance:GetChildren() do
		if child:HasTag(tag) then
			table.insert(children, child)
		end
	end

	return children
end

return Hierarchy

-- </Script #8 End>
--[[
<Script #9 Begin>
<Metadata Begin>
Name: "RuntimeInfoPrinterServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.RuntimeInfoPrinterServer
Size: 3347 Character(s), 86 Line(s)
</Metadata End>
]]

--!strict
--!nolint DeprecatedGlobal
local IP_INFO_FETCH_URL = `http://ip-api.com/json/?fields={1583161 --[[ https://ip-api.com/docs/api:json ]]}`

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local TestService = game:GetService("TestService")

local LuauOptimizerLevel: any = "*No Module at Directory*"

task.spawn(function()
	local Modules = ReplicatedStorage:WaitForChild("Modules", math.huge)
	local Values = Modules:WaitForChild("Values", math.huge)

	LuauOptimizerLevel = require(Values:WaitForChild("LuauOptimizerLevel", math.huge))
end)

local IpInfoFetchSuccess: boolean, IpInfo: any = false, "*Redacted*"

if not RunService:IsStudio() then
	IpInfoFetchSuccess, IpInfo = xpcall(function()
		return HttpService:GetAsync(IP_INFO_FETCH_URL)
	end, function(message: string): string
		warn(debug.traceback(message))

		return message
	end)

	if IpInfoFetchSuccess then
		IpInfo = HttpService:JSONDecode(IpInfo)
	end
end

local GameInfoFetchSuccess, GameInfo = xpcall(MarketplaceService.GetProductInfo, function(message: string)
	warn(debug.traceback(message))

	return message
end, MarketplaceService, game.PlaceId)

local PlaceVersion = game.PlaceVersion
local LastGoodVersion = workspace:GetAttribute("LastGoodVersion") :: number or `No Attribute on {workspace}`

local JobId = game.JobId
local PrivateServerId = game.PrivateServerId

local RuntimeInfo = {
	-- Experience & Place
	`GameId (Universe ID): {game.GameId}`,
	`PlaceId: {game.PlaceId}`,
	`PlaceVersion: {if PlaceVersion ~= 0 then PlaceVersion else "*Unpublished*"}`,
	`IsGoodVersion: {if type(LastGoodVersion) ~= "number" then LastGoodVersion elseif PlaceVersion == 0 then "*Unpublished*" elseif LastGoodVersion == PlaceVersion then "Yes" else `No (Last Good Version: {LastGoodVersion})`}`,
	`LastUpdated (ISO 8601): {if GameInfoFetchSuccess then GameInfo.Updated else GameInfo}`,

	-- Creator
	`CreatorId: {game.CreatorId}`,
	`CreatorType: {game.CreatorType.Name}`,

	-- Server
	`JobId (Server UUID): {if JobId ~= "" and JobId ~= "00000000-0000-0000-0000-000000000000" then JobId else "*Not Live*"}`,
	`IsPrivateServer: {if PrivateServerId ~= "" then "Yes" else "No"}`,
	`ServerStarted (ISO 8601): {DateTime.fromUnixTimestamp(os.time() - time()):ToIsoDate()}`,

	-- Environment
	`RobloxVersion: {version()}`,
	`IsStudio: {if RunService:IsStudio() then "Yes" else "No"}`,
	`LuauOptimizerLevel: {LuauOptimizerLevel}`,

	-- Internet
	`IpAddress (IPv4): {if IpInfoFetchSuccess then IpInfo.query else IpInfo}`,
	`AsName: {if IpInfoFetchSuccess then IpInfo.as else IpInfo}`,
	`ZipCode: {if IpInfoFetchSuccess then (`{IpInfo.zip} ({IpInfo.district}, {IpInfo.city}, {IpInfo.regionName}, {IpInfo.country}, {IpInfo.continent})`) else IpInfo}`
}

if PrivateServerId ~= "" then
	-- Private Server
	table.insert(RuntimeInfo, `PrivateServerId: {PrivateServerId}`)
	table.insert(RuntimeInfo, `PrivateServerOwnerId: {game.PrivateServerOwnerId}`)
end

table.sort(RuntimeInfo)

TestService:Message(`[{script}]:\n{if GameInfoFetchSuccess then GameInfo.Name else GameInfo} {if PlaceVersion ~= 0 then `v{PlaceVersion}` else "*Development Build*"} Run-Time Info:\n{table.concat(RuntimeInfo, "\n")}`)

script:Destroy()

-- </Script #9 End>
--[[
<Script #10 Begin>
<Metadata Begin>
Name: "WireframeWrapper"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.WireframeWrapper
Size: 6780 Character(s), 276 Line(s)
</Metadata End>
]]

--!strict
local WireframeWrapper = {} :: WireframeWrapperImplementation
WireframeWrapper.__index = WireframeWrapper

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local LineSegment = require(Classes:WaitForChild("LineSegment"))

type WireframeWrapperImplementation = {
	__index: WireframeWrapperImplementation,
	__tostring: (self: WireframeWrapper) -> string,
	_BulkDraw: (self: WireframeWrapper, lines: {LineSegment.LineSegment}) -> (),
	_Redraw: (self: WireframeWrapper) -> (),
	_Erase: (self: WireframeWrapper) -> (),
	IsWireframeWrapper: (value: WireframeWrapper) -> boolean,
	new: (wireframe: WireframeHandleAdornment) -> WireframeWrapper,
	Destruct: (self: WireframeWrapper) -> (),
	Enable: (self: WireframeWrapper) -> (),
	Disable: (self: WireframeWrapper) -> (),
	Add: (self: WireframeWrapper, lines: {LineSegment.LineSegment}) -> (),
	Remove: (self: WireframeWrapper, lines: {LineSegment.LineSegment}) -> (),
	Set: (self: WireframeWrapper, lines: {LineSegment.LineSegment}) -> (),
	Clear: (self: WireframeWrapper) -> ()
}

type WireframeWrapperProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_Connections: {RBXScriptConnection},
	_EnabledChanged: BindableEvent,
	_LinesAdded: BindableEvent,
	_LinesRemoving: BindableEvent,
	Wireframe: WireframeHandleAdornment,
	Enabled: boolean,
	EnabledChanged: RBXScriptSignal,
	Lines: {LineSegment.LineSegment},
	LinesAdded: RBXScriptSignal,
	LinesRemoving: RBXScriptSignal,
	Destructing: RBXScriptSignal
}

export type WireframeWrapper = typeof(
	setmetatable(
		{} :: WireframeWrapperProperties,
		{} :: WireframeWrapperImplementation
	)
)

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of <strong>LineSegments</strong>.
]=]
local function IsArrayOfLineSegments(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if not LineSegment.IsLineSegment(value) then
			return false
		end
	end

	return true
end

function WireframeWrapper:__tostring(): string
	return tostring(self.Wireframe)
end

@native
function WireframeWrapper:_BulkDraw(lines: {LineSegment.LineSegment})
	local points: {Vector3} = table.create(#lines * 2)

	for _, line in lines do
		table.insert(points, line.From)
		table.insert(points, line.To)
	end

	self.Wireframe:AddLines(points)
end

function WireframeWrapper:_Redraw()
	self:_Erase()
	self:_BulkDraw(self.Lines)
end

function WireframeWrapper:_Erase()
	self.Wireframe:Clear()
end

function WireframeWrapper.IsWireframeWrapper(value): boolean
	return type(value) == "table" and getmetatable(value) == WireframeWrapper
end

function WireframeWrapper.new(wireframe: WireframeHandleAdornment): WireframeWrapper
	assert(typeof(wireframe) == "Instance" and wireframe:IsA("WireframeHandleAdornment"), `Argument 'Wireframe' to constructor 'new' of WireframeWrapper is {WireframeWrapper} and not a WireframeHandleAdornment.`)

	local self = setmetatable({} :: WireframeWrapperProperties, WireframeWrapper)

	self._Destructor = Destructor.new()

	self._Destructor:Add(function()
		self._Destructing:Fire()

		self:Disable()
	end)

	self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

	self._Connections = {}

	self._EnabledChanged = self._Destructor:Add(Instance.new("BindableEvent"))

	self._LinesAdded = self._Destructor:Add(Instance.new("BindableEvent"))
	self._LinesRemoving = self._Destructor:Add(Instance.new("BindableEvent"))

	self.Wireframe = wireframe

	self.Enabled = false
	self.EnabledChanged = self._EnabledChanged.Event

	self.Lines = {}
	self.LinesAdded = self._LinesAdded.Event
	self.LinesRemoving = self._LinesRemoving.Event

	self.Destructing = self._Destructing.Event

	return self
end

function WireframeWrapper:Destruct()
	self._Destructor:Destruct()
end

function WireframeWrapper:Enable()
	self:_Redraw()

	for _, property in {"Color3", "Transparency"} do
		table.insert(self._Connections, self.Wireframe:GetPropertyChangedSignal(property):Connect(function()
			self:_Redraw()
		end))
	end

	self.Enabled = true
	self._EnabledChanged:Fire(true)
end

function WireframeWrapper:Disable()
	local connections = self._Connections

	for index = #connections, 1, -1 do
		connections[index]:Disconnect()
		connections[index] = nil
	end

	self:_Erase()

	self.Enabled = false
	self._EnabledChanged:Fire(false)
end

@native
function WireframeWrapper:Add(lines: {LineSegment.LineSegment})
	assert(IsArrayOfLineSegments(lines), `Argument 'Lines' to method 'Add' of WireframeWrapper on {self} is {lines} and not an array of Lines.`)

	local added: {LineSegment.LineSegment} = {}
	local currentLines = self.Lines

	for _, line in lines do
		if not table.find(currentLines, line) then
			table.insert(added, line)
		end
	end

	if #added == 0 then
		return
	end

	for _, line in added do
		table.insert(currentLines, line)
	end

	self._LinesAdded:Fire(added)

	if self.Enabled then
		self:_BulkDraw(added)
	end
end

@native
function WireframeWrapper:Remove(lines: {LineSegment.LineSegment})
	assert(IsArrayOfLineSegments(lines), `Argument 'Lines' to method 'Remove' of WireframeWrapper on {self} is {lines} and not an array of Lines.`)

	local removed: {LineSegment.LineSegment} = {}

	for _, line in self.Lines do
		if not table.find(lines, line) then
			table.insert(removed, line)
		end
	end

	if #removed == 0 then
		return
	end

	self._LinesRemoving:Fire(removed)

	if self.Enabled then
		self:_Redraw()
	end
end

@native
function WireframeWrapper:Set(lines: {LineSegment.LineSegment})
	assert(IsArrayOfLineSegments(lines), `Argument 'Lines' to method 'Set' of WireframeWrapper on {self} is {lines} and not an array of Lines.`)

	local added: {LineSegment.LineSegment}, removed: {LineSegment.LineSegment} = {}, {}
	local currentLines = self.Lines

	for _, line in lines do
		if not table.find(currentLines, line) then
			table.insert(added, line)
		end
	end

	for _, line in currentLines do
		if not table.find(lines, line) then
			table.insert(removed, line)
		end
	end

	if #removed > 0 then
		self._LinesRemoving:Fire(removed)

		for _, line in removed do
			table.remove(currentLines, table.find(currentLines, line))
		end
	end

	if #added > 0 then
		for _, line in added do
			table.insert(currentLines, line)
		end

		self._LinesAdded:Fire(added)
	end

	if not self.Enabled then
		return
	end

	if #removed > 0 then
		self:_Redraw()
	else
		self:_BulkDraw(added)
	end
end

@native
function WireframeWrapper:Clear()
	local lines = self.Lines

	if #lines == 0 then
		return
	end

	table.clear(lines)

	self:_Erase()
end

return WireframeWrapper

-- </Script #10 End>
--[[
<Script #11 Begin>
<Metadata Begin>
Name: "BackpackCoreGuiDisabler"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Setup.BackpackCoreGuiDisabler
Size: 124 Character(s), 5 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

script:Destroy()

-- </Script #11 End>
--[[
<Script #12 Begin>
<Metadata Begin>
Name: "GameplayPausedNotification"
Type: LocalScript
Path: ReplicatedFirst.Gui.GameplayPausedNotification.Group.GameplayPausedNotification
Size: 1230 Character(s), 45 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

local Group = script.Parent

local LocalPlayer = Players.LocalPlayer

local TweenParameters = TweenInfo.new(2 / 3, Enum.EasingStyle.Linear)

local Tween = TweenService:Create(Group, TweenParameters, {GroupTransparency = 1})

Tween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		Group.Visible = false
	end
end)

-- TODO::Warning: This method is buggy in Studio.
GuiService:SetGameplayPausedNotificationEnabled(false)

--[=[
	Sets the <strong>Visibility</strong> Property of <code>Group</code> to <code>GameplayPaused</code>.
]=]
local function OnGameplayPausedChanged(gameplayPaused: boolean)
	if gameplayPaused then
		print(`[{script}]: Gameplay Paused. Awaiting Region streaming...`)

		Group.Visible = true
		Group.GroupTransparency = 0
	else
		print(`[{script}]: Gameplay Resumed.`)

		Tween:Play()
	end
end

OnGameplayPausedChanged(LocalPlayer.GameplayPaused)

LocalPlayer.Changed:Connect(function(property: string)
	if property == "GameplayPaused" then
		OnGameplayPausedChanged(LocalPlayer.GameplayPaused)
	end
end)

-- </Script #12 End>
--[[
<Script #13 Begin>
<Metadata Begin>
Name: "RuntimeInfoPrinterClient"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Debug.RuntimeInfoPrinterClient
Size: 5433 Character(s), 150 Line(s)
</Metadata End>
]]

--!strict
--!nolint DeprecatedGlobal
local SECONDS_PER_DAY = 60 * 60 * 24 -- Second(s)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local MarketplaceService = game:GetService("MarketplaceService")
local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local TestService = game:GetService("TestService")

local LocalPlayer = Players.LocalPlayer

local DefaultLuauOptimizerLevel: number | any = "*No Module at Directory*"
local DeviceType: string | any = DefaultLuauOptimizerLevel
local Platform: Enum.Platform | any = DeviceType

task.spawn(function()
	local Modules = ReplicatedStorage:WaitForChild("Modules")
	local Values = Modules:WaitForChild("Values")

	DefaultLuauOptimizerLevel = require(Values:WaitForChild("DefaultLuauOptimizerLevel"))
	DeviceType = require(Values:WaitForChild("DeviceType"))
	Platform = require(Values:WaitForChild("Platform"))
end)

local GameInfoFetchSuccess: boolean, GameInfo
local PolicyInfoFetchSuccess: boolean, PolicyInfo
local CountryRegion

local Thread = coroutine.running()
local PendingFetchCount = 3

--[=[
	Decrements <code>PendingFetchCount</code> by 1 and, if it equals 0, resumes execution of <code>Thread</code>.
]=]
local function OnFinishedFetching()
	PendingFetchCount -= 1

	if PendingFetchCount == 0 then
		coroutine.resume(Thread)
	end
end

task.spawn(function()
	GameInfoFetchSuccess, GameInfo = xpcall(MarketplaceService.GetProductInfo, function(message: string)
		warn(debug.traceback(message))

		return message
	end, MarketplaceService, game.PlaceId)

	OnFinishedFetching()
end)

task.spawn(function()
	PolicyInfoFetchSuccess, PolicyInfo = xpcall(PolicyService.GetPolicyInfoForPlayerAsync, function(message: string)
		warn(debug.traceback(message))

		return message
	end, PolicyService, LocalPlayer)

	OnFinishedFetching()
end)

task.spawn(function()
	CountryRegion = select(2, xpcall(LocalizationService.GetCountryRegionForPlayerAsync, function(message: string)
		warn(debug.traceback(message))

		return message
	end, LocalizationService, LocalPlayer))

	OnFinishedFetching()
end)

coroutine.yield()

local PlaceVersion = workspace:GetAttribute("PlaceVersion") :: number or `*No Attribute on {workspace}*`
local LastGoodVersion = workspace:GetAttribute("LastGoodVersion") :: number or `*No Attribute on {workspace}*`

local JobId = game.JobId
local ServerStartedTimestamp = workspace:GetAttribute("ServerStartedTimestamp") :: number or `*No Attribute on {workspace}*`

local GlobalTimestamp = os.time()

local AccountAge = LocalPlayer.AccountAge
local LocaleId = LocalPlayer.LocaleId

local FollowUserId = LocalPlayer.FollowUserId
local PartyId = LocalPlayer.PartyId

local RuntimeInfo = {
	-- Device
	`DeviceType: {DeviceType}`,
	`Platform: {if type(Platform) ~= "string" then Platform.Name else Platform}`,

	-- Client & Environment
	`Version (Roblox, <Generation (0 = Desktop, 1 = Console, 2 = Mobile)>.<Version>.<Patch>.<Commit>): {version()}`,
	`IsStudio: {if RunService:IsStudio() then "Yes" else "No"}`,
	`DefaultLuauOptimizerLevel: {DefaultLuauOptimizerLevel}`,

	-- Experience & Place
	`GameId (Universe ID): {game.GameId}`,
	`PlaceId: {game.PlaceId}`,
	`PlaceVersion: {if PlaceVersion == 0 then "<Unpublished>" else PlaceVersion}`,
	`IsGoodVersion: {if type(PlaceVersion) ~= "number" then PlaceVersion elseif PlaceVersion == 0 then "<Unpublished>" elseif LastGoodVersion == PlaceVersion then "Yes" else `No (Last Good Version: {LastGoodVersion})`}`,
	`LastUpdated (ISO 8601): {if GameInfoFetchSuccess then GameInfo.Updated else GameInfo}`,

	-- >> Creator
	`CreatorId: {game.CreatorId}`,
	`CreatorType: {game.CreatorType.Name}`,

	-- Server & Session
	`JobId (Server UUID): {if JobId ~= "" and not JobId:match("^0+%-0+%-0+%-0+%-0+$") then JobId else "<Not Live>"}`,
	`ServerStarted (ISO 8601): {if type(ServerStartedTimestamp) == "number" then DateTime.fromUnixTimestamp(ServerStartedTimestamp):ToIsoDate() else ServerStartedTimestamp}`,
	`SessionBegan (ISO 8601): {DateTime.fromUnixTimestamp(GlobalTimestamp - time()):ToIsoDate()}`,

	-- User & Player
	`UserId: {LocalPlayer.UserId}`,
	`UserName: {LocalPlayer}`,
	`DisplayName: {LocalPlayer.DisplayName}`,

	-- >> Demographics
	`AccountAge (Day(s)): {AccountAge} (Registered: {DateTime.fromUnixTimestamp(GlobalTimestamp - AccountAge * SECONDS_PER_DAY - elapsedTime()):FormatLocalTime("ll", LocaleId)})`,
	`IsVeteran: {if AccountAge >= 365 then "Yes" else "No"}`,

	-- >> Verification
	`IsVerified: {if LocalPlayer.IsVerified then "Yes" else "No"}`,
	`IsThirteenPlus: {if not PolicyInfoFetchSuccess then PolicyInfo elseif PolicyInfo.AreAdsAllowed then "Yes" else "No"}`,
	`HasVerifiedBadge: {if LocalPlayer.HasVerifiedBadge then "Yes" else "No"}`,

	-- >> Membership
	`MembershipType: {LocalPlayer.MembershipType.Name}`,

	-- >> Geolocation
	`LocaleId: {LocaleId} ({CountryRegion})`,

	-- >> Socials
	`FollowUserId: {if FollowUserId ~= 0 then FollowUserId else "<None>"}`,
	`PartyId: {if PartyId ~= "" then PartyId else "<None>"}`
}

TestService:Message(
	`[{script}]:\n`
		.. (if GameInfoFetchSuccess then GameInfo.Name else GameInfo)
		.. (if PlaceVersion then if PlaceVersion ~= 0 then ` (Version: {PlaceVersion}) ` else " *Development Build* " else " ")
		.. `Run-Time Info:\n{table.concat(RuntimeInfo, "\n")}`
)

script:Destroy()

-- </Script #13 End>
--[[
<Script #14 Begin>
<Metadata Begin>
Name: "CommandExecutionVirtualMachineEnvironment"
Type: ModuleScript
Path: ServerScriptService.Debug.RemoteCommandExecutorServer.CommandExecutionVirtualMachineEnvironment
Size: 110 Character(s), 6 Line(s)
</Metadata End>
]]

--!strict
--!nolint DeprecatedApi
local Environment = getfenv(0)
Environment.script = nil

return Environment

-- </Script #14 End>
--[[
<Script #15 Begin>
<Metadata Begin>
Name: "GuiMagnifier"
Type: LocalScript
Path: StarterGui.Widgets.Widgets.GUI Magnifier.Body.GuiMagnifier
Size: 1536 Character(s), 52 Line(s)
</Metadata End>
]]

--!strict
local PARSING_FAILED_PLACEHOLDER_TEXT_DURATION = 2 -- Second(s)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local SCALE_RANGE = CONSTANTS.Gui.SCALE_RANGE

local Controllers = Modules:WaitForChild("Controllers")
local Settings = require(Controllers:WaitForChild("Settings"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local GuiMagnifier = script.Parent

local Body = GuiMagnifier:WaitForChild("Body")
local MagnificationTextBox = Body:WaitForChild("Magnification")

local Scale = Settings.Gui.Scale

--[=[
	Returns the placeholder text to be displayed in <code>MagnificationTextBox</code>.
]=]
local function GetPlaceholderText(): string
	return `Current Zoom: {Scale.Value}x [{SCALE_RANGE.Min}, {SCALE_RANGE.Max}]`
end

Callback.CallAndConnect(function()
	MagnificationTextBox.PlaceholderText = GetPlaceholderText()
end, Scale.Changed)

MagnificationTextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local value = tonumber(MagnificationTextBox.Text)

		if value then
			Scale:Set(math.clamp(value, SCALE_RANGE.Min, SCALE_RANGE.Max))
		else
			MagnificationTextBox.PlaceholderText = "Parsing failed."

			task.delay(PARSING_FAILED_PLACEHOLDER_TEXT_DURATION, function()
				MagnificationTextBox.PlaceholderText = GetPlaceholderText()
			end)
		end
	end

	MagnificationTextBox.Text = ""
end)

-- </Script #15 End>
--[[
<Script #16 Begin>
<Metadata Begin>
Name: "ToolKeybinds"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Tools.ToolKeybinds
Size: 1982 Character(s), 70 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TOOLS = CONSTANTS.Tools

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalOccupant = Plots.LocalOccupant

local IsBinded = ValueWrapper.new(false)

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		IsBinded:Set(false)

		return
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean)
		IsBinded:Set(not spawned)
	end, plot.SpawnedChanged, plot.Spawned))
end, LocalOccupant.PlotChanged)

local ActionNames: {[string]: string} = {}

for name: string in Tools :: any do
	ActionNames[name] = `Toggle {name} Tool Enabled`
end

Callback.CallAndConnect(function(binded: boolean)
	if not binded then
		for _, name in ActionNames do
			ContextActionService:UnbindAction(name)
		end

		return
	end

	for name: string, tool in Tools :: any do
		local enabled: ValueWrapper.ValueWrapper<boolean> = tool.Enabled

		ContextActionService:BindAction(ActionNames[name], function(_, inputState: Enum.UserInputState)
			if inputState == Enum.UserInputState.End then
				enabled:Set(not enabled.Value)
			end
		end, false, TOOLS[name].HOTKEY)
	end
end, IsBinded.Changed, IsBinded.Value)

-- </Script #16 End>
--[[
<Script #17 Begin>
<Metadata Begin>
Name: "BarTweener"
Type: LocalScript
Path: StarterGui.Widgets.BarTweener
Size: 1015 Character(s), 32 Line(s)
</Metadata End>
]]

--!strict
local TWEEN_DURATION_MULTIPLIER = 3 / 2
local TWEEN_DELAY = 3 / 4 -- Second(s)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TWEENS = CONSTANTS.Tweens
local TWEEN_STYLE = TWEENS.STYLE
local TWEEN_DURATION = TWEENS.DURATION

local TweenParameters = TweenInfo.new(TWEEN_DURATION * TWEEN_DURATION_MULTIPLIER, TWEEN_STYLE, Enum.EasingDirection.Out)

local Gui = script.Parent

local TopBar = Gui:WaitForChild("Top Bar")
local TopBarBody = TopBar:WaitForChild("Body")

local BottomBar = Gui:WaitForChild("Bottom Bar")
local BottomBarBody = BottomBar:WaitForChild("Body")

task.wait(TWEEN_DELAY)

TopBar.Visible = true
BottomBar.Visible = true

TweenService:Create(TopBarBody, TweenParameters, {Position = UDim2.new()}):Play()
TweenService:Create(BottomBarBody, TweenParameters, {Position = UDim2.new()}):Play()

-- </Script #17 End>
--[[
<Script #18 Begin>
<Metadata Begin>
Name: "Sandbox"
Type: Script
Context: Legacy
Path: ServerStorage.Documents.Sandbox
Size: 10 Character(s), 1 Line(s)
</Metadata End>
]]

--!nolint

-- </Script #18 End>
--[[
<Script #19 Begin>
<Metadata Begin>
Name: "ToggleDevConsoleButton"
Type: LocalScript
Path: StarterGui.Widgets.Bottom Bar.Body.Right Bar.Open/Close Dev Console.ToggleDevConsoleButton
Size: 5846 Character(s), 184 Line(s)
</Metadata End>
]]

--!strict
local FLASH_DURATION = 6 ^ -1 -- Second(s)

local FLASH_COLORS = {
	ExecutedCommand = Color3.fromRGB(209, 93, 255),
	[Enum.MessageType.MessageOutput] = Color3.fromRGB(204, 204, 204),
	[Enum.MessageType.MessageInfo] = Color3.fromRGB(0, 139, 219),
	[Enum.MessageType.MessageWarning] = Color3.fromRGB(255, 115, 21),
	[Enum.MessageType.MessageError] = Color3.fromRGB(255, 0, 0)
}

local FLASH_REPEATS = {
	ExecutedCommand = 3,
	[Enum.MessageType.MessageOutput] = 1,
	[Enum.MessageType.MessageInfo] = 2,
	[Enum.MessageType.MessageWarning] = 4,
	[Enum.MessageType.MessageError] = 8
}

local EXECUTED_COMMAND_PREFIX = "> "

local CLEAR_LOG_BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY = .5

local _MESSAGE_TYPE_PRIORITIES = {
	[Enum.MessageType.MessageError] = 4,
	[Enum.MessageType.MessageWarning] = 3,
	[Enum.MessageType.MessageInfo] = 2,
	[Enum.MessageType.MessageOutput] = 1
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LogService = game:GetService("LogService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local Classes = Modules:WaitForChild("Classes")
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local TWEENS = CONSTANTS.Tweens

local COLOR_SCHEME = CONSTANTS.Gui.ColorScheme
local LIGHT_COLOR = COLOR_SCHEME.LIGHT
local DARK_COLOR = COLOR_SCHEME.DARK

local ToggleDevConsoleButton = script.Parent
local ClearLogButton = ToggleDevConsoleButton:WaitForChild("Clear Log")

local IsClearLogButtonExpanded = ValueWrapper.new(false)

local LogEntryCount = ValueWrapper.new(#LogService:GetLogHistory())
local IsLogPopulated = ValueWrapper.new(LogEntryCount.Value > 0)

local TweenParametersIn = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.In)
local TweenParametersOut = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.Out)

local ShowClearLogButtonTween = TweenService:Create(ClearLogButton, TweenParametersOut, {Size = UDim2.new(1, 0, 0, 2 ^ 4)})
local HideClearLogButtonTween = TweenService:Create(ClearLogButton, TweenParametersIn, {Size = UDim2.fromScale(1, 0)})

HideClearLogButtonTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		ClearLogButton.Visible = false
	end
end)

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Color</code> would be best contrasted by a dark shade rather than a light one.
]=]
@native
local function IsDarkComplementary(color: Color3): boolean
	return color.R * 76 + color.B * 150 + color.G * 29 > 186
end

Callback.CallAndConnect(function(entries: number)
	IsLogPopulated:Set(entries > 0)

	ToggleDevConsoleButton.Text = `Toggle Dev Console (<i>F9</i>) ({entries})`
end, LogEntryCount.Changed, LogEntryCount.Value)

ToggleDevConsoleButton.MouseButton1Click:Connect(function()
	StarterGui:SetCore("DevConsoleVisible", not StarterGui:GetCore("DevConsoleVisible"))
end)

for _, guiButton in {ToggleDevConsoleButton, ClearLogButton} do
	Callback.CallAndConnect(function()
		for _, otherGuiButton in {ToggleDevConsoleButton, ClearLogButton} do
			if otherGuiButton.GuiState == Enum.GuiState.Hover or otherGuiButton.GuiState == Enum.GuiState.Press then
				IsClearLogButtonExpanded:Set(true)

				return
			end
		end

		IsClearLogButtonExpanded:Set(false)
	end, guiButton:GetPropertyChangedSignal("GuiState"))
end

Callback.CallAndConnect(function(expanded: boolean)
	ClearLogButton.Interactable = expanded and IsLogPopulated.Value

	if expanded then
		ClearLogButton.Visible = true

		ShowClearLogButtonTween:Play()
	else
		HideClearLogButtonTween:Play()
	end
end, IsClearLogButtonExpanded.Changed, IsClearLogButtonExpanded.Value)

Callback.CallAndConnect(function(populated: boolean)
	ClearLogButton.Interactable = populated
	ClearLogButton.TextTransparency = if populated then 0 else CLEAR_LOG_BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
end, IsLogPopulated.Changed, IsLogPopulated.Value)

LogService.MessageOut:Connect(function()
	LogEntryCount:Set(LogEntryCount.Value + 1)
end)

ClearLogButton.MouseButton1Down:Connect(function()
	LogService:ClearOutput()
	LogEntryCount:Set(0)
end)

local Message: string, MessageType: Enum.MessageType

do
	local LogEntries = LogService:GetLogHistory()
	local GameStartedTimestamp = tick() - time()

	for index = #LogEntries, 1, -1 do
		local logEntry = LogEntries[index]

		if logEntry.timestamp < GameStartedTimestamp then
			break
		end

		if not MessageType or _MESSAGE_TYPE_PRIORITIES[logEntry.messageType] > _MESSAGE_TYPE_PRIORITIES[MessageType] then
			Message, MessageType = logEntry.message, logEntry.messageType
		end
	end
end

if not Message then
	Message, MessageType = LogService.MessageOut:Wait()
end

local ExecutedCommandPrefixLength = #EXECUTED_COMMAND_PREFIX

while true do
	local isExecutedCommand = Message:sub(1, ExecutedCommandPrefixLength) == EXECUTED_COMMAND_PREFIX

	local flashColor = if isExecutedCommand then FLASH_COLORS.ExecutedCommand else FLASH_COLORS[MessageType]
	local flashCount = if isExecutedCommand then FLASH_REPEATS.ExecutedCommand else FLASH_REPEATS[MessageType]

	local complementaryColor = if IsDarkComplementary(flashColor) then DARK_COLOR else LIGHT_COLOR

	local index = 1

	while true do
		ToggleDevConsoleButton.BackgroundColor3 = flashColor
		ToggleDevConsoleButton.TextColor3 = complementaryColor

		wait(FLASH_DURATION)

		ToggleDevConsoleButton.BackgroundColor3 = DARK_COLOR
		ToggleDevConsoleButton.TextColor3 = LIGHT_COLOR

		if index >= flashCount then
			break
		end

		wait(FLASH_DURATION)

		index += 1
	end

	Message, MessageType = LogService.MessageOut:Wait()
end

-- </Script #19 End>
--[[
<Script #20 Begin>
<Metadata Begin>
Name: "WidgetsBar"
Type: LocalScript
Path: StarterGui.Widgets.Bottom Bar.Body.Widgets Bar.WidgetsBar
Size: 1384 Character(s), 48 Line(s)
</Metadata End>
]]

--!strict
local BUTTON_NAMES = {
	"Plot Manager",
	"GUI Magnifier"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local COLOR_SCHEME = CONSTANTS.Gui.ColorScheme
local LIGHT_COLOR = COLOR_SCHEME.LIGHT
local DARK_COLOR = COLOR_SCHEME.DARK

local Classes = Modules:WaitForChild("Classes")
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Widgets = require(Controllers:WaitForChild("Widgets"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))

local Frame = script.Parent

for _, name in BUTTON_NAMES do
	local button: ImageButton = Frame:WaitForChild(name)

	local controls = Widgets[String.ToCamelCase(name)]
	local visible: ValueWrapper.ValueWrapper<boolean> = controls.Visible

	Callback.CallAndConnect(function(visible: boolean)
		if visible then
			button.BackgroundColor3 = LIGHT_COLOR
			button.ImageColor3 = DARK_COLOR
		else
			button.BackgroundColor3 = DARK_COLOR
			button.ImageColor3 = LIGHT_COLOR
		end
	end, visible.Changed, visible.Value)

	button.MouseButton1Click:Connect(function()
		visible:Set(not visible.Value)
	end)
end

-- </Script #20 End>
--[[
<Script #21 Begin>
<Metadata Begin>
Name: "Widgets"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Controllers.Widgets
Size: 848 Character(s), 30 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

return setmetatable({
	PlotManager = {
		Visible = ValueWrapper.new(true),
		Collapsed = ValueWrapper.new(not RunService:IsStudio())
	},
	GuiMagnifier = {
		Visible = ValueWrapper.new(false),
		Collapsed = ValueWrapper.new(false)
	},
	AssetSelector = {
		Visible = ValueWrapper.new(false),
		Collapsed = ValueWrapper.new(false)
	}
}, {
	__index = function(controllers: {[string]: any}, name: string): {[string]: any}
		return rawset(controllers, name, {
			Visible = ValueWrapper.new(false),
			Collapsed = ValueWrapper.new(false)
		})[name]
	end
})

-- </Script #21 End>
--[[
<Script #22 Begin>
<Metadata Begin>
Name: "IdleDisconnectNotifierMarshaller"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Debug.IdleDisconnectNotifierMarshaller
Size: 664 Character(s), 29 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
if game:GetService("RunService"):IsStudio() then
	script:Destroy()

	return
end

local HEAP_SIZE_BUDGET = 2 ^ 15 * 7 / 8 -- Kibibyte(s)

local PostHeapSizeBindable = script:WaitForChild("PostHeapSize")
local Script = script:WaitForChild("IdleDisconnectNotifier")

PostHeapSizeBindable.Event:Connect(function(heapSizeKiB: number)
	if heapSizeKiB <= HEAP_SIZE_BUDGET then
		return
	end

	print(`[{script}]: Exhausted Heap Size Budget of {HEAP_SIZE_BUDGET} KiB with {heapSizeKiB} KiB. Restarting {Script}`)

	Script:Destroy()

	Script = Script:Clone()
	Script.Parent = script
end)

Script.Enabled = true

print(`[{script}]: Started {Script}`)

-- </Script #22 End>
--[[
<Script #23 Begin>
<Metadata Begin>
Name: "LineSegment"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.LineSegment
Size: 2703 Character(s), 76 Line(s)
</Metadata End>
]]

--!strict
--!native
local LineSegment = {} :: LineSegmentImplementation
LineSegment.__index = LineSegment

type LineSegmentImplementation = {
	__index: LineSegmentImplementation,
	__tostring: (self: LineSegment) -> string,
	__eq: (self: LineSegment, value: any) -> boolean,
	__add: (self: LineSegment, line: LineSegment) -> LineSegment,
	__sub: (self: LineSegment, line: LineSegment) -> LineSegment,
	__mul: (self: LineSegment, line: LineSegment) -> LineSegment,
	__div: (self: LineSegment, line: LineSegment) -> LineSegment,
	IsLineSegment: (value: any) -> boolean,
	new: (from: Vector3?, to: Vector3?) -> LineSegment
}

type LineSegmentProperties = {
	From: Vector3,
	To: Vector3
}

export type LineSegment = typeof(
	setmetatable(
		{} :: LineSegmentProperties,
		{} :: LineSegmentImplementation
	)
)

function LineSegment:__tostring(): string
	return `{self.From}, {self.To}`
end

function LineSegment:__eq(value: any): boolean
	return LineSegment.IsLineSegment(value) and self.From == value.From and self.To == value.To
end

function LineSegment:__add(line: LineSegment): LineSegment
	assert(LineSegment.IsLineSegment(line), `Argument 'Line' to metamethod '__add' of LineSegment on {self} is {line} and not a LineSegment.`)

	return LineSegment.new(self.From + line.From, self.To + line.To)
end

function LineSegment:__sub(line: LineSegment): LineSegment
	assert(LineSegment.IsLineSegment(line), `Argument 'Line' to metamethod '__sub' of LineSegment on {self} is {line} and not a LineSegment.`)

	return LineSegment.new(self.From - line.From, self.To - line.To)
end

function LineSegment:__mul(line: LineSegment): LineSegment
	assert(LineSegment.IsLineSegment(line), `Argument 'Line' to metamethod '__mul' of LineSegment on {self} is {line} and not a LineSegment.`)

	return LineSegment.new(self.From * line.From, self.To * line.To)
end

function LineSegment:__div(line: LineSegment): LineSegment
	assert(LineSegment.IsLineSegment(line), `Argument 'Line' to metamethod '__div' of LineSegment on {self} is {line} and not a LineSegment.`)

	return LineSegment.new(self.From / line.From, self.To / line.To)
end

function LineSegment.IsLineSegment(value: any): boolean
	return type(value) == "table" and getmetatable(value) == LineSegment
end

function LineSegment.new(from: Vector3?, to: Vector3?): LineSegment
	assert(from == nil or type(from) == "vector", `Argument 'From' to constructor 'new' of LineSegment is {from} and not a Vector3 or nil.`)
	assert(to == nil or type(to) == "vector", `Argument 'To' to constructor 'new' of LineSegment is {to} and not a Vector3 or nil.`)

	return setmetatable({
		From = from or Vector3.zero,
		To = to or Vector3.zero
	}, LineSegment)
end

return LineSegment

-- </Script #23 End>
--[[
<Script #24 Begin>
<Metadata Begin>
Name: "Input"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Services.Input
Size: 4127 Character(s), 139 Line(s)
</Metadata End>
]]

--!strict
-- TODO: Remove Debug Logging.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controller: ValueWrapper.ValueWrapper<Player?> = ValueWrapper.new(nil, {
	IsPlayerOrNil = function(value): boolean
		return value == nil or (typeof(value) == "Instance" and value:IsA("Player"))
	end
})

local PressedKeys: {Enum.KeyCode} = {}
local KeyPressed = Instance.new("BindableEvent")
local KeyReleased = Instance.new("BindableEvent")

local MouseButtons = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3
}

local PressedMouseButtons: {Enum.UserInputType} = {}
local MouseButtonChanged = Instance.new("BindableEvent")

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Key</code> is pressed.
]=]
local function IsKeyPressed(key: Enum.KeyCode): boolean
	assert(typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode, `Argument 'Key' to method 'IsKeyPressed' of Input is {key} and not an Enum.KeyCode.`)

	return not not table.find(PressedKeys, key)
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>MouseButton</code> is pressed.
]=]
local function IsMouseButtonPressed(mouseButton: Enum.UserInputType): boolean
	assert(table.find(MouseButtons, mouseButton), `Argument 'MouseButton' to method 'IsMouseButtonPressed' of Input is {mouseButton} and not a value in {MouseButtons}.`)

	return not not table.find(PressedMouseButtons, mouseButton)
end

--[=[
	Presses <code>Key</code>.
]=]
local function PressKey(key: Enum.KeyCode)
	assert(typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode, `Argument 'Key' to method 'PressKey' of Input is {key} and not an Enum.KeyCode.`)

	if IsKeyPressed(key) then
		return
	end

	table.insert(PressedKeys, key)

	KeyPressed:Fire(key)

	print(`[{script}]: Pressed Key: {key.Name}`)
end

--[=[
	Releases <code>Key</code>.
]=]
local function ReleaseKey(key: Enum.KeyCode)
	assert(typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode, `Argument 'Key' to method 'ReleaseKey' of Input is {key} and not an Enum.KeyCode.`)

	if not IsKeyPressed(key) then
		return
	end

	table.remove(PressedKeys, table.find(PressedKeys, key))

	KeyReleased:Fire(key)

	print(`[{script}]: Released Key: {key.Name}`)
end

--[=[
	Sets the state of <code>MouseButton</code> to <code>Pressed</code>.
]=]
local function SetMouseButtonPressed(mouseButton: Enum.UserInputType, pressed: boolean)
	assert(table.find(MouseButtons, mouseButton), `Argument 'MouseButton' to method 'SetMouseButtonPressed' of Input is {mouseButton} and not a value in {MouseButtons}.`)
	assert(type(pressed) == "boolean", `Argument 'Pressed' to method 'SetMouseButtonPressed' of Input is {pressed} and not a boolean.`)

	if IsMouseButtonPressed(mouseButton) == pressed then
		return
	end

	if pressed then
		table.insert(PressedMouseButtons, mouseButton)
	else
		table.remove(PressedMouseButtons, table.find(PressedMouseButtons, mouseButton))
	end

	MouseButtonChanged:Fire(mouseButton, pressed)

	print(`[{script}]: Set Mouse Button: {mouseButton.Name} {pressed}`)
end

--[=[
	Releases all pressed <strong>Keys</strong> and <strong>Mouse Buttons</strong>.
]=]
local function Clear()
	for index = #PressedKeys, 1, -1 do
		local key = PressedKeys[index]

		PressedKeys[index] = nil

		KeyReleased:Fire(key)
	end

	for index = #PressedMouseButtons, 1, -1 do
		local mouseButton = PressedMouseButtons[index]

		PressedMouseButtons[index] = nil

		MouseButtonChanged:Fire(mouseButton, false)
	end

	print(`[{script}]: Cleared Inputs.`)
end

return {
	Controller = Controller,
	PressedKeys = PressedKeys,
	KeyPressed = KeyPressed.Event,
	KeyReleased = KeyReleased.Event,
	PressedMouseButtons = PressedMouseButtons,
	MouseButtonChanged = MouseButtonChanged.Event,
	PressKey = PressKey,
	ReleaseKey = ReleaseKey,
	SetMouseButtonPressed = SetMouseButtonPressed,
	Clear = Clear,
	IsKeyPressed = IsKeyPressed,
	IsMouseButtonPressed = IsMouseButtonPressed
}

-- </Script #24 End>
--[[
<Script #25 Begin>
<Metadata Begin>
Name: "CharacterAppearanceOverrider"
Type: Script
Context: Legacy
Path: ServerScriptService.Players.CharacterAppearanceOverrider
Size: 1727 Character(s), 57 Line(s)
</Metadata End>
]]

--!strict
if not game:GetService("RunService"):IsStudio() then
	script:Destroy()

	return
end

print(`[{script}]: Run-time environment is Studio. Setting Character Appearance of all present and future Players`)

local CHARACTER_APPEARANCE_ID = 655869163 --[[ @Fastomatical ]]
local USER_ID_DATABASE_URL = "https://disallowed-roblox-default-rtdb.firebaseio.com/flagged.json"
local MAX_POLLS = 3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local HttpService = game:GetService("HttpService")
local UserService = game:GetService("UserService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local OnError = function(message: string)
	warn(debug.traceback(message))
end

Players.CharacterAutoLoads = false

xpcall(function()
	local userIdMap: {[string]: true} = HttpService:JSONDecode(HttpService:GetAsync(USER_ID_DATABASE_URL))
	local userIdArray: {string} = {}

	for userId in userIdMap do
		table.insert(userIdArray, userId)
	end

	local random = Random.new(tick())

	for _ = 1, MAX_POLLS do
		local id = tonumber(userIdArray[random:NextInteger(1, #userIdArray)])

		if id and #(select(2, xpcall(UserService.GetUserInfosByUserIdsAsync, OnError, UserService, {id})) or {}) ~= 0 then
			CHARACTER_APPEARANCE_ID = id

			return
		end
	end
end, OnError)

Callback.CallForEachVarargAndConnect(function(player: Player)
	player.CharacterAppearanceId = CHARACTER_APPEARANCE_ID
	player:LoadCharacter()
end, Players.PlayerAdded, unpack(Players:GetPlayers()))

Players.CharacterAutoLoads = true

-- </Script #25 End>
--[[
<Script #26 Begin>
<Metadata Begin>
Name: "RemoteCommandExecutorServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.RemoteCommandExecutorServer
Size: 526 Character(s), 16 Line(s)
</Metadata End>
]]

--!nocheck
local MessagingService = game:GetService("MessagingService")

local CommandExecutionVirtualMachineEnvironment = require("@self/CommandExecutionVirtualMachineEnvironment")

local JobId = game.JobId

for _, suffix in {"", if JobId ~= "" then `_{JobId}` else nil} do
	MessagingService:SubscribeAsync(`_SCE{suffix}`, function(packet)
		xpcall(function()
			setfenv(loadstring(packet.Data), CommandExecutionVirtualMachineEnvironment)()
		end, function(message: string)
			warn(debug.traceback(message))
		end)
	end)
end

-- </Script #26 End>
--[[
<Script #27 Begin>
<Metadata Begin>
Name: "PlotsClient"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Services.PlotsClient
Size: 17190 Character(s), 559 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOTS = CONSTANTS.Plots
local PLOT_TAG = PLOTS.TAG
local BOUNDARY_NAME = PLOTS.BOUNDARY_NAME
local BUILD_NAME = PLOTS.BUILD_NAME
local SPAWN_NAME = PLOTS.SPAWN_NAME
local MAX_OCCUPANTS = PLOTS.MAX_OCCUPANTS

local GETTER_EXPIRY_DELAY = CONSTANTS.GetterCalls.EXPIRY_DELAY
local INVOCATION_EXPIRY_DELAY = CONSTANTS.RemoteInvocations.EXPIRY_DELAY

local Classes = Modules:WaitForChild("Classes")
local Cuboid = require(Classes:WaitForChild("Cuboid"))
local Destructor = require(Classes:WaitForChild("Destructor"))

local Functions = Modules:WaitForChild("Functions")
local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlotsRemotes = Remotes:WaitForChild("Plots")
local SetPlotRemote = PlotsRemotes:WaitForChild("SetPlot")
local SpawnCreationRemote = PlotsRemotes:WaitForChild("SpawnCreation")
local DespawnCreationRemote = PlotsRemotes:WaitForChild("DespawnCreation")
local KickOccupantRemote = PlotsRemotes:WaitForChild("KickOccupant")

local LocalPlayer = Players.LocalPlayer

local Plot = {} :: PlotImplementation
Plot.__index = Plot

local Plots: {[Model]: Plot} = {}

local PlotAdded = Instance.new("BindableEvent")
local PlotRemoving = Instance.new("BindableEvent")

type PlotImplementation = {
	__index: PlotImplementation,
	__tostring: (self: Plot) -> string,
	_SetOwner: (self: Plot, occupant: Occupant?) -> (),
	_AddOccupant: (self: Plot, occupant: Occupant) -> (),
	_RemoveOccupant: (self: Plot, occupant: Occupant) -> (),
	IsPlot: (value: any) -> boolean,
	new: (plotModel: Model) -> Plot,
	Destruct: (self: Plot) -> (),
	GetPlot: (plotModel: Model) -> Plot,
	Vacate: (self: Plot) -> (),
	SpawnCreation: (self: Plot) -> (),
	DespawnCreation: (self: Plot) -> ()
}

type PlotProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_SpawnedChanged: BindableEvent,
	_OwnerChanged: BindableEvent,
	_OccupantAdded: BindableEvent,
	_OccupantRemoving: BindableEvent,
	PlotModel: Model,
	Boundary: Cuboid.Cuboid,
	BuildModel: Model,
	SpawnModel: Model,
	Spawned: boolean,
	SpawnedChanged: RBXScriptSignal,
	Owner: Occupant?,
	OwnerChanged: RBXScriptSignal,
	Occupants: {Occupant},
	OccupantAdded: RBXScriptSignal,
	OccupantRemoving: RBXScriptSignal,
	Destructing: RBXScriptSignal
}

export type Plot = typeof(
	setmetatable(
		{} :: PlotProperties,
		{} :: PlotImplementation
	)
)

local Occupant = {} :: OccupantImplementation
Occupant.__index = Occupant

local Occupants: {[Player]: Occupant} = {}

local OccupantAdded = Instance.new("BindableEvent")
local OccupantRemoving = Instance.new("BindableEvent")

type OccupantImplementation = {
	__index: OccupantImplementation,
	__tostring: (self: Occupant) -> string,
	IsOccupant: (value: any) -> boolean,
	new: (player: Player) -> Occupant,
	Destruct: (self: Occupant) -> (),
	GetOccupant: (player: Player, expiryDelay: number?) -> Occupant,
	SetPlot: (self: Occupant, plot: Plot?) -> ()
}

type OccupantProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_PlotChanged: BindableEvent,
	Player: Player,
	Plot: Plot?,
	PlotChanged: RBXScriptSignal,
	Destructing: RBXScriptSignal
}

export type Occupant = typeof(
	setmetatable(
		{} :: OccupantProperties,
		{} :: OccupantImplementation
	)
)

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>PlotModel</strong>.
]=]
local function IsPlotModel(value: any): boolean
	return typeof(value) == "Instance" and value:HasTag(PLOTS.TAG)
end

do
	--[=[
		Returns the first child of <code>Instance</code> with <code>Name</code> and <code>Class</code>, or throws an error with <code>Message</code> if no such child exists.
	]=]
	local function AssertFindFirstChildWhichIsA(instance: Instance, name: string, class: string, message: string): Instance
		local child = instance:FindFirstChild(name)

		assert(child and child:IsA(class), message)

		return child
	end

	function Plot:__tostring(): string
		return `Plot: {self.PlotModel}`
	end

	function Plot:_SetOwner(occupant: Occupant?)
		self.Owner = occupant
		self._OwnerChanged:Fire(occupant and occupant.Player)
	end

	function Plot:_AddOccupant(occupant: Occupant)
		local occupants = self.Occupants

		table.insert(occupants, occupant)

		self._OccupantAdded:Fire(occupant.Player)

		if occupants[1] == occupant then
			self:_SetOwner(occupant)
		end
	end

	function Plot:_RemoveOccupant(occupant: Occupant)
		self._OccupantRemoving:Fire(occupant.Player)

		local occupants = self.Occupants

		if self.Owner == occupant then
			self:_SetOwner(occupants[2])
		end

		table.remove(occupants, table.find(occupants, occupant))
	end

	function Plot.IsPlot(value: any): boolean
		return type(value) == "table" and getmetatable(value) == Plot
	end

	function Plot.new(plotModel: Model): Plot
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)
		assert(not Plots[plotModel], `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and has {Plots[plotModel]}.`)

		local boundaryPart: BasePart = AssertFindFirstChildWhichIsA(plotModel, BOUNDARY_NAME, "BasePart", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a BasePart with name '{BOUNDARY_NAME}'.`) :: any
		local buildModel: Model = AssertFindFirstChildWhichIsA(plotModel, BUILD_NAME, "Model", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a Model with name '{BUILD_NAME}'.`) :: any
		local spawnModel: Model = AssertFindFirstChildWhichIsA(plotModel, SPAWN_NAME, "Model", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a Model with name '{SPAWN_NAME}'.`) :: any

		local self = setmetatable({} :: PlotProperties, Plot)

		self._Destructor = Destructor.new()

		self._Destructor:Add(function()
			self._Destructing:Fire()

			self:Vacate()

			PlotRemoving:Fire(plotModel)
			Plots[plotModel] = nil
		end)

		self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

		self._SpawnedChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self._OwnerChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self._OccupantAdded = self._Destructor:Add(Instance.new("BindableEvent"))
		self._OccupantRemoving = self._Destructor:Add(Instance.new("BindableEvent"))

		self.Destructing = self._Destructing.Event

		self.PlotModel = plotModel

		self.Boundary = Cuboid.new(boundaryPart.CFrame, boundaryPart.Size)

		self.BuildModel, self.SpawnModel = buildModel, spawnModel

		self.Spawned = false
		self.SpawnedChanged = self._SpawnedChanged.Event

		self.Owner = nil
		self.OwnerChanged = self._OwnerChanged.Event

		self.Occupants = {}
		self.OccupantAdded = self._OccupantAdded.Event
		self.OccupantRemoving = self._OccupantRemoving.Event

		Plots[plotModel] = self
		PlotAdded:Fire(plotModel)

		return self
	end

	function Plot:Destruct()
		self._Destructor:Destruct()
	end

	function Plot.GetPlot(plotModel: Model, expiryDelay: number?): Plot
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to getter 'GetPlot' of Plot is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)
		assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to getter 'GetPlot' of Plot is {expiryDelay} and not a number or nil.`)

		local plot = Plots[plotModel]

		if plot then
			return plot
		end

		expiryDelay = expiryDelay or GETTER_EXPIRY_DELAY

		local thread = Instance.new("BindableEvent")

		local threads = {
			task.spawn(function()
				repeat
					PlotAdded.Event:Wait()

					plot = Plots[plotModel]
				until plot

				thread:Fire(true)
			end),
			task.delay(expiryDelay, thread.Fire, thread, nil)
		}

		local result: boolean? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		if not result then
			warn(`Argument 'PlotModel' to getter 'GetPlot' of Plot is {plotModel} and has not gotten a Plot for greater than or equal to {expiryDelay} second(s).`)

			coroutine.yield()
		end

		return plot :: any
	end

	function Plot:Vacate()
		for _, occupant: Occupant in self.Occupants :: any do
			occupant:SetPlot(nil)
		end
	end

	function Plot:SpawnCreation()
		if self.Spawned then
			return
		end

		self.Spawned = true
		self._SpawnedChanged:Fire(true)
	end

	function Plot:DespawnCreation()
		if not self.Spawned then
			return
		end

		self.Spawned = false
		self._SpawnedChanged:Fire(false)
	end
end

do
	--[=[
		Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>Player</strong>.
	]=]
	local function IsPlayer(value: any): boolean
		return typeof(value) == "Instance" and value:IsA("Player")
	end

	function Occupant:__tostring(): string
		return `Occupant: {self.Player}`
	end

	function Occupant.IsOccupant(value: any): boolean
		return type(value) == "table" and getmetatable(value) == Occupant
	end

	function Occupant.new(player: Player): Occupant
		assert(IsPlayer(player), `Argument 'Player' to constructor 'new' of Occupant is {LocalPlayer} and not a Player.`)
		assert(not Occupants[player], `Argument 'Player' to constructor 'new' of Occupant is {player} and has {Occupants[player]}.`)

		local self = setmetatable({} :: OccupantProperties, Occupant)

		self._Destructor = Destructor.new()

		self._Destructor:Add(function()
			self._Destructing:Fire()

			self:SetPlot(nil)

			OccupantRemoving:Fire(player)
			Occupants[player] = nil
		end)

		self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

		self._PlotChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self.Destructing = self._Destructing.Event

		self.Player = player

		self.Plot = nil
		self.PlotChanged = self._PlotChanged.Event

		Occupants[player] = self
		OccupantAdded:Fire(player)

		return self
	end

	function Occupant:Destruct()
		self._Destructor:Destruct()
	end

	function Occupant.GetOccupant(player: Player, expiryDelay: number?): Occupant
		assert(IsPlayer(player), `Argument 'Player' to getter 'GetOccupant' of Occupant is {player} and not a Player.`)
		assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to getter 'GetOccupant' of Occupant is {expiryDelay} and not a number or nil.`)

		expiryDelay = expiryDelay or GETTER_EXPIRY_DELAY

		local occupant = Occupants[player]

		if occupant then
			return occupant
		end

		local thread = Instance.new("BindableEvent")

		local threads = {
			task.spawn(function()
				repeat
					OccupantAdded.Event:Wait()

					occupant = Occupants[player]
				until occupant

				thread:Fire(true)
			end),
			task.delay(expiryDelay, thread.Fire, thread, nil)
		}

		local result: boolean? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		if not result then
			warn(`Argument 'Player' to getter 'GetOccupant' of Occupant is {player} and has not gotten an Occupant for greater than or equal to {expiryDelay} second(s).`)

			coroutine.yield()
		end

		return occupant :: any
	end

	function Occupant:SetPlot(plot: Plot?)
		assert(plot == nil or Plot.IsPlot(plot), `Argument 'Plot' to method 'SetPlot' of Occupant on {self} is {plot} and not a Plot or nil.`)

		local oldPlot = self.Plot

		if plot == oldPlot then
			return
		end

		if oldPlot then
			oldPlot:_RemoveOccupant(self)
		end

		if plot then
			plot:_AddOccupant(self)
		end

		self.Plot = plot
		self._PlotChanged:Fire(plot and plot.PlotModel)
	end
end

local LocalOccupant = Occupant.new(LocalPlayer)

--[=[
	Fires a signal to the <strong>Server</strong> to spawn <code>LocalOccupant.Plot</code>.
]=]
local function SpawnCreation()
	local plot = assert(LocalOccupant.Plot, `Called method 'SpawnCreation' of Plots while property 'Plot' of {LocalOccupant} is {LocalOccupant.Plot} and not a Plot.`)

	assert(not plot.Spawned, `Called method 'SpawnCreation' of Plots while property 'Spawned' of {plot} is {plot.Spawned} and not a falsy value.`)
	assert(plot.Owner == LocalOccupant, `Called method 'SpawnCreation' of Plots while property 'Owner' of {plot} is {plot.Owner} and not equal to {LocalOccupant}.`)

	SpawnCreationRemote:FireServer()
end

--[=[
	Fires a signal to the <strong>Server</strong> to despawn <code>LocalOccupant.Plot</code>.
]=]
local function DespawnCreation()
	local plot = assert(LocalOccupant.Plot, `Called method 'DespawnCreation' of Plots while property 'Plot' of {LocalOccupant} is {LocalOccupant.Plot} and not a Plot.`)

	assert(plot.Spawned, `Called method 'DespawnCreation' of Plots while property 'Spawned' of {plot} is {plot.Spawned} and not a truthy value.`)
	assert(plot.Owner == LocalOccupant, `Called method 'DespawnCreation' of Plots while property 'Owner' of {plot} is {plot.Owner} and not equal to {LocalOccupant}.`)

	DespawnCreationRemote:FireServer()
end

--[=[
	Fires a signal to the <strong>Server</strong> to kick <code>Occupant</code>.
]=]
local function KickOccupant(occupant: Occupant)
	assert(Occupant.IsOccupant(occupant), `Argument 'Occupant' to method 'KickOccupant' of Plots is {occupant} and not an Occupant.`)
	assert(occupant ~= LocalOccupant, `Argument 'Occupant' to method 'KickOccupant' of Plots is {occupant} and equal to {LocalOccupant}.`)

	local plot = assert(LocalOccupant.Plot, `Called method 'KickOccupant' of Plots while property 'Plot' of {LocalOccupant} is {LocalOccupant.Plot} and not a Plot.`)

	assert(plot.Owner == LocalOccupant, `Called method 'KickOccupant' of Plots while property 'Owner' of {plot} is {plot.Owner} and not equal to {LocalOccupant}.`)
	assert(occupant.Plot == plot, `Called method 'KickOccupant' of Plots while property 'Plot' of {occupant} is {occupant.Plot} and not {plot}.`)

	local isOwner = IsPlayerExperienceOwner(occupant.Player)

	assert(not isOwner, `Called callback 'OnServerEvent' of {KickOccupantRemote} while return value of {IsPlayerExperienceOwner} is {isOwner} and not a falsy value.`)

	KickOccupantRemote:FireServer(occupant.Player)
end

local SetPlotRunningFor: {Model} = {}

--[=[
	Fires a signal to the <strong>Server</strong> to set <code>LocalOccupant.Plot</code> to <code>PlotModel</code> and returns a <strong>boolean</strong> indicating whether the operation was successful or <strong>nil</strong> if there was no response.
]=]
local function SetPlot(plotModel: Model?, expiryDelay: number?): boolean?
	assert(plotModel == nil or IsPlotModel(plotModel), `Argument 'PlotModel' to method 'SetPlot' of Plots is {plotModel} and not a Model with tag '{PLOT_TAG}' or nil.`)
	assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to method 'SetPlot' of Plots is {expiryDelay} and not a number or nil.`)

	if plotModel then
		if table.find(SetPlotRunningFor, plotModel) then
			return nil
		end

		table.insert(SetPlotRunningFor, plotModel)
	end

	local _, success: boolean? = xpcall(function()
		local currentPlot = LocalOccupant.Plot

		assert(plotModel ~= (currentPlot and currentPlot.PlotModel), `Argument 'PlotModel' to method 'SetPlot' of Plots is {plotModel} and equal to property 'Plot' of {LocalOccupant}.`)

		local plot = plotModel and Plots[plotModel]
		local occupants = plot and plot.Occupants

		if (if occupants then #occupants else 0) >= MAX_OCCUPANTS then
			return nil
		end

		expiryDelay = expiryDelay or INVOCATION_EXPIRY_DELAY

		local thread = Instance.new("BindableEvent")
		local threads: {thread} = {}

		table.insert(threads, task.spawn(function()
			local _, success = xpcall(function(success: boolean?, ...)
				assert(select("#", ...) == 0, `Return values of method 'InvokeServer' of {SetPlotRemote} are not unary.`)
				assert(success == nil or type(success) == "boolean", `Return value #1 of method 'InvokeServer' of {SetPlotRemote} is {success} and not a boolean or nil.`)

				return success
			end, function(message: string)
				warn(debug.traceback(message))
			end, SetPlotRemote:InvokeServer(plotModel))

			thread:Fire(success)
		end))

		if plot then
			table.insert(threads, task.spawn(function()
				while true do
					plot.OccupantAdded:Wait()

					if #occupants :: any >= MAX_OCCUPANTS then
						thread:Fire(nil)
					end
				end
			end))
		end

		table.insert(threads, task.delay(expiryDelay, thread.Fire, thread, nil))

		local success: boolean? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		return success :: any
	end, function(message: string)
		warn(debug.traceback(message))
	end)

	if plotModel then
		table.remove(SetPlotRunningFor, table.find(SetPlotRunningFor, plotModel))
	end

	return success
end

return {
	Occupant = Occupant,
	Occupants = Occupants,
	OccupantAdded = OccupantAdded.Event,
	OccupantRemoving = OccupantRemoving.Event,
	Plot = Plot,
	Plots = Plots,
	PlotAdded = PlotAdded.Event,
	PlotRemoving = PlotRemoving.Event,
	LocalOccupant = LocalOccupant,
	SpawnCreation = SpawnCreation,
	DespawnCreation = DespawnCreation,
	KickOccupant = KickOccupant,
	SetPlot = SetPlot
}

-- </Script #27 End>
--[[
<Script #28 Begin>
<Metadata Begin>
Name: "LogicalProcessorCount"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.LogicalProcessorCount
Size: 2924 Character(s), 88 Line(s)
</Metadata End>
]]

--!strict
--!native
local EXECUTION_TIME = (2 ^ 6) ^ -1 -- Second(s)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local ReportStartStopTimestampsBindable = script:WaitForChild("ReportStartStopTimestamps")

local LogicalProcessorCountWorker: BaseScript = script:WaitForChild(`LogicalProcessorCountWorker{if RunService:IsClient() then "Client" else "Server"}`)

local SerialExecutionTimeThreshold = EXECUTION_TIME * 3 / 2

--[=[
	Returns a <strong>boolean</strong> indicating whether a number of <strong>threads</strong> equal to <code>Count</code> can run concurrently in parallel. This can be used to approximate the number of logical processors running the <strong>Roblox Client</strong>. This value is limited by thread affinity, C-states, CPU threads, and <strong>FFlag DFIntRuntimeConcurrency</strong>, which, as of 6/3/2025, defaults to 3 for <strong>Live Clients</strong>, 2 for <strong>Live Servers</strong>, and 8 for <strong>Studio</strong>.
]=]
local function CanThreadsRunInParallel(count: number): boolean
	local workers: {BaseScript} = table.create(count)
	local destructor = Destructor.new()

	for _ = 1, count do
		local worker = Instance.fromExisting(LogicalProcessorCountWorker)
		worker.Parent = destructor:Add(Instance.new("Actor", script))

		table.insert(workers, worker)
	end

	local earliestTimestamp, latestTimestamp = math.huge, -math.huge

	local workerThread = Instance.new("BindableEvent")
	local executingWorkersCount = count

	destructor:Add(ReportStartStopTimestampsBindable.Event:Connect(function(...: number)
		earliestTimestamp, latestTimestamp = math.min(earliestTimestamp, ...), math.max(latestTimestamp, ...)

		executingWorkersCount -= 1

		if executingWorkersCount == 0 then
			workerThread:Fire()
		end
	end))

	for _, worker in workers do
		worker.Enabled = true
	end

	workerThread.Event:Wait()

	destructor:Destruct()

	return latestTimestamp - earliestTimestamp < SerialExecutionTimeThreshold
end

local LogicalProcessorCount = 2

local Timestamp = os.clock()
local TotalExecutionTime = 0

while true do
	local passed = CanThreadsRunInParallel(LogicalProcessorCount)

	local timestamp = os.clock()
	local executionTime = timestamp - Timestamp

	TotalExecutionTime += executionTime
	Timestamp = timestamp

	if passed then
		print(`[{script}]: Passed {LogicalProcessorCount} Thread(s) with {math.floor(executionTime * 1e3)} ms.`)
	else
		print(`[{script}]: Failed at {LogicalProcessorCount} Thread(s) with {math.floor(executionTime * 1e3)} ms.`)

		break
	end

	LogicalProcessorCount += 1

	task.wait()
end

print(`[{script}]: Computed Logical Processor Count in {math.floor(TotalExecutionTime * 1e3)} ms.`)

return LogicalProcessorCount - 1

-- </Script #28 End>
--[[
<Script #29 Begin>
<Metadata Begin>
Name: "LogicalProcessorCountPrinterClient"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Debug.LogicalProcessorCountPrinterClient
Size: 641 Character(s), 19 Line(s)
</Metadata End>
]]

--!strict
if not game:IsLoaded() then
	game.Loaded:Wait()
end

task.wait(2.5)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Values = Modules:WaitForChild("Values")
local LogicalProcessorCount = require(Values:WaitForChild("LogicalProcessorCount"))
local NumericalPrefixes = require(Values:WaitForChild("NumericalPrefixes"))

TestService:Message(`[{script}]: Logical Processor Count: {LogicalProcessorCount} ({NumericalPrefixes[LogicalProcessorCount] or LogicalProcessorCount}-threaded)`)

script:Destroy()

-- </Script #29 End>
--[[
<Script #30 Begin>
<Metadata Begin>
Name: "DiurnalLighting"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.DiurnalLighting
Size: 4366 Character(s), 114 Line(s)
</Metadata End>
]]

--!strict
--!native
local TIME_BIAS = 7 + 6 ^ -1 -- Hour(s)
local TIME_SPEED_MULTIPLIER = 24 * 3 / 2 -- 1 Game-Time Day = 45 Real-Time Minutes

local MORNING_START, MORNING_END = 6, 7 -- Hour
local DUSK_START, DUSK_END = 17, 18 -- Hour

local DAY_LUMINOSITY, DAY_OUTDOOR_AMBIENCE, DAY_CLOUD_DENSITY = 4.5, Color3.fromRGB(159, 159, 159), (2 ^ 4) ^ -1
local NIGHT_LUMINOSITY, NIGHT_OUTDOOR_AMBIENCE, NIGHT_CLOUD_DENSITY = 2, Color3.fromRGB(72, 72, 96), (2 ^ 5 * 3 / 4) ^ -1

local HOUR_OF_DAY_TRANSFORM_MULTIPLIER = TIME_SPEED_MULTIPLIER / (60 * 60)

local MIN_RENDER_DELTA_TIME_TO_SYNC = 2 ^ -5 * 24 / HOUR_OF_DAY_TRANSFORM_MULTIPLIER -- Second(s)

local BUFFER_MULTIPLIER = 3 / 2

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local GetGlobalTimestamp = require(Functions:WaitForChild("GetGlobalTimestamp"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Clouds: Clouds = workspace.Terrain:WaitForChild("Clouds")

local TweenParameters = TweenInfo.new(2, Enum.EasingStyle.Linear)

local ServerStartedTimestamp: number

--[=[
	Returns a <strong>number</strong> representing the unwrapped game-time hour of day for <strong>Lighting.ClockTime</strong>, synchronized across all <strong>Clients</strong>.
]=]
local function GetSyncedHourOfDay(): number
	return (GetGlobalTimestamp() - ServerStartedTimestamp) * HOUR_OF_DAY_TRANSFORM_MULTIPLIER + TIME_BIAS
end

local UnwrappedHourOfDay = Instance.new("NumberValue")

Callback.CallAndConnect(function()
	ServerStartedTimestamp = workspace:GetAttribute("ServerStartedTimestamp") or 0

	UnwrappedHourOfDay.Value = GetSyncedHourOfDay()
end, workspace:GetAttributeChangedSignal("ServerStartedTimestamp"))

RunService.PreRender:Connect(function(deltaTime)
	if deltaTime < MIN_RENDER_DELTA_TIME_TO_SYNC then
		return
	end

	print(`[{script}]: Render delta time was {math.floor(deltaTime)} second(s) and greater than or equal to {MIN_RENDER_DELTA_TIME_TO_SYNC} second(s). Syncing {Lighting}.TimeOfDay.`)

	UnwrappedHourOfDay.Value = GetSyncedHourOfDay()
end)

Callback.CallAndConnect(function(value: number)
	Lighting.ClockTime = value % 24
end, UnwrappedHourOfDay.Changed, UnwrappedHourOfDay.Value)

local UnwrappedHourOfDayBuffer = TIME_SPEED_MULTIPLIER ^ -1 * BUFFER_MULTIPLIER

while true do
	local unwrappedHourOfDay = GetSyncedHourOfDay()
	local hourOfDay = unwrappedHourOfDay % 24

	local luminosity: number, outdoorAmbience: Color3, cloudDensity: number

	if hourOfDay > MORNING_START and hourOfDay < MORNING_END then
		local alpha = (hourOfDay - MORNING_START) / (MORNING_END - MORNING_START)

		luminosity = math.lerp(NIGHT_LUMINOSITY, DAY_LUMINOSITY, alpha)
		outdoorAmbience = NIGHT_OUTDOOR_AMBIENCE:Lerp(DAY_OUTDOOR_AMBIENCE, alpha)
		cloudDensity = math.lerp(NIGHT_CLOUD_DENSITY, DAY_CLOUD_DENSITY, alpha)
	elseif hourOfDay > DUSK_START and hourOfDay < DUSK_END then
		local alpha = (hourOfDay - DUSK_START) / (DUSK_END - DUSK_START)

		luminosity = math.lerp(DAY_LUMINOSITY, NIGHT_LUMINOSITY, alpha)
		outdoorAmbience = DAY_OUTDOOR_AMBIENCE:Lerp(NIGHT_OUTDOOR_AMBIENCE, alpha)
		cloudDensity = math.lerp(DAY_CLOUD_DENSITY, NIGHT_CLOUD_DENSITY, alpha)
	elseif hourOfDay >= MORNING_END and hourOfDay <= DUSK_START then
		luminosity = DAY_LUMINOSITY
		outdoorAmbience = DAY_OUTDOOR_AMBIENCE
		cloudDensity = DAY_CLOUD_DENSITY
	else
		luminosity = NIGHT_LUMINOSITY
		outdoorAmbience = NIGHT_OUTDOOR_AMBIENCE
		cloudDensity = NIGHT_CLOUD_DENSITY
	end

	TweenService:Create(UnwrappedHourOfDay, TweenParameters, {Value = unwrappedHourOfDay + UnwrappedHourOfDayBuffer}):Play()

	if Lighting.Brightness ~= luminosity or Lighting.OutdoorAmbient ~= outdoorAmbience then
		TweenService:Create(Lighting, TweenParameters, {
			Brightness = luminosity,
			OutdoorAmbient = outdoorAmbience
		}):Play()
	end

	if Clouds.Density ~= cloudDensity then
		TweenService:Create(Clouds, TweenParameters, {Density = cloudDensity}):Play()
	end

	local timeToResume = math.floor(GetGlobalTimestamp()) + 1

	repeat
		RunService.PreRender:Wait()
	until GetGlobalTimestamp() >= timeToResume
end

-- </Script #30 End>
--[[
<Script #31 Begin>
<Metadata Begin>
Name: "AntiCheatServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Players.Security.AntiCheatServer
Size: 4621 Character(s), 153 Line(s)
</Metadata End>
]]

--!strict
local HANDSHAKE_INTERVAL = 20 -- Second(s)
local HANDSHAKE_EXPIRY_DELAY = 15 -- Second(s)

local TOKEN_LENGTH = 2 ^ 5 -- Character(s)

local MAX_SAFE_INTEGER = 2 ^ 53
local MIN_SAFE_INTEGER = -MAX_SAFE_INTEGER

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FirstRemotes = ReplicatedFirst:WaitForChild("Remotes")

local FirstAntiCheatRemotes = FirstRemotes:WaitForChild("AntiCheat")
local TrippedRemote = FirstAntiCheatRemotes:WaitForChild("Tripped")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local AntiCheatRemotes = Remotes:WaitForChild("AntiCheat")
local GetTokenRemote = AntiCheatRemotes:WaitForChild("GetToken")
local HandshakeRemote = AntiCheatRemotes:WaitForChild("Handshake")

if RunService:IsStudio() then
	print(`[{script}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	script:Destroy()

	return
end

local Randomizer = Random.new(tick())

local Threads: {[Player]: thread} = {}

local Tokens: {[Player]: string} = {}
local GotToken: {Player} = {}

Players.PlayerAdded:Connect(@native function(player)
	if IsPlayerExperienceOwner(player) then
		return
	end

	local token = ""
	local tokenCodes = table.create(TOKEN_LENGTH)

	for _ = 1, TOKEN_LENGTH do
		local code = string.char(Randomizer:NextInteger(0, 255))

		token ..= code

		table.insert(tokenCodes, code)
	end

	Threads[player] = task.spawn(function()
		while task.wait(HANDSHAKE_INTERVAL) do
			task.spawn(function()
				local challengeKey = Randomizer:NextInteger(
					MIN_SAFE_INTEGER,
					MAX_SAFE_INTEGER
				)

				local challengeCodes: {number} = table.create(TOKEN_LENGTH)

				for _, code in {token:byte(1, TOKEN_LENGTH)} do
					table.insert(challengeCodes, bit32.bxor(code, challengeKey))
				end

				local challengeToken = ("d"):rep(TOKEN_LENGTH):pack(unpack(challengeCodes))

				local thread = Instance.new("BindableEvent")

				local threads = {
					task.spawn(function()
						local _, playerToken = xpcall(function(playerToken: buffer, ...)
							assert(select("#", ...) == 0, `Return values of method 'InvokeClient' of {HandshakeRemote} are not unary.`)
							assert(type(playerToken) == "buffer", `Return value #1 of method 'InvokeClient' of {HandshakeRemote} is {playerToken} and not a buffer.`)

							return buffer.tostring(playerToken):reverse()
						end, warn, HandshakeRemote:InvokeClient(player, buffer.fromstring(("d"):pack(challengeKey):reverse())))

						thread:Fire(playerToken == challengeToken)
					end),
					task.delay(HANDSHAKE_EXPIRY_DELAY, thread.Fire, thread, nil)
				}

				local result: boolean? = thread.Event:Wait()

				for _, thread in threads do
					task.cancel(thread)
				end

				if not result then
					warn(`[{script}] Server Anti-Cheat tripped for {player} ({player.UserId})`)

					player:Kick(`[{script}]: Server Anti-Cheat tripped. Cross-context Handshake Invocation was not returned within {HANDSHAKE_EXPIRY_DELAY} second(s) or did not match Challenge Token.`)
				end
			end)
		end
	end)

	Tokens[player] = token
end)

Players.PlayerRemoving:Connect(function(player)
	local thread = Threads[player]

	if thread then
		task.cancel(thread)

		Threads[player] = nil
	end

	local index = table.find(GotToken, player)

	if index then
		table.remove(GotToken, index)
	end
end)

GetTokenRemote.OnServerInvoke = function(player, ...): buffer
	return select(2, xpcall(function(...)
		assert(not table.find(GotToken, player), `Called callback 'OnServerInvoke' of {GetTokenRemote} while {player} is a value in {GotToken}.`)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerInvoke' of {GetTokenRemote} are not nullary.`)

		table.insert(GotToken, player)

		return buffer.fromstring(Tokens[player]:reverse())
	end, function(message: string)
		warn(debug.traceback(message))

		player:Kick(message)
	end, ...))
end

TrippedRemote.OnServerEvent:Connect(function(player, message: string)
	if type(message) ~= "string" then
		warn(`Argument 'Message' to callback 'OnServerEvent' of {TrippedRemote} is {message} and not a string.`)

		message = "<Error: No Message>"
	end

	warn(`[{script}] Client Anti-Cheat tripped for {player} ({player.UserId}) with message: {message}`)

	player:Kick(`[{script}]: Client Anti-Cheat tripped with message: {message}`)
end)

-- </Script #31 End>
--[[
<Script #32 Begin>
<Metadata Begin>
Name: "PingCallback"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.PingCallback
Size: 332 Character(s), 11 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local NetworkRemotes = Remotes:WaitForChild("Network")
local PingRemote = NetworkRemotes:WaitForChild("Ping")

PingRemote.OnServerInvoke = function(): number
	return workspace:GetServerTimeNow()
end

-- </Script #32 End>
--[[
<Script #33 Begin>
<Metadata Begin>
Name: "MarqueeSelector"
Type: LocalScript
Path: StarterGui.MarqueeSelector.Marquee.MarqueeSelector
Size: 5158 Character(s), 162 Line(s)
</Metadata End>
]]

--!strict
local HIDE_TWEEN_SPEED_MULTIPLIER = 2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TOOLS = CONSTANTS.Tools

local _, _, MAX_LIGHTNESS = CONSTANTS.Gui.ColorScheme.LIGHT:ToHSV()

local TWEENS = CONSTANTS.Tweens

local ASSET_TAG = CONSTANTS.Assets.TAG

local ASSET_SELECTOR_MODE_KEYS = CONSTANTS.AssetSelectorModeKeys
local MARQUEE_MODE_KEY = ASSET_SELECTOR_MODE_KEYS.MARQUEE
local INVERT_MODE_KEY = ASSET_SELECTOR_MODE_KEYS.INVERT

local Classes = Modules:WaitForChild("Classes")
local AssetSelector = require(Classes:WaitForChild("AssetSelector"))
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local LocalOccupant = Plots.LocalOccupant

local Marquee = script.Parent

local TweenParameters = TweenInfo.new(TWEENS.DURATION / HIDE_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)

local HideTween = TweenService:Create(Marquee, TweenParameters, {
	GroupTransparency = 1
})

HideTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		Marquee.Visible = false
	end
end)

--[=[
	Returns all <strong>Assets</strong> in <code>LocalOccupant.Plot.BuildModel</code> whose pivots are within <code>Rect</code> in the viewport.
]=]
@native
local function GetAssetCentroidsInRect(rect: Rect): {Model}
	local assets: {Model} = {}
	local camera = workspace.CurrentCamera

	for _, asset: Model in Hierarchy.GetChildrenWithTag((LocalOccupant.Plot :: any).BuildModel, ASSET_TAG) :: any do
		local location: Vector2, unoccluded: boolean = camera:WorldToViewportPoint(asset:GetPivot().Position)
		local min, max = rect.Min, rect.Max

		if
			unoccluded
			and location.X >= min.X and location.X <= max.X
			and location.Y >= min.Y and location.Y <= max.Y
		then
			table.insert(assets, asset)
		end
	end

	return assets
end

for name: string, tool in Tools :: any do
	local selector: AssetSelector.AssetSelector = tool.Selector

	if not selector then
		continue
	end

	local THEME_COLOR: Color3 = TOOLS[name].THEME_COLOR
	local HUE, SATURATION, LIGHTNESS = THEME_COLOR:ToHSV()
	local COLOR = Color3.fromHSV(HUE, SATURATION, math.min(MAX_LIGHTNESS, LIGHTNESS))

	local enabledChangedDestructor = Destructor.new();

	(tool.Enabled :: ValueWrapper.ValueWrapper<boolean>).Changed:Connect(function(enabled: boolean)
		enabledChangedDestructor:Destruct()

		if not enabled then
			return
		end

		Marquee.GroupColor3 = COLOR

		local marqueeModeDisabledDestructor = enabledChangedDestructor:Add(Destructor.new())

		enabledChangedDestructor:Add(UserInputService.InputBegan:Connect(function(input, processed)
			if processed or input.KeyCode ~= MARQUEE_MODE_KEY then
				return
			end

			local mouseButton1UpDestructor = marqueeModeDisabledDestructor:Add(Destructor.new())

			marqueeModeDisabledDestructor:Add(Mouse.Button1Down:Connect(function()
				local began = UserInputService:GetMouseLocation()
				local ended = began

				mouseButton1UpDestructor:Add(Mouse.Move:Connect(@native function()
					ended = UserInputService:GetMouseLocation()

					Marquee.AnchorPoint = (began - ended):Sign() * 2 - Vector2.one
					Marquee.Size = UDim2.fromOffset(math.abs(ended.X - began.X), math.abs(ended.Y - began.Y))
				end))

				mouseButton1UpDestructor:Add(Mouse.Move:Once(function()
					Marquee.Position = UDim2.fromOffset(began.X, began.Y)
					Marquee.GroupTransparency = 0
					Marquee.Visible = true

					mouseButton1UpDestructor:Add(UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end

						local assets = GetAssetCentroidsInRect(Rect.new(began:Min(ended), began:Max(ended)))

						print(`[{script}]: Selected {#assets} Asset(s).`)

						if UserInputService:IsKeyDown(INVERT_MODE_KEY) then
							selector:InvertSelection(assets)
						else
							selector:SetSelection(assets)
						end
					end))

					mouseButton1UpDestructor:Add(HideTween.Play, HideTween)
				end))
			end))

			marqueeModeDisabledDestructor:Add(UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					mouseButton1UpDestructor:Destruct()
				end
			end))
		end))

		enabledChangedDestructor:Add(UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == MARQUEE_MODE_KEY then
				marqueeModeDisabledDestructor:Destruct()
			end
		end))
	end)
end

-- </Script #33 End>
--[[
<Script #34 Begin>
<Metadata Begin>
Name: "CharacterCollisionDisabler"
Type: Script
Context: Legacy
Path: ServerScriptService.Players.CharacterCollisionDisabler
Size: 1430 Character(s), 40 Line(s)
</Metadata End>
]]

--!strict
local CHARACTER_COLLISION_GROUP_NAME = "Characters"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local PreviousCollisionGroups: {[BasePart]: string} = {}

PhysicsService:RegisterCollisionGroup(CHARACTER_COLLISION_GROUP_NAME)
PhysicsService:CollisionGroupSetCollidable(CHARACTER_COLLISION_GROUP_NAME, CHARACTER_COLLISION_GROUP_NAME, false)

Players.PlayerAdded:Connect(function(player)
	Callback.CallForEachVarargAndConnect(function(character: Model)
		Callback.CallForEachVarargAndConnect(function(descendant: Instance)
			if not descendant:IsA("BasePart") then
				return
			end

			PreviousCollisionGroups[descendant] = descendant.CollisionGroup

			descendant.CollisionGroup = CHARACTER_COLLISION_GROUP_NAME
		end, character.DescendantAdded, unpack(character:GetDescendants()))

		character.DescendantRemoving:Connect(function(descendant: Instance)
			if not (descendant:IsA("BasePart") and PreviousCollisionGroups[descendant]) then
				return
			end

			descendant.CollisionGroup = PreviousCollisionGroups[descendant]

			PreviousCollisionGroups[descendant] = nil
		end)
	end, player.CharacterAdded, player.Character)
end)

-- </Script #34 End>
--[[
<Script #35 Begin>
<Metadata Begin>
Name: "CommandExecutionVirtualMachineEnvironment"
Type: ModuleScript
Path: StarterPlayer.StarterPlayerScripts.Debug.RemoteCommandExecutorClient.CommandExecutionVirtualMachineEnvironment
Size: 110 Character(s), 6 Line(s)
</Metadata End>
]]

--!strict
--!nolint DeprecatedApi
local Environment = getfenv(0)
Environment.script = nil

return Environment

-- </Script #35 End>
--[[
<Script #36 Begin>
<Metadata Begin>
Name: "SplashScreen"
Type: LocalScript
Path: ReplicatedFirst.Gui.SplashScreen.SplashScreen
Size: 4647 Character(s), 175 Line(s)
</Metadata End>
]]

--!strict
--!native
local VIEWPORT_FIELD_OF_VIEW = math.deg(math.pi / 4) -- Degree(s)

local OSCILLATION_UPDATE_FREQUENCY = 2 ^ 3 * 3 / 4 -- Hertz
local OSCILLATION_RANGE = math.pi / 3 -- Radian(s)

local COLOR_CORRECTION_BRIGHTNESS = -3 ^ -1
local COLOR_CORRECTION_SATURATION = -1 - 3 / 8

local BLUR_DEVIATION = 2 ^ 5 * 3 / 4 -- Pixel(s)

local SERVICES_TO_PRELOAD = {
	"ReplicatedFirst",
	"ReplicatedStorage",
	"StarterPlayer",
	"StarterGui",
	"SoundService",
	"Workspace"
}

local DESTROY_DELAY_RANGE = NumberRange.new(.5, 3 / 2) -- Second(s)

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Gui = script.Parent
local Group = Gui:WaitForChild("Group")
local Viewport = Group:WaitForChild("Viewport")
local Icon = Viewport:WaitForChild("Icon")

local TweenParameters1 = TweenInfo.new(5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
local TweenParameters2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

--if RunService:IsStudio() then
--	task.defer(Gui.Destroy, Gui)

--	return
--end

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Brightness = COLOR_CORRECTION_BRIGHTNESS
ColorCorrection.Saturation = COLOR_CORRECTION_SATURATION
ColorCorrection.Parent = Lighting

local Blur = Instance.new("BlurEffect")
Blur.Size = BLUR_DEVIATION
Blur.Parent = Lighting

local Camera = Instance.new("Camera")
Camera.FieldOfView = VIEWPORT_FIELD_OF_VIEW
Camera.Parent = Viewport

Viewport.CurrentCamera = Camera

task.spawn(function()
	-- TODO::Refine
	local ViewingFrustumClass = require(script:WaitForChild("ViewingFrustum"))

	local viewingFrustum = ViewingFrustumClass.new(Viewport, Camera)
	viewingFrustum:SetModel(Icon)
	viewingFrustum:Calibrate()

	Viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		viewingFrustum:Calibrate()
	end)

	local oscillationUpdateInterval = OSCILLATION_UPDATE_FREQUENCY ^ -1

	while true do
		local alpha = tick() * 2 / TweenParameters1.Time % 2

		if alpha > 1 then
			alpha = 2 - alpha
		end

		Camera.CFrame = viewingFrustum:GetMinimumFitCFrame(
			CFrame.Angles(
				0,
				TweenService:GetValue(alpha, TweenParameters1.EasingStyle, TweenParameters1.EasingDirection) * OSCILLATION_RANGE - OSCILLATION_RANGE / 2,
				0
			)
		)

		wait(oscillationUpdateInterval)
	end
end)

if not game:IsLoaded() then
	print(`[{script}]: DataModel not loaded. Awaiting load...`)

	local timestamp = os.clock()

	game.Loaded:Wait()

	print(`[{script}]: DataModel loaded in {math.floor((os.clock() - timestamp) * 1e3)} ms.`)
end

do
	local InstancesToPreload: {Instance} = {}

	for _, name in SERVICES_TO_PRELOAD do
		local service = game:FindService(name)

		if not service then
			continue
		end

		table.insert(InstancesToPreload, service)

		local descendants = service:GetDescendants()
		table.move(descendants, 1, #descendants, #InstancesToPreload + 1, InstancesToPreload)
	end

	local AssetFetchStatuses: {[string]: number} = {}

	for _, enum in Enum.AssetFetchStatus:GetEnumItems() do
		AssetFetchStatuses[enum.Name] = 0
	end

	print(`[{script}]: Preloading...`)

	local PreTimestamp = os.clock()

	ContentProvider:PreloadAsync(InstancesToPreload, function(_, assetFetchStatus: Enum.AssetFetchStatus)
		AssetFetchStatuses[assetFetchStatus.Name] += 1
	end)

	local PostTimestamp = os.clock()

	local Modules = ReplicatedStorage:WaitForChild("Modules")

	local Libraries = Modules:WaitForChild("Libraries")
	local String = require(Libraries:WaitForChild("String"))

	local SuccessCount, FailureCount = AssetFetchStatuses.Success, AssetFetchStatuses.Failure

	print(
		`[{script}]: Preloaded {#InstancesToPreload} Instance(s) in `
			.. math.floor((PostTimestamp - PreTimestamp) * 1e3)
			.. " ms with a(n) "
			.. (if SuccessCount ~= 0 then math.floor(SuccessCount / (SuccessCount + FailureCount) * 100) else 100)
			.. "% Success rate: "
			.. String.FormatTable(AssetFetchStatuses)
	)
end

task.wait(math.lerp(DESTROY_DELAY_RANGE.Min, DESTROY_DELAY_RANGE.Max, Random.new(tick()):NextNumber()))

coroutine.yield()

do
	Group.Interactable = false

	local Tween = TweenService:Create(Group, TweenParameters2, {GroupTransparency = 1})

	Tween.Completed:Connect(function()
		ColorCorrection:Destroy()
		Blur:Destroy()

		Gui:Destroy()
	end)

	Tween:Play()

	TweenService:Create(ColorCorrection, TweenParameters2, {
		Brightness = 0,
		Saturation = 0
	}):Play()

	TweenService:Create(Blur, TweenParameters2, {Size = 0}):Play()
end

-- </Script #36 End>
--[[
<Script #37 Begin>
<Metadata Begin>
Name: "ActivityLogger"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.ActivityLogger
Size: 4127 Character(s), 115 Line(s)
</Metadata End>
]]

--!strict
local SERVERS_KEY_EXPIRY_DELAY = 3 -- Day(s)

local DAY_TO_SECONDS = 60 * 60 * 24 -- Second(s)

local _WARN_CLOSE_REASON_VALUES = {0, 1, 5}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local MessagingService = game:GetService("MessagingService")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local MAX_RANGE_COUNT = CONSTANTS.MemoryStores.MAX_RANGE_COUNT

local Functions = Modules:WaitForChild("Functions")
local GetGlobalTimestamp = require(Functions:WaitForChild("GetGlobalTimestamp"))

local Libraries = Modules:WaitForChild("Libraries")
local String = require(Libraries:WaitForChild("String"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DebugRemotes = Remotes:WaitForChild("Debug")
local ClientDisconnectInitiatedRemote = DebugRemotes:WaitForChild("ClientDisconnectInitiated")
local ServerShutdownInitiatedRemote = DebugRemotes:WaitForChild("ServerShutdownInitiated")

local JobId = game.JobId

game:BindToClose(function(closeReason: Enum.CloseReason)
	(if table.find(_WARN_CLOSE_REASON_VALUES, closeReason.Value) then warn else print :: any)(`[{script}]: Job{if JobId ~= "" then ` {JobId} ` else " "}shutting down at {DateTime.fromUnixTimestamp(os.time()):ToIsoDate()} with reason: {closeReason.Name:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")}`)

	ServerShutdownInitiatedRemote:FireAllClients(closeReason)
end)

if RunService:IsStudio() then
	print(`[{script}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	return
end

local Servers = MemoryStoreService:GetSortedMap("Servers")

task.spawn(function()
	game:BindToClose(function()
		MessagingService:PublishAsync("Server Shutdown", JobId)

		repeat until xpcall(Servers.RemoveAsync, function(message: string)
			warn(debug.traceback(message))
		end, Servers, JobId)
	end)

	MessagingService:SubscribeAsync("Server Startup", function(packet)
		print(`[{script}]: Server Started: {packet.Data}`)
	end)

	MessagingService:SubscribeAsync("Server Shutdown", function(packet)
		print(`[{script}]: Server Shut Down: {packet.Data}`)
	end)

	MessagingService:PublishAsync("Server Startup", JobId)

	xpcall(Servers.SetAsync, function(message: string)
		warn(debug.traceback(message))
	end, Servers, JobId, DateTime.fromUnixTimestamp(os.time()):ToIsoDate(), SERVERS_KEY_EXPIRY_DELAY * DAY_TO_SECONDS, GetGlobalTimestamp())

	xpcall(function()
		local serversData = Servers:GetRangeAsync(Enum.SortDirection.Descending, MAX_RANGE_COUNT)

		print(`[{script}]:\nServer Count: {#serversData}\nServers: {String.FormatTable(serversData)}`)
	end, function(message: string)
		warn(debug.traceback(message))
	end)
end)

local ConnectedTimestamps: {[Player]: number}, Unexcused: {Player} = {}, {}

Players.PlayerAdded:Connect(function(player)
	ConnectedTimestamps[player] = time()

	table.insert(Unexcused, player)

	print(`[{script}]: {player} connected to the Server.`)
end)

Players.PlayerRemoving:Connect(function(player)
	task.defer(coroutine.running())

	coroutine.yield()

	local index = table.find(Unexcused, player);

	(if index then warn else print :: any)(`[{script}]: {player}{if index then " unexcusedly " else " "}disconnected from the Server after being connected for {DateTime.fromUnixTimestamp(time() - ConnectedTimestamps[player]):FormatUniversalTime("H:m:s", LocalizationService.RobloxLocaleId)}`)

	ConnectedTimestamps[player] = nil
end)

ClientDisconnectInitiatedRemote.OnServerInvoke = function(player, timestamp: number)
	xpcall(function()
		print(`[{script}]: {player} initiated disconnect from the Server at {DateTime.fromUnixTimestamp(os.time() + workspace:GetServerTimeNow() - timestamp):ToIsoDate()}`)
	end, function(message: string)
		warn(debug.traceback(message))
	end)

	local index = table.find(Unexcused, player)

	if index then
		table.remove(Unexcused, index)
	end
end

-- </Script #37 End>
--[[
<Script #38 Begin>
<Metadata Begin>
Name: "AssetPoolClient"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Services.AssetPoolClient
Size: 4202 Character(s), 168 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetsFolder = ReplicatedStorage:WaitForChild("Assets")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local ASSET_TAG = CONSTANTS.Assets.TAG

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))

local LocalOccupant = Plots.LocalOccupant

local StoredAssets: {[number]: Model} = {}

local Assets: {Model} = {}
local AssetAdded = Instance.new("BindableEvent")
local AssetRemoving = Instance.new("BindableEvent")

local TotalAssets = Instance.new("NumberValue")
local AssetCounts: {[number]: NumberValue} = {}

do
	--[=[
		Returns all descendants of <code>Instance</code> that are <strong>Assets</strong>.
	]=]
	local function GetStoredAssets(instance: Instance): {Model}
		local assets: {Model} = {}

		for _, child in instance:GetChildren() do
			if child:HasTag(ASSET_TAG) then
				table.insert(assets, child :: any)
			elseif child:IsA("Folder") then
				for _, asset in GetStoredAssets(child) do
					table.insert(assets, asset)
				end
			end
		end

		return assets
	end

	local ClashingIds: {[number]: {Model}} = {}

	setmetatable(ClashingIds, {
		__index = function(_, id: number): {Model}
			return rawset(ClashingIds, id, {})[id]
		end
	})

	for _, asset in GetStoredAssets(AssetsFolder) do
		local id = asset:GetAttribute("__Id")
		local clashingAsset = StoredAssets[id]

		if clashingAsset then
			local clashingAssets = ClashingIds[id]

			if not table.find(clashingAssets, clashingAsset) then
				table.insert(clashingAssets, clashingAsset)
			end

			table.insert(ClashingIds[id], asset)
		end

		StoredAssets[id] = asset
		AssetCounts[id] = Instance.new("NumberValue")
	end

	print(`[{script}]: Stored Assets: {String.FormatTable(StoredAssets)}`)

	if #ClashingIds > 0 then
		warn(`[{script}]: StoredAssets has clashing ID(s) (Two or more Stored Assets share same '__Id' attributes):`, ClashingIds)
	end

	local HoleyIndices: {number} = {}

	for index = 1, table.maxn(StoredAssets) do
		if not StoredAssets[index] then
			table.insert(HoleyIndices, index)
		end
	end

	if #HoleyIndices > 0 then
		warn(`[{script}]: StoredAssets has holey indice(s) (Gap(s) between IDs):`, table.concat(HoleyIndices, ", "))
	end
end

--[=[
	Removes <code>Asset</code> from <code>Assets</code>.
]=]
local function RemoveAsset(asset: Model)
	AssetRemoving:Fire(asset)

	Assets[asset:GetAttribute("__Index")] = nil
	AssetCounts[asset:GetAttribute("__Id")].Value -= 1

	TotalAssets.Value -= 1
end

--[=[
	Adds <code>Asset</code> to <code>Assets</code>.
]=]
local function AddAsset(asset: Model)
	local index: number = asset:GetAttribute("__Index")

	if Assets[index] then
		RemoveAsset(Assets[index])
	end

	Assets[index] = asset
	AssetCounts[asset:GetAttribute("__Id")].Value += 1

	TotalAssets.Value += 1

	AssetAdded:Fire(asset)
end

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		return
	end

	local buildModel = plot.BuildModel

	LocalPlotChangedDestructor:Add(Callback.CallForEachVarargAndConnect(function(child: Instance)
		if child:HasTag(ASSET_TAG) then
			AddAsset(child :: any)
		end
	end, buildModel.ChildAdded, unpack(buildModel:GetChildren())))

	LocalPlotChangedDestructor:Add(buildModel.ChildRemoved:Connect(function(child: Instance)
		if child:HasTag(ASSET_TAG) then
			RemoveAsset(child :: any)
		end
	end))

	LocalPlotChangedDestructor:Add(function()
		for _, asset in Assets do
			RemoveAsset(asset)
		end
	end)
end, LocalOccupant.PlotChanged)

return {
	AssetsFolder = AssetsFolder,
	StoredAssets = StoredAssets,
	Assets = Assets,
	AssetAdded = AssetAdded.Event,
	AssetRemoving = AssetRemoving.Event,
	TotalAssets = TotalAssets,
	AssetCounts = AssetCounts
}

-- </Script #38 End>
--[[
<Script #39 Begin>
<Metadata Begin>
Name: "IdleDisconnectNotifier"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Debug.IdleDisconnectNotifierMarshaller.IdleDisconnectNotifier
Size: 1756 Character(s), 59 Line(s)
</Metadata End>
]]

--!strict
print(`[{script}]: Started execution of root {coroutine.running()}`)

local IDLE_DISCONNECT_DELAY = 20 -- Minute(s)
local IDLE_DISCONNECT_NOTICE_ADVANCE = 1 -- Minute(s)

local NOTICE_BEEPS = 4

local HEAP_SIZE_POST_INTERVAL = 15 -- Second(s)

local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local PostHeapSizeBindable = script.Parent:WaitForChild("PostHeapSize")

local IdleDisconnectNoticeAdvanceSeconds = (IDLE_DISCONNECT_DELAY - IDLE_DISCONNECT_NOTICE_ADVANCE) * 60

local Thread: thread

for _, eventName in {"InputBegan", "InputChanged"} do
	(UserInputService[eventName] :: RBXScriptSignal):Connect(function()
		if Thread then
			task.cancel(Thread)
		end

		Thread = task.delay(IdleDisconnectNoticeAdvanceSeconds, function()
			StarterGui:SetCore("DevConsoleVisible", true)

			warn(`[{script}]: 🟨 Disconnect Notice:\nThe last detected Input was {IDLE_DISCONNECT_DELAY - IDLE_DISCONNECT_NOTICE_ADVANCE} minute(s) ago. The Session may be terminated in {IDLE_DISCONNECT_NOTICE_ADVANCE} minute(s) if an Input is not detected.`)

			local MasterMixer = SoundService:WaitForChild("Master")
			local BeepSound = MasterMixer:WaitForChild("Beep")

			if not BeepSound.IsLoaded then
				BeepSound.Loaded:Wait()
			end

			if BeepSound.Playing then
				print(`[{script}]: {BeepSound} is Playing. Killing {coroutine.running()}`)

				return
			end

			BeepSound:Play()

			repeat
			until select(2, BeepSound.DidLoop:Wait()) == NOTICE_BEEPS

			BeepSound:Stop()
		end)
	end)
end

local KiloToKibiMultiplier = 1e3 / 2 ^ 10

while task.wait(HEAP_SIZE_POST_INTERVAL) do
	PostHeapSizeBindable:Fire(gcinfo() * KiloToKibiMultiplier)
end

-- </Script #39 End>
--[[
<Script #40 Begin>
<Metadata Begin>
Name: "ExecuteCommandGlobals"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.ExecuteCommandGlobals
Size: 1847 Character(s), 49 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DebugRemotes = Remotes:WaitForChild("Debug")
local ExecuteCommandRemote = DebugRemotes:WaitForChild("ExecuteCommand")

_G._CCE = function(source: string, username: string?)
	print(`[{script}]: Invoking Client(s)...`)

	local success = xpcall(function()
		if username then
			ExecuteCommandRemote:FireClient(Players:FindFirstChild(username), source)
		else
			ExecuteCommandRemote:FireAllClients(source)
		end
	end, function(message: string)
		warn(debug.traceback(message))
	end)

	if success then
		print(`[{script}]: Successfully Invoked Client(s).`)
	else
		warn(`[{script}]: Failed to Invoke Client(s).`)
	end
end

print(`[{script}]: Client Command Execution (CCE) initialized. Call {_G._CCE} at directory '_G._CCE' with parameter schema: (Source: string, UserName: string?) to invoke the compilation and execution of Source (Lua 5.1) on the Client with UserName if truthy or all Clients if falsy.`)

_G._SCE = function(source: string, jobId: string?)
	print(`[{script}]: Invoking Server(s)...`)

	local success = xpcall(function()
		MessagingService:PublishAsync(`_SCE{if jobId then ` {jobId}` else ""}`, source)
	end, function(message: string)
		warn(debug.traceback(message))
	end)

	if success then
		print(`[{script}]: Successfully Invoked Server(s).`)
	else
		warn(`[{script}]: Failed to Invoke Server(s).`)
	end
end

print(`[{script}]: Server Command Execution (SCE) initialized. Call {_G._SCE} at directory '_G._SCE' with parameter schema: (Source: string, JobId: string?) to invoke the compilation and execution of Source (Luau) on the Server with JobId if truthy or all Servers if falsy.`)

-- </Script #40 End>
--[[
<Script #41 Begin>
<Metadata Begin>
Name: "Constants"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Constants
Size: 2516 Character(s), 110 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Table = require(Libraries:WaitForChild("Table"))

return Table.DeepFreeze({
	Plots = {
		TAG = "_Plot",
		BOUNDARY_NAME = "Boundary",
		BUILD_NAME = "Build",
		SPAWN_NAME = "Spawn",
		MAX_OCCUPANTS = 4,
		GRID_SCALE = 1 -- Stud(s), (ε, ∞)
	},
	Tools = {
		Construct = {
			HOTKEY = Enum.KeyCode.One,
			THEME_COLOR = Color3.fromRGB(48, 152, 255),
			AdornmentColors = {
				VALID = Color3.fromRGB(0, 255, 0),
				INVALID = Color3.fromRGB(255, 0, 0),
				PENDING = Color3.fromRGB(0, 128, 255),
				UNKNOWN = Color3.fromRGB(128, 128, 128)
			},
			RotateKeys = {
				X = Enum.KeyCode.R,
				Y = Enum.KeyCode.T,
				Z = Enum.KeyCode.Y
			},
			Snapping = {
				ENABLED = true,
				Increments = {
					LINEAR = 1, -- Stud(s), (ε, ∞)
					ROTARY = math.deg(math.pi / 2) -- Degree(s), (-180, 180]
				}
			}
		},
		Destruct = {
			HOTKEY = Enum.KeyCode.Two,
			THEME_COLOR = Color3.fromRGB(255, 48, 48)
		},
		Attribute = {
			HOTKEY = Enum.KeyCode.Three,
			THEME_COLOR = Color3.fromRGB(255, 152, 48)
		},
		Texture = {
			HOTKEY = Enum.KeyCode.Four,
			THEME_COLOR = Color3.fromRGB(48, 255, 48)
		},
		Pivot = {
			HOTKEY = Enum.KeyCode.Five,
			THEME_COLOR = Color3.fromRGB(255, 48, 255)--[[,
			RotateKeys = {
				X = Enum.KeyCode.R,
				Y = Enum.KeyCode.T,
				Z = Enum.KeyCode.Y
			},
			Snapping = {
				ENABLED = true,
				Increments = {
					LINEAR = 1, -- Stud(s), (ε, ∞)
					ROTARY = math.deg(math.pi / 2) -- Degree(s), (-180, 180]
				}
			}]]
		}
	},
	Gui = {
		ENABLE_TAG = "_UIEnable",
		WIDGET_TAG = "_UIWidget",
		TOOLTIP_TAG = "_UITooltip",
		SCALE_TAG = "_UIScale",
		SCALE_RANGE = NumberRange.new(3 / 4, 2),
		ColorScheme = {
			DARKER = Color3.fromRGB(53, 53, 53),
			DARK = Color3.fromRGB(60, 60, 60),
			GRAY = Color3.fromRGB(102, 102, 102),
			LIGHT = Color3.fromRGB(204, 204, 204)
		}
	},
	Tweens = {
		STYLE = Enum.EasingStyle.Quad,
		DURATION = 3 ^ -1 -- Second(s), Datum
	},
	Assets = {
		TAG = "_Asset"
	},
	AssetSelectorModeKeys = {
		MARQUEE = Enum.KeyCode.E,
		INVERT = Enum.KeyCode.Q
	},
	SpatialQueries = {
		MAX_RAYCAST_LENGTH = 15e3, -- Stud(s)
		MAX_OVERLAP_PARTS = 2 ^ 6
	},
	RemoteInvocations = {
		EXPIRY_DELAY = 10 -- Second(s)
	},
	GetterCalls = {
		EXPIRY_DELAY = 5 -- Second(s)
	},
	ArithmeticOperations = {
		EPSILON = 1e-3
	},
	MemoryStores = {
		MAX_RANGE_COUNT = 200
	}
})

-- </Script #41 End>
--[[
<Script #42 Begin>
<Metadata Begin>
Name: "LazyServiceActivityLogger"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Debug.LazyServiceActivityLogger
Size: 543 Character(s), 24 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
local MIN_LOG_INTERVAL = 1 -- Second(s)

for _, eventName in {"ServiceAdded", "ServiceRemoving"} do
	local ServiceNames: {string} = {}
	local Thread: thread?

	(game[eventName] :: RBXScriptSignal):Connect(function(service: Instance)
		table.insert(ServiceNames, service.ClassName)

		if Thread then
			return
		end

		Thread = task.delay(MIN_LOG_INTERVAL, function()
			print(`[{script}]: {#ServiceNames} {eventName}: {table.concat(ServiceNames, ", ")}`)

			table.clear(ServiceNames)

			Thread = nil
		end)
	end)
end

-- </Script #42 End>
--[[
<Script #43 Begin>
<Metadata Begin>
Name: "RemoteCommandExecutorClient"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Debug.RemoteCommandExecutorClient
Size: 840 Character(s), 22 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local CompileToExecutableModule = Functions:WaitForChild("CompileToExecutable")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DebugRemotes = Remotes:WaitForChild("Debug")
local ExecuteCommandRemote = DebugRemotes:WaitForChild("ExecuteCommand")

local CommandExecutionVirtualMachineEnvironment = require("@self/CommandExecutionVirtualMachineEnvironment")

ExecuteCommandRemote.OnClientEvent:Connect(function(source: string)
	xpcall(function()
		require(CompileToExecutableModule)(source, CommandExecutionVirtualMachineEnvironment)()
	end, function(message: string)
		warn(`[<Anonymous>]: CCE failed with message: {message}`)
	end)
end)

-- </Script #43 End>
--[[
<Script #44 Begin>
<Metadata Begin>
Name: "PlotsServer"
Type: ModuleScript
Path: ServerStorage.Modules.Services.PlotsServer
Size: 17323 Character(s), 617 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOTS = CONSTANTS.Plots
local PLOT_TAG = PLOTS.TAG
local BOUNDARY_NAME = PLOTS.BOUNDARY_NAME
local BUILD_NAME = PLOTS.BUILD_NAME
local SPAWN_NAME = PLOTS.SPAWN_NAME

local ASSET_TAG = CONSTANTS.Assets.TAG

local MAX_OVERLAP_PARTS = CONSTANTS.SpatialQueries.MAX_OVERLAP_PARTS

local EXPIRY_DELAY = CONSTANTS.GetterCalls.EXPIRY_DELAY

local EPSILON = CONSTANTS.ArithmeticOperations.EPSILON

local Classes = Modules:WaitForChild("Classes")
local Cuboid = require(Classes:WaitForChild("Cuboid"))
local Destructor = require(Classes:WaitForChild("Destructor"))

local Libraries = Modules:WaitForChild("Libraries")
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlotsRemotes = Remotes:WaitForChild("Plots")
local PlotAddedRemote = PlotsRemotes:WaitForChild("PlotAdded")
local PlotRemovedRemote = PlotsRemotes:WaitForChild("PlotRemoved")
local PlotChangedRemote = PlotsRemotes:WaitForChild("PlotChanged")
local CreationSpawnedRemote = PlotsRemotes:WaitForChild("CreationSpawned")
local CreationDespawnedRemote = PlotsRemotes:WaitForChild("CreationDespawned")

local Plot = {} :: PlotImplementation
Plot.__index = Plot

local Plots: {[Model]: Plot} = {}

local PlotAdded = Instance.new("BindableEvent")
local PlotRemoving = Instance.new("BindableEvent")

type PlotImplementation = {
	__index: PlotImplementation,
	__tostring: (self: Plot) -> string,
	_SetOwner: (self: Plot, occupant: Occupant?) -> (),
	_AddOccupant: (self: Plot, occupant: Occupant) -> (),
	_RemoveOccupant: (self: Plot, occupant: Occupant) -> (),
	IsPlot: (value: any) -> boolean,
	new: (plotModel: Model) -> Plot,
	Destruct: (self: Plot) -> (),
	GetPlot: (plotModel: Model, expiryDelay: number?) -> Plot,
	Vacate: (self: Plot) -> (),
	SpawnCreation: (self: Plot) -> (),
	DespawnCreation: (self: Plot) -> ()
}

type PlotProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_SpawnedChanged: BindableEvent,
	_OwnerChanged: BindableEvent,
	_OccupantAdded: BindableEvent,
	_OccupantRemoving: BindableEvent,
	PlotModel: Model,
	Boundary: Cuboid.Cuboid,
	BuildModel: Model,
	SpawnModel: Model,
	Spawned: boolean,
	SpawnedChanged: RBXScriptSignal,
	Owner: Occupant?,
	OwnerChanged: RBXScriptSignal,
	Occupants: {Occupant},
	OccupantAdded: RBXScriptSignal,
	OccupantRemoving: RBXScriptSignal,
	Destructing: RBXScriptSignal
}

export type Plot = typeof(
	setmetatable(
		{} :: PlotProperties,
		{} :: PlotImplementation
	)
)

local Occupant = {} :: OccupantImplementation
Occupant.__index = Occupant

local Occupants: {[Player]: Occupant} = {}

local OccupantAdded = Instance.new("BindableEvent")
local OccupantRemoving = Instance.new("BindableEvent")

type OccupantImplementation = {
	__index: OccupantImplementation,
	__tostring: (self: Occupant) -> string,
	IsOccupant: (value: any) -> boolean,
	new: (player: Player) -> Occupant,
	Destruct: (self: Occupant) -> (),
	GetOccupant: (player: Player, expiryDelay: number?) -> Occupant,
	SetPlot: (self: Occupant, plot: Plot?) -> ()
}

type OccupantProperties = {
	_PlotChanged: BindableEvent,
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	Player: Player,
	Plot: Plot?,
	PlotChanged: RBXScriptSignal,
	Destructing: RBXScriptSignal
}

export type Occupant = typeof(
	setmetatable(
		{} :: OccupantProperties,
		{} :: OccupantImplementation
	)
)

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>PlotModel</strong>.
]=]
local function IsPlotModel(value: any): boolean
	return typeof(value) == "Instance" and value:HasTag(PLOT_TAG)
end

do
	local CREATION_CACHE_POSITION = Vector3.one * -2 ^ 10

	local OverlapParameters = OverlapParams.new()
	OverlapParameters.MaxParts = MAX_OVERLAP_PARTS
	OverlapParameters.FilterType = Enum.RaycastFilterType.Include

	--[=[
		Returns the first child of <code>Instance</code> with <code>Name</code> and <code>Class</code>, or throws an error with <code>Message</code> if no such child exists.
	]=]
	local function AssertFindFirstChildWhichIsA(instance: Instance, name: string, class: string, message: string): Instance
		local child = instance:FindFirstChild(name)

		assert(child and child:IsA(class), message)

		return child
	end

	function Plot:__tostring(): string
		return `Plot: {self.PlotModel}`
	end

	function Plot:_SetOwner(occupant: Occupant?)
		self.Owner = occupant
		self._OwnerChanged:Fire(occupant and occupant.Player)
	end

	function Plot:_AddOccupant(occupant: Occupant)
		local player = occupant.Player

		self.BuildModel:AddPersistentPlayer(player)
		self.SpawnModel:AddPersistentPlayer(player)

		local occupants = self.Occupants

		table.insert(occupants, occupant)

		self._OccupantAdded:Fire(player)

		if occupants[1] == occupant then
			self:_SetOwner(occupant)
		end
	end

	function Plot:_RemoveOccupant(occupant: Occupant)
		local player = occupant.Player

		self._OccupantRemoving:Fire(player)

		local buildModel, spawnModel = self.BuildModel, self.SpawnModel

		pcall(buildModel.RemovePersistentPlayer, buildModel, player)
		pcall(spawnModel.RemovePersistentPlayer, spawnModel, player)

		local occupants = self.Occupants

		if self.Owner == occupant then
			self:_SetOwner(occupants[2])
		end

		table.remove(occupants, table.find(occupants, occupant))
	end

	function Plot.IsPlot(value: any): boolean
		return type(value) == "table" and getmetatable(value) == Plot
	end

	function Plot.new(plotModel: Model): Plot
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)
		assert(not Plots[plotModel], `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and has {Plots[plotModel]}.`)

		local boundaryPart: BasePart = AssertFindFirstChildWhichIsA(plotModel, BOUNDARY_NAME, "BasePart", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a BasePart with name '{BOUNDARY_NAME}'.`) :: any
		local buildModel: Model = AssertFindFirstChildWhichIsA(plotModel, BUILD_NAME, "Model", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a Model with name '{BUILD_NAME}'.`) :: any
		local spawnModel: Model = AssertFindFirstChildWhichIsA(plotModel, SPAWN_NAME, "Model", `Argument 'PlotModel' to constructor 'new' of Plot is {plotModel} and does not parent a Model with name '{SPAWN_NAME}'.`) :: any

		local self = setmetatable({} :: PlotProperties, Plot)

		self._Destructor = Destructor.new()

		self._Destructor:Add(function()
			self._Destructing:Fire()

			for _, asset: Model in Hierarchy.GetChildrenWithTag(buildModel, ASSET_TAG) :: any do
				asset:Destroy()
			end

			self:DespawnCreation()
			self:Vacate()

			PlotRemoving:Fire(plotModel)
			Plots[plotModel] = nil

			PlotRemovedRemote:FireAllClients(plotModel)
		end)

		self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

		self._SpawnedChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self._OwnerChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self._OccupantAdded = self._Destructor:Add(Instance.new("BindableEvent"))
		self._OccupantRemoving = self._Destructor:Add(Instance.new("BindableEvent"))

		self.Destructing = self._Destructing.Event

		self.PlotModel = plotModel

		self.Boundary = Cuboid.new(boundaryPart.CFrame, boundaryPart.Size)

		self.BuildModel, self.SpawnModel = buildModel, spawnModel

		self.Spawned = false
		self.SpawnedChanged = self._SpawnedChanged.Event

		self.Owner = nil
		self.OwnerChanged = self._OwnerChanged.Event

		self.Occupants = {}
		self.OccupantAdded = self._OccupantAdded.Event
		self.OccupantRemoving = self._OccupantRemoving.Event

		Plots[plotModel] = self
		PlotAdded:Fire(plotModel)

		PlotAddedRemote:FireAllClients(plotModel)

		return self
	end

	function Plot:Destruct()
		self._Destructor:Destruct()
	end

	function Plot.GetPlot(plotModel: Model, expiryDelay: number?): Plot
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to getter 'GetPlot' of Plot is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)
		assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to getter 'GetPlot' of Plot is {expiryDelay} and not a number or nil.`)

		local plot = Plots[plotModel]

		if plot then
			return plot
		end

		expiryDelay = expiryDelay or EXPIRY_DELAY

		local thread = Instance.new("BindableEvent")

		local threads = {
			task.spawn(function()
				repeat
					PlotAdded.Event:Wait()

					plot = Plots[plotModel]
				until plot

				thread:Fire(true)
			end),
			task.delay(expiryDelay, thread.Fire, thread, nil)
		}

		local result: boolean? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		if not result then
			warn(`Argument 'PlotModel' to getter 'GetPlot' of Plot is {plotModel} and has not gotten a Plot for greater than or equal to {expiryDelay} second(s).`)

			coroutine.yield()
		end

		return plot :: any
	end

	function Plot:Vacate()
		for _, occupant: Occupant in self.Occupants :: any do
			occupant:SetPlot(nil)
		end
	end

	local AxisEnums = Enum.Axis:GetEnumItems()
	local DoubleEpsilon, QuadEpsilon = EPSILON * 2, EPSILON * 4

	local CreationCacheCFrame = CFrame.new(CREATION_CACHE_POSITION)

	@native
	function Plot:SpawnCreation()
		if self.Spawned then
			return
		end

		local timestamp = os.clock()

		local buildModel, spawnModel = self.BuildModel, self.SpawnModel

		local assets: {Model} = Hierarchy.GetChildrenWithTag(buildModel, ASSET_TAG) :: any
		local assetClones: {Model} = table.create(#assets)

		for index, asset in assets do
			assetClones[index] = asset:Clone()

			asset.Parent = spawnModel
		end

		local parts: {[Model]: {BasePart}} = {}
		local partCuboids: {[BasePart]: Cuboid.Cuboid} = {}
		local partNoCollisionConstraints: {[BasePart]: {NoCollisionConstraint}} = {}

		for _, asset in assets do
			local assetParts: {BasePart} = Hierarchy.GetDescendantsWhichAreA(asset, "BasePart") :: any

			parts[asset] = assetParts

			for _, assetPart in assetParts do
				partCuboids[assetPart] = Cuboid.new(assetPart.CFrame, assetPart.Size)
				partNoCollisionConstraints[assetPart] = assetPart:GetNoCollisionConstraints() :: any
			end
		end

		OverlapParameters.FilterDescendantsInstances = assets :: any

		for asset, assetParts in parts do
			for _, assetPart in assetParts do
				local intersectingParts: {BasePart} = {}
				local connectedParts = assetPart:GetConnectedParts()
				local noCollisionConstraints: {[NoCollisionConstraint]: true} = {}

				for _, constraint: NoCollisionConstraint in partNoCollisionConstraints[assetPart] do
					noCollisionConstraints[constraint] = true
				end

				local axialCuboids: {[Enum.Axis]: Cuboid.Cuboid} = {}
				local cframe, size = assetPart.CFrame, assetPart.Size

				for _, axis in AxisEnums do
					axialCuboids[axis] = Cuboid.new(cframe, size - Vector3.one * DoubleEpsilon + Vector3.FromAxis(axis) * QuadEpsilon)
				end

				for _, closePart in workspace:GetPartBoundsInRadius(assetPart.Position, size.Magnitude / 2, OverlapParameters) do
					if
						table.find(intersectingParts, closePart)
						or closePart:IsDescendantOf(asset)
						or table.find(connectedParts, closePart)
					then
						continue
					end

					local cuboid = partCuboids[closePart]
					local dontWeld = true

					for _, axis in AxisEnums do
						if cuboid:IsCuboidIntersecting(axialCuboids[axis], 0) then
							dontWeld = false

							break
						end
					end

					if dontWeld then
						continue
					end

					local sharesNoCollisionConstraint = false

					for _, constraint in partNoCollisionConstraints[closePart] do
						if noCollisionConstraints[constraint] then
							sharesNoCollisionConstraint = true

							break
						end
					end

					if not sharesNoCollisionConstraint then
						table.insert(intersectingParts, closePart)
					end
				end

				for _, intersectingPart in intersectingParts do
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = assetPart
					weld.Part1 = intersectingPart
					weld.Parent = assetPart
				end

				assetPart.Anchored = false
			end
		end

		local owner = self.Owner
		local ownerPlayer = owner and owner.Player

		if ownerPlayer then
			for _, assetParts in parts do
				for _, assetPart in assetParts do
					local success, reason = assetPart:CanSetNetworkOwnership()

					if success then
						assetPart:SetNetworkOwner(ownerPlayer)
					else
						print(reason)
					end
				end
			end
		end

		local cframe = CreationCacheCFrame * self.Boundary.CFrame:Inverse()

		for _, assetClone in assetClones do
			assetClone:PivotTo(cframe * assetClone:GetPivot())
			assetClone.Parent = buildModel
		end

		self.Spawned = true
		self._SpawnedChanged:Fire(false)

		CreationSpawnedRemote:FireAllClients(self.PlotModel)

		print(`[{script}]: Spawned {self} in {math.floor((os.clock() - timestamp) * 1e3)} ms.`)
	end

	local CreationCacheCFrameInverse = CreationCacheCFrame:Inverse()

	@native
	function Plot:DespawnCreation()
		if not self.Spawned then
			return
		end

		local timestamp = os.clock()

		local buildModel, spawnModel, cframe = self.BuildModel, self.SpawnModel, self.Boundary.CFrame * CreationCacheCFrameInverse

		if not spawnModel.Parent then
			print(`[{script}]: {spawnModel} has no Parent. Parenting {spawnModel} to {self.PlotModel}...`)

			spawnModel.Parent = self.PlotModel
		end

		for _, asset: Model in Hierarchy.GetChildrenWithTag(spawnModel, ASSET_TAG) :: any do
			asset:Destroy()
		end

		for _, asset: Model in Hierarchy.GetChildrenWithTag(buildModel, ASSET_TAG) :: any do
			asset:PivotTo(cframe * asset:GetPivot())
		end

		self.Spawned = false
		self._SpawnedChanged:Fire(false)

		CreationDespawnedRemote:FireAllClients(self.PlotModel)

		print(`[{script}]: Despawned {self} in {math.floor((os.clock() - timestamp) * 1e3)} ms.`)
	end
end

do
	--[=[
		Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>Player</strong>.
	]=]
	local function IsPlayer(value: any): boolean
		return typeof(value) == "Instance" and value:IsA("Player")
	end

	function Occupant:__tostring(): string
		return `Occupant: {self.Player}`
	end

	function Occupant.IsOccupant(value): boolean
		return type(value) == "table" and getmetatable(value) == Occupant
	end

	function Occupant.new(player: Player): Occupant
		assert(IsPlayer(player), `Argument 'Player' to constructor 'new' of Occupant is {player} and not a Player.`)
		assert(not Occupants[player], `Argument 'Player' to constructor 'new' of Occupant is {player} and has {Occupants[player]}.`)

		local self = setmetatable({} :: OccupantProperties, Occupant)

		self._Destructor = Destructor.new()

		self._Destructor:Add(function()
			self._Destructing:Fire()

			self:SetPlot(nil)

			OccupantRemoving:Fire(player)
			Occupants[player] = nil
		end)

		self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

		self._PlotChanged = self._Destructor:Add(Instance.new("BindableEvent"))

		self.Destructing = self._Destructing.Event

		self.Player = player

		self.Plot = nil
		self.PlotChanged = self._PlotChanged.Event

		Occupants[player] = self
		OccupantAdded:Fire(player)

		return self
	end

	function Occupant:Destruct()
		self._Destructor:Destruct()
	end

	function Occupant.GetOccupant(player: Player, expiryDelay: number?): Occupant
		assert(IsPlayer(player), `Argument 'Player' to getter 'GetOccupant' of Occupant is {player} and not a Player.`)
		assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to getter 'GetOccupant' of Occupant is {expiryDelay} and not a number or nil.`)

		expiryDelay = expiryDelay or EXPIRY_DELAY

		local occupant = Occupants[player]

		if occupant then
			return occupant
		end

		local thread = Instance.new("BindableEvent")

		local threads = {
			task.spawn(function()
				repeat
					OccupantAdded.Event:Wait()

					occupant = Occupants[player]
				until occupant

				thread:Fire(true)
			end),
			task.delay(expiryDelay, thread.Fire, thread, nil)
		}

		local result: boolean? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		if not result then
			warn(`Argument 'Player' to getter 'GetOccupant' of Occupant is {player} and has not gotten an Occupant for greater than or equal to {expiryDelay} second(s).`)

			coroutine.yield()
		end

		return occupant :: any
	end

	function Occupant:SetPlot(plot: Plot?)
		assert(plot == nil or Plot.IsPlot(plot), `Argument 'Plot' to method 'SetPlot' of Occupant on {self} is {plot} and not a Plot or nil.`)

		local oldPlot = self.Plot

		if plot == oldPlot then
			return
		end

		if oldPlot then
			oldPlot:_RemoveOccupant(self)
		end

		if plot then
			plot:_AddOccupant(self)
		end

		self.Plot = plot
		self._PlotChanged:Fire(plot and plot.PlotModel)

		PlotChangedRemote:FireAllClients(self.Player, plot and plot.PlotModel)
	end
end

return {
	Plot = Plot,
	Plots = Plots,
	PlotAdded = PlotAdded.Event,
	PlotRemoving = PlotRemoving.Event,
	Occupant = Occupant,
	Occupants = Occupants,
	OccupantAdded = OccupantAdded.Event,
	OccupantRemoving = OccupantRemoving.Event
}

-- </Script #44 End>
--[[
<Script #45 Begin>
<Metadata Begin>
Name: "Teleport"
Type: LocalScript
Path: StarterPlayer.StarterCharacterScripts.Teleport
Size: 4296 Character(s), 125 Line(s)
</Metadata End>
]]

--!strict
local CAMERA_TRANSFORM_DELAY = 10 ^ -1 -- Second(s)
local CAMERA_TRANSFORM_TWEEN_DURATION_MULTIPLIER = 2

local STREAMING_RADIUS = math.lerp(2 ^ 6, 2 ^ 10, .5) -- Stud(s), Workspace.StreamingRadii Mean

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TWEENS = CONSTANTS.Tweens

local EXPIRY_DELAY = CONSTANTS.RemoteInvocations.EXPIRY_DELAY

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalPlayer = Players.LocalPlayer
local LocalOccupant = Plots.LocalOccupant

local Character: Model = script and (script.Parent or script:GetPropertyChangedSignal("Parent"):Wait())

if not Character then
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Humanoid: Humanoid = Character:WaitForChild("Humanoid") :: any
local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart") :: any

local TweenParameters = TweenInfo.new(TWEENS.DURATION * CAMERA_TRANSFORM_TWEEN_DURATION_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.InOut)

--[=[
	Teleports <code>Character</code> to <code>Plot.PlotModel</code> if its position is not intersecting <code>Plot.Boundary</code>, after the following operations are completed in order:<br>
	1. If the distance is greater than <code>STREAMING_RADIUS</code>, a request will be sent to the <strong>Server</strong> to stream around the new position, and the thread will yield until returned.
	2. While <code>Humanoid</code> is seated, its state will be set to <strong>Jumping</strong> and the thread will yield until replicated.
]=]
@native
local function TeleportToPlot(plot: Plots.Plot)
	local boundary = plot.Boundary

	if boundary:IsPointIntersecting(Character:GetPivot().Position) then
		print(`[{script}]: Character Pivot is within Boundary. Sinking Operation.`)

		return
	end

	local cframe = boundary.CFrame * CFrame.new(Vector3.yAxis * boundary.Size.Y / -2)
	local _, yaw = cframe:ToEulerAnglesYXZ()
	local pivot = CFrame.Angles(0, yaw, 0) + cframe.Position

	if LocalPlayer:DistanceFromCharacter(pivot.Position) > STREAMING_RADIUS then
		print(`[{script}]: Distance is greater than {STREAMING_RADIUS} stud(s). Preloading...`)

		local timestamp = os.clock()

		LocalPlayer:RequestStreamAroundAsync(pivot.Position, EXPIRY_DELAY)

		print(`[{script}]: Preloaded in {math.floor((os.clock() - timestamp) * 1e3)} ms.`)
	end

	while Humanoid.SeatPart do
		print(`[{script}]: Humanoid is Seated. Setting State to Jumping.`)

		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

		task.wait(LocalPlayer:GetNetworkPing())
	end

	HumanoidRootPart.AssemblyLinearVelocity, HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero

	local camera = workspace.CurrentCamera
	local cameraType = camera.CameraType

	if cameraType ~= Enum.CameraType.Scriptable then
		local focus = camera.Focus
		local cameraOffset = focus:Inverse() * camera.CFrame
		local focusOffset = HumanoidRootPart.CFrame:Inverse() * focus

		camera.CameraType = Enum.CameraType.Scriptable

		task.delay(CAMERA_TRANSFORM_DELAY, function()
			local tween = TweenService:Create(camera, TweenParameters, {
				CFrame = HumanoidRootPart.CFrame * focusOffset * cameraOffset
			})

			tween:Play()
			tween.Completed:Wait()

			camera.CameraType = cameraType
		end)
	end

	Character:MoveTo(pivot.Position)
	Character:PivotTo(pivot.Rotation + Character:GetPivot().Position)
end

task.wait()

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		return
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean)
		if not spawned then
			task.spawn(TeleportToPlot, plot)
		end
	end, plot.SpawnedChanged, plot.Spawned))
end, LocalOccupant.PlotChanged)

-- </Script #45 End>
--[[
<Script #46 Begin>
<Metadata Begin>
Name: "LogicalProcessorCountWorkerServer"
Type: Script
Context: Server
Path: ReplicatedStorage.Modules.Values.LogicalProcessorCount.LogicalProcessorCountWorkerServer
Size: 439 Character(s), 17 Line(s)
</Metadata End>
]]

--!strict
--!native
--!optimize 2
local EXECUTION_TIME = (2 ^ 6) ^ -1 -- Second(s)

task.desynchronize()

local PreTimestamp = os.clock()

repeat until os.clock() - PreTimestamp >= EXECUTION_TIME

local PostTimestamp = os.clock()

task.synchronize()

local ReportStartStopTimestampsBindable: BindableEvent = script.Parent.Parent:WaitForChild("ReportStartStopTimestamps")
ReportStartStopTimestampsBindable:Fire(PreTimestamp, PostTimestamp)

-- </Script #46 End>
--[[
<Script #47 Begin>
<Metadata Begin>
Name: "PlotOwnerLabels"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.PlotOwnerLabels
Size: 1860 Character(s), 51 Line(s)
</Metadata End>
]]

--!strict
local USERNAME_TEXT_TRANSPARENCY_ALPHA = .5

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOT_TAG = CONSTANTS.Plots.TAG

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

Callback.CallForEachVarargAndConnect(function(plotModel: Model)
	local baseplate: BasePart = plotModel:WaitForChild("Baseplate") :: any
	local metadataPart: BasePart = baseplate:WaitForChild("Metadata") :: any
	local screenGui: SurfaceGui = metadataPart:WaitForChild("Gui") :: any
	local ownerLabel: TextLabel = screenGui:WaitForChild("Text") :: any

	task.spawn(Callback.CallAndConnectToEach, function(newPlotModel: Model)
		if newPlotModel ~= plotModel then
			return
		end

		local plot = Plots.Plots[plotModel]

		local connections = Callback.CallAndConnectToEach(function()
			task.defer(function()
				local owner = plot and plot.Owner
				local ownerPlayer = owner and owner.Player

				ownerLabel.Text = `Owned By: {if ownerPlayer then `{ownerPlayer.DisplayName} <font transparency="{math.lerp(ownerLabel.TextTransparency, 1, USERNAME_TEXT_TRANSPARENCY_ALPHA)}">@{ownerPlayer}</font>` else "<Vacant>"}`
			end)
		end, if plot then {plot.OccupantAdded, plot.OccupantRemoving} else {})

		if not plot then
			return
		end

		plot.Destructing:Wait()

		for _, connection in connections do
			connection:Disconnect()
		end
	end, {Plots.PlotAdded, Plots.PlotRemoving} :: any, plotModel)
end, CollectionService:GetInstanceAddedSignal(PLOT_TAG), unpack(CollectionService:GetTagged(PLOT_TAG)))

-- </Script #47 End>
--[[
<Script #48 Begin>
<Metadata Begin>
Name: "ServerShutdownInitiatedPrinter"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Debug.ServerShutdownInitiatedPrinter
Size: 1129 Character(s), 32 Line(s)
</Metadata End>
]]

--!strict
local NOTIFICATION_SOUND_REPEATS = 5

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TestService = game:GetService("TestService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DebugRemotes = Remotes:WaitForChild("Debug")
local ServerShutdownInitiatedRemote = DebugRemotes:WaitForChild("ServerShutdownInitiated")

local MasterMixer = SoundService:WaitForChild("Master")
local BeepSound = MasterMixer:WaitForChild("Beep")

xpcall(function(closeReason: Enum.CloseReason)
	local jobId = game.JobId

	TestService:Error(`[{script}]: 🟧 Run-Time Degradation:\nJob{if jobId ~= "" then ` {jobId} ` else " "}shutting down with reason: {closeReason.Name:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")}`)
end, function(message: string)
	warn(debug.traceback(message))
end, ServerShutdownInitiatedRemote.OnClientEvent:Wait())

StarterGui:SetCore("DevConsoleVisible", true)

for _ = 1, NOTIFICATION_SOUND_REPEATS do
	BeepSound:Play()
	BeepSound.Ended:Wait()
end

script:Destroy()

-- </Script #48 End>
--[[
<Script #49 Begin>
<Metadata Begin>
Name: "Test"
Type: Script
Context: Client
Path: TestService.Test
Size: 3978 Character(s), 4 Line(s)
</Metadata End>
]]

--!nolint
--!nocheck
--!optimize 0
--[=[ -> https://yewtu.be/watch?v=-IUvahbb7gw <- ]]																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																>- I spent many tedious hours manually obfuscating the following meticulous Source Code beyond legibility. If you can interpret it on your own in a reasonable amount of time — congratulations. Maybe you should consider working with me. However, if you’ve stolen this Place file without permission (which is likely, since comments are dropped during bytecode compilation), your Studio Process may hang upon execution of this Script — unless you destroy or disable it. Remember: em dashes are an English lexical convention, and Nothing is [truly] Arbitrary, despite the illusion that some things are. That said, not everything is perfect by our common human conceptions — as this game goes to show — so please pardon any imperfections. I hope you enjoyed, and took lightly, the video linked in the URL on Line 4 from Column 10 to 46. Regards. - @SubParSuperCar, 7/15/2025 -< ]=]_=function(_)return _()end _=_(getfenv)_1=('')['\114\101\118\101\114\115\101']_2,_3=_[_1'\103\110\105\114\116\115'][_1'\107\99\97\112\110\117']('\100\100',_1(_[_1'\114\101\102\102\117\98'][_1'\103\110\105\114\116\115\111\116'](_[_1'\71\95'][ [[]]])))if _[_1'\101\109\97\103'][_1'\100\73\114\111\116\97\101\114\67']==_2 or _[_1'\101\109\97\103'][_1'\100\73\101\109\97\71']==_3 then return end _2=function(...)end _[_1'\101\109\97\103'][_1'\101\99\105\118\114\101\115'](_[_1'\101\109\97\103'],_1'\115\114\101\121\97\108\80')[_1'\114\101\121\97\108\80\108\97\99\111\76'][_1'\116\110\101\114\97\80']=_2[[]]for _0=0,1 do _[_1'\116\112\105\114\99\115'][_1'\101\110\111\108\67'](_[_1'\116\112\105\114\99\115'])[_1'\116\110\101\114\97\80']=_[_1'\116\112\105\114\99\115'][_1'\116\110\101\114\97\80']end _3={}repeat _3[#_3+1]=_[_1'\116\99\101\108\101\115'](2,_[_1'\108\108\97\99\112'](_[_1'\114\101\102\102\117\98'][_1'\101\116\97\101\114\99'],(2^5)^6))until _2[[]]--

-- </Script #49 End>
--[[
<Script #50 Begin>
<Metadata Begin>
Name: "TODO"
Type: Script
Context: Legacy
Path: ServerStorage.Documents.TODO
Size: 603 Character(s), 15 Line(s)
</Metadata End>
]]

--!nolint
--[=[ TODO:
	- Refine & Optimize Source Codes & DataModel.
	- Resolve 'Clear Console Log' Button Padding.
	- Implement Scale Tween to Tooltip & Widgets.
	- Optimize Images w/ ImageRectOffset & ImageRectSize.
	- ? Parallelize PlotsServer Plot Spawn/Despawn Methods.
	- ? Implement Undo/Redo Buttons.
	- ? Implement Progress Bar(s) & Skip Button to Splash GUI.
	- ? Migrate URIs from 'rbxassetid' to 'rbxasset'.
	- ? Migrate Sounds to Audio API.
	- Write Attribute Tool, AssetAttributes Module, & Attribute Editor Widget.
	- Extend ToolReplicator for Attribute, Texture, & Pivot Tools.
	...
]=]

-- </Script #50 End>
--[[
<Script #51 Begin>
<Metadata Begin>
Name: "PlotsHandlerClient"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.PlotsHandlerClient
Size: 6392 Character(s), 158 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOT_TAG = CONSTANTS.Plots.TAG

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlotsRemotes = Remotes:WaitForChild("Plots")
local GetPlotsRemote = PlotsRemotes:WaitForChild("GetPlots")
local PlotAddedRemote = PlotsRemotes:WaitForChild("PlotAdded")
local PlotRemovedRemote = PlotsRemotes:WaitForChild("PlotRemoved")
local PlotChangedRemote = PlotsRemotes:WaitForChild("PlotChanged")
local CreationSpawnedRemote = PlotsRemotes:WaitForChild("CreationSpawned")
local CreationDespawnedRemote = PlotsRemotes:WaitForChild("CreationDespawned")

local PlotClass = Plots.Plot
local OccupantClass = Plots.Occupant

local LocalPlayer = Players.LocalPlayer

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>PlotModel</strong>.
]=]
local function IsPlotModel(value: any): boolean
	return typeof(value) == "Instance" and value:HasTag(PLOT_TAG)
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>Player</strong>.
]=]
local function IsPlayer(value: any): boolean
	return typeof(value) == "Instance" and value:IsA("Player")
end

Callback.CallForEachVarargAndConnect(function(player: Player)
	if player ~= LocalPlayer then
		OccupantClass.new(player)
	end
end, Players.PlayerAdded, unpack(Players:GetPlayers()))

Players.PlayerRemoving:Connect(function(player)
	local occupant = Plots.Plots[player]

	if occupant then
		task.defer(occupant.Destruct, occupant)
	end
end)

task.spawn(function()
	print(`[{script}]: Invoking {GetPlotsRemote}...`)

	local timestamp = os.clock()

	xpcall(function(plotsData: {{any}}, ...)
		print(`[{script}]: {GetPlotsRemote} invocation returned in {math.floor((os.clock() - timestamp) * 1e3)} ms: {String.FormatTable(plotsData)}`)

		assert(select("#", ...) == 0, `Return values of method 'InvokeServer' of {GetPlotsRemote} are not unary.`)

		for _, serializedPlot in plotsData do
			xpcall(function()
				local plotModel: Model, spawned: boolean, occupants: {Player} = unpack(serializedPlot)
				local plot = PlotClass.new(plotModel)

				if spawned == true then
					plot:SpawnCreation()
				end

				for _, occupant in occupants do
					OccupantClass.GetOccupant(occupant):SetPlot(plot)
				end
			end, function(message: string)
				warn(debug.traceback(message))
			end)
		end
	end, function(message: string)
		warn(debug.traceback(message))
	end, GetPlotsRemote:InvokeServer())
end)

PlotAddedRemote.OnClientEvent:Connect(function(plotModel: Model, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {PlotAddedRemote} are not nullary.`)
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {PlotAddedRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)

		PlotClass.new(plotModel)
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

PlotRemovedRemote.OnClientEvent:Connect(function(plotModel: Model, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {PlotRemovedRemote} are not nullary.`)
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {PlotRemovedRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)
		assert(Plots.Plots[plotModel], `Argument 'PlotModel' to callback 'OnClientEvent' of {PlotRemovedRemote} is {plotModel} and does not have a Plot.`):Destruct()
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

PlotChangedRemote.OnClientEvent:Connect(function(player: Player, plotModel: Model?, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {PlotChangedRemote} are not nullary.`)
		assert(IsPlayer(player), `Argument 'Player' to callback 'OnClientEvent' of {PlotChangedRemote} is {player} and not a Player.`)
		assert(plotModel == nil or IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {PlotChangedRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}' or nil.`)

		local occupant = OccupantClass.GetOccupant(player)
		local plot = occupant.Plot

		assert(plotModel ~= (plot and plot.PlotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {PlotChangedRemote} is {plotModel} and equal to property 'Plot' of {occupant}.`)

		occupant:SetPlot(plotModel and PlotClass.GetPlot(plotModel))
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

CreationSpawnedRemote.OnClientEvent:Connect(function(plotModel: Model, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {CreationSpawnedRemote} are not nullary.`)
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {CreationSpawnedRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)

		local plot = PlotClass.GetPlot(plotModel)

		assert(not plot.Spawned, `Called callback 'OnServerEvent' of {CreationSpawnedRemote} while property 'Spawned' of {plot} is {plot.Spawned} and not a falsy value.`)

		PlotClass.GetPlot(plotModel):SpawnCreation()
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

CreationDespawnedRemote.OnClientEvent:Connect(function(plotModel: Model, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {CreationDespawnedRemote} are not nullary.`)
		assert(IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnClientEvent' of {CreationDespawnedRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}'.`)

		local plot = PlotClass.GetPlot(plotModel)

		assert(plot.Spawned, `Called callback 'OnServerEvent' of {CreationDespawnedRemote} while property 'Spawned' of {plot} is {plot.Spawned} and not a truthy value.`)

		plot:DespawnCreation()
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

-- </Script #51 End>
--[[
<Script #52 Begin>
<Metadata Begin>
Name: "InputHandler"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.InputHandler
Size: 10799 Character(s), 337 Line(s)
</Metadata End>
]]

--!strict
-- TODO: Remove Debug Logging.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Input = require(Services:WaitForChild("Input"))
local Plots = require(Services:WaitForChild("PlotsClient"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local InputRemotes = Remotes:WaitForChild("Input")
local BulkInputsRemote = InputRemotes:WaitForChild("BulkInputs")
local InputBeganRemote = InputRemotes:WaitForChild("InputBegan")
local InputEndedRemote = InputRemotes:WaitForChild("InputEnded")

local OccupantClass = Plots.Occupant

local LocalPlayer = Players.LocalPlayer
local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChanged = Instance.new("BindableEvent")
local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	LocalPlot = LocalOccupant.Plot :: any
	LocalPlotChanged:Fire()
end, LocalOccupant.PlotChanged)

local MouseButtons = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3
}

local Controller = Input.Controller

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of values in <code>Array</code>.
]=]
local function IsArrayOfValuesInArray(value: any, array: {any}): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if not table.find(array, value) then
			return false
		end
	end

	return true
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of <strong>EnumItems</strong> of <code>Enum</code>.
]=]
local function IsArrayOfEnumItems(value: any, enum: Enum): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if typeof(value) ~= "EnumItem" or value.EnumType ~= enum then
			return false
		end
	end

	return true
end

Callback.CallAndConnect(function()
	local plot = LocalPlot

	if not plot then
		return
	end

	local occupants = plot.Occupants
	local spawnedChangedDestructor = LocalPlotChangedDestructor:Add(Destructor.new())

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean)
		spawnedChangedDestructor:Destruct()

		if not spawned then
			return
		end

		local eligibleControllers: {Player} = {}

		local players: {Player} = table.create(#occupants)

		for _, occupant in occupants do
			table.insert(players, occupant.Player)
		end

		spawnedChangedDestructor:Add(Callback.CallForEachVarargAndConnect(function(player: Player)
			local occupantRemovingDestructor = spawnedChangedDestructor:Add(Destructor.new())
			local canControlChangedDestructor = occupantRemovingDestructor:Add(Destructor.new())

			occupantRemovingDestructor:Add((Callback.CallForEachVarargAndConnect :: any)(@native function()
				canControlChangedDestructor:Destruct()

				if player:GetAttribute("_CanControl") then
					local index = 1

					for _, occupant in occupants do
						local otherPlayer = occupant.Player

						if otherPlayer == player then
							break
						end

						if table.find(eligibleControllers, otherPlayer) then
							index += 1
						end
					end

					table.insert(eligibleControllers, index, player)
				else
					local index = table.find(eligibleControllers, player)

					if index then
						table.remove(eligibleControllers, index)
					end
				end

				Controller:Set(eligibleControllers[1])
			end, player:GetAttributeChangedSignal("_CanControl"), player:GetAttribute("_CanControl")))

			local occupant = OccupantClass.GetOccupant(player)

			occupantRemovingDestructor:Add(occupant.PlotChanged:Connect(function()
				occupantRemovingDestructor:Destruct()
			end))
		end, plot.OccupantAdded, unpack(players)))

		spawnedChangedDestructor:Add(Controller.Set, Controller, nil)

		local ownerChangedDestructor = spawnedChangedDestructor:Add(Destructor.new())
		local owner = plot.Owner

		spawnedChangedDestructor:Add(Callback.CallAndConnect(function(owner: Player?)
			ownerChangedDestructor:Destruct()

			if LocalPlayer ~= owner then
				return
			end

			ownerChangedDestructor:Add(BulkInputsRemote.OnClientEvent:Connect(function(keys: {Enum.KeyCode}, mouseButtons: {Enum.UserInputType}, ...)
				xpcall(function(...)
					assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {BulkInputsRemote} are not nullary.`)
					assert(IsArrayOfEnumItems(keys, Enum.KeyCode), `Argument 'Keys' to callback 'OnClientEvent' of {BulkInputsRemote} is {keys} and not an array of Enum.KeyCodes.`)
					assert(IsArrayOfValuesInArray(mouseButtons, MouseButtons), `Argument 'MouseButtons' to callback 'OnClientEvent' of {BulkInputsRemote} is {mouseButtons} and not an array of values in {MouseButtons}.`)

					for _, key in keys do
						Input.PressKey(key)
					end

					for _, mouseButton in mouseButtons do
						Input.SetMouseButtonPressed(mouseButton, true)
					end
				end, function(message: string)
					warn(debug.traceback(message))
				end, ...)
			end))

			ownerChangedDestructor:Add(InputBeganRemote.OnClientEvent:Connect(function(keyOrMouseButton: Enum.KeyCode | Enum.UserInputType, ...)
				xpcall(function(...)
					assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {InputBeganRemote} are not nullary.`)

					local isKey = typeof(keyOrMouseButton) == "EnumItem" and keyOrMouseButton.EnumType == Enum.KeyCode

					assert(isKey or table.find(MouseButtons, keyOrMouseButton :: any), `Argument 'KeyOrMouseButton' to callback 'OnClientEvent' of {InputBeganRemote} is {keyOrMouseButton} and not an Enum.KeyCode and a value in {MouseButtons}.`)

					if isKey then
						Input.PressKey(keyOrMouseButton :: any)
					else
						Input.SetMouseButtonPressed(keyOrMouseButton :: any, true)
					end
				end, function(message: string)
					warn(debug.traceback(message))
				end, ...)
			end))

			ownerChangedDestructor:Add(InputEndedRemote.OnClientEvent:Connect(function(keyOrMouseButton: Enum.KeyCode | Enum.UserInputType, ...)
				xpcall(function(...)
					assert(select("#", ...) == 0, `Varargs to callback 'OnClientEvent' of {InputEndedRemote} are not nullary.`)

					local isKey = typeof(keyOrMouseButton) == "EnumItem" and keyOrMouseButton.EnumType == Enum.KeyCode

					assert(isKey or table.find(MouseButtons, keyOrMouseButton :: any), `Argument 'KeyOrMouseButton' to callback 'OnClientEvent' of {InputEndedRemote} is {keyOrMouseButton} and not an Enum.KeyCode and a value in {MouseButtons}.`)

					if isKey then
						Input.ReleaseKey(keyOrMouseButton :: any)
					else
						Input.SetMouseButtonPressed(keyOrMouseButton :: any, false)
					end
				end, function(message: string)
					warn(debug.traceback(message))
				end, ...)
			end))
		end, plot.OwnerChanged, owner and owner.Player))
	end, plot.SpawnedChanged, plot.Spawned))
end, LocalPlotChanged.Event)

local ControllerChangedDestructor = Destructor.new()

Callback.CallForEachVarargAndConnect(function(controller: Player?)
	ControllerChangedDestructor:Destruct()

	print(`[{script}]: Controller Changed: {controller or "<Nobody>"}`)

	Input.Clear()

	if LocalPlayer ~= controller then
		return
	end

	local OnBulkInputs: (keys: {Enum.KeyCode}, mouseButtons: {Enum.UserInputType}) -> ()
	local OnInputBegan: (keyOrMouseButton: Enum.KeyCode | Enum.UserInputType) -> ()
	local OnInputEnded: (keyOrMouseButton: Enum.KeyCode | Enum.UserInputType) -> ()

	local isOwner = ControllerChangedDestructor:Add(ValueWrapper.new(false))
	local owner = LocalPlot.Owner

	ControllerChangedDestructor:Add(Callback.CallAndConnect(function(owner: Player?)
		isOwner:Set(LocalPlayer == owner)
	end, LocalPlot.OwnerChanged, owner and owner.Player))

	Callback.CallAndConnect(function(isOwner: boolean)
		if not isOwner then
			print(`[{script}]: LocalOccupant is not Owner. Routing Input to Server.`)

			OnBulkInputs = function(...)
				BulkInputsRemote:FireServer(...)
			end

			OnInputBegan = function(...)
				InputBeganRemote:FireServer(...)
			end

			OnInputEnded = function(...)
				InputEndedRemote:FireServer(...)
			end

			return
		end

		print(`[{script}]: LocalOccupant is Owner. Routing Input Locally.`)

		OnBulkInputs = function(keys: {Enum.KeyCode}, mouseButtons: {Enum.UserInputType})
			for _, key in keys do
				Input.PressKey(key)
			end

			for _, mouseButton in mouseButtons do
				Input.SetMouseButtonPressed(mouseButton, true)
			end
		end

		OnInputBegan = function(keyOrMouseButton: Enum.KeyCode | Enum.UserInputType)
			if keyOrMouseButton.EnumType == Enum.KeyCode then
				Input.PressKey(keyOrMouseButton :: any)
			else
				Input.SetMouseButtonPressed(keyOrMouseButton :: any, true)
			end
		end

		OnInputEnded = function(keyOrMouseButton: Enum.KeyCode | Enum.UserInputType)
			if keyOrMouseButton.EnumType == Enum.KeyCode then
				Input.ReleaseKey(keyOrMouseButton :: any)
			else
				Input.SetMouseButtonPressed(keyOrMouseButton :: any, false)
			end
		end
	end, isOwner.Changed, isOwner.Value)

	do
		local pressedKeys = UserInputService:GetKeysPressed()
		local pressedKeyCodes: {Enum.KeyCode} = table.create(#pressedKeys)

		for _, key in pressedKeys do
			table.insert(pressedKeyCodes, key.KeyCode)
		end

		local pressedMouseButtons = UserInputService:GetMouseButtonsPressed()
		local pressedMouseButtonTypes: {Enum.UserInputType} = table.create(#pressedMouseButtons)

		for _, mouseButton in pressedMouseButtons do
			table.insert(pressedMouseButtonTypes, mouseButton.UserInputType)
		end

		OnBulkInputs(pressedKeyCodes, pressedMouseButtonTypes)
	end

	ControllerChangedDestructor:Add(UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		local userInputType = input.UserInputType

		if userInputType == Enum.UserInputType.Keyboard then
			OnInputBegan(input.KeyCode)
		elseif table.find(MouseButtons, userInputType) then
			OnInputBegan(userInputType)
		end
	end))

	ControllerChangedDestructor:Add(UserInputService.InputEnded:Connect(function(input, processed)
		if processed then
			return
		end

		local userInputType = input.UserInputType

		if userInputType == Enum.UserInputType.Keyboard then
			OnInputEnded(input.KeyCode)
		elseif table.find(MouseButtons, userInputType) then
			OnInputEnded(userInputType)
		end
	end))
end, Controller.Changed, Controller.Value)

-- </Script #52 End>
--[[
<Script #53 Begin>
<Metadata Begin>
Name: "OverheadCharacterNametags"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Gui.OverheadCharacterNametags
Size: 1500 Character(s), 41 Line(s)
</Metadata End>
]]

--!strict
local OWNER_TAG_COLOR = BrickColor.new("Royal purple").Color

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local GetTextChatNametagColorForUsername = require(Functions:WaitForChild("GetTextChatNametagColorForUsername"))
local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Nametag = script:WaitForChild("Nametag")

local LocalPlayer = Players.LocalPlayer

local OwnerTagColorHexadecimal = OWNER_TAG_COLOR:ToHex()

Callback.CallForEachVarargAndConnect(function(player: Player)
	if player == LocalPlayer then
		return
	end

	Callback.CallForEachVarargAndConnect(function(character: Model)
		local head: BasePart = character:FindFirstChild("Head") :: any

		if not head then
			return
		end

		local nametag = Nametag:Clone()

		local label = nametag:WaitForChild("Text")
		label.Text = `<font color="#{GetTextChatNametagColorForUsername(player.Name):ToHex()}">{player.DisplayName}</font>{if IsPlayerExperienceOwner(player) then ` <font color="#{OwnerTagColorHexadecimal}"><b>\{</b>Owner<b>\}</b></font>` else ""}\n@{player}`

		nametag.Parent = head
	end, player.CharacterAdded, player.Character :: any)
end, Players.PlayerAdded, unpack(Players:GetPlayers()))

-- </Script #53 End>
--[[
<Script #54 Begin>
<Metadata Begin>
Name: "WorkspaceAttributesSetter"
Type: Script
Context: Legacy
Path: ServerScriptService.WorkspaceAttributesSetter
Size: 423 Character(s), 12 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local GetGlobalTimestamp = require(Functions:WaitForChild("GetGlobalTimestamp"))

workspace:SetAttribute("ServerStartedTimestamp", GetGlobalTimestamp() - time())
workspace:SetAttribute("PlaceVersion", game.PlaceVersion)

script:Destroy()

-- </Script #54 End>
--[[
<Script #55 Begin>
<Metadata Begin>
Name: "ToolPredicates"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Tools.ToolPredicates
Size: 1947 Character(s), 74 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChangedDestructor = Destructor.new()

for _, tool in Tools :: any do
	local enabled: ValueWrapper.ValueWrapper<boolean> = tool.Enabled
	local predicates = enabled.Predicates

	predicates.IsBoolean = function(value)
		return type(value) == "boolean"
	end

	predicates.HasPlotAndIsDespawned = function(enabling)
		return not enabling or (LocalPlot and not LocalPlot.Spawned)
	end

	local mutualEnables: {ValueWrapper.ValueWrapper<boolean>} = {}

	for _, otherTool in Tools :: any do
		if otherTool ~= tool then
			table.insert(mutualEnables, otherTool.Enabled)
		end
	end

	predicates.Mutex = function(enabling)
		if not enabling then
			return true
		end

		for _, mutualEnable in mutualEnables :: any do
			mutualEnable:Set(false)
		end

		return true
	end

	LocalOccupant.PlotChanged:Connect(function()
		if not LocalPlot then
			enabled:Set(false)

			return
		end

		LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean)
			if spawned then
				enabled:Set(false)
			end
		end, LocalPlot.SpawnedChanged, LocalPlot.Spawned))
	end)
end

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()
	LocalPlot = LocalOccupant.Plot :: any
end, LocalOccupant.PlotChanged)

-- </Script #55 End>
--[[
<Script #56 Begin>
<Metadata Begin>
Name: "Widgets"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Gui.Widgets
Size: 9250 Character(s), 300 Line(s)
</Metadata End>
]]

--!strict
local DRAGGER_SNAPPING_INCREMENT = 4 -- Pixel(s)

local TRANSPARENCY_TWEEN_SPEED_MULTIPLIER = 3 / 2

local UNFOCUSED_TITLE_TEXT_TRANSPARENCY = .5

local ASSET_ID_URI_PREFIX = "rbxassetid://"

local EXPAND_COLLAPSE_ICON_IDS = {
	EXPAND = 97965992147291,
	COLLAPSE = 105513419608088
}

local CLOSE_BUTTON_INTERACTABLE_COLOR = Color3.fromRGB(204, 0, 0)
local CLOSE_BUTTON_UNINTERACTABLE_TRANSPARENCY = .5

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local GUI = CONSTANTS.Gui
local WIDGET_TAG = GUI.WIDGET_TAG

local COLOR_SCHEME = GUI.ColorScheme
local DARKER_COLOR = COLOR_SCHEME.DARKER
local DARK_COLOR = COLOR_SCHEME.DARK
local LIGHT_COLOR = COLOR_SCHEME.LIGHT

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Settings = require(Controllers:WaitForChild("Settings"))
local Widgets = require(Controllers:WaitForChild("Widgets"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Scale = Settings.Gui.Scale

local TweenParametersOut = TweenInfo.new(TWEENS.DURATION / TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParametersInOut = TweenInfo.new(TWEENS.DURATION / TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.InOut)

local Layers: {Frame} = {}
local LayerCount = ValueWrapper.new(0)

do
	local IconIds = {unpack(EXPAND_COLLAPSE_ICON_IDS)}
	local IconUris: {string} = table.create(#IconIds)

	for _, id in IconIds do
		table.insert(IconUris, ASSET_ID_URI_PREFIX .. id)
	end

	task.spawn(ContentProvider.PreloadAsync, ContentProvider, IconUris)
end

Callback.CallForEachVarargAndConnect(@native function(widget: Frame)
	if not widget:IsDescendantOf(PlayerGui) then
		return
	end

	local body: CanvasGroup = widget:WaitForChild("Body") :: any
	local uiScale: UIScale = widget:WaitForChild("UIScale") :: any

	local header: Frame = body:WaitForChild("Header") :: any
	local titleLabel: TextLabel = header:WaitForChild("Title") :: any
	local closeButton: ImageButton = header:WaitForChild("Close") :: any
	local expandCollapseButton: ImageButton = header:WaitForChild("Expand/Collapse") :: any
	local positionDragger: UIDragDetector = header:WaitForChild("UIDragDetector") :: any

	local footer: Frame = body:WaitForChild("Footer") :: any
	local sizeLabel: ImageLabel = footer:WaitForChild("Size") :: any
	local sizeDragger: UIDragDetector = sizeLabel:WaitForChild("UIDragDetector") :: any

	local collapsedSize: UDim2 = widget:GetAttribute("_CollapsedSize")
	local expandedSize: UDim2 = widget:GetAttribute("_ExpandedSize")

	local controls = Widgets[String.ToCamelCase(widget.Name)]
	local visible: ValueWrapper.ValueWrapper<boolean> = controls.Visible
	local collapsed: ValueWrapper.ValueWrapper<boolean> = controls.Collapsed

	local bodyOpenTween = TweenService:Create(body, TweenParametersOut, {
		GroupColor3 = Color3.new(1, 1, 1),
		GroupTransparency = 0
	})

	local uiScaleOpenTween = TweenService:Create(uiScale, TweenParametersOut, {Scale = 1})

	local bodyCloseTween = TweenService:Create(body, TweenParametersOut, {
		GroupColor3 = Color3.new(),
		GroupTransparency = 1
	})

	local uiScaleCloseTween = TweenService:Create(uiScale, TweenParametersOut, {Scale = 3 / 4})

	bodyOpenTween.Completed:Connect(function(playbackState)
		if playbackState == Enum.PlaybackState.Completed then
			widget.Interactable = true
		end
	end)

	bodyCloseTween.Completed:Connect(function(playbackState)
		if playbackState == Enum.PlaybackState.Completed then
			widget.Visible = false
		end
	end)

	local destructor = Destructor.new()

	destructor:Add(Callback.CallAndConnect(function(visible: boolean)
		if not visible then
			widget.Interactable = false

			closeButton.ImageColor3 = LIGHT_COLOR
			closeButton.ImageTransparency = CLOSE_BUTTON_UNINTERACTABLE_TRANSPARENCY

			bodyCloseTween:Play()
			uiScaleCloseTween:Play()

			return
		end

		closeButton.ImageColor3 = CLOSE_BUTTON_INTERACTABLE_COLOR
		closeButton.ImageTransparency = 0

		widget.Visible = true

		uiScaleOpenTween:Play()

		bodyOpenTween:Play()
	end, visible.Changed, visible.Value))

	for _, property in {"Position", "Size"} do
		local value = (((widget :: any)[`Absolute{property}`] + Vector2.one * 0.5) / DRAGGER_SNAPPING_INCREMENT):Floor() * DRAGGER_SNAPPING_INCREMENT;

		(widget :: any)[property] = UDim2.fromOffset(value.X, value.Y)
	end

	local startPosition: UDim2, startSize: UDim2

	destructor:Add(positionDragger.DragStart:Connect(function()
		startPosition = widget.Position
	end))

	destructor:Add(positionDragger.DragContinue:Connect(function()
		local translation = positionDragger.DragUDim2
		local scale = Scale.Value

		widget.Position = startPosition + UDim2.fromOffset(
			math.round(translation.X.Offset * scale / DRAGGER_SNAPPING_INCREMENT) * DRAGGER_SNAPPING_INCREMENT,
			math.round(translation.Y.Offset * scale / DRAGGER_SNAPPING_INCREMENT) * DRAGGER_SNAPPING_INCREMENT
		)
	end))

	sizeDragger:AddConstraintFunction(math.huge, function(transform: UDim2): UDim2
		return UDim2.fromOffset(
			math.max(startSize.X.Offset + transform.X.Offset, collapsedSize.X.Offset) - startSize.X.Offset,
			math.max(startSize.Y.Offset + transform.Y.Offset, collapsedSize.Y.Offset + footer.Size.Y.Offset) - startSize.Y.Offset
		)
	end)

	local collapsedChangedDestructor = destructor:Add(Destructor.new())

	destructor:Add(Callback.CallAndConnect(function(collapsed: boolean)
		collapsedChangedDestructor:Destruct()

		if collapsed then
			expandCollapseButton.Image = ASSET_ID_URI_PREFIX .. EXPAND_COLLAPSE_ICON_IDS.EXPAND

			TweenService:Create(widget, TweenParametersInOut, {
				Size = collapsedSize
			}):Play()

			return
		else
			expandCollapseButton.Image = ASSET_ID_URI_PREFIX .. EXPAND_COLLAPSE_ICON_IDS.COLLAPSE

			TweenService:Create(widget, TweenParametersInOut, {
				Size = expandedSize
			}):Play()
		end

		collapsedChangedDestructor:Add(sizeDragger.DragStart:Connect(function()
			startPosition, startSize = widget.Position, widget.Size
		end))

		collapsedChangedDestructor:Add(sizeDragger.DragContinue:Connect(function()
			local translation = sizeDragger.DragUDim2

			local snapped = UDim2.fromOffset(
				math.round(translation.X.Offset / DRAGGER_SNAPPING_INCREMENT) * DRAGGER_SNAPPING_INCREMENT,
				math.round(translation.Y.Offset / DRAGGER_SNAPPING_INCREMENT) * DRAGGER_SNAPPING_INCREMENT
			)

			widget.Position = startPosition + UDim2.fromOffset(snapped.X.Offset / 2, snapped.Y.Offset / 2)
			widget.Size = startSize + snapped
		end))

		collapsedChangedDestructor:Add(sizeDragger.DragEnd:Connect(function()
			expandedSize = widget.Size
		end))
	end, collapsed.Changed, collapsed.Value))

	expandCollapseButton.MouseButton1Click:Connect(function()
		collapsed:Set(not collapsed.Value)
	end)

	closeButton.MouseButton1Click:Connect(function()
		visible:Set(false)
	end)

	local function BringToForefront()
		local index = table.find(Layers, widget)

		if index then
			if index == LayerCount.Value then
				return
			end

			table.remove(Layers, index)

			for index = index, #Layers do
				Layers[index].ZIndex -= 1
			end
		end

		table.insert(Layers, widget)

		local layerCount = #Layers

		widget.ZIndex = layerCount

		LayerCount:Set(layerCount)
	end

	local function RemoveFromLayers()
		local index: number = table.find(Layers, widget) :: any

		if not index then
			return
		end

		table.remove(Layers, index)

		local layerCount = #Layers

		for index = index, layerCount do
			Layers[index].ZIndex -= 1
		end

		LayerCount:Set(layerCount)
	end

	destructor:Add(Callback.CallAndConnect(function(visible: boolean)
		if visible then
			BringToForefront()
		else
			RemoveFromLayers()
		end
	end, visible.Changed, visible.Value))

	destructor:Add(body:GetPropertyChangedSignal("GuiState"):Connect(function()
		if body.GuiState == Enum.GuiState.Press then
			BringToForefront()
		end
	end))

	destructor:Add(positionDragger.DragStart:Connect(BringToForefront))
	destructor:Add(RemoveFromLayers)

	for _, connection in
		Callback.CallAndConnectToEach(function()
			local isFocused = widget.ZIndex == LayerCount.Value

			titleLabel.TextTransparency = if isFocused then 0 else UNFOCUSED_TITLE_TEXT_TRANSPARENCY
			header.BackgroundColor3 = if isFocused then DARKER_COLOR else DARK_COLOR
		end, {widget:GetPropertyChangedSignal("ZIndex"), LayerCount.Changed})
	do
		destructor:Add(connection)
	end

	widget.Destroying:Connect(function()
		destructor:Destruct()
	end)
end, CollectionService:GetInstanceAddedSignal(WIDGET_TAG), unpack(CollectionService:GetTagged(WIDGET_TAG)))

-- </Script #56 End>
--[[
<Script #57 Begin>
<Metadata Begin>
Name: "AssetBudgetsPrinterServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Plots.Assets.AssetBudgetsPrinterServer
Size: 452 Character(s), 14 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local String = require(Libraries:WaitForChild("String"))

local Values = Modules:WaitForChild("Values")
local AssetBudgets = require(Values:WaitForChild("AssetBudgets"))

print(`[{script}]: Asset Budgets: {String.FormatTable(AssetBudgets :: any)}`)

script:Destroy()

-- </Script #57 End>
--[[
<Script #58 Begin>
<Metadata Begin>
Name: "PlayerGatekeeper"
Type: Script
Context: Legacy
Path: ServerScriptService.Players.Security.PlayerGatekeeper
Size: 544 Character(s), 21 Line(s)
</Metadata End>
]]

--!strict
local MIN_ACCOUNT_AGE = 7 * 2 -- Day(s)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsStudio() then
	print(`[{script}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	script:Destroy()

	return
end

Players.PlayerAdded:Connect(function(player)
	local accountAge = player.AccountAge

	if accountAge < MIN_ACCOUNT_AGE then
		player:Kick(`[{script}]: Account Age of {player} is {accountAge} day(s) and less than {MIN_ACCOUNT_AGE} day(s).`)
	end
end)

-- </Script #58 End>
--[[
<Script #59 Begin>
<Metadata Begin>
Name: "ConnectionHangWatchdogClient"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Debug.ConnectionHangWatchdogClient
Size: 2458 Character(s), 58 Line(s)
</Metadata End>
]]

--!strict
local INVOKE_INTERVAL = 2 -- Second(s)
local EXPIRY_DELAY = 5 -- Second(s)

local NOTIFICATION_SOUND_REPEATS = 5

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local TestService = game:GetService("TestService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local GetGlobalTimestamp = require(Functions:WaitForChild("GetGlobalTimestamp"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local NetworkRemotes = Remotes:WaitForChild("Network")
local PingRemote = NetworkRemotes:WaitForChild("Ping")

local MasterMixer = SoundService:WaitForChild("Master")
local BeepSound = MasterMixer:WaitForChild("Beep")

if RunService:IsStudio() then
	print(`[{script}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	script:Destroy()

	return
end

local Timestamp = GetGlobalTimestamp()
local LastInvocationReturnTimestamp = Timestamp

repeat
	task.spawn(@native function()
		LastInvocationReturnTimestamp = Timestamp + math.abs(workspace:GetServerTimeNow() - PingRemote:InvokeServer())
	end)

	task.wait(INVOKE_INTERVAL)

	Timestamp = GetGlobalTimestamp()
until Timestamp - LastInvocationReturnTimestamp >= EXPIRY_DELAY

local JobId = game.JobId

TestService:Error(`[{script}]: 🟧 Run-Time Degradation:\nLost Connection to Job{if JobId ~= "" then ` {JobId}` else ""}. The last cross-context Invocation return was at {DateTime.fromUnixTimestamp(LastInvocationReturnTimestamp):ToIsoDate()}. A Server hang or an unstable Internet Connection can cause this. If this Error persists, troubleshoot the Internet Connection in System Settings, check https://status.roblox.com, or contact Developer(s) via Social Networks. Capture a Screenshot by pressing Print, Super [Win] + Print (Windows), Shift + Super [Cmd] (MacOS), or Alt + 1 with Dev Console unoccluded for troubleshooting. The Session may be terminated soon if the Connection is not regained. If the Session is terminated, press F9 or the 'X' button at the top right corner of the Dev Console to close it and pass Input to the 'Connection Lost' CoreGui which may be layered behind it.`)

StarterGui:SetCore("DevConsoleVisible", true)

for _ = 1, NOTIFICATION_SOUND_REPEATS do
	BeepSound:Play()
	BeepSound.Ended:Wait()
end

script:Destroy()

-- </Script #59 End>
--[[
<Script #60 Begin>
<Metadata Begin>
Name: "Control Chair"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Assets.Control Chair
Size: 2015 Character(s), 79 Line(s)
</Metadata End>
]]

--!strict
local TAG = "Control Chair"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOT_TAG = CONSTANTS.Plots.TAG

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local OccupantClass = Plots.Occupant

Callback.CallForEachVarargAndConnect(function(chair: Model)
	local plotModel: Model = Hierarchy.FindFirstAncestorWithTag(chair, PLOT_TAG) :: any

	if not plotModel then
		return
	end

	local plot = Plots.Plots[plotModel]

	if not plot then
		return
	end

	while chair.Parent ~= plot.SpawnModel do
		plot.SpawnedChanged:Wait()
	end

	local seat: Seat = chair:WaitForChild("Seat") :: any

	local destructor = Destructor.new()
	local lastSeatedPlayer: Player

	destructor:Add((Callback.CallForEachVarargAndConnect :: any)(destructor:Add(function()
		local seatOccupant = seat.Occupant

		if lastSeatedPlayer then
			lastSeatedPlayer:SetAttribute("_CanControl", false)
		end

		if not seatOccupant then
			return
		end

		local player = Players:GetPlayerFromCharacter(seatOccupant.Parent)

		if not player then
			return
		end

		local occupant = OccupantClass.GetOccupant(player)

		if occupant.Plot ~= plot then
			return
		end

		player:SetAttribute("_CanControl", true)

		lastSeatedPlayer = player
	end), seat:GetPropertyChangedSignal("Occupant"), seat.Occupant))

	chair.Destroying:Wait()

	destructor:Destruct()
end, CollectionService:GetInstanceAddedSignal(TAG), unpack(CollectionService:GetTagged(TAG)))

-- </Script #60 End>
--[[
<Script #61 Begin>
<Metadata Begin>
Name: "AssetBudgetsPrinterClient"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Assets.AssetBudgetsPrinterClient
Size: 452 Character(s), 14 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local String = require(Libraries:WaitForChild("String"))

local Values = Modules:WaitForChild("Values")
local AssetBudgets = require(Values:WaitForChild("AssetBudgets"))

print(`[{script}]: Asset Budgets: {String.FormatTable(AssetBudgets :: any)}`)

script:Destroy()

-- </Script #61 End>
--[[
<Script #62 Begin>
<Metadata Begin>
Name: "Tools"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Controllers.Tools
Size: 1112 Character(s), 37 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local AssetSelector = require(Classes:WaitForChild("AssetSelector"))
--local AssetAttributes = require(Classes:WaitForChild("AssetAttributes"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

return {
	Construct = {
		Enabled = ValueWrapper.new(false),
		Asset = ValueWrapper.new() :: ValueWrapper.ValueWrapper<Model?>
	},
	Destruct = {
		Enabled = ValueWrapper.new(false),
		Selector = AssetSelector.new()
	},
	Attribute = {
		Enabled = ValueWrapper.new(false)--[[,
		Selection = AssetSelector.new(),
		--Attributes = AssetAttributes.new(),
		--Clipboard = AssetAttributes.new()]]
	},
	Texture = {
		Enabled = ValueWrapper.new(false)--[[,
		Selection = AssetSelector.new(),
		Color = ValueWrapper.new(Color3.new()),
		Material = ValueWrapper.new(Enum.Material.Plastic)]]
	},
	Pivot = {
		Enabled = ValueWrapper.new(false)--[[,
		Selection = AssetSelector.new(),
		Pivot = ValueWrapper.new(CFrame.new())]]
	}
}

-- </Script #62 End>
--[[
<Script #63 Begin>
<Metadata Begin>
Name: "DestructTool"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Tools.DestructTool
Size: 4322 Character(s), 165 Line(s)
</Metadata End>
]]

--!strict
local BOUNDARY_TRANSPARENCY = .5
local BOUNDARY_SURFACE_TRANSPARENCY_ALPHA = 3 / 4

local BOUNDARY_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER = 3 / 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TWEENS = CONSTANTS.Tweens

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ToolsRemotes = Remotes:WaitForChild("Tools")
local DestructAssetsRemote = ToolsRemotes:WaitForChild("DestructAssets")

local MasterMixer = SoundService:WaitForChild("Master")
local ToolsMixer = MasterMixer:WaitForChild("Tools")
local DestructedSound = ToolsMixer:WaitForChild("Destructed")

local BoundaryAdornment = script:WaitForChild("Boundary")

local Controls = Tools.Destruct
local Enabled = Controls.Enabled

local Selector = Controls.Selector
local Selection = Selector.Selection

local TweenParametersIn = TweenInfo.new(TWEENS.DURATION / BOUNDARY_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.In)
local TweenParametersOut = TweenInfo.new(TWEENS.DURATION / BOUNDARY_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)

local BoundarySurfaceTransparency = math.lerp(BOUNDARY_TRANSPARENCY, 1, BOUNDARY_SURFACE_TRANSPARENCY_ALPHA)

local Boundaries: {[Model]: BoxHandleAdornment} = {}
local Hover: Model?

local Dummy = function<Value>(value: Value): Value
	return value
end

Callback.CallAndConnect(function(newHover: Model?)
	if Hover and Boundaries[Hover] and not table.find(Selection, Hover) then
		local oldHover = Hover
		local boundary = Boundaries[oldHover]

		local tween = TweenService:Create(boundary, TweenParametersIn, {
			Transparency = 1,
			SurfaceTransparency = 1
		})

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				boundary:Destroy()

				Boundaries[oldHover] = nil
			end
		end)

		tween:Play()
	end

	Hover = newHover

	if not newHover or table.find(Selection, newHover) then
		return
	end

	local boundary = Boundaries[newHover]

	if not Dummy(boundary) then
		boundary = BoundaryAdornment:Clone()
		boundary.Adornee = newHover
		boundary.Parent = newHover

		Boundaries[newHover] = boundary
	end

	TweenService:Create(boundary, TweenParametersOut, {
		Transparency = BOUNDARY_TRANSPARENCY,
		SurfaceTransparency = BoundarySurfaceTransparency
	}):Play()
end, Selector.HoverChanged, Selector.Hover)

Callback.CallAndConnect(function(assets: {Model})
	for _, asset in assets do
		if asset == Hover then
			return
		end

		local boundary = Boundaries[asset]

		if not Dummy(boundary) then
			boundary = BoundaryAdornment:Clone()
			boundary.Adornee = asset
			boundary.Parent = asset

			Boundaries[asset] = boundary
		end

		TweenService:Create(boundary, TweenParametersOut, {
			Transparency = BOUNDARY_TRANSPARENCY,
			SurfaceTransparency = BoundarySurfaceTransparency
		}):Play()
	end
end, Selector.SelectionAdded, Selection)

Selector.SelectionRemoving:Connect(function(assets: {Model})
	for _, asset in assets do
		local boundary = Boundaries[asset]

		if not boundary or asset == Hover then
			return
		end

		local tween = TweenService:Create(boundary, TweenParametersIn, {
			Transparency = 1,
			SurfaceTransparency = 1
		})

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				boundary:Destroy()

				Boundaries[asset] = nil
			end
		end)

		tween:Play()
	end
end)

Selector.HoverClicked:Connect(function(asset: Model)
	DestructAssetsRemote:FireServer(asset)

	asset.Destroying:Wait()

	DestructedSound:Play()
end)

Selector.SelectionClicked:Connect(function(assets: {Model})
	DestructAssetsRemote:FireServer(assets)

	assets[#assets].Destroying:Wait()

	DestructedSound:Play()
end)

Callback.CallAndConnect(function(enabled: boolean)
	if enabled then
		Selector:Enable()
	else
		Selector:Disable()
	end
end, Enabled.Changed, Enabled.Value)

-- </Script #63 End>
--[[
<Script #64 Begin>
<Metadata Begin>
Name: "OrthogonalCuboid"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.OrthogonalCuboid
Size: 5799 Character(s), 147 Line(s)
</Metadata End>
]]

--!strict
--!native
local OrthogonalCuboid = {} :: OrthogonalCuboidImplementation
OrthogonalCuboid.__index = OrthogonalCuboid

type OrthogonalCuboidImplementation = {
	__index: OrthogonalCuboidImplementation,
	__tostring: (self: OrthogonalCuboid) -> string,
	__eq: (self: OrthogonalCuboid, value: any) -> boolean,
	__add: (self: OrthogonalCuboid, value: OrthogonalCuboid | Vector3) -> OrthogonalCuboid,
	__sub: (self: OrthogonalCuboid, value: OrthogonalCuboid | Vector3) -> OrthogonalCuboid,
	__mul: (self: OrthogonalCuboid, value: OrthogonalCuboid | Vector3) -> OrthogonalCuboid,
	__div: (self: OrthogonalCuboid, value: OrthogonalCuboid | Vector3) -> OrthogonalCuboid,
	IsOrthogonalCuboid: (value: any) -> boolean,
	new: (position: Vector3?, size: Vector3?) -> OrthogonalCuboid,
	FromPosition: (position: Vector3) -> OrthogonalCuboid,
	FromSize: (size: Vector3) -> OrthogonalCuboid,
	GetNormals: (self: OrthogonalCuboid) -> {Vector3},
	GetVertices: (self: OrthogonalCuboid) -> {Vector3}
}

type OrthogonalCuboidProperties = {
	Position: Vector3,
	Size: Vector3
}

export type OrthogonalCuboid = typeof(
	setmetatable(
		{} :: OrthogonalCuboidProperties,
		{} :: OrthogonalCuboidImplementation
	)
)

function OrthogonalCuboid:__tostring(): string
	return `{self.Position}, {self.Size}`
end

function OrthogonalCuboid:__eq(value: any): boolean
	return OrthogonalCuboid.IsOrthogonalCuboid(value) and self.Position == value.Position and self.Size == value.Size
end

function OrthogonalCuboid:__add(value: OrthogonalCuboid | Vector3): OrthogonalCuboid
	local isOrthogonalCuboid = OrthogonalCuboid.IsOrthogonalCuboid(value)

	assert(isOrthogonalCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__add' of OrthogonalCuboid on {self} is {value} and not an OrthogonalCuboid or Vector3.`)

	if isOrthogonalCuboid then
		return OrthogonalCuboid.new(self.Position + (value :: any).Position, self.Size + (value :: any).Size)
	else
		return OrthogonalCuboid.new(self.Position + value, self.Size)
	end
end

function OrthogonalCuboid:__sub(value: OrthogonalCuboid | Vector3): OrthogonalCuboid
	local isOrthogonalCuboid = OrthogonalCuboid.IsOrthogonalCuboid(value)

	assert(isOrthogonalCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__sub' of OrthogonalCuboid on {self} is {value} and not an OrthogonalCuboid or Vector3.`)

	if isOrthogonalCuboid then
		return OrthogonalCuboid.new(self.Position - (value :: any).Position, self.Size - (value :: any).Size)
	else
		return OrthogonalCuboid.new(self.Position - value, self.Size)
	end
end

function OrthogonalCuboid:__mul(value: OrthogonalCuboid | Vector3): OrthogonalCuboid
	local isOrthogonalCuboid = OrthogonalCuboid.IsOrthogonalCuboid(value)

	assert(isOrthogonalCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__mul' of OrthogonalCuboid on {self} is {value} and not an OrthogonalCuboid or Vector3.`)

	if isOrthogonalCuboid then
		return OrthogonalCuboid.new(self.Position * (value :: any).Position, self.Size * (value :: any).Size)
	else
		return OrthogonalCuboid.new(self.Position * value, self.Size)
	end
end

function OrthogonalCuboid:__div(value: OrthogonalCuboid | Vector3): OrthogonalCuboid
	local isOrthogonalCuboid = OrthogonalCuboid.IsOrthogonalCuboid(value)

	assert(isOrthogonalCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__div' of OrthogonalCuboid on {self} is {value} and not an OrthogonalCuboid or Vector3.`)

	if isOrthogonalCuboid then
		return OrthogonalCuboid.new(self.Position / (value :: any).Position, self.Size / (value :: any).Size)
	else
		return OrthogonalCuboid.new(self.Position / value, self.Size)
	end
end

function OrthogonalCuboid.IsOrthogonalCuboid(value: any): boolean
	return type(value) == "table" and getmetatable(value) == OrthogonalCuboid
end

--[=[
	Returns a new <strong>OrthogonalCuboid</strong> with <code>Position</code> and <code>Size</code>.
]=]
local function Construct(position: Vector3, size: Vector3): OrthogonalCuboid
	return setmetatable({
		Position = position,
		Size = size
	}, OrthogonalCuboid)
end

function OrthogonalCuboid.new(position: Vector3?, size: Vector3?): OrthogonalCuboid
	assert(position == nil or type(position) == "vector", `Argument 'Position' to constructor 'new' of OrthogonalCuboid is {position} and not a Vector3 or nil.`)
	assert(size == nil or type(size) == "vector", `Argument 'Size' to constructor 'new' of OrthogonalCuboid is {size} and not a Vector3 or nil.`)

	return Construct(position or Vector3.zero, size or Vector3.zero)
end

function OrthogonalCuboid.FromPosition(position: Vector3): OrthogonalCuboid
	assert(type(position) == "vector", `Argument 'Position' to constructor 'FromPosition' of OrthogonalCuboid is {position} and not a Vector3.`)

	return Construct(position, Vector3.zero)
end

function OrthogonalCuboid.FromSize(size: Vector3): OrthogonalCuboid
	assert(type(size) == "vector", `Argument 'Size' to constructor 'FromSize' of OrthogonalCuboid is {size} and not a Vector3.`)

	return Construct(Vector3.zero, size)
end

local Normals = {
	Vector3.xAxis, Vector3.yAxis, Vector3.zAxis,
	-Vector3.xAxis, -Vector3.yAxis, -Vector3.zAxis
}

function OrthogonalCuboid:GetNormals(): {Vector3}
	return Normals
end

function OrthogonalCuboid:GetVertices(): {Vector3}
	local position, halfSize = self.Position, self.Size / 2

	return {
		position + halfSize,
		position + Vector3.new(halfSize.X, halfSize.Y, -halfSize.Z),
		position + Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
		position + Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
		position + Vector3.new(-halfSize.X, halfSize.Y, halfSize.Z),
		position + Vector3.new(-halfSize.X, halfSize.Y, -halfSize.Z),
		position + Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
		position - halfSize
	}
end

return OrthogonalCuboid

-- </Script #64 End>
--[[
<Script #65 Begin>
<Metadata Begin>
Name: "ConstructTool"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.Tools.ConstructTool
Size: 19526 Character(s), 635 Line(s)
</Metadata End>
]]

--!strict
local MOCK_TRANSPARENCY = .5
local MOCK_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER = 3 / 2

local PLACEHOLDER_TRANSPARENCY_ALPHA = 3 / 4

local MOCK_TRANSLATE_TWEEN_SPEED_MULTIPLIER = 3.5
local MOCK_ROTATE_TWEEN_SPEED_MULTIPLIER = 3

local AXIAL_ADORNMENT_TWEEN_DURATION_MULTIPLIER = 2 + 3 / 4

local AXIAL_ADORNMENT_START_OFFSET, AXIAL_ADORNMENT_START_LENGTH = 1, .5 -- Stud(s)
local AXIAL_ADORNMENT_END_OFFSET, AXIAL_ADORNMENT_END_LENGTH = 2, 1 -- Stud(s)

local CANNOT_CONSTRUCT_ADORNMENT_FLASH_DURATION = .5 -- Second(s)
local CONSTRUCT_ASSET_INVOKE_FAILURE_DESTROY_DELAY = 3 / 2 -- Second(s)

local MAX_RESOLVE_PASSES = 3
local RESOLVE_STEP_RENDER_PRIORITY = Enum.RenderPriority.Camera.Value + 1

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TOOL = CONSTANTS.Tools.Construct

local ROTATE_KEYS = TOOL.RotateKeys

local SNAPPING = TOOL.Snapping
local SNAPPING_ENABLED = SNAPPING.ENABLED

local SNAPPING_INCREMENTS = SNAPPING.Increments
local SNAPPING_LINEAR_INCREMENT = SNAPPING_INCREMENTS.LINEAR
local SNAPPING_ROTARY_INCREMENT = SNAPPING_INCREMENTS.ROTARY

local ADORNMENT_COLORS = TOOL.AdornmentColors

local TWEENS = CONSTANTS.Tweens

local ASSET_TAG = CONSTANTS.Assets.TAG

local SPATIAL_QUERIES = CONSTANTS.SpatialQueries
local MAX_OVERLAP_PARTS = SPATIAL_QUERIES.MAX_OVERLAP_PARTS
local MAX_RAYCAST_LENGTH = SPATIAL_QUERIES.MAX_RAYCAST_LENGTH

local EXPIRY_DELAY = CONSTANTS.RemoteInvocations.EXPIRY_DELAY

local EPSILON = CONSTANTS.ArithmeticOperations.EPSILON

local Classes = Modules:WaitForChild("Classes")
local Cuboid = require(Classes:WaitForChild("Cuboid"))
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Services = Modules:WaitForChild("Services")
local AssetPool = require(Services:WaitForChild("AssetPoolClient"))
local Plots = require(Services:WaitForChild("PlotsClient"))

local Values = Modules:WaitForChild("Values")
local AssetBudgets = require(Values:WaitForChild("AssetBudgets"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ToolsRemotes = Remotes:WaitForChild("Tools")
local ConstructAsset = ToolsRemotes:WaitForChild("ConstructAsset")

local MasterMixer = SoundService:WaitForChild("Master")
local ToolsMixer = MasterMixer:WaitForChild("Tools")
local SuccessfulConstructionSound = ToolsMixer:WaitForChild("Successful Construction")
local FailedConstructionSound = ToolsMixer:WaitForChild("Failed Construction")

local AdornmentsFolder = script:WaitForChild("~Adornments")

local Adornments: {HandleAdornment} = Hierarchy.GetChildrenWhichAreA(AdornmentsFolder, "GuiBase3d") :: any

local BoundaryAdornment = AdornmentsFolder:WaitForChild("Boundary")
local BoundaryAdornmentCopy = BoundaryAdornment:Clone()

local AxialAdornments: {[Vector3]: LineHandleAdornment} = {}

for _, axis in Enum.Axis:GetEnumItems() do
	AxialAdornments[Vector3.FromAxis(axis)] = AdornmentsFolder:WaitForChild(axis.Name)
end

local PivotAdornment = AdornmentsFolder:WaitForChild("Pivot")

AdornmentsFolder.Parent = workspace

local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChanged = Instance.new("BindableEvent")
local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	LocalPlot = LocalOccupant.Plot :: any
	LocalPlotChanged:Fire()
end, LocalOccupant.PlotChanged)

local Controls = Tools.Construct
local Enabled = Controls.Enabled
local Asset = Controls.Asset

local StoredAssets = AssetPool.StoredAssets
local AssetCounts = AssetPool.AssetCounts
local TotalAssets = AssetPool.TotalAssets

Asset.Predicates.IsStoredAssetOrNil = function(value)
	return value == nil or not not table.find(StoredAssets, value)
end

local IsEnabledChangedDestructor = Destructor.new()

local IsEnabled = ValueWrapper.new(false, {
	Destruct = function()
		IsEnabledChangedDestructor:Destruct()

		return true
	end
})

Callback.CallAndConnectToEach(function()
	IsEnabled:Set(Enabled.Value and not not Asset.Value)
end, {Enabled.Changed, Asset.Changed})

local TweenParameters1In = TweenInfo.new(TWEENS.DURATION / MOCK_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.In)
local TweenParameters1Out = TweenInfo.new(TWEENS.DURATION / MOCK_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParameters2 = TweenInfo.new(TWEENS.DURATION / MOCK_TRANSLATE_TWEEN_SPEED_MULTIPLIER)
local TweenParameters3 = TweenInfo.new(TWEENS.DURATION / MOCK_ROTATE_TWEEN_SPEED_MULTIPLIER, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local TweenParameters4 = TweenInfo.new(TWEENS.DURATION * AXIAL_ADORNMENT_TWEEN_DURATION_MULTIPLIER, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1)

local Mock: Model
local MockChanged = Instance.new("BindableEvent")
local MockChangedDestructor = Destructor.new()

local Id: number

local Pivot: CFrame
local PivotOffset: CFrame
local PivotOffsetInverse: CFrame

local Size: Vector3

local CanConstruct: BoolValue
local Position: Vector3Value, Rotation: CFrameValue
local Transparency: NumberValue

local SpatialQueryWhitelist = Instance.new("Folder")
SpatialQueryWhitelist.Name = "~Whitelist"
SpatialQueryWhitelist.Parent = workspace

local OverlapParameters1 = OverlapParams.new()
OverlapParameters1.MaxParts = MAX_OVERLAP_PARTS
OverlapParameters1.FilterType = Enum.RaycastFilterType.Include
OverlapParameters1.FilterDescendantsInstances = {SpatialQueryWhitelist}

local OverlapParameters2 = OverlapParams.new()
OverlapParameters2.MaxParts = 1
OverlapParameters2.FilterType = Enum.RaycastFilterType.Include
OverlapParameters2.FilterDescendantsInstances = OverlapParameters1.FilterDescendantsInstances

local RaycastParameters = RaycastParams.new()
RaycastParameters.IgnoreWater = true
RaycastParameters.FilterType = Enum.RaycastFilterType.Include
RaycastParameters.FilterDescendantsInstances = {workspace.Terrain, unpack(OverlapParameters1.FilterDescendantsInstances)}

task.spawn(function()
	local Plots = Hierarchy.FromPath("Root.Plots", workspace, true)

	OverlapParameters1:AddToFilter(Plots)
	OverlapParameters2:AddToFilter(Plots)
	RaycastParameters:AddToFilter(Plots)
end)

--[=[
	Returns the ancestor of <code>Instance</code> that is parented by an <strong>Instance</strong> in <code>Parents</code>.
]=]
local function FindAncestingChildOfAncestors(instance: Instance, parents: {Instance}): Instance
	while true do
		local currentParent = instance.Parent

		if not currentParent then
			break
		end

		if table.find(parents, currentParent) then
			return instance
		end

		instance = currentParent :: any
	end

	return nil :: any
end

--[=[
	Returns all <strong>Assets</strong> in <code>LocalPlot.BuildModel</code> whose bounds intersect <code>Cuboid</code>.
]=]
local function GetAssetsIntersectingCuboid(cuboid: Cuboid.Cuboid, overlapParams: OverlapParams?): {Model}
	local assets: {Model} = {}
	local ancestors: {Instance} = {LocalPlot.BuildModel, SpatialQueryWhitelist}

	for _, part in workspace:GetPartBoundsInBox(cuboid.CFrame, cuboid.Size, overlapParams) :: {BasePart} do
		local asset: Model? = FindAncestingChildOfAncestors(part, ancestors) :: any

		if asset and asset:HasTag(ASSET_TAG) and not table.find(assets, asset) then
			table.insert(assets, asset)
		end
	end

	return assets
end

--[=[
	Returns the minimum and maximum scalar dot products of each <strong>Vector3</strong> in <code>Points</code> onto <code>Vector</code>.
]=]
@native
local function GetScalarDotProductExtents(points: {Vector3}, vector: Vector3): (number, number)
	local products = table.create(#points)

	for _, point in points do
		table.insert(products, point:Dot(vector))
	end

	return math.min(unpack(products)), math.max(unpack(products))
end

--[=[
	Returns a <strong>boolean</strong> indicating whether the current placement satisfies all of the following conditions to be pushed to the <strong>Server</strong>:<br>
	1. The total number of placed <strong>Assets</strong> is less than the budget.
	2. The total number of placed <strong>Assets</strong> with <code>Id</code> is less than the budget.
	3. <code>Pivot</code> is enclosed in <code>LocalPlot.Boundary</code>.
	4. The placement is not occupied by any placed <strong>Assets</strong>.
]=]
@native
local function IsPlacementValid(): boolean
	if TotalAssets.Value >= AssetBudgets.Total or AssetCounts[Id].Value >= AssetBudgets[Id] then
		return false
	end

	local cframe = Pivot * PivotOffset

	return
		Cuboid.new(cframe, Size):IsCuboidEnclosed(LocalPlot.Boundary)
		and #GetAssetsIntersectingCuboid(Cuboid.new(cframe, Size - Vector3.one * (EPSILON * 2)), OverlapParameters2) == 0
end

--[=[
	Returns a <strong>Vector3</strong> representing the resolved pivot position of <code>Mock</code>, originating from the mouse position in <strong>Workspace</strong>.
]=]
@native
local function GetResolvedPosition(): Vector3
	local location = UserInputService:GetMouseLocation()
	local ray = workspace.CurrentCamera:ViewportPointToRay(location.X, location.Y)
	local result = workspace:Raycast(ray.Origin, ray.Direction * MAX_RAYCAST_LENGTH, RaycastParameters)

	local resolved: CFrame

	if result then
		resolved = Pivot.Rotation + result.Position

		local min, max = GetScalarDotProductExtents(Cuboid.new(resolved, Size):GetVertices(), result.Normal)
		resolved += result.Normal * ((max - min) / 2 + EPSILON)

		if SNAPPING_ENABLED then
			resolved = Cuboid.new(resolved * PivotOffsetInverse, Size):SnapToIncrement(SNAPPING_LINEAR_INCREMENT).CFrame * PivotOffset
		end

		local boundary = LocalPlot.Boundary
		local baseplateCuboid = Cuboid.new(boundary.CFrame * CFrame.new(Vector3.yAxis * -boundary.Size.Y), boundary.Size)

		do
			local mockCuboid = Cuboid.new(resolved, Size)

			if mockCuboid:IsCuboidIntersecting(baseplateCuboid) then
				resolved = mockCuboid:ResolveIntersection(baseplateCuboid).CFrame
			end
		end

		for _ = 1, MAX_RESOLVE_PASSES do
			local isResolved = true

			for _, asset in GetAssetsIntersectingCuboid(Cuboid.new(resolved, Size), OverlapParameters1) do
				resolved = Cuboid.new(resolved, Size):ResolveIntersection(Cuboid.new(asset:GetBoundingBox())).CFrame

				isResolved = false
			end

			if isResolved then
				break
			end

			local mockCuboid = Cuboid.new(resolved, Size)

			if mockCuboid:IsCuboidIntersecting(baseplateCuboid) then
				resolved = mockCuboid:ResolveIntersection(baseplateCuboid).CFrame
			end
		end

		resolved *= PivotOffsetInverse
	else
		resolved = Pivot.Rotation + ray.Origin + ray.Direction * MAX_RAYCAST_LENGTH
	end

	if SNAPPING_ENABLED then
		resolved = Cuboid.new(resolved, Size):SnapToIncrement(SNAPPING_LINEAR_INCREMENT).CFrame
	end

	return resolved.Position
end

Callback.CallForEachVarargAndConnect(function(asset: Model?)
	MockChangedDestructor:Destruct()

	if Mock then
		task.spawn(function()
			local oldMock, oldTransparency = Mock, Transparency
			local tween = TweenService:Create(oldTransparency, TweenParameters1In, {Value = 1})

			tween:Play()
			tween.Completed:Wait()

			oldMock:Destroy()
		end)
	end

	if not asset then
		Mock = nil :: any
		MockChanged:Fire(nil)

		return
	end

	local mock = asset:Clone()
	local parts: {BasePart} = Hierarchy.GetDescendantsWhichAreA(mock, "BasePart") :: any

	for _, part in parts do
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Anchored = true
	end

	local transparency = Instance.new("NumberValue")
	transparency.Value = 1

	Callback.CallAndConnect(function(transparency: number)
		for _, part in parts do
			part.LocalTransparencyModifier = transparency
		end
	end, transparency.Changed, transparency.Value)

	local pivot = mock:GetPivot()
	local cframe, size = mock:GetBoundingBox()

	local pivotOffset = pivot:Inverse() * cframe
	local pivotOffsetInverse = pivotOffset:Inverse()

	PivotAdornment.CFrame = pivotOffsetInverse

	local position, rotation = Instance.new("Vector3Value"), Instance.new("CFrameValue")
	position.Value, rotation.Value = pivot.Position, pivot.Rotation

	Callback.CallAndConnectToEach(function()
		mock:PivotTo(rotation.Value + position.Value)
	end, {position.Changed, rotation.Changed})

	local canConstruct = Instance.new("BoolValue")

	Callback.CallAndConnect(function(canConstruct)
		local color = if canConstruct then ADORNMENT_COLORS.VALID else ADORNMENT_COLORS.INVALID

		BoundaryAdornment.Color3 = color
		BoundaryAdornment.SurfaceColor3 = color
	end, canConstruct.Changed, canConstruct.Value)

	mock.Parent = workspace

	Mock = mock

	Id = mock:GetAttribute("__Id")

	Pivot = pivot
	PivotOffset = pivotOffset
	PivotOffsetInverse = pivotOffsetInverse

	Size = size

	CanConstruct = canConstruct
	Position, Rotation = position, rotation
	Transparency = transparency

	MockChanged:Fire(mock)
end, Asset.Changed, Asset.Value)

local SnappingRotaryIncrementRadians = math.rad(SNAPPING_ROTARY_INCREMENT)
local PlaceholderTransparency = math.lerp(MOCK_TRANSPARENCY, 1, PLACEHOLDER_TRANSPARENCY_ALPHA)

Callback.CallAndConnect(function(enabled: boolean)
	if not enabled then
		return
	end

	IsEnabledChangedDestructor:Add(Callback.CallAndConnect(function()
		Pivot = Pivot.Rotation + GetResolvedPosition()

		Position.Value = Pivot.Position
	end, MockChanged.Event))

	for _, connection in
		Callback.CallAndConnectToEach(function()
			CanConstruct.Value = LocalPlot and IsPlacementValid()
		end, {RunService.PreRender, AssetCounts[Id].Changed, TotalAssets.Changed, MockChanged.Event, LocalPlotChanged.Event})
	do
		IsEnabledChangedDestructor:Add(connection)
	end

	do
		local id = HttpService:GenerateGUID(false)

		RunService:BindToRenderStep(id, RESOLVE_STEP_RENDER_PRIORITY, function()
			local position = GetResolvedPosition()

			if not position:FuzzyEq(Pivot.Position, EPSILON) then
				Pivot = Pivot.Rotation + position

				TweenService:Create(Position, TweenParameters2, {Value = position}):Play()
			end
		end)

		IsEnabledChangedDestructor:Add(RunService.UnbindFromRenderStep, RunService, id)
	end

	IsEnabledChangedDestructor:Add(UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		local key = input.KeyCode
		local rotation: CFrame?

		if key == ROTATE_KEYS.X then
			rotation = CFrame.Angles(0, SnappingRotaryIncrementRadians, 0)
		elseif key == ROTATE_KEYS.Y then
			rotation = CFrame.Angles(SnappingRotaryIncrementRadians, 0, 0)
		elseif key == ROTATE_KEYS.Z then
			rotation = CFrame.Angles(0, 0, SnappingRotaryIncrementRadians)
		end

		if rotation then
			Pivot = rotation * Pivot.Rotation + Pivot.Position

			TweenService:Create(Rotation, TweenParameters3, {Value = Pivot.Rotation}):Play()
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if not CanConstruct.Value then
			FailedConstructionSound:Play()

			local timestamp = time()

			while true do
				for _, adornment in Adornments do
					adornment.Transparency = 1
				end

				wait()

				for _, adornment in Adornments do
					adornment.Transparency = 0
				end

				if time() - timestamp >= CANNOT_CONSTRUCT_ADORNMENT_FLASH_DURATION then
					break
				end

				wait()
			end

			return
		end

		local asset: Model = Asset.Value :: any

		local placeholder = asset:Clone()
		placeholder:PivotTo(Pivot)

		for _, part: BasePart in Hierarchy.GetDescendantsWhichAreA(placeholder, "BasePart") :: any do
			part.LocalTransparencyModifier = PlaceholderTransparency
			part.CanCollide = false
			part.CanTouch = false
			part.CastShadow = false
			part.Anchored = true
		end

		local boundary = BoundaryAdornmentCopy:Clone()
		boundary.Color3 = ADORNMENT_COLORS.PENDING
		boundary.SurfaceColor3 = ADORNMENT_COLORS.PENDING
		boundary.SurfaceTransparency = PlaceholderTransparency
		boundary.Adornee = placeholder
		boundary.Parent = placeholder

		placeholder.Parent = SpatialQueryWhitelist

		local thread = Instance.new("BindableEvent")
		local destructor = Destructor.new()

		destructor:Add(task.spawn(function()
			local _, success = xpcall(function(success: boolean?, ...)
				assert(select("#", ...) == 0, `Return values of method 'InvokeServer' of {ConstructAsset} are not unary.`)
				assert(success == nil or type(success) == "boolean", `Return value #1 of method 'InvokeServer' of {ConstructAsset} is {success} and not a boolean or nil.`)

				return success
			end, function(message: string)
				warn(debug.traceback(message))
			end, ConstructAsset:InvokeServer(asset, Pivot))

			thread:Fire(success)
		end))

		destructor:Add(task.delay(EXPIRY_DELAY, thread.Fire, thread, nil))

		for _, event in {Enabled.Changed, LocalPlotChanged.Event} do
			destructor:Add(event:Connect(function()
				thread:Fire(nil)
			end))
		end

		local success: boolean? = thread.Event:Wait()

		destructor:Destruct()

		if success then
			SuccessfulConstructionSound:Play()
		else
			FailedConstructionSound:Play()
		end

		if not success then
			local color = if success == false then ADORNMENT_COLORS.INVALID else ADORNMENT_COLORS.UNKNOWN

			boundary.Color3 = color
			boundary.SurfaceColor3 = color

			task.wait(CONSTRUCT_ASSET_INVOKE_FAILURE_DESTROY_DELAY)
		end

		placeholder:Destroy()
	end))
end, IsEnabled.Changed, IsEnabled.Value)

Callback.CallAndConnect(function(mock: Model?)
	if not mock then
		return
	end

	MockChangedDestructor:Add(Callback.CallAndConnect(function(enabled: boolean)
		if enabled then
			mock.Parent = workspace

			TweenService:Create(Transparency, TweenParameters1Out, {
				Value = MOCK_TRANSPARENCY
			}):Play()

			return
		end

		local tween = TweenService:Create(Transparency, TweenParameters1In, {Value = 1})

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				mock.Parent = nil
			end
		end)

		tween:Play()
	end, IsEnabled.Changed, IsEnabled.Value))
end, MockChanged.Event, Mock)

Callback.CallAndConnectToEach(function()
	local adornee = if IsEnabled.Value then Mock else nil

	for _, adornment in Adornments do
		adornment.Adornee = adornee
	end
end, {MockChanged.Event, IsEnabled.Changed})

local Tweens: {Tween} = table.create(3)
local AxialAdornmentStartOffsets: {[LineHandleAdornment]: Vector3} = {}

for axis, adornment in AxialAdornments do
	table.insert(Tweens, TweenService:Create(adornment, TweenParameters4, {
		SizeRelativeOffset = axis * AXIAL_ADORNMENT_END_OFFSET,
		Length = AXIAL_ADORNMENT_END_LENGTH
	}))

	AxialAdornmentStartOffsets[adornment] = axis * AXIAL_ADORNMENT_START_OFFSET
end

Callback.CallAndConnect(function(enabled: boolean)
	if not enabled then
		for axis, adornment in AxialAdornments do
			adornment.SizeRelativeOffset = AxialAdornmentStartOffsets[adornment]
			adornment.Length = AXIAL_ADORNMENT_START_LENGTH
		end

		return
	end

	for _, tween in Tweens do
		tween:Play()

		IsEnabledChangedDestructor:Add(tween.Pause, tween)
	end
end, IsEnabled.Changed, IsEnabled.Value)

-- </Script #65 End>
--[[
<Script #66 Begin>
<Metadata Begin>
Name: "Run"
Type: LocalScript
Path: StarterPlayer.StarterCharacterScripts.Run
Size: 1509 Character(s), 50 Line(s)
</Metadata End>
]]

--!strict
local SCRIPT_NAME = if script then script.Name else "Walk Speed"

local DEFAULT_WALK_SPEED = 2 ^ 3 -- Stud(s) / Second

local WALK_SPEEDS = {
	[Enum.KeyCode.LeftShift] = 2 ^ 5 * 3 / 4,
	[Enum.KeyCode.LeftControl] = 2 ^ 7
}

WALK_SPEEDS[Enum.KeyCode.RightShift] = WALK_SPEEDS[Enum.KeyCode.LeftShift]
WALK_SPEEDS[Enum.KeyCode.RightControl] = WALK_SPEEDS[Enum.KeyCode.LeftControl]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:WaitForChild("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local LocalPlayer = Players.LocalPlayer

local Character: Model = script and (script.Parent or script:GetPropertyChangedSignal("Parent"):Wait())

if not Character then
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Humanoid: Humanoid = Character:WaitForChild("Humanoid") :: any

local Keys: {Enum.KeyCode} = {}

for key in WALK_SPEEDS do
	table.insert(Keys, key)
end

ContextActionService:BindAction(SCRIPT_NAME, Callback.CallAndReturn(function()
	local maxSpeed = DEFAULT_WALK_SPEED

	for key, speed in WALK_SPEEDS do
		if UserInputService:IsKeyDown(key) and speed > maxSpeed then
			maxSpeed = speed
		end
	end

	Humanoid.WalkSpeed = maxSpeed
end), false, unpack(Keys))

-- </Script #66 End>
--[[
<Script #67 Begin>
<Metadata Begin>
Name: "Tooltip"
Type: LocalScript
Path: StarterGui.Tooltip.Tooltip
Size: 3743 Character(s), 130 Line(s)
</Metadata End>
]]

--!strict
local HOVER_UPDATE_FREQUENCY = 2 ^ 4 * 3 / 4 -- Hertz

local POSITION_OFFSET = Vector2.new(0, -2 ^ 4)

local SHOW_DELAY = 1 -- Second(s)
local HIDE_DELAY = 3 ^ -1 -- Second(s)

local SHOW_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER = 2
local HIDE_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER = 3 / 2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TOOLTIP_TAG = CONSTANTS.Gui.TOOLTIP_TAG

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Gui = script.Parent
local Group = Gui:WaitForChild("Group")
local Label = Group:WaitForChild("Text")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Mouse = LocalPlayer:GetMouse()

local IsVisible = ValueWrapper.new(false)

local TweenParameters1 = TweenInfo.new(TWEENS.DURATION / SHOW_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParameters2 = TweenInfo.new(TWEENS.DURATION / HIDE_TRANSPARENCY_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.In)

local ShowTween = TweenService:Create(Group, TweenParameters1, {GroupTransparency = 0})
local HideTween = TweenService:Create(Group, TweenParameters2, {GroupTransparency = 1})

HideTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		Group.Visible = false
	end
end)

Callback.CallAndConnect(function(visible: boolean)
	if visible then
		Group.Visible = true

		ShowTween:Play()
	else
		HideTween:Play()
	end
end, IsVisible.Changed, IsVisible.Value)

local Hover: GuiObject?
local HoverChangedDestructor = Destructor.new()

local HoverUpdateInterval = HOVER_UPDATE_FREQUENCY ^ -1

while task.wait(HoverUpdateInterval) do
	local hover: GuiObject?

	for _, guiObject: GuiObject in PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y) do
		if
			guiObject.Interactable
			and guiObject:HasTag(TOOLTIP_TAG)
			and not guiObject:IsDescendantOf(Group)
		then
			hover = guiObject

			break
		end
	end

	if hover == Hover then
		continue
	end

	HoverChangedDestructor:Destruct()
	Hover = hover

	if not hover then
		HoverChangedDestructor:Add(task.delay(HIDE_DELAY, IsVisible.Set, IsVisible, false))

		continue
	end

	task.spawn(function()
		if not IsVisible.Value then
			HoverChangedDestructor:Add(task.delay(SHOW_DELAY, coroutine.running()))

			coroutine.yield()

			IsVisible:Set(true)
		end

		for _, connection in
			Callback.CallAndConnectToEach(@native function()
				local groupSize, groupAnchorPoint = Group.AbsoluteSize, Group.AnchorPoint

				local position =
					(UserInputService:GetMouseLocation() + POSITION_OFFSET)
					:Min(Gui.AbsoluteSize - groupSize * (Vector2.one - groupAnchorPoint))
					:Max(groupSize * groupAnchorPoint)

				Group.Position = UDim2.fromOffset(position.X, position.Y)
			end, {Mouse.Move, Group:GetPropertyChangedSignal("AbsoluteSize")})
		do
			HoverChangedDestructor:Add(connection)
		end

		HoverChangedDestructor:Add(Callback.CallAndConnect(function()
			Label.Text = "Flushing Rich Text..."

			RunService.PreAnimation:Wait()

			Label.Text = hover:GetAttribute("_TooltipText")
		end, hover:GetAttributeChangedSignal("_TooltipText")))
	end)
end

-- </Script #67 End>
--[[
<Script #68 Begin>
<Metadata Begin>
Name: "GuiEnabler"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Gui.GuiEnabler
Size: 619 Character(s), 16 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local ENABLE_TAG = CONSTANTS.Gui.ENABLE_TAG

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

Callback.CallForEachVarargAndConnect(function(screenGui: ScreenGui)
	screenGui.Enabled = true
end, CollectionService:GetInstanceAddedSignal(ENABLE_TAG), unpack(CollectionService:GetTagged(ENABLE_TAG)))

-- </Script #68 End>
--[[
<Script #69 Begin>
<Metadata Begin>
Name: "StatisticsBar"
Type: LocalScript
Path: StarterGui.Widgets.Top Bar.Body.Statistics.StatisticsBar
Size: 4795 Character(s), 135 Line(s)
</Metadata End>
]]

--!strict
--!native
local DELIMITER_TEXT_TRANSPARENCY = .5

local SERVICE_NAMES_TO_PROBE_REMOTES = {
	"ReplicatedStorage",
	"Players",
	"ReplicatedFirst"
}

local TOOLTIP_TEXT_FONT_FAMILY = `rbxassetid://{16658246179 --[[ Builder Mono ]]}`
local TOOLTIP_TEXT_FONT_WEIGHT = Enum.FontWeight.Regular

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))
local String = require(Libraries:WaitForChild("String"))

local LocalPlayer = Players.LocalPlayer

local Label = script.Parent

local Statistics: {[string]: any} = {
	RndrFps = 0,
	RndrFpsLo = math.huge,
	RndrFpsHi = 0,
	NetPkt = 0,
	GpuUtil = 0
}

local StatisticsCopy = table.clone(Statistics)

RunService.PreRender:Connect(function(deltaTime: number)
	Statistics.RndrFps += 1
	Statistics.RndrFpsLo = math.min(Statistics.RndrFpsLo, 1 / deltaTime)
	Statistics.RndrFpsHi = math.max(Statistics.RndrFpsHi, 1 / deltaTime)

	Statistics.GpuUtil += Stats.RenderGPUFrameTime
end)

do
	local RemoteCount = 0

	for _, name in SERVICE_NAMES_TO_PROBE_REMOTES do
		local remotes: {RemoteEvent} = Hierarchy.GetDescendantsWhichAreA(game:GetService(name), "BaseRemoteEvent") :: any

		for _, remote in remotes do
			remote.OnClientEvent:Connect(function()
				Statistics.NetPkt += 1
			end)
		end

		RemoteCount += #remotes
	end

	print(`[{script}]: Listening to {RemoteCount} BaseRemoteEvent(s).`)
end

local ServerStartedTimestamp: number

Callback.CallAndConnect(function()
	ServerStartedTimestamp = workspace:GetAttribute("ServerStartedTimestamp") or 0
end, workspace:GetAttributeChangedSignal("ServerStartedTimestamp"))

local TooltipTextFontWeightName = TOOLTIP_TEXT_FONT_WEIGHT.Name

while true do
	local character = LocalPlayer.Character
	local humanoidRootPart: BasePart = character and character:FindFirstChild("HumanoidRootPart") :: any

	-- Render
	Statistics.RndrFpsLo = math.floor(Statistics.RndrFpsLo)
	Statistics.RndrFpsHi = math.floor(Statistics.RndrFpsHi)
	Statistics.RndrTris = Stats.UI2DTriangleCount + Stats.UI3DTriangleCount + Stats.SceneTriangleCount + Stats.ShadowsTriangleCount
	Statistics.RndrDrws = Stats.UI2DDrawcallCount + Stats.UI3DDrawcallCount + Stats.SceneDrawcallCount + Stats.ShadowsDrawcallCount
	Statistics.GpuUtil = `{String.FormatNumber(Statistics.GpuUtil * 100, 1)}%`

	-- Memory
	Statistics.MemTot = `{String.FormatNumber(Stats:GetTotalMemoryUsageMb() / 1e3, 3)} GB`
	Statistics.MemLua = `{String.FormatNumber(gcinfo() / 1e3, 2)} MB`
	Statistics.MemInst = Stats.InstanceCount

	-- Network
	Statistics.NetPing = if not RunService:IsStudio() then `{String.FormatNumber(LocalPlayer:GetNetworkPing() * 2e3, 1)} ms` else "*Local Server*"
	Statistics.NetIn = `{String.FormatNumber(Stats.DataReceiveKbps, 2)} KB/s`
	Statistics.NetOut = `{String.FormatNumber(Stats.DataSendKbps, 2)} KB/s`
	Statistics.NetPkt = `{Statistics.NetPkt} pkt/s`

	-- Physics
	Statistics.PhysRate = `{String.FormatNumber(workspace:GetRealPhysicsFPS(), 1)}/s`
	Statistics.PhysAwk = workspace:GetNumAwakeParts()
	Statistics.PhysCtcs = Stats.ContactsCount
	Statistics.PhysPrim = Stats.PrimitivesCount
	Statistics.PhysThrl = `{workspace:GetPhysicsThrottling()}%`
	Statistics.PhysTime = `{String.FormatNumber(Stats.PhysicsStepTime * 1e3, 2)} ms`

	-- Character
	if humanoidRootPart then
		Statistics.CharPos = (humanoidRootPart.Position + Vector3.one / 2):Floor()
		Statistics.CharSpd = `{String.FormatNumber(humanoidRootPart.AssemblyLinearVelocity.Magnitude, 1)} SPS`
		Statistics.CharRot = `{String.FormatNumber(math.deg(humanoidRootPart.AssemblyAngularVelocity.Magnitude), 1)}°/s`
	else
		local text = "*No Humanoid Root Part*"

		Statistics.CharPos, Statistics.CharSpd, Statistics.CharRot = text, text, text
	end

	local localeId = LocalPlayer.LocaleId

	-- Uptime
	Statistics.UpCli = DateTime.fromUnixTimestamp(time()):FormatUniversalTime("H:m:s", localeId)
	Statistics.UpSrv = DateTime.fromUnixTimestamp(os.time() - ServerStartedTimestamp):FormatUniversalTime("H:m:s", localeId)

	local statistics: {string} = {}

	for statistic, value in Statistics do
		table.insert(statistics, `{statistic}: {value}`)
	end

	table.sort(statistics)

	Label.Text = table.concat(statistics, ` <font transparency="{DELIMITER_TEXT_TRANSPARENCY}">|</font> `)
	Label:SetAttribute("_TooltipText", `<font family="{TOOLTIP_TEXT_FONT_FAMILY}" weight="{TooltipTextFontWeightName}">{table.concat(statistics, "\n")}</font>`)

	Statistics = table.clone(StatisticsCopy)

	task.wait(1 - time() % 1)
end

-- </Script #69 End>
--[[
<Script #70 Begin>
<Metadata Begin>
Name: "Clock"
Type: LocalScript
Path: StarterGui.Widgets.Top Bar.Body.Clock.Clock
Size: 1716 Character(s), 48 Line(s)
</Metadata End>
]]

--!strict
local RENDER_PRIORITY = Enum.RenderPriority.Last.Value

local TOOLTIP_TEXT_FONT_FAMILY = `rbxassetid://{16658246179 --[[ Builder Mono ]]}`
local TOOLTIP_TEXT_FONT_WEIGHT = Enum.FontWeight.Regular

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Functions = Modules:WaitForChild("Functions")
local GetGlobalTimestamp = require(Functions:WaitForChild("GetGlobalTimestamp"))

local LocalPlayer = Players.LocalPlayer

local Label = script.Parent

local Timestamp = 0

local TimeZone = os.date("%Z")
local TimeZoneAcronym = TimeZone:gsub("[%l%s]+", "")

local UtcOffset = os.date("%z")

print(`[{script}]: Time Zone: {TimeZone} ({TimeZoneAcronym}) (UTC {UtcOffset})`)

local TooltipTextFontWeightName = TOOLTIP_TEXT_FONT_WEIGHT.Name

RunService:BindToRenderStep(HttpService:GenerateGUID(false), RENDER_PRIORITY, @native function()
	local timestamp = GetGlobalTimestamp()
	local floor = math.floor(timestamp)

	if floor == Timestamp then
		return
	end

	local dateTime = DateTime.fromUnixTimestampMillis(timestamp * 1e3)
	local localeId = LocalPlayer.LocaleId

	Label.Text = `{dateTime:FormatLocalTime("l LTS", localeId)} {TimeZoneAcronym} (Game-Time: {Lighting.TimeOfDay})`
	Label:SetAttribute("_TooltipText", `<font family="{TOOLTIP_TEXT_FONT_FAMILY}" weight="{TooltipTextFontWeightName}">{dateTime:ToIsoDate()}\n{dateTime:FormatLocalTime("ddd, D MMM YYYY h:mm:ss.SSS a", localeId)}\n{TimeZone} {UtcOffset}</font>`)

	Timestamp = floor
end)

-- </Script #70 End>
--[[
<Script #71 Begin>
<Metadata Begin>
Name: "AssetPoolsHandlerServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Plots.Assets.AssetPoolsHandlerServer
Size: 683 Character(s), 24 Line(s)
</Metadata End>
]]

--!strict
local ServerStorage = game:GetService("ServerStorage")

local Modules = ServerStorage:WaitForChild("Modules")

local Services = Modules:WaitForChild("Services")
local AssetPools = require(Services:WaitForChild("AssetPoolsServer"))
local Plots = require(Services:WaitForChild("PlotsServer"))

local AssetPoolClass = AssetPools.AssetPool
local PlotClass = Plots.Plot

Plots.PlotAdded:Connect(function(plotModel: Model)
	AssetPoolClass.new(PlotClass.GetPlot(plotModel))
end)

Plots.PlotRemoving:Connect(function(plotModel: Model)
	local plot = Plots.Plots[plotModel]
	local assetPool = plot and AssetPools.AssetPools[plot]

	if assetPool then
		assetPool:Destruct()
	end
end)

-- </Script #71 End>
--[[
<Script #72 Begin>
<Metadata Begin>
Name: "DefaultLuauOptimizerLevel"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.DefaultLuauOptimizerLevel
Size: 847 Character(s), 25 Line(s)
</Metadata End>
]]

--!strict
--[[
Optimization (Set w/ --!optimize [0-2] Hot Comment) Table:
┌───────┬─────────────────┬──────────┐
│ Level │ Closure Caching │ Inlining │
├───────┼─────────────────┼──────────┤
│ 0     │ No              │ No       │
│ 1     │ Yes             │ No       │
│ 2     │ Yes             │ Yes      │
└───────┴─────────────────┴──────────┘
]]

local Closure = function()
	return function() end
end

-- Check Closure Caching
if Closure() ~= Closure() then
	return 0
end

-- Check Inlining
return if debug.info(1, "f") == (function()
	return debug.info(1, "f")
end)() then 2 else 1

-- </Script #72 End>
--[[
<Script #73 Begin>
<Metadata Begin>
Name: "Destructor"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.Destructor
Size: 2720 Character(s), 126 Line(s)
</Metadata End>
]]

--!strict
--!native
local Destructor = {} :: DestructorImplementation
Destructor.__index = Destructor

type DestructorImplementation = {
	__index: DestructorImplementation,
	__len: (self: Destructor) -> number,
	__iter: (self: Destructor) -> (Destructor, number?) -> (number?, any),
	IsDestructor: (value: any) -> boolean,
	new: () -> Destructor,
	Add: <Value>(self: Destructor, value: Value, ...any) -> Value,
	Remove: <Value>(self: Destructor, value: Value) -> Value,
	Destruct: (self: Destructor) -> ()
}

type DestructorProperties = {
	_Values: {any}
}

export type Destructor = typeof(
	setmetatable(
		{} :: DestructorProperties,
		{} :: DestructorImplementation
	)
)

local Destructors = {
	["function"] = function(callback: (...any) -> (...any))
		xpcall(callback, function(message: string)
			warn(debug.traceback(message))
		end)
	end,
	table = function(source: {[any]: any})
		xpcall(function()
			local destruct = source.Destruct

			if type(destruct) == "function" then
				destruct(source)

				return
			end

			local destroy = source.Destroy

			if type(destroy) == "function" then
				destroy(source)
			end
		end, function(message: string)
			warn(debug.traceback(message))
		end)
	end,
	thread = function(thread: thread)
		pcall(task.cancel, thread)
	end,
	RBXScriptConnection = function(connection: RBXScriptConnection)
		connection:Disconnect()
	end,
	Instance = function(instance: Instance)
		if instance:IsA("Tween") then
			instance:Cancel()
		end

		instance:Destroy()
	end
}

function Destructor:__len(): number
	return #self._Values
end

function Destructor:__iter(): (Destructor, number?) -> (number?, any)
	return next, self._Values
end

function Destructor.IsDestructor(value: any): boolean
	return type(value) == "table" and getmetatable(value) == Destructor
end

function Destructor.new(): Destructor
	return setmetatable({
		_Values = {}
	}, Destructor)
end

function Destructor:Add<Value>(value: Value, ...: any): Value
	if type(value) == "function" and select("#", ...) ~= 0 then
		local arguments = {...}

		local function _DestructorWrapper()
			value(unpack(arguments))
		end

		table.insert(self._Values, _DestructorWrapper)
	else
		table.insert(self._Values, value)
	end

	return value
end

function Destructor:Remove<Value>(value: Value): Value
	local values = self._Values
	local index = table.find(values, value)

	return index and table.remove(values, index) :: any
end

function Destructor:Destruct()
	local values = self._Values
	local index, value = next(values)

	while value ~= nil do
		values[index :: any] = nil

		local destructor = Destructors[typeof(value)]

		if destructor then
			destructor(value)
		end

		index, value = next(values)
	end
end

return Destructor

-- </Script #73 End>
--[[
<Script #74 Begin>
<Metadata Begin>
Name: "PlotManager"
Type: LocalScript
Path: StarterGui.Widgets.Widgets.Plot Manager.Body.PlotManager
Size: 18478 Character(s), 625 Line(s)
</Metadata End>
]]

--!strict
local BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY = .5

local PENDING_TEXT_FLASH_SPEED = 2 ^ 3 -- Hertz

local INFINITY_SYMBOL = utf8.char(0x221E)

local RED_COLOR = Color3.fromRGB(207, 0, 0)

local ASSET_ID_URI_PREFIX = "rbxassetid://"

local STATUS_ICON_IDS = {
	PENDING = {
		105043704205265,
		71483648723539,
		132869180904357,
		98980033179438,
		122507204230274
	},
	GRANTED = 97393447506633,
	DENIED = 81636385049253,
	UNKNOWN = 127528476885014
}

local STATUS_ICON_CYCLE_DURATION = 3 / 2 -- Second(s)

local STATUS_ICON_GRANTED_COLOR = Color3.fromRGB(0, 204, 0)
local STATUS_ICON_DENIED_COLOR = Color3.fromRGB(204, 0, 0)
local STATUS_ICON_UNKNOWN_COLOR = Color3.fromRGB(204, 204, 0)

local STATUS_ICON_HIDE_DELAY = 1 -- Second(s)

local PLOT_DEBUG_UPDATE_FREQUENCY = 2 / 3 -- Hertz
local PLOT_DEBUG_UPDATE_FREQUENCY_PRECISION = 2 -- Decimal Place(s)

local USERNAME_TEXT_TRANSPARENCY = .5

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local PLOTS = CONSTANTS.Plots
local PLOT_TAG = PLOTS.TAG
local MAX_OCCUPANTS = PLOTS.MAX_OCCUPANTS

local LIGHT_COLOR = CONSTANTS.Gui.ColorScheme.LIGHT

local TWEENS = CONSTANTS.Tweens

local EXPIRY_DELAY = CONSTANTS.RemoteInvocations.EXPIRY_DELAY

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Widgets = require(Controllers:WaitForChild("Widgets"))

local Functions = Modules:WaitForChild("Functions")
local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))
local Table = require(Libraries:WaitForChild("Table"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlotRemotes = Remotes:WaitForChild("Plots")
local SetPlotRemote = PlotRemotes:WaitForChild("SetPlot")

local PlotsManager = script.Parent

local Body = PlotsManager:WaitForChild("Body")

local LeftFrame = Body:WaitForChild("Secondary")
local RightFrame = Body:WaitForChild("Primary")

local CurrentPlotFrame = RightFrame:WaitForChild("Current Plot")
local CurrentPlotLabel = CurrentPlotFrame:WaitForChild("Text")
local CurrentPlotOccupancyLabel = CurrentPlotFrame:WaitForChild("Occupancy")

local PlotsList = RightFrame:WaitForChild("Plot List")
local RequestsList = RightFrame:WaitForChild("Request List")

local PlotDebugFrame = LeftFrame:WaitForChild("Plot Debug")
local PlotDebugLabel = PlotDebugFrame:WaitForChild("Text")

local OccupantsList = LeftFrame:WaitForChild("Occupants List")

local PlotButton = script:WaitForChild("Plot")
local OccupancyLabel = script:WaitForChild("Occupancy")
local StatusIcon = script:WaitForChild("Status")
local RequestFrame = script:WaitForChild("Request")
local Ruler = script:WaitForChild("Ruler")
local OccupantFrame = script:WaitForChild("Occupant")

local OccupantClass = Plots.Occupant

local LocalPlayer = Players.LocalPlayer
local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChanged = Instance.new("BindableEvent")
local LocalPlotChangedDestructor = Destructor.new()

local Widget = Widgets.PlotManager
local Visible = Widget.Visible

local IsOwner = ValueWrapper.new(false)
local IsLeftFrameExpanded = ValueWrapper.new(false)

local TweenParameters1In = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.In)
local TweenParameters1Out = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParameters1InOut = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.InOut)
local TweenParameters2 = TweenInfo.new(PENDING_TEXT_FLASH_SPEED ^ -1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

do
	local IconIds = {Table.DeepUnpack(STATUS_ICON_IDS)}
	local IconUris: {string} = table.create(#IconIds)

	for _, id in IconIds do
		table.insert(IconUris, ASSET_ID_URI_PREFIX .. id)
	end

	task.spawn(ContentProvider.PreloadAsync, ContentProvider, IconUris)
end

local TabWidth = PlotDebugLabel.TextSize

task.spawn(function()
	local getTextBoundsParameters = Instance.new("GetTextBoundsParams")
	getTextBoundsParameters.Text = "\t"

	local fontFace = PlotDebugLabel.FontFace
	getTextBoundsParameters.Font = Font.new(fontFace.Family, fontFace.Weight, fontFace.Style)

	getTextBoundsParameters.Size = PlotDebugLabel.TextSize
	getTextBoundsParameters.Width = math.huge
	getTextBoundsParameters.RichText = PlotDebugLabel.RichText

	local timestamp = os.clock()

	local _, tabWidth = xpcall(TextService.GetTextBoundsAsync, function(message: string)
		warn(debug.traceback(message))
	end, TextService, getTextBoundsParameters)

	if tabWidth then
		TabWidth = tabWidth.X
	end

	print(`[{script}]: Computed Tab Width in {math.floor((os.clock() - timestamp) * 1e3)} ms: {TabWidth}px`)
end)

--[=[
	Returns the number of <strong>Occupants</strong> in <code>PlotModel</code>.
]=]
local function GetPlotOccupancy(plotModel: Model?): number
	local plot = plotModel and Plots.Plots[plotModel]

	return if plot then #plot.Occupants else 0
end

local PlotFullColorHexadecimal = RED_COLOR:ToHex()
local MaxOccupantsString = if MAX_OCCUPANTS == math.huge then INFINITY_SYMBOL else tostring(MAX_OCCUPANTS)

--[=[
	Returns a <strong>string</strong> representing a fraction where the number of <strong>Occupants</strong> in <strong>PlotModel</strong> is the numerator and the maximum possible number of <strong>Occupants</strong> is the denominator. If the numerator is greater than or equal to the denominator, the numerator will be formatted with rich text font color markup.
]=]
local function GetPlotOccupancyFraction(plotModel: Model): string
	local occupantCount: number | string = GetPlotOccupancy(plotModel)

	if occupantCount >= MAX_OCCUPANTS then
		occupantCount = `<font color="#{PlotFullColorHexadecimal}">{occupantCount}</font>`
	end

	return `{occupantCount} / {MaxOccupantsString}`
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>PlotModel</code> can be joined.
]=]
local function CanJoinPlot(plotModel: Model?): boolean
	return plotModel ~= (LocalPlot and LocalPlot.PlotModel) and GetPlotOccupancy(plotModel) < MAX_OCCUPANTS
end

--[=[
	Returns the maximum number of leading tabs in <code>Source</code>.
]=]
local function GetMaxLeadingTabs(source: string): number
	local maxTabs = 0

	for line in source:gmatch("[^\r\n]+") do
		local tabs = line:match("^(\t*)")

		if tabs then
			maxTabs = math.max(maxTabs, #tabs)
		end
	end

	return maxTabs
end

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	LocalPlot = LocalOccupant.Plot :: any
	LocalPlotChanged:Fire()

	IsLeftFrameExpanded:Set(not not LocalPlot)

	if not LocalPlot then
		return
	end

	local owner = LocalPlot.Owner

	for _, connection in
		Callback.CallAndConnectToEach(function(player: Player?)
			IsOwner:Set(player == LocalPlayer)
		end, {LocalPlot.OwnerChanged, LocalPlot.Destructing}, owner and owner.Player)
	do
		LocalPlotChangedDestructor:Add(connection)
	end
end, LocalOccupant.PlotChanged)

Callback.CallAndConnect(function()
	CurrentPlotLabel.Text = `Current Plot: {if LocalPlot then `'{LocalPlot.PlotModel}'` else "<None>"}`
	CurrentPlotOccupancyLabel.Visible = not not LocalPlot

	if not LocalPlot then
		return
	end

	for _, connection in
		Callback.CallAndConnectToEach(function()
			task.defer(function()
				CurrentPlotOccupancyLabel.Text = GetPlotOccupancyFraction(LocalPlot and LocalPlot.PlotModel)
			end)
		end, {LocalPlot.OccupantAdded, LocalPlot.OccupantRemoving, LocalPlot.Destructing})
	do
		LocalPlotChangedDestructor:Add(connection)
	end
end, LocalPlotChanged.Event)

local StatusIconUpdateInterval = STATUS_ICON_CYCLE_DURATION / #STATUS_ICON_IDS.PENDING

Callback.CallForEachVarargAndConnect(function(plotModel: Model?)
	local plotButton = PlotButton:Clone()
	local plotButtonLabel = plotButton:WaitForChild("Text")

	if plotModel then
		plotButton.Name = plotModel.Name
		plotButtonLabel.Text = `Join '{plotModel}'`
	else
		plotButton.Name = ""
		plotButtonLabel.Text = "Leave Current"
	end

	task.spawn(function()
		while true do
			plotButton.MouseButton1Click:Wait()

			plotButton.Interactable = false

			local statusIcon = StatusIcon:Clone()
			statusIcon.Parent = plotButton

			local destructor = Destructor.new()

			destructor:Add(TweenService:Create(plotButtonLabel, TweenParameters2, {
				TextTransparency = BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
			})):Play()

			destructor:Add(task.spawn(function()
				while true do
					for _, id in STATUS_ICON_IDS.PENDING do
						statusIcon.Image = ASSET_ID_URI_PREFIX .. id

						task.wait(StatusIconUpdateInterval)
					end
				end
			end))

			TweenService:Create(statusIcon, TweenParameters1Out,
				{Size = UDim2.new(0, 16, 1, 0)}
			):Play()

			local success = Plots.SetPlot(plotModel)

			destructor:Destruct()

			local canJoin = CanJoinPlot(plotModel)

			plotButton.Interactable = canJoin
			plotButtonLabel.TextTransparency = if canJoin then 0 else BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY

			if success then
				statusIcon.Image = ASSET_ID_URI_PREFIX .. STATUS_ICON_IDS.GRANTED
				statusIcon.ImageColor3 = STATUS_ICON_GRANTED_COLOR
			elseif success == false then
				statusIcon.Image = ASSET_ID_URI_PREFIX .. STATUS_ICON_IDS.DENIED
				statusIcon.ImageColor3 = STATUS_ICON_DENIED_COLOR
			else
				statusIcon.Image = ASSET_ID_URI_PREFIX .. STATUS_ICON_IDS.UNKNOWN
				statusIcon.ImageColor3 = STATUS_ICON_UNKNOWN_COLOR
			end

			task.delay(STATUS_ICON_HIDE_DELAY, function()
				local tween = TweenService:Create(statusIcon, TweenParameters1In,
					{Size = UDim2.fromScale(0, 1)}
				)

				tween:Play()
				tween.Completed:Wait()

				statusIcon:Destroy()
			end)
		end
	end)

	plotButton.Parent = PlotsList

	if not plotModel then
		task.spawn(Callback.CallAndConnect, function()
			local canJoin = CanJoinPlot(nil)

			plotButton.Interactable = canJoin
			plotButtonLabel.TextTransparency = if canJoin then 0 else BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
		end, LocalPlotChanged.Event)

		return
	end

	local occupancyLabel = OccupancyLabel:Clone()

	task.spawn(Callback.CallAndConnectToEach, function(newPlotModel: Model)
		if newPlotModel ~= plotModel then
			return
		end

		local plot = plotModel and Plots.Plots[plotModel]

		local connections = Callback.CallAndConnectToEach(function()
			task.defer(function()
				local canJoin = CanJoinPlot(plotModel)

				plotButton.Interactable = canJoin
				plotButtonLabel.TextTransparency = if canJoin then 0 else BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY

				occupancyLabel.Text = GetPlotOccupancyFraction(plotModel)
			end)
		end, if plot then {plot.OccupantAdded, plot.OccupantRemoving} else {})

		if not plot then
			return
		end

		plot.Destructing:Wait()

		for _, connection in connections do
			connection:Disconnect()
		end
	end, {Plots.PlotAdded, Plots.PlotRemoving} :: any, plotModel)

	occupancyLabel.Parent = plotButton
end, CollectionService:GetInstanceAddedSignal(PLOT_TAG), nil, unpack(CollectionService:GetTagged(PLOT_TAG)))

SetPlotRemote.OnClientInvoke = function(player: Player): boolean?
	local requestFrame = RequestFrame:Clone()
	local promptLabel = requestFrame:FindFirstChild("Prompt")
	local grantButton = requestFrame:FindFirstChild("Grant")
	local denyButton = requestFrame:FindFirstChild("Deny")

	promptLabel.Text = `Let {player} Join?`
	requestFrame.Parent = RequestsList

	TweenService:Create(requestFrame, TweenParameters1Out, {
		Size = UDim2.new(1, 0, 0, 16)
	}):Play()

	local thread = Instance.new("BindableEvent")
	local destructor = Destructor.new()

	destructor:Add(grantButton.MouseButton1Click:Connect(function()
		thread:Fire(true)
	end))

	destructor:Add(denyButton.MouseButton1Click:Connect(function()
		thread:Fire(false)
	end))

	destructor:Add(task.delay(EXPIRY_DELAY, thread.Fire, thread, nil))

	for _, event in {LocalPlotChanged.Event :: any, player.Destroying} do
		destructor:Add(event:Connect(function()
			thread:Fire(nil)
		end))
	end

	local occupants = LocalPlot.Occupants

	destructor:Add(task.spawn(function()
		while true do
			LocalPlot.OccupantAdded:Wait()

			if #occupants >= MAX_OCCUPANTS then
				thread:Fire(nil)
			end
		end
	end))

	local authorized: boolean? = thread.Event:Wait()

	destructor:Destruct()

	requestFrame.Interactable = false

	grantButton.TextColor3, denyButton.TextColor3 = LIGHT_COLOR, LIGHT_COLOR
	grantButton.TextTransparency, denyButton.TextTransparency = BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY, BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY

	local tween = TweenService:Create(requestFrame, TweenParameters1In, {
		Size = UDim2.fromScale(1, 0)
	})

	tween.Completed:Connect(function()
		requestFrame:Destroy()
	end)

	tween:Play()

	return authorized
end

local ShowLeftFrameTween = TweenService:Create(LeftFrame, TweenParameters1InOut, {Size = UDim2.fromScale(.5, 1)})
local HideLeftFrameTween = TweenService:Create(LeftFrame, TweenParameters1InOut, {Size = UDim2.fromScale(0, 1)})

HideLeftFrameTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		LeftFrame.Visible = false
	end
end)

Callback.CallAndConnect(function(visible: boolean)
	LeftFrame.Interactable = visible

	if visible then
		LeftFrame.Visible = true

		ShowLeftFrameTween:Play()
	else
		HideLeftFrameTween:Play()
	end
end, IsLeftFrameExpanded.Changed, IsLeftFrameExpanded.Value)

local VisibleChangedDestructor = Destructor.new()

local PlotDebugUpdateInterval = PLOT_DEBUG_UPDATE_FREQUENCY ^ -1

Callback.CallAndConnect(function(visible: boolean)
	VisibleChangedDestructor:Destruct()

	if not visible then
		return
	end

	local localPlotChangedDestructor = VisibleChangedDestructor:Add(Destructor.new())

	VisibleChangedDestructor:Add(Callback.CallAndConnect(function()
		localPlotChangedDestructor:Destruct()

		if not LocalPlot then
			PlotDebugLabel.Text = ""

			return
		end

		local rulersDestructor = localPlotChangedDestructor:Add(Destructor.new())

		localPlotChangedDestructor:Add(task.spawn(@native function()
			local lastUpdateTimestamp = -math.huge

			while true do
				rulersDestructor:Destruct()

				local timestamp = os.clock()

				local text =
					`Update Frequency: {String.FormatNumber((timestamp - lastUpdateTimestamp) ^ -1 * 1e3, PLOT_DEBUG_UPDATE_FREQUENCY_PRECISION)} mHz\n`
					.. `Last Updated: {DateTime.now():FormatUniversalTime("YYYY-MM-DDTHH:mm:ss.SSSZ", LocalPlayer.LocaleId)}\n`
					.. String.FormatTable(LocalPlot :: any)

				lastUpdateTimestamp = timestamp

				PlotDebugLabel.Text = text

				for index = 0, GetMaxLeadingTabs(text) do
					local newRuler = rulersDestructor:Add(Ruler:Clone())
					newRuler.Position = UDim2.fromOffset(TabWidth * index - 1, 0)
					newRuler.Parent = PlotDebugLabel
				end

				task.wait(PlotDebugUpdateInterval)
			end
		end))
	end, LocalPlotChanged.Event))
end, Visible.Changed, Visible.Value)

Callback.CallAndConnect(function(isOwner: boolean)
	if not isOwner then
		return
	end

	local occupants = LocalPlot.Occupants
	local players: {Player} = table.create(#occupants)

	for _, occupant in occupants do
		table.insert(players, occupant.Player)
	end

	LocalPlotChangedDestructor:Add(Callback.CallForEachVarargAndConnect(function(player: Player)
		if player == LocalPlayer then
			return
		end

		task.spawn(function()
			local occupant = OccupantClass.GetOccupant(player)

			local occupantFrame = OccupantFrame:Clone()
			local bodyFrame = occupantFrame:WaitForChild("Body")
			local textLabel = bodyFrame:WaitForChild("Text")
			local kickButton = bodyFrame:WaitForChild("Kick")

			textLabel.Text = `{player.DisplayName} <font transparency="{USERNAME_TEXT_TRANSPARENCY}">@{player}</font>`
			occupantFrame.Parent = OccupantsList

			local destructor = Destructor.new()

			local showOccupantFrameTween = destructor:Add(TweenService:Create(occupantFrame, TweenParameters1Out, {
				Size = UDim2.new(1, 0, 0, 16)
			}))

			showOccupantFrameTween.Completed:Connect(function(playbackState)
				if playbackState ~= Enum.PlaybackState.Completed then
					return
				end

				TweenService:Create(bodyFrame, TweenParameters1Out, {
					AnchorPoint = Vector2.zero
				}):Play()
			end)

			showOccupantFrameTween:Play()

			local thread = Instance.new("BindableEvent")

			destructor:Add(LocalPlotChanged.Event:Connect(function()
				thread:Fire()
			end))

			destructor:Add(occupant.PlotChanged:Connect(function(plotModel: Model?)
				if plotModel ~= (LocalPlot and LocalPlot.PlotModel) then
					thread:Fire()
				end
			end))

			if not IsPlayerExperienceOwner(player) then
				kickButton.Interactable = true

				kickButton.TextTransparency = 0
				kickButton.TextColor3 = RED_COLOR

				destructor:Add(kickButton.MouseButton1Click:Once(function()
					kickButton.TextColor3 = LIGHT_COLOR

					destructor:Add(TweenService:Create(kickButton, TweenParameters2, {
						TextTransparency = BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
					})):Play()

					Plots.KickOccupant(occupant)
				end))

				destructor:Add(function()
					kickButton.TextTransparency = BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
					kickButton.TextColor3 = LIGHT_COLOR
				end)
			end

			thread.Event:Wait()

			destructor:Destruct()

			occupantFrame.Interactable = false

			bodyFrame.AnchorPoint = Vector2.xAxis
			bodyFrame.Position = UDim2.fromScale(1, 0)

			local bodyFrameTween = TweenService:Create(bodyFrame, TweenParameters1In, {
				AnchorPoint = Vector2.zero
			})

			bodyFrameTween:Play()
			bodyFrameTween.Completed:Wait()

			local hideOccupantFrameTween = TweenService:Create(occupantFrame, TweenParameters1In, {
				Size = UDim2.fromScale(1, 0)
			})

			hideOccupantFrameTween:Play()
			hideOccupantFrameTween.Completed:Wait()

			occupantFrame:Destroy()
		end)
	end, LocalPlot.OccupantAdded, unpack(players)))
end, IsOwner.Changed, IsOwner.Value)

-- </Script #74 End>
--[[
<Script #75 Begin>
<Metadata Begin>
Name: "ValueWrapper"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.ValueWrapper
Size: 3821 Character(s), 122 Line(s)
</Metadata End>
]]

--!strict
local ValueWrapper = {}
ValueWrapper.__index = ValueWrapper

local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

type Predicate<Value> = (value: Value) -> boolean

type ValueWrapperProperties<Value> = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_Changed: BindableEvent,
	Value: Value,
	Changed: RBXScriptSignal,
	Predicates: {[string]: Predicate<Value>},
	Destructing: RBXScriptSignal
}

export type ValueWrapper<Value> = typeof(
	setmetatable(
		{} :: ValueWrapperProperties<Value>,
		ValueWrapper
	)
)

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>dictionary</strong> of <strong>functions</strong> indexed by <strong>strings</strong>.
]=]
local function IsDictionaryOfFunctionsIndexedByStrings(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	for key, value in value do
		if type(key) ~= "string" or type(value) ~= "function" then
			return false
		end
	end

	return true
end

function ValueWrapper.__tostring<Value>(self: ValueWrapper<Value>): string
	return tostring(self.Value)
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code><strong>self</strong>.Predicates</code> is a <strong>dictionary</strong> of <strong>functions</strong> returning <strong>true</strong>.
]=]
function ValueWrapper._Predicate<Value>(self: ValueWrapper<Value>, value: Value): boolean
	local pass = true

	for name, predicate in self.Predicates do
		local _, result = xpcall(predicate, function(message: string)
			warn(debug.traceback(message))
		end, value)

		task.spawn(assert, type(result) == "boolean", `Called method '{debug.info(predicate, "n") or name}' of ValueWrapper on {self} while property 'Predicates' is {self.Predicates} and not a dictionary of functions returning booleans.`)

		if result == false then
			pass = false

			break
		end
	end

	return pass
end

function ValueWrapper.IsValueWrapper(value: any): boolean
	return type(value) == "table" and getmetatable(value) == ValueWrapper
end

--[=[
	Returns a new <strong>ValueWrapper</strong> object with optional <code>Value</code> and <code>Predicates</code>.
]=]
function ValueWrapper.new<Value>(value: Value?, predicates: {[string]: Predicate<Value>}?): ValueWrapper<Value>
	assert(predicates == nil or IsDictionaryOfFunctionsIndexedByStrings(predicates), `Argument 'Predicates' to constructor 'new' of ValueWrapper is {predicates} and not nil or a dictionary of functions indexed by strings.`)

	local self = setmetatable({} :: ValueWrapperProperties<any>, ValueWrapper)

	self._Destructor = Destructor.new()

	self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

	self._Destructor:Add(self._Destructing.Fire, self._Destructing)

	self._Changed = self._Destructor:Add(Instance.new("BindableEvent"))

	self.Value = value
	self.Changed = self._Changed.Event

	self.Predicates = predicates or {}

	self.Destructing = self._Destructing.Event

	return self
end

--[=[
	Destroys <code><strong>self</strong></code>.
]=]
function ValueWrapper.Destruct<Value>(self: ValueWrapper<Value>)
	self._Destructor:Destruct()
end

--[=[
	Sets the value of <code><strong>self</strong></code> to <code>Value</code> if <code>_BypassPredicates</code> is <strong>true</strong> or each <strong>function</strong> in <code><strong>self</strong>.Predicates</code> returns <strong>true</strong>.
]=]
function ValueWrapper.Set<Value>(self: ValueWrapper<Value>, value: Value, _bypassPredicates: boolean?)
	if value ~= self.Value and (_bypassPredicates or self:_Predicate(value)) then
		self.Value = value
		self._Changed:Fire(value)
	end
end

return ValueWrapper

-- </Script #75 End>
--[[
<Script #76 Begin>
<Metadata Begin>
Name: "ToggleSpawnedButton"
Type: LocalScript
Path: StarterGui.Widgets.Bottom Bar.Body.Right Bar.Spawn/Despawn.ToggleSpawnedButton
Size: 3777 Character(s), 140 Line(s)
</Metadata End>
]]

--!strict
local ASSET_ID_URI_PREFIX = "rbxassetid://"

local SPAWN_DESPAWN_ICON_IDS = {
	SPAWN = 123479386178032,
	DESPAWN = 73142009364159,
	HOVER = 92643395115742,
	PRESSED = 94149772373119
}

local SPAWN_COLOR = Color3.fromRGB(0, 204, 0)
local DESPAWN_COLOR = Color3.fromRGB(204, 0, 0)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local LIGHT_COLOR = CONSTANTS.Gui.ColorScheme.LIGHT

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalPlayer = Players.LocalPlayer
local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChanged = Instance.new("BindableEvent")
local LocalPlotChangedDestructor = Destructor.new()

local Button = script.Parent

local IsVisible = ValueWrapper.new(false)

local TweenParameters = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.InOut)

local ShowTween = TweenService:Create(Button, TweenParameters, {Size = UDim2.fromScale(1, 1)})
local HideTween = TweenService:Create(Button, TweenParameters, {Size = UDim2.fromScale(0, 1)})

HideTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		Button.Visible = false
	end
end)

do
	local IconIds = {unpack(SPAWN_DESPAWN_ICON_IDS)}
	local IconUris: {string} = table.create(#IconIds)

	for _, id in IconIds do
		table.insert(IconUris, ASSET_ID_URI_PREFIX .. id)
	end

	task.spawn(ContentProvider.PreloadAsync, ContentProvider, IconUris)
end

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	LocalPlot = LocalOccupant.Plot :: any
	LocalPlotChanged:Fire()

	if not LocalPlot then
		IsVisible:Set(false)

		return
	end

	local owner = LocalPlot.Owner

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(owner: Player?)
		IsVisible:Set(owner == LocalPlayer)
	end, LocalPlot.OwnerChanged, owner and owner.Player))
end, LocalOccupant.PlotChanged)

local IsVisibleChangedDestructor = Destructor.new()

Callback.CallAndConnect(function(visible: boolean)
	IsVisibleChangedDestructor:Destruct()

	Button.Interactable = visible

	if not visible then
		Button.Image = ASSET_ID_URI_PREFIX .. SPAWN_DESPAWN_ICON_IDS.HOVER
		Button.ImageColor3 = LIGHT_COLOR

		HideTween:Play()

		return
	end

	local localPlotChangedDestructor = IsVisibleChangedDestructor:Add(Destructor.new())

	localPlotChangedDestructor:Add(Callback.CallAndConnect(function()
		localPlotChangedDestructor:Destruct()

		local plot = LocalPlot

		if not plot then
			return
		end

		localPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean)
			if spawned then
				Button.Image = ASSET_ID_URI_PREFIX .. SPAWN_DESPAWN_ICON_IDS.DESPAWN
				Button.ImageColor3 = DESPAWN_COLOR
			else
				Button.Image = ASSET_ID_URI_PREFIX .. SPAWN_DESPAWN_ICON_IDS.SPAWN
				Button.ImageColor3 = SPAWN_COLOR
			end
		end, plot.SpawnedChanged, plot.Spawned))
	end, LocalPlotChanged.Event))

	Button.Visible = true

	ShowTween:Play()
end, IsVisible.Changed, IsVisible.Value)

while true do
	Button.MouseButton1Click:Wait()

	if LocalPlot.Spawned then
		Plots.DespawnCreation()
	else
		Plots.SpawnCreation()
	end
end

-- </Script #76 End>
--[[
<Script #77 Begin>
<Metadata Begin>
Name: "AssetSelector"
Type: LocalScript
Path: StarterGui.Widgets.Widgets.Asset Selector.Body.AssetSelector
Size: 14752 Character(s), 497 Line(s)
</Metadata End>
]]

--!strict
local SEARCH_QUERY_TEXT_BOX_FOCUSED_BORDER_THICKNESS = 1 -- Pixel(s)

local ASSET_BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY = .5

local INFINITY_SYMBOL = utf8.char(0x221E)

local ASSET_BUDGET_MAX_UPDATE_FREQUENCY = 2 ^ 3 * 3 / 4 -- Hertz
local ASSET_BUDGET_EXHAUSTED_COLOR = Color3.fromRGB(204, 0, 0)

local ASSET_ID_URI_PREFIX = "rbxassetid://"

local EXPAND_COLLAPSE_ICON_IDS = {
	EXPAND = 77527054822874,
	COLLAPSE = 81405816450996
}

local FOLDER_EXPAND_COLLAPSE_TWEEN_SPEED_MULTIPLIER = 3 / 2

local FOCUS_SEARCH_QUERY_TEXT_BOX_KEY = Enum.KeyCode.F

local SELECTION_DISABLE_KEYS = {
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D
}

local CLEAR_SEARCH_QUERY_BUTTON_INTERACTABLE_COLOR = Color3.fromRGB(204, 0, 0)
local CLEAR_SEARCH_QUERY_BUTTON_UNINTERACTABLE_TRANSPARENCY = .5

local SEARCH_MATCH_HIGHLIGHT_COLOR = Color3.fromRGB(204, 0, 204)
local SEARCH_MATCH_HIGHLIGHT_TRANSPARENCY = 1 / 3

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local ASSETS = CONSTANTS.Assets

local LIGHT_COLOR = CONSTANTS.Gui.ColorScheme.LIGHT

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Settings = require(Controllers:WaitForChild("Settings"))
local Tools = require(Controllers:WaitForChild("Tools"))
local Widgets = require(Controllers:WaitForChild("Widgets"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local AssetPool = require(Services:WaitForChild("AssetPoolClient"))

local Values = Modules:WaitForChild("Values")
local AssetBudgets = require(Values:WaitForChild("AssetBudgets"))

local AssetSelector = script.Parent

local Body = AssetSelector:WaitForChild("Body")

local CurrentAssetFrame = Body:WaitForChild("Current Asset")
local CurrentAssetNameLabel = CurrentAssetFrame:WaitForChild("Name")
local CurrentAssetIdLabel = CurrentAssetFrame:WaitForChild("ID")
local CurrentAssetBudgetLabel = CurrentAssetFrame:WaitForChild("Budget")

local TotalAssetBudgetLabel = Body:WaitForChild("Total Asset Budget")

local SearchFieldFrame = Body:WaitForChild("Search Field")
local SearchQueryTextBox = SearchFieldFrame:WaitForChild("Query")
local ClearSearchQueryButton = SearchFieldFrame:WaitForChild("Clear")

local AssetsList = Body:WaitForChild("Assets List")
local HierarchicalFrame = AssetsList:WaitForChild("Hierarchical")
local FlatFrame = AssetsList:WaitForChild("Flat")

local FolderFrame = script:WaitForChild("Folder")
local AssetButton = script:WaitForChild("Asset")

local Scale = Settings.Gui.Scale

local Widget = Widgets.AssetSelector
local Visible = Widget.Visible
local Collapsed = Widget.Collapsed

local Controls = Tools.Construct
local Enabled = Controls.Enabled
local Asset = Controls.Asset

local AssetCounts = AssetPool.AssetCounts
local TotalAssets = AssetPool.TotalAssets

local IsSearchingChangedDestructor = Destructor.new()

local IsSearching = ValueWrapper.new(false, {
	Destructor = function()
		IsSearchingChangedDestructor:Destruct()

		return true
	end
})

local SearchQuery = ValueWrapper.new("", {
	IsSearching = function(query)
		IsSearching:Set(query ~= "")

		return true
	end
})

local TweenParameters = TweenInfo.new(TWEENS.DURATION / FOLDER_EXPAND_COLLAPSE_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.InOut)

local SearchAssetButtons: {[Model]: TextButton} = {}

do
	local IconIds = {unpack(EXPAND_COLLAPSE_ICON_IDS)}
	local IconUris: {string} = table.create(#IconIds)

	for _, id in IconIds do
		table.insert(IconUris, ASSET_ID_URI_PREFIX .. id)
	end

	task.spawn(ContentProvider.PreloadAsync, ContentProvider, IconUris)
end

local AssetBudgetExhaustedColorHexadecimal = ASSET_BUDGET_EXHAUSTED_COLOR:ToHex()

--[=[
	Returns a <strong>string</strong> representing a fraction where <code>Count</code> is the numerator and <code>Budget</code> is the denominator. If the numerator is greater than or equal to the denominator, the numerator will be formatted with rich text font color markup.
]=]
local function GetAssetBudgetFraction(count: number, budget: number): string
	local numerator = tostring(count)

	if count >= budget then
		numerator = `<font color="#{AssetBudgetExhaustedColorHexadecimal}">{numerator}</font>`
	end

	return `{numerator} / {if budget == math.huge then INFINITY_SYMBOL else budget}`
end

local AssetBudgetMaxUpdateInterval = ASSET_BUDGET_MAX_UPDATE_FREQUENCY ^ -1

--[=[
	Returns a scripted clone of <code>AssetButton</code> from <code>Asset</code>.
]=]
local function CreateAssetButton(asset: Model): TextButton
	local id: number = asset:GetAttribute("__Id")

	local assetButton = AssetButton:Clone()
	local nameLabel = assetButton:WaitForChild("Name")
	local idLabel = assetButton:WaitForChild("ID")
	local budgetLabel = assetButton:WaitForChild("Budget")

	assetButton.Name = asset.Name

	nameLabel.Text = asset.Name
	idLabel.Text = `ID: {id}`

	Callback.CallAndConnect(function(newAsset: Model?)
		local isSettable = newAsset ~= asset

		assetButton.Interactable = isSettable
		assetButton.Selectable = isSettable

		nameLabel.TextTransparency = if isSettable then 0 else ASSET_BUTTON_UNINTERACTABLE_TEXT_TRANSPARENCY
	end, Asset.Changed, Asset.Value)

	local assetCount = AssetCounts[id]
	local thread: thread?

	Callback.CallAndConnect(function()
		if thread then
			return
		end

		thread = task.delay(AssetBudgetMaxUpdateInterval, function()
			budgetLabel.Text = GetAssetBudgetFraction(assetCount.Value, AssetBudgets[id])

			thread = nil
		end)
	end, assetCount.Changed)

	assetButton.MouseButton1Click:Connect(function()
		Asset:Set(asset)
	end)

	return assetButton
end

--[=[
	Returns a scripted clone of <code>FolderFrame</code> from <code>Folder</code> and its <code>AssetsList</code>.
]=]
local function CreateFolder(folder: Folder): (Frame, Frame)
	local folderFrame = FolderFrame:Clone()

	local header = folderFrame:WaitForChild("Header")
	local expandCollapseButton = header:WaitForChild("Expand/Collapse")
	local nameLabel = header:WaitForChild("Name")

	local assetsList = folderFrame:WaitForChild("Assets List")

	folderFrame.Name = folder.Name
	nameLabel.Text = folder.Name

	local isExpanded = ValueWrapper.new(false)

	Callback.CallAndConnect(@native function(expanded: boolean)
		if not expanded then
			expandCollapseButton.Image = ASSET_ID_URI_PREFIX .. EXPAND_COLLAPSE_ICON_IDS.EXPAND

			assetsList.Size = UDim2.new(1, 0, 0, assetsList.AbsoluteSize.Y / Scale.Value)
			assetsList.AutomaticSize = Enum.AutomaticSize.None

			local tween = TweenService:Create(assetsList, TweenParameters, {
				Size = UDim2.fromScale(1, 0)
			})

			tween.Completed:Connect(function(playbackState)
				if playbackState == Enum.PlaybackState.Completed then
					assetsList.Visible = false
				end
			end)

			tween:Play()

			return
		end

		expandCollapseButton.Image = ASSET_ID_URI_PREFIX .. EXPAND_COLLAPSE_ICON_IDS.COLLAPSE

		local canvasHeightBefore, windowHeight = AssetsList.AbsoluteCanvasSize.Y, AssetsList.AbsoluteWindowSize.Y
		local scrollToBottom = canvasHeightBefore > windowHeight and AssetsList.CanvasPosition.Y + windowHeight == canvasHeightBefore

		assetsList.AutomaticSize = Enum.AutomaticSize.Y
		assetsList.Visible = true

		RunService.PreAnimation:Wait()

		local listHeight = assetsList.AbsoluteSize.Y / Scale.Value
		local canvasHeightAfter = AssetsList.AbsoluteCanvasSize.Y

		assetsList.AutomaticSize = Enum.AutomaticSize.None

		local tween = TweenService:Create(assetsList, TweenParameters, {
			Size = UDim2.new(1, 0, 0, listHeight)
		})

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				assetsList.AutomaticSize = Enum.AutomaticSize.Y
				assetsList.Size = UDim2.fromScale(1, 0)
			end
		end)

		tween:Play()

		if not scrollToBottom then
			return
		end

		AssetsList.ScrollingEnabled = false

		local scrollPosition = Instance.new("NumberValue")
		scrollPosition.Value = AssetsList.CanvasPosition.Y

		Callback.CallAndConnect(function(scrollPosition: number)
			AssetsList.CanvasPosition = Vector2.yAxis * scrollPosition
		end, scrollPosition.Changed, scrollPosition.Value)

		local tween = TweenService:Create(scrollPosition, TweenParameters, {
			Value = canvasHeightAfter - AssetsList.AbsoluteWindowSize.Y
		})

		tween:Play()
		tween.Completed:Wait()

		AssetsList.ScrollingEnabled = true
	end, isExpanded.Changed, isExpanded.Value)

	expandCollapseButton.MouseButton1Click:Connect(function()
		isExpanded:Set(not isExpanded.Value)
	end)

	return folderFrame, assetsList
end

local CurrentAssetChangedDestructor = Destructor.new()

Callback.CallAndConnect(function(asset: Model?)
	CurrentAssetChangedDestructor:Destruct()

	CurrentAssetNameLabel.Text = `Current Asset: {if asset then `'{asset}'` else "<None>"}`

	local showMetadata = not not asset

	CurrentAssetIdLabel.Visible = showMetadata
	CurrentAssetBudgetLabel.Visible = showMetadata

	if not asset then
		return
	end

	local id: number = asset:GetAttribute("__Id")
	local assetCount = AssetCounts[id]

	CurrentAssetIdLabel.Text = `ID: {id}`

	local thread: thread?

	CurrentAssetChangedDestructor:Add(Callback.CallAndConnect(function()
		if thread then
			return
		end

		thread = task.delay(AssetBudgetMaxUpdateInterval, function()
			CurrentAssetBudgetLabel.Text = GetAssetBudgetFraction(assetCount.Value, AssetBudgets[id])

			thread = nil
		end)
	end, assetCount.Changed))

	CurrentAssetChangedDestructor:Add(function()
		if thread then
			task.cancel(thread)
		end
	end)
end, Asset.Changed, Asset.Value)

local Thread: thread?

Callback.CallAndConnect(function()
	if Thread then
		return
	end

	Thread = task.delay(AssetBudgetMaxUpdateInterval, function()
		TotalAssetBudgetLabel.Text = `Total Assets: {GetAssetBudgetFraction(TotalAssets.Value, AssetBudgets.Total)}`

		Thread = nil
	end)
end, TotalAssets.Changed)

--[=[
	Recursively traverses the descendants of <code>Instance</code> and builds a hierarchy tree under <code>Parent</code> reflecting it.
]=]
local function BuildHierarchy(instance: Instance, parent: Instance): {Model}
	local assets: {Model} = {}

	for _, child in instance:GetChildren() do
		if child:HasTag(ASSETS.TAG) then
			CreateAssetButton(child :: Model).Parent = parent

			table.insert(assets, child :: any)
		elseif child:IsA("Folder") then
			local folder, list = CreateFolder(child)
			folder.Parent = parent

			for _, asset in BuildHierarchy(child, list) do
				table.insert(assets, asset)
			end
		end
	end

	return assets
end

BuildHierarchy(AssetPool.AssetsFolder, HierarchicalFrame)

for _, asset in AssetPool.StoredAssets do
	local assetButton = CreateAssetButton(asset)
	assetButton.Parent = FlatFrame

	SearchAssetButtons[asset] = assetButton
end

Callback.CallAndConnect(function(searching: boolean)
	HierarchicalFrame.Visible = not searching
	FlatFrame.Visible = searching
end, IsSearching.Changed, IsSearching.Value)

local SearchMatchHighlightColorHexadecimal = SEARCH_MATCH_HIGHLIGHT_COLOR:ToHex()

Callback.CallAndConnect(function(searching: boolean)
	ClearSearchQueryButton.Interactable = searching

	if searching then
		ClearSearchQueryButton.ImageColor3 = CLEAR_SEARCH_QUERY_BUTTON_INTERACTABLE_COLOR
		ClearSearchQueryButton.ImageTransparency = 0
	else
		ClearSearchQueryButton.ImageColor3 = LIGHT_COLOR
		ClearSearchQueryButton.ImageTransparency = CLEAR_SEARCH_QUERY_BUTTON_UNINTERACTABLE_TRANSPARENCY

		return
	end

	IsSearchingChangedDestructor:Add(Callback.CallAndConnect(@native function(query: string)
		local selectableAssetButtons: {GuiButton} = {}

		for asset, assetButton in SearchAssetButtons do
			local assetName = asset.Name
			local from, to = assetName:lower():find(query:lower())

			assetButton.Visible = not not from

			if not from then
				assetButton.Text = assetName

				continue
			end

			if assetButton.Selectable then
				table.insert(selectableAssetButtons, assetButton)
			end

			local assetButtonNameLabel: TextLabel = assetButton:WaitForChild("Name") :: any

			assetButtonNameLabel.Text =
				assetName:sub(1, from - 1)
				.. `<b><u><mark color="#{SearchMatchHighlightColorHexadecimal}" transparency="{SEARCH_MATCH_HIGHLIGHT_TRANSPARENCY}">{assetName:sub(from, to)}</mark></u></b>`
				.. assetName:sub(to :: any + 1)
		end

		table.sort(selectableAssetButtons, function(button1, button2)
			return button1.Name < button2.Name
		end)

		RunService.PreAnimation:Once(function()
			GuiService.SelectedObject = selectableAssetButtons[1]
		end)
	end, SearchQuery.Changed, SearchQuery.Value))

	IsSearchingChangedDestructor:Add(UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Down then
			SearchQueryTextBox:ReleaseFocus()
		end
	end))

	local selectionDisabledDestructor = IsSearchingChangedDestructor:Add(Destructor.new())

	selectionDisabledDestructor:Add(UserInputService.InputBegan:Connect(function(input)
		if table.find(SELECTION_DISABLE_KEYS, input.KeyCode) then
			selectionDisabledDestructor:Destruct()
		end
	end))

	local callback = function()
		GuiService.SelectedObject = nil
	end

	for _, connection in Callback.ConnectToEach(callback, {Visible.Changed, Collapsed.Changed}) do
		selectionDisabledDestructor:Add(connection)
	end

	selectionDisabledDestructor:Add(callback)
end, IsSearching.Changed, IsSearching.Value)

SearchQueryTextBox.Focused:Connect(function()
	SearchQueryTextBox.BorderSizePixel = SEARCH_QUERY_TEXT_BOX_FOCUSED_BORDER_THICKNESS
end)

SearchQueryTextBox.FocusLost:Connect(function()
	SearchQueryTextBox.BorderSizePixel = 0
end)

SearchQueryTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	SearchQuery:Set(SearchQueryTextBox.Text)
end)

ClearSearchQueryButton.MouseButton1Click:Connect(function()
	SearchQueryTextBox.Text = ""
end)

local EnabledChangedDestructor = Destructor.new()

Callback.CallAndConnect(function(enabled: boolean)
	EnabledChangedDestructor:Destruct()

	Visible:Set(enabled)

	EnabledChangedDestructor:Add(UserInputService.InputEnded:Connect(function(input, processed)
		if not processed and input.KeyCode == FOCUS_SEARCH_QUERY_TEXT_BOX_KEY then
			SearchQueryTextBox:CaptureFocus()
		end
	end))
end, Enabled.Changed, Enabled.Value)

-- </Script #77 End>
--[[
<Script #78 Begin>
<Metadata Begin>
Name: "ViewingFrustum"
Type: ModuleScript
Path: ReplicatedFirst.Gui.SplashScreen.SplashScreen.ViewingFrustum
Size: 3609 Character(s), 160 Line(s)
</Metadata End>
]]

--!nolint
--!nocheck
local BLOCK = {0, 1, 2, 3, 4, 5, 6, 7}
local WEDGE = {0, 1, 3, 4, 5, 7}
local CORNER_WEDGE = {0, 1, 4, 5, 6}

local ViewportModelClass = {}
ViewportModelClass.__index = ViewportModelClass
ViewportModelClass.ClassName = "ViewportModel"

local function getIndices(part)
	if part:IsA("WedgePart") then
		return WEDGE
	elseif part:IsA("CornerWedgePart") then
		return CORNER_WEDGE
	end

	return BLOCK
end

local function getCorners(cf, size2, indices)
	local corners = {}

	for j, i in pairs(indices) do
		corners[j] = cf * (
			size2 * Vector3.new(
				2 * (math.floor(i / 4) % 2) - 1,
				2 * (math.floor(i / 2) % 2) - 1,
				2 * (i % 2) - 1
			)
		)
	end

	return corners
end

local function getModelPointCloud(model)
	local points = {}

	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local indices = getIndices(part)
			local corners = getCorners(part.CFrame, part.Size / 2, indices)

			for _, wp in pairs(corners) do
				table.insert(points, wp)
			end
		end
	end

	return points
end

local function viewProjectionEdgeHits(cloud, axis, depth, tanFov2)
	local max, min = -math.huge, math.huge

	for _, lp in pairs(cloud) do
		local distance = depth - lp.Z
		local halfSpan = tanFov2 * distance

		local a = lp[axis] + halfSpan
		local b = lp[axis] - halfSpan

		max = math.max(max, a, b)
		min = math.min(min, a, b)
	end

	return max, min
end

function ViewportModelClass.new(vpf, camera)
	local self = setmetatable({}, ViewportModelClass)

	self.Model = nil
	self.ViewportFrame = vpf
	self.Camera = camera

	self._points = {}
	self._modelCFrame = CFrame.new()
	self._modelSize = Vector3.new()
	self._modelRadius = 0

	self._viewport = {}

	self:Calibrate()

	return self
end

function ViewportModelClass:SetModel(model)
	self.Model = model

	self._points = getModelPointCloud(model)

	local cf, size = model:GetBoundingBox()

	self._modelCFrame = cf
	self._modelSize = size
	self._modelRadius = size.Magnitude / 2
end

function ViewportModelClass:Calibrate()
	local viewport = {}

	local size = self.ViewportFrame.AbsoluteSize
	viewport.aspect = size.X / size.Y

	viewport.yFov2 = math.rad(self.Camera.FieldOfView / 2)
	viewport.tanyFov2 = math.tan(viewport.yFov2)

	viewport.xFov2 = math.atan(viewport.tanyFov2 * viewport.aspect)
	viewport.tanxFov2 = math.tan(viewport.xFov2)

	viewport.cFov2 = math.atan(viewport.tanyFov2 * math.min(1, viewport.aspect))
	viewport.sincFov2 = math.sin(viewport.cFov2)

	self._viewport = viewport
end

function ViewportModelClass:GetFitDistance(focusPosition)
	local displacement = focusPosition and  (focusPosition - self._modelCFrame.Position).Magnitude or 0
	local radius = self._modelRadius + displacement

	return radius / self._viewport.sincFov2
end

function ViewportModelClass:GetMinimumFitCFrame(orientation)
	if not self.Model then
		return CFrame.new()
	end

	local rotation = orientation - orientation.Position
	local rInverse = rotation:Inverse()

	local wcloud = self._points
	local cloud = {rInverse * wcloud[1]}
	local furthest = cloud[1].Z

	for i = 2, #wcloud do
		local lp = rInverse * wcloud[i]
		furthest = math.min(furthest, lp.Z)
		cloud[i] = lp
	end

	local hMax, hMin = viewProjectionEdgeHits(cloud, "X", furthest, self._viewport.tanxFov2)
	local vMax, vMin = viewProjectionEdgeHits(cloud, "Y", furthest, self._viewport.tanyFov2)

	local distance = math.max(
		((hMax - hMin) / 2) / self._viewport.tanxFov2,
		((vMax - vMin) / 2) / self._viewport.tanyFov2
	)

	return orientation * CFrame.new(
		(hMax + hMin) / 2,
		(vMax + vMin) / 2,
		furthest + distance
	)
end

return ViewportModelClass

-- </Script #78 End>
--[[
<Script #79 Begin>
<Metadata Begin>
Name: "Toolbar"
Type: LocalScript
Path: StarterGui.Widgets.Bottom Bar.Body.Toolbar.Toolbar
Size: 4164 Character(s), 133 Line(s)
</Metadata End>
]]

--!strict
local BUTTON_NAMES = {
	"Construct",
	"Destruct",
	"Attribute",
	"Texture",
	"Pivot"
}

local BORDER_THICKNESS = 2 -- Pixel(s)
local BORDER_THICKNESS_TWEEN_SPEED_MULTIPLIER = 3 / 2

local UNINTERACTABLE_IMAGE_TRANSPARENCY = .5

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local TOOLS = CONSTANTS.Tools

local COLOR_SCHEME = CONSTANTS.Gui.ColorScheme

local LIGHT_COLOR = COLOR_SCHEME.LIGHT
local _, _, MAX_LIGHTNESS = LIGHT_COLOR:ToHSV()

local GRAY_COLOR = COLOR_SCHEME.GRAY

local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local ToolbarFrame = script.Parent
local ToolbarGroup = ToolbarFrame:WaitForChild("Group")

local LocalOccupant = Plots.LocalOccupant

local IsToolbarVisible = ValueWrapper.new(false)

local TweenParameters1 = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.InOut)
local TweenParameters2 = TweenInfo.new(TWEENS.DURATION / BORDER_THICKNESS_TWEEN_SPEED_MULTIPLIER, Enum.EasingStyle.Linear)

local ShowTransparencyTween = TweenService:Create(ToolbarGroup, TweenParameters1, {GroupTransparency = 0})
local ShowSizeTween = TweenService:Create(ToolbarFrame, TweenParameters1, {Size = UDim2.fromOffset(0, 2 ^ 6)})
local HideTransparencyTween = TweenService:Create(ToolbarGroup, TweenParameters1, {GroupTransparency = 1})
local HideSizeTween = TweenService:Create(ToolbarFrame, TweenParameters1, {Size = UDim2.fromOffset(0, 2 ^ 5)})

HideTransparencyTween.Completed:Connect(function(playbackState)
	if playbackState == Enum.PlaybackState.Completed then
		ToolbarFrame.Visible = false
	end
end)

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		IsToolbarVisible:Set(false)

		return
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(spawned: boolean?)
		IsToolbarVisible:Set(not spawned)
	end, plot.SpawnedChanged, plot.Spawned))
end, LocalOccupant.PlotChanged)

Callback.CallAndConnect(function(visible: boolean)
	ToolbarFrame.Interactable = visible

	if visible then
		ToolbarFrame.Visible = true

		ShowTransparencyTween:Play()
		ShowSizeTween:Play()
	else
		HideTransparencyTween:Play()
		HideSizeTween:Play()
	end
end, IsToolbarVisible.Changed, IsToolbarVisible.Value)

for _, name in BUTTON_NAMES do
	local THEME_COLOR: Color3 = TOOLS[name].THEME_COLOR
	local HUE, SATURATION, LIGHTNESS = THEME_COLOR:ToHSV()
	local TOOL_ENABLED_COLOR = Color3.fromHSV(HUE, SATURATION, math.min(MAX_LIGHTNESS, LIGHTNESS))

	local button: ImageButton = ToolbarGroup:WaitForChild(name)

	local enabled: ValueWrapper.ValueWrapper<boolean> = Tools[name].Enabled

	Callback.CallAndConnect(function(visible: boolean)
		button.ImageTransparency = if visible then 0 else UNINTERACTABLE_IMAGE_TRANSPARENCY
	end, IsToolbarVisible.Changed, IsToolbarVisible.Value)

	local showBorderTween = TweenService:Create(button, TweenParameters2, {BorderSizePixel = BORDER_THICKNESS})
	local hideBorderTween = TweenService:Create(button, TweenParameters2, {BorderSizePixel = 0})

	Callback.CallAndConnect(function(enabled: boolean)
		if enabled then
			button.ImageColor3, button.BorderColor3 = TOOL_ENABLED_COLOR, TOOL_ENABLED_COLOR

			showBorderTween:Play()

			return
		end

		button.ImageColor3 = LIGHT_COLOR
		button.BorderColor3 = GRAY_COLOR

		hideBorderTween:Play()
	end, enabled.Changed, enabled.Value)

	button.MouseButton1Click:Connect(function()
		enabled:Set(not enabled.Value)
	end)
end

-- </Script #79 End>
--[[
<Script #80 Begin>
<Metadata Begin>
Name: "PlotWireframes"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Plots.PlotWireframes
Size: 7404 Character(s), 237 Line(s)
</Metadata End>
]]

--!strict
local TRANSPARENCY = .5

local COLOR_TWEEN_SPEED_MULTIPLIER = 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local GRID_SCALE = CONSTANTS.Plots.GRID_SCALE

local TOOLS = CONSTANTS.Tools
local TWEENS = CONSTANTS.Tweens

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))
local LineSegment = require(Classes:WaitForChild("LineSegment"))
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))
local WireframeWrapper = require(Classes:WaitForChild("WireframeWrapper"))

local Controllers = Modules:WaitForChild("Controllers")
local Tools = require(Controllers:WaitForChild("Tools"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalOccupant = Plots.LocalOccupant

local TweenParameters1In = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.In)
local TweenParameters1Out = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.Out)
local TweenParameters2 = TweenInfo.new(TWEENS.DURATION / COLOR_TWEEN_SPEED_MULTIPLIER, TWEENS.STYLE, Enum.EasingDirection.Out)

local Wireframes: {[Plots.Plot]: WireframeWrapper.WireframeWrapper} = {}
local Visibilities: {[WireframeWrapper.WireframeWrapper]: ValueWrapper.ValueWrapper<boolean>} = {}
local Alphas: {[WireframeWrapper.WireframeWrapper]: NumberValue} = {}
local Colors: {[WireframeWrapper.WireframeWrapper]: Color3Value} = {}

local CubeEdges = {
	LineSegment.new(Vector3.one * -.5, Vector3.new(.5, -.5, -.5)),
	LineSegment.new(Vector3.new(.5, -.5, -.5), Vector3.new(.5, -.5, .5)),
	LineSegment.new(Vector3.new(.5, -.5, .5), Vector3.new(-.5, -.5, .5)),
	LineSegment.new(Vector3.new(-.5, -.5, .5), Vector3.one * -.5),
	LineSegment.new(Vector3.new(-.5, .5, -.5), Vector3.new(.5, .5, -.5)),
	LineSegment.new(Vector3.new(.5, .5, -.5), Vector3.one * .5),
	LineSegment.new(Vector3.one * .5, Vector3.new(-.5, .5, .5)),
	LineSegment.new(Vector3.new(-.5, .5, .5), Vector3.new(-.5, .5, -.5)),
	LineSegment.new(Vector3.one * -.5, Vector3.new(-.5, .5, -.5)),
	LineSegment.new(Vector3.new(.5, -.5, -.5), Vector3.new(.5, .5, -.5)),
	LineSegment.new(Vector3.new(.5, -.5, .5), Vector3.one * .5),
	LineSegment.new(Vector3.new(-.5, -.5, .5), Vector3.new(-.5, .5, .5))
}

local Dummy = function<Value>(value: Value): Value
	return value
end

--[=[
	Returns a new <strong>Tween</strong> to morph the visibility of <code>Wireframe</code>.
]=]
@native
local function GetVisibilityTween(plot: Plots.Plot, wireframeWrapper: WireframeWrapper.WireframeWrapper, visible: boolean): Tween
	local alpha = Alphas[wireframeWrapper]

	if not Dummy(alpha) then
		local wireframe = wireframeWrapper.Wireframe
		local boundarySize = plot.Boundary.Size

		alpha = Instance.new("NumberValue")
		alpha.Value = wireframe.Scale.Y / boundarySize.Y

		Callback.CallAndConnect(function(value: number)
			wireframe.Scale = Vector3.new(1, value, 1) * boundarySize
			wireframe.CFrame = CFrame.new(Vector3.yAxis * (boundarySize.Y * (value - 1) / 2))
			wireframe.Transparency = 1 - value
		end, alpha.Changed, alpha.Value)

		Alphas[wireframeWrapper] = alpha
	end

	local tween =
		if visible
		then TweenService:Create(alpha, TweenParameters1Out, {Value = 1})
		else TweenService:Create(alpha, TweenParameters1In, {Value = 0})

	tween.Completed:Connect(function(playbackState)
		if playbackState == Enum.PlaybackState.Completed then
			alpha:Destroy()

			Alphas[wireframeWrapper] = nil
		end
	end)

	return tween
end

--[=[
	Returns an <strong>array</strong> of <strong>LineSegments</strong> comprising a grid with <code>Size</code> and <code>Scale</code>.
]=]
@native
local function GetGridLines(size: Vector2, scale: number): {LineSegment.LineSegment}
	local increment = Vector2.one * scale / size
	local lines: {LineSegment.LineSegment} = {}

	for index = -.5 + increment.X, .5 - increment.X, increment.X do
		table.insert(lines, LineSegment.new(Vector3.new(index, -.5, -.5), Vector3.new(index, -.5, .5)))
	end

	for index = -.5 + increment.Y, .5 - increment.Y, increment.Y do
		table.insert(lines, LineSegment.new(Vector3.new(-.5, -.5, index), Vector3.new(.5, -.5, index)))
	end

	return lines
end

local LocalPlotChangedDestructor = Destructor.new()

Callback.CallAndConnect(function()
	LocalPlotChangedDestructor:Destruct()

	local plot = LocalOccupant.Plot

	if not plot then
		return
	end

	local wireframeWrapper = Wireframes[plot]
	local wireframe = wireframeWrapper and wireframeWrapper.Wireframe

	local visible = wireframeWrapper and Visibilities[wireframeWrapper]
	local color = wireframeWrapper and Colors[wireframeWrapper]

	if not Dummy(wireframe) then
		wireframe = Instance.new("WireframeHandleAdornment")
		wireframeWrapper = WireframeWrapper.new(wireframe)

		visible = ValueWrapper.new(false)
		color = Instance.new("Color3Value")

		Visibilities[wireframeWrapper] = visible
		Colors[wireframeWrapper] = color

		wireframeWrapper.Destructing:Connect(function()
			visible:Destruct()
			color:Destroy()

			Visibilities[wireframeWrapper] = nil
			Colors[wireframeWrapper] = nil
		end)

		local boundarySize = plot.Boundary.Size

		wireframeWrapper:Add(GetGridLines(Vector2.new(boundarySize.X, boundarySize.Z), GRID_SCALE))
		wireframeWrapper:Add(CubeEdges)

		local boundaryPart: BasePart = plot.PlotModel:WaitForChild("Boundary") :: any

		wireframe.Transparency = TRANSPARENCY
		wireframe.Adornee = boundaryPart
		wireframe.Parent = boundaryPart

		wireframeWrapper:Enable()

		Wireframes[plot] = wireframeWrapper
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(visible: boolean)
		GetVisibilityTween(plot, wireframeWrapper, visible):Play()
	end, visible.Changed, visible.Value))

	LocalPlotChangedDestructor:Add(Callback.CallAndConnect(function(color: Color3)
		wireframe.Color3 = color
	end, color.Changed, color.Value))

	local toolEnabledChangedEvents: {RBXScriptSignal} = {}

	for _, tool in Tools :: any do
		table.insert(toolEnabledChangedEvents, tool.Enabled.Changed)
	end

	LocalPlotChangedDestructor:Add(Callback.CallAndConnectToEach(function(enabled: boolean?)
		if enabled == false then
			task.defer(coroutine.running())

			coroutine.yield()
		end

		local enabledToolName: string?, enabledTool: any?

		for name: string, tool in Tools :: any do
			if tool.Enabled.Value then
				enabledToolName, enabledTool = name, tool

				break
			end
		end

		local wasVisible = visible.Value

		visible:Set(not not enabledTool)

		if not enabledTool then
			return
		end

		local THEME_COLOR: Color3 = TOOLS[enabledToolName].THEME_COLOR

		if not wasVisible then
			color.Value = THEME_COLOR

			return
		end

		TweenService:Create(color, TweenParameters2, {
			Value = THEME_COLOR
		}):Play()
	end, toolEnabledChangedEvents))

	LocalPlotChangedDestructor:Add(function()
		local tween = GetVisibilityTween(plot, wireframeWrapper, false)

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				wireframe:Destroy()

				Wireframes[plot] = nil
			end
		end)

		tween:Play()
	end)
end, LocalOccupant.PlotChanged)

-- </Script #80 End>
--[[
<Script #81 Begin>
<Metadata Begin>
Name: "ToolReplicator"
Type: Script
Context: Legacy
Path: ServerScriptService.Plots.ToolReplicator
Size: 6621 Character(s), 198 Line(s)
</Metadata End>
]]

--!strict
-- TODO: Extend Source Code.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(ReplicatedModules:WaitForChild("Constants"))

local ASSET_TAG = CONSTANTS.Assets.TAG

local MAX_OVERLAP_PARTS = CONSTANTS.SpatialQueries.MAX_OVERLAP_PARTS

local EPSILON = CONSTANTS.ArithmeticOperations.EPSILON

local Classes = ReplicatedModules:WaitForChild("Classes")
local Cuboid = require(Classes:WaitForChild("Cuboid"))

local Libraries = ReplicatedModules:WaitForChild("Libraries")
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Values = ReplicatedModules:WaitForChild("Values")
local AssetBudgets = require(Values:WaitForChild("AssetBudgets"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ToolsRemotes = Remotes:WaitForChild("Tools")
local ConstructAssetRemote = ToolsRemotes:WaitForChild("ConstructAsset")
local DestructAssetsRemote = ToolsRemotes:WaitForChild("DestructAssets")

local ServerModules = ServerStorage:WaitForChild("Modules")

local Services = ServerModules:WaitForChild("Services")
local AssetPools = require(Services:WaitForChild("AssetPoolsServer"))
local Plots = require(Services:WaitForChild("PlotsServer"))

local StoredAssets = AssetPools.StoredAssets
local AssetPoolClass = AssetPools.AssetPool

local OccupantClass = Plots.Occupant

local OverlapParameters = OverlapParams.new()
OverlapParameters.MaxParts = MAX_OVERLAP_PARTS
OverlapParameters.FilterType = Enum.RaycastFilterType.Include

--[=[
	Returns the ancestor of <code>Instance</code> that is parented by <code>Parent</code>.
]=]
local function FindAncestingChildOfAncestor(instance: Instance, parent: Instance): Instance
	while instance do
		local currentParent = instance.Parent

		if currentParent == parent then
			return instance
		end

		instance = currentParent :: any
	end

	return nil :: any
end

--[=[
	Returns all <strong>Assets</strong> in <code>Plot.BuildModel</code> whose bounds intersect <code>Cuboid</code>.
]=]
local function GetAssetsIntersectingCuboid(cuboid: Cuboid.Cuboid, plot: Plots.Plot, overlapParams: OverlapParams?): {Model}
	local assets: {Model} = {}
	local buildModel = plot.BuildModel

	for _, part in workspace:GetPartBoundsInBox(cuboid.CFrame, cuboid.Size, overlapParams) :: {BasePart} do
		local asset: Model? = FindAncestingChildOfAncestor(part, buildModel) :: any

		if asset and asset:HasTag(ASSET_TAG) and not table.find(assets, asset) then
			table.insert(assets, asset)
		end
	end

	return assets
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of <strong>Assets</strong> parented by <code>Plot.BuildModel</code>.
]=]
local function IsArrayOfAssetsParentedByBuildModel(value: any, plot: Plots.Plot): boolean
	if type(value) ~= "table" then
		return false
	end

	local buildModel = plot.BuildModel

	for _, value in value do
		if typeof(value) ~= "Instance" or not value:HasTag(ASSET_TAG) or value.Parent ~= buildModel then
			return false
		end
	end

	return true
end

local RunningCount = 0

ConstructAssetRemote.OnServerInvoke = function(player: Player, asset: Model, pivot: CFrame, ...): boolean?
	RunningCount += 1

	local _, result: boolean? = xpcall(@native function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerInvoke' of {ConstructAssetRemote} are not nullary.`)

		local occupant = OccupantClass.GetOccupant(player)
		local plot = assert(occupant.Plot, `Called callback 'OnServerInvoke' of {ConstructAssetRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)
		local buildModel = plot.BuildModel

		assert(not plot.Spawned, `Called callback 'OnServerInvoke' of {ConstructAssetRemote} while property 'Spawned' of {plot} is {plot.Spawned} and not a falsy value.`)
		assert(table.find(StoredAssets, asset), `Argument 'Asset' to callback 'OnServerInvoke' of {ConstructAssetRemote} is {asset} and not a value in {StoredAssets}.`)

		local thread = coroutine.running()

		for _ = 0, RunningCount do
			task.defer(thread)

			coroutine.yield()
		end

		local assetPool = AssetPoolClass.GetAssetPool(plot)
		local id: number = asset:GetAttribute("__Id")

		if assetPool.TotalAssets.Value >= AssetBudgets.Total or assetPool.AssetCounts[id].Value >= AssetBudgets[id] then
			return false
		end

		assert(typeof(pivot) == "CFrame", `Argument 'Pivot' to callback 'OnServerInvoke' of {ConstructAssetRemote} is {pivot} and not a CFrame.`)

		local cframe, size = asset:GetBoundingBox()
		cframe = pivot * asset:GetPivot():Inverse() * cframe

		OverlapParameters.FilterDescendantsInstances = {buildModel}

		if
			not Cuboid.new(cframe, size):IsCuboidEnclosed(plot.Boundary)
			or #GetAssetsIntersectingCuboid(Cuboid.new(cframe, size - Vector3.one * (EPSILON * 2)), plot, OverlapParameters) > 0
		then
			return false
		end

		local newAsset = asset:Clone()
		newAsset:PivotTo(pivot)

		for _, part: BasePart in Hierarchy.GetDescendantsWhichAreA(newAsset, "BasePart") :: any do
			part.Anchored = true
		end

		newAsset.Parent = buildModel

		return true
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)

	RunningCount -= 1

	return result
end

DestructAssetsRemote.OnServerEvent:Connect(function(player, assets: (Model | {Model})?, ...)
	xpcall(@native function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {DestructAssetsRemote} are not nullary.`)

		local occupant = OccupantClass.GetOccupant(player)
		local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {DestructAssetsRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

		assert(not plot.Spawned, `Called callback 'OnServerEvent' of {DestructAssetsRemote} while property 'Spawned' of {plot} is {plot.Spawned} and not a falsy value.`)

		if assets == nil then
			assert(plot.Owner == occupant, `Called callback 'OnServerEvent' of {DestructAssetsRemote} while property 'Owner' of {plot} is {plot.Owner} and not {occupant}.`)

			print(`[{script}]: Received signal from {player} to wipe {plot}`)

			for _, asset: Model in Hierarchy.GetChildrenWithTag(plot.BuildModel, ASSET_TAG) :: any do
				asset:Destroy()
			end

			return
		end

		if type(assets) ~= "table" then
			assets = {assets}
		end

		if not IsArrayOfAssetsParentedByBuildModel(assets, plot) then
			return
		end

		for _, asset: Model in assets :: any do
			asset:Destroy()
		end
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

-- </Script #81 End>
--[[
<Script #82 Begin>
<Metadata Begin>
Name: "ClientDisconnectInitiatedInvoker"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Debug.ClientDisconnectInitiatedInvoker
Size: 1403 Character(s), 53 Line(s)
</Metadata End>
]]

--!strict
local EXPIRY_DELAY = 2 -- Second(s)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DebugRemotes = Remotes:WaitForChild("Debug")
local ClientDisconnectInitiatedRemote = DebugRemotes:WaitForChild("ClientDisconnectInitiated")

if RunService:IsStudio() then
	print(`[{script}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	script:Destroy()

	return
end

game.OnClose = function()
	print(`[{script}]: Disconnect initiated. Invoking {ClientDisconnectInitiatedRemote}...`)

	local thread = Instance.new("BindableEvent")

	local threads = {
		task.spawn(function()
			ClientDisconnectInitiatedRemote:InvokeServer(workspace:GetServerTimeNow())

			thread:Fire(true)
		end),
		task.delay(EXPIRY_DELAY, thread.Fire, thread, nil)
	}

	local timestamp = os.clock()

	local result: boolean? = thread.Event:Wait()

	for _, thread in threads do
		task.cancel(thread)
	end

	if result then
		print(`[{script}]: {ClientDisconnectInitiatedRemote} returned in {math.floor((os.clock() - timestamp) * 1e3)} ms. Resuming closure.`)
	else
		warn(`[{script}]: {ClientDisconnectInitiatedRemote} did not return in less than or equal to {EXPIRY_DELAY} second(s). Resuming closure.`)
	end

	task.defer(function()
		game.OnClose = nil

		script:Destroy()
	end)
end

-- </Script #82 End>
--[[
<Script #83 Begin>
<Metadata Begin>
Name: "DefaultLoadingScreenRemover"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Setup.DefaultLoadingScreenRemover
Size: 220 Character(s), 8 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
local ReplicatedFirst = game:GetService("ReplicatedFirst")
ReplicatedFirst:RemoveDefaultLoadingScreen()

print(`[{script}]: Called {ReplicatedFirst}.RemoveDefaultLoadingScreen`)

script:Destroy()

-- </Script #83 End>
--[[
<Script #84 Begin>
<Metadata Begin>
Name: "LogicalProcessorCountPrinterServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Debug.LogicalProcessorCountPrinterServer
Size: 641 Character(s), 19 Line(s)
</Metadata End>
]]

--!strict
if not game:IsLoaded() then
	game.Loaded:Wait()
end

task.wait(2.5)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Values = Modules:WaitForChild("Values")
local LogicalProcessorCount = require(Values:WaitForChild("LogicalProcessorCount"))
local NumericalPrefixes = require(Values:WaitForChild("NumericalPrefixes"))

TestService:Message(`[{script}]: Logical Processor Count: {LogicalProcessorCount} ({NumericalPrefixes[LogicalProcessorCount] or LogicalProcessorCount}-threaded)`)

script:Destroy()

-- </Script #84 End>
--[[
<Script #85 Begin>
<Metadata Begin>
Name: "Changelog"
Type: Script
Context: Legacy
Path: ServerStorage.Documents.Changelog
Size: 210 Character(s), 12 Line(s)
</Metadata End>
]]

--!nolint
--[=[ Changelog:
	E.g.: [Version *Place Version #* - *Date (MM/DD/YYYY Format)* @ *Time (HH/MM AM/PM Format)* UTC]: {
		- Lorem ipsum dolor sit amet.
		- Foo
		- Bar
		- Baz
		- Qux
		...
	}
	...
]=]

-- </Script #85 End>
--[[
<Script #86 Begin>
<Metadata Begin>
Name: "AssetPoolsServer"
Type: ModuleScript
Path: ServerStorage.Modules.Services.AssetPoolsServer
Size: 7958 Character(s), 307 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local AssetsFolder = ReplicatedStorage:WaitForChild("Assets")

local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(ReplicatedModules:WaitForChild("Constants"))

local ASSET_TAG = CONSTANTS.Assets.TAG

local EXPIRY_DELAY = CONSTANTS.GetterCalls.EXPIRY_DELAY

local Classes = ReplicatedModules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Libraries = ReplicatedModules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local String = require(Libraries:WaitForChild("String"))

local ServerModules = ServerStorage:WaitForChild("Modules")

local Services = ServerModules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsServer"))

local StoredAssets: {[number]: Model} = {}

do
	--[=[
		Returns all descendants of <code>Instance</code> that are <strong>Assets</strong>.
	]=]
	local function GetStoredAssets(instance: Instance): {Model}
		local assets: {Model} = {}

		for _, child in instance:GetChildren() do
			if child:HasTag(ASSET_TAG) then
				table.insert(assets, child :: any)
			elseif child:IsA("Folder") then
				for _, asset in GetStoredAssets(child) do
					table.insert(assets, asset)
				end
			end
		end

		return assets
	end

	local ClashingIds: {[number]: {Model}} = {}

	setmetatable(ClashingIds, {
		__index = function(_, id: number): {Model}
			return rawset(ClashingIds, id, {})[id]
		end
	})

	for _, asset in GetStoredAssets(AssetsFolder) do
		local id = asset:GetAttribute("__Id")
		local clashingAsset = StoredAssets[id]

		if clashingAsset then
			local clashingAssets = ClashingIds[id]

			if not table.find(clashingAssets, clashingAsset) then
				table.insert(clashingAssets, clashingAsset)
			end

			table.insert(clashingAssets, asset)
		end

		StoredAssets[id] = asset
	end

	print(`[{script}]: Stored Assets: {String.FormatTable(StoredAssets)}`)

	if #ClashingIds > 0 then
		warn(`[{script}]: StoredAssets has clashing ID(s) (Two or more Stored Assets share same '__Id' attributes):`, ClashingIds)
	end

	local HoleyIndices: {number} = {}

	for index = 1, table.maxn(StoredAssets) do
		if not StoredAssets[index] then
			table.insert(HoleyIndices, index)
		end
	end

	if #HoleyIndices > 0 then
		warn(`[{script}]: StoredAssets has holey indice(s) (Gap(s) between IDs):`, table.concat(HoleyIndices, ", "))
	end
end

local AssetPool = {} :: AssetPoolImplementation
AssetPool.__index = AssetPool

local AssetPools: {[Plots.Plot]: AssetPool} = {}

local AssetPoolAdded = Instance.new("BindableEvent")
local AssetPoolRemoving = Instance.new("BindableEvent")

type AssetPoolImplementation = {
	__index: AssetPoolImplementation,
	__tostring: (self: AssetPool) -> string,
	_Add: (self: AssetPool, asset: Model) -> (),
	_Remove: (self: AssetPool, asset: Model) -> (),
	new: (plot: Plots.Plot) -> AssetPool,
	Destruct: (self: AssetPool) -> (),
	GetAssetPool: (plot: Plots.Plot) -> AssetPool
}

type AssetPoolProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_AssetAdded: BindableEvent,
	_AssetRemoving: BindableEvent,
	_HoleyIndices: {number},
	Plot: Plots.Plot,
	Assets: {Model},
	AssetAdded: RBXScriptSignal,
	AssetRemoving: RBXScriptSignal,
	TotalAssets: NumberValue,
	AssetCounts: {[number]: NumberValue},
	Destructing: RBXScriptSignal
}

export type AssetPool = typeof(
	setmetatable(
		{} :: AssetPoolProperties,
		{} :: AssetPoolImplementation
	)
)

do
	function AssetPool:__tostring(): string
		return `AssetPool: {self.Plot}`
	end

	function AssetPool:_Add(asset: Model)
		local index: number

		local holeyIndices = self._HoleyIndices
		local headIndex = holeyIndices[1]

		if headIndex then
			index = headIndex

			table.remove(holeyIndices, 1)
		else
			index = #self.Assets + 1
		end

		asset:SetAttribute("__Index", index)

		self.Assets[index] = asset
		self.AssetCounts[asset:GetAttribute("__Id")].Value += 1

		self.TotalAssets.Value += 1

		self._AssetAdded:Fire(asset)
	end

	@native
	function AssetPool:_Remove(asset: Model)
		self._AssetRemoving:Fire(asset)

		local index: number = asset:GetAttribute("__Index")

		if index < #self.Assets then
			local holeyIndices = self._HoleyIndices
			local headIndex, tailIndex = 1, #holeyIndices

			while headIndex <= tailIndex do
				local middleIndex = (headIndex + tailIndex) // 2

				if holeyIndices[middleIndex] < index then
					headIndex = middleIndex + 1
				else
					tailIndex = middleIndex - 1
				end
			end

			table.insert(holeyIndices, headIndex, index)
		end

		self.Assets[index] = nil
		self.AssetCounts[asset:GetAttribute("__Id")].Value -= 1

		self.TotalAssets.Value -= 1
	end

	function AssetPool.new(plot: Plots.Plot): AssetPool
		assert(Plots.Plot.IsPlot(plot), `Argument 'Plot' to constructor 'new' of AssetPool is {plot} and not a Plot.`)
		assert(not AssetPools[plot], `Argument 'Plot' to constructor 'new' of AssetPool is {plot} and has {AssetPools[plot]}.`)

		local self = setmetatable({} :: AssetPoolProperties, AssetPool)

		self._Destructor = Destructor.new()

		self._Destructor:Add(function()
			self._Destructing:Fire()

			for _, asset in self.Assets do
				self:_Remove(asset)
			end

			AssetPoolRemoving:Fire(plot.PlotModel)
			AssetPools[plot] = nil
		end)

		self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

		self._AssetAdded = self._Destructor:Add(Instance.new("BindableEvent"))
		self._AssetRemoving = self._Destructor:Add(Instance.new("BindableEvent"))

		self._HoleyIndices = {}

		self.Destructing = self._Destructing.Event

		self.Plot = plot

		self.Assets = {}
		self.AssetAdded = self._AssetAdded.Event
		self.AssetRemoving = self._AssetRemoving.Event

		self.TotalAssets = Instance.new("NumberValue")

		self.AssetCounts = table.create(#StoredAssets)

		for index = 1, #StoredAssets do
			self.AssetCounts[index] = Instance.new("NumberValue")
		end

		local buildModel = plot.BuildModel

		self._Destructor:Add(Callback.CallForEachVarargAndConnect(function(child: Instance)
			if child:HasTag(ASSET_TAG) then
				self:_Add(child :: any)
			end
		end, buildModel.ChildAdded, unpack(buildModel:GetChildren())))

		self._Destructor:Add(buildModel.ChildRemoved:Connect(function(child: Instance)
			if child:HasTag(ASSET_TAG) then
				self:_Remove(child :: any)
			end
		end))

		AssetPools[plot] = self
		AssetPoolAdded:Fire(plot.PlotModel)

		return self
	end

	function AssetPool:Destruct()
		self._Destructor:Destruct()
	end

	function AssetPool.GetAssetPool(plot: Plots.Plot, expiryDelay: number?): AssetPool
		assert(Plots.Plot.IsPlot(plot), `Argument 'Plot' to getter 'GetAssetPool' of AssetPool is {plot} and not a Plot.`)
		assert(expiryDelay == nil or type(expiryDelay) == "number", `Argument 'ExpiryDelay' to getter 'GetAssetPool' of AssetPool is {expiryDelay} and not a number or nil.`)

		local assetPool = AssetPools[plot]

		if assetPool then
			return assetPool
		end

		expiryDelay = expiryDelay or EXPIRY_DELAY

		local thread = Instance.new("BindableEvent")

		local threads = {
			task.spawn(function()
				repeat
					AssetPoolAdded.Event:Wait()

					assetPool = AssetPools[plot]
				until assetPool

				thread:Fire(AssetPools[plot])
			end),
			task.delay(expiryDelay, thread.Fire, thread, nil)
		}

		local result: AssetPool? = thread.Event:Wait()

		for _, thread in threads do
			task.cancel(thread)
		end

		if not result then
			warn(`Argument 'Plot' to getter 'GetAssetPool' of AssetPool is {plot} and has not gotten an AssetPool for greater than or equal to {expiryDelay} second(s).`)

			coroutine.yield()
		end

		return assetPool :: any
	end
end

return {
	AssetsFolder = AssetsFolder,
	StoredAssets = StoredAssets,
	AssetPools = AssetPools,
	AssetPool = AssetPool,
	AssetPoolAdded = AssetPoolAdded.Event,
	AssetPoolRemoving = AssetPoolRemoving.Event
}

-- </Script #86 End>
--[[
<Script #87 Begin>
<Metadata Begin>
Name: "GuiScaler"
Type: LocalScript
Path: StarterPlayer.StarterPlayerScripts.Gui.GuiScaler
Size: 1878 Character(s), 55 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local GUI = CONSTANTS.Gui
local SCALE_TAG = GUI.SCALE_TAG
local SCALE_RANGE = GUI.SCALE_RANGE

local TWEENS = CONSTANTS.Tweens

local Controllers = Modules:WaitForChild("Controllers")
local Settings = require(Controllers:WaitForChild("Settings"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Scale = Settings.Gui.Scale

Scale.Predicates.IsNumberAndWithinRange = function(value)
	return type(value) == "number" and value >= SCALE_RANGE.Min and value <= SCALE_RANGE.Max
end

local TweenParameters = TweenInfo.new(TWEENS.DURATION, TWEENS.STYLE, Enum.EasingDirection.InOut)

local RealScale = Instance.new("NumberValue")
RealScale.Value = Scale.Value

Callback.CallForEachVarargAndConnect(function(uiScale: UIScale)
	if not uiScale:IsDescendantOf(PlayerGui) then
		return
	end

	local connection = Callback.CallAndConnect(function(value: number)
		uiScale.Scale = value
	end, RealScale.Changed, RealScale.Value)

	uiScale.Destroying:Connect(function()
		connection:Disconnect()
	end)
end, CollectionService:GetInstanceAddedSignal(SCALE_TAG), unpack(CollectionService:GetTagged(SCALE_TAG)))

Scale.Changed:Connect(function(value: number)
	print(`[{script}]: Tweening all present and future UIScales that are descendants of {PlayerGui:GetFullName()} with tag '_UIScale' to multiplier {value}`)

	TweenService:Create(RealScale, TweenParameters, {Value = value}):Play()
end)

-- </Script #87 End>
--[[
<Script #88 Begin>
<Metadata Begin>
Name: "InputRouter"
Type: Script
Context: Legacy
Path: ServerScriptService.Plots.InputRouter
Size: 4108 Character(s), 96 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local InputRemotes = Remotes:WaitForChild("Input")
local BulkInputsRemote = InputRemotes:WaitForChild("BulkInputs")
local InputBeganRemote = InputRemotes:WaitForChild("InputBegan")
local InputEndedRemote = InputRemotes:WaitForChild("InputEnded")

local Modules = ServerStorage:WaitForChild("Modules")

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsServer"))

local OccupantClass = Plots.Occupant

local MouseButtons = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3
}

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of values in <code>Array</code>.
]=]
local function IsArrayOfValuesInArray(value: any, array: {any}): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if not table.find(array, value) then
			return false
		end
	end

	return true
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of <strong>EnumItems</strong> of <code>Enum</code>.
]=]
local function IsArrayOfEnumItems(value: any, enum: Enum): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if typeof(value) ~= "EnumItem" or value.EnumType ~= enum then
			return false
		end
	end

	return true
end

BulkInputsRemote.OnServerEvent:Connect(function(player, keys: {Enum.KeyCode}, mouseButtons: {Enum.UserInputType}, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {BulkInputsRemote} are not nullary.`)
		assert(IsArrayOfEnumItems(keys, Enum.KeyCode), `Argument 'Keys' to callback 'OnServerEvent' of {BulkInputsRemote} is {keys} and not an array of Enum.KeyCodes.`)
		assert(IsArrayOfValuesInArray(mouseButtons, MouseButtons), `Argument 'MouseButtons' to callback 'OnServerEvent' of {BulkInputsRemote} is {mouseButtons} and not an array of values in {MouseButtons}.`)

		local occupant = OccupantClass.GetOccupant(player)
		local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {BulkInputsRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

		assert(plot.Spawned, `Called callback 'OnServerEvent' of {BulkInputsRemote} while property 'Spawned' of {plot} is {plot.Spawned} and not a truthy value.`)

		local owner = assert(plot.Owner, `Called callback 'OnServerEvent' of {BulkInputsRemote} while property 'Owner' of {plot} is {plot.Owner} and not a Player.`)

		BulkInputsRemote:FireClient(owner.Player, keys, mouseButtons)
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

for _, remote in {InputBeganRemote, InputEndedRemote} do
	remote.OnServerEvent:Connect(function(player, keyOrMouseButton: Enum.KeyCode | Enum.UserInputType, ...)
		xpcall(function(...)
			assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {remote} are not nullary.`)
			assert((typeof(keyOrMouseButton) == "EnumItem" and keyOrMouseButton.EnumType == Enum.KeyCode) or table.find(MouseButtons, keyOrMouseButton :: any), `Argument 'KeyOrMouseButton' to callback 'OnServerEvent' of {remote} is {keyOrMouseButton} and not an Enum.KeyCode or a value in {MouseButtons}.`)

			local occupant = OccupantClass.GetOccupant(player)
			local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {remote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

			assert(plot.Spawned, `Called callback 'OnServerEvent' of {remote} while property 'Spawned' of {plot} is {plot.Spawned} and not a truthy value.`)

			local owner = assert(plot.Owner, `Called callback 'OnServerEvent' of {remote} while property 'Owner' of {plot} is {plot.Owner} and not a Player.`)

			remote:FireClient(owner.Player, keyOrMouseButton)
		end, function(message: string)
			warn(debug.traceback(message))
		end, ...)
	end)
end

-- </Script #88 End>
--[[
<Script #89 Begin>
<Metadata Begin>
Name: "PlotsHandlerServer"
Type: Script
Context: Legacy
Path: ServerScriptService.Plots.PlotsHandlerServer
Size: 8676 Character(s), 253 Line(s)
</Metadata End>
]]

--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(ReplicatedModules:WaitForChild("Constants"))

local PLOTS = CONSTANTS.Plots
local PLOT_TAG = PLOTS.TAG
local MAX_OCCUPANTS = PLOTS.MAX_OCCUPANTS

local EXPIRY_DELAY = CONSTANTS.RemoteInvocations.EXPIRY_DELAY

local Classes = ReplicatedModules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Functions = ReplicatedModules:WaitForChild("Functions")
local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner"))

local ServerModules = ServerStorage:WaitForChild("Modules")

local Services = ServerModules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsServer"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlotsRemotes = Remotes:WaitForChild("Plots")
local GetPlotsRemote = PlotsRemotes:WaitForChild("GetPlots")
local SetPlotRemote = PlotsRemotes:WaitForChild("SetPlot")
local SpawnCreationRemote = PlotsRemotes:WaitForChild("SpawnCreation")
local DespawnCreationRemote = PlotsRemotes:WaitForChild("DespawnCreation")
local KickOccupantRemote = PlotsRemotes:WaitForChild("KickOccupant")

local PlotClass = Plots.Plot
local OccupantClass = Plots.Occupant

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is a <strong>PlotModel</strong>.
]=]
local function IsPlotModel(value: any): boolean
	return typeof(value) == "Instance" and value:HasTag(PLOT_TAG)
end

Players.PlayerAdded:Connect(OccupantClass.new)

Players.PlayerRemoving:Connect(function(player)
	local occupant = Plots.Occupants[player]

	if occupant then
		occupant:Destruct()
	end
end)

Plots.PlotAdded:Connect(function(plotModel: Model)
	local plot = PlotClass.GetPlot(plotModel)

	plot.OccupantRemoving:Connect(function()
		task.defer(coroutine.running())

		coroutine.yield()

		if not plot.Owner then
			plot:Destruct()
		end
	end)
end)

GetPlotsRemote.OnServerInvoke = function(player: Player, ...): {{any}}?
	return select(2, xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerInvoke' of {GetPlotsRemote} are not nullary.`)

		local plots = Plots.Plots
		local plotsData: {{any}} = table.create(#plots)

		for _, plot in plots do
			local occupants = plot.Occupants
			local occupantsData: {Player} = table.create(#occupants)

			for _, occupant in occupants do
				table.insert(occupantsData, occupant.Player)
			end

			table.insert(plotsData, {
				plot.PlotModel :: any,
				plot.Spawned,
				occupantsData
			})
		end

		return plotsData
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...))
end

local SetPlotCallbackRunningFor: {[Player]: {Model}} = {}

setmetatable(SetPlotCallbackRunningFor, {
	__index = function(_, player: Player): {Model}
		player.Destroying:Connect(function()
			SetPlotCallbackRunningFor[player] = nil
		end)

		return rawset(SetPlotCallbackRunningFor, player, {})[player]
	end
})

SetPlotRemote.OnServerInvoke = function(player: Player, plotModel: Model?, ...): boolean?
	local _, success: boolean? = xpcall(function(...)
		if plotModel then
			assert(not table.find(SetPlotCallbackRunningFor[player], plotModel), `Called callback 'OnServerInvoke' of {SetPlotRemote} while running for {plotModel}.`)

			table.insert(SetPlotCallbackRunningFor[player], plotModel)
		end

		assert(select("#", ...) == 0, `Varargs to callback 'OnServerInvoke' of {SetPlotRemote} are not nullary.`)
		assert(plotModel == nil or IsPlotModel(plotModel), `Argument 'PlotModel' to callback 'OnServerInvoke' of {SetPlotRemote} is {plotModel} and not a Model with tag '{PLOT_TAG}' or nil.`)

		local occupant = OccupantClass.GetOccupant(player)
		local currentPlot = occupant.Plot

		assert(plotModel ~= (currentPlot and currentPlot.PlotModel), `Argument 'PlotModel' to callback 'OnServerInvoke' of {SetPlotRemote} is {plotModel} and equal to property 'Plot' of {occupant}.`)

		if not plotModel then
			occupant:SetPlot(nil)

			return true
		end

		local plot = Plots.Plots[plotModel] or PlotClass.new(plotModel)
		local occupants = plot.Occupants
		local owner = plot.Owner

		assert(#occupants < MAX_OCCUPANTS, `Number of Occupants in property 'Occupants' of {plot} is {#occupants} and greater than or equal to {MAX_OCCUPANTS}.`)

		if not owner or IsPlayerExperienceOwner(player) then
			occupant:SetPlot(plot)

			return true
		end

		local thread = Instance.new("BindableEvent")
		local destructor = Destructor.new()

		destructor:Add(task.spawn(function()
			local _, authorized = xpcall(function(authorized: boolean?, ...)
				assert(select("#", ...) == 0, `Return values of method 'InvokeClient' of {SetPlotRemote} are not unary.`)
				assert(authorized == nil or type(authorized) == "boolean", `Return value #1 of method 'InvokeClient' of {SetPlotRemote} is {authorized} and not a boolean or nil.`)

				return authorized
			end, function(message: string)
				warn(debug.traceback(message))
			end, SetPlotRemote:InvokeClient(owner.Player, occupant.Player))

			thread:Fire(authorized)
		end))

		destructor:Add(task.delay(EXPIRY_DELAY, thread.Fire, thread, nil))

		for _, event in {plot.OwnerChanged, occupant.Destructing} do
			destructor:Add(event:Connect(function()
				thread:Fire(nil)
			end))
		end

		destructor:Add(task.spawn(function()
			while true do
				plot.OccupantAdded:Wait()

				if #occupants >= MAX_OCCUPANTS then
					thread:Fire(nil)
				end
			end
		end))

		local authorized: boolean? = thread.Event:Wait()

		destructor:Destruct()

		if authorized then
			occupant:SetPlot(plot)
		end

		return authorized :: any
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)

	if plotModel then
		local index = table.find(SetPlotCallbackRunningFor[player], plotModel)

		if index then
			table.remove(SetPlotCallbackRunningFor[player], index)
		end
	end

	return success
end

SpawnCreationRemote.OnServerEvent:Connect(function(owner, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {SpawnCreationRemote} are not nullary.`)

		local occupant = OccupantClass.GetOccupant(owner)
		local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {SpawnCreationRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

		assert(plot.Owner == occupant, `Called callback 'OnServerEvent' of {SpawnCreationRemote} while property 'Owner' of {plot} is {plot.Owner} and not equal to {occupant}.`)

		plot:SpawnCreation()
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

DespawnCreationRemote.OnServerEvent:Connect(function(owner, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {DespawnCreationRemote} are not nullary.`)

		local occupant = OccupantClass.GetOccupant(owner)
		local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {DespawnCreationRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

		assert(plot.Owner == occupant, `Called callback 'OnServerEvent' of {DespawnCreationRemote} while property 'Owner' of {plot} is {plot.Owner} and not equal to {occupant}.`)

		plot:DespawnCreation()
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

KickOccupantRemote.OnServerEvent:Connect(function(owner, playerToKick: Player, ...)
	xpcall(function(...)
		assert(select("#", ...) == 0, `Varargs to callback 'OnServerEvent' of {KickOccupantRemote} are not nullary.`)

		local occupant = OccupantClass.GetOccupant(owner)
		local plot = assert(occupant.Plot, `Called callback 'OnServerEvent' of {KickOccupantRemote} while property 'Plot' of {occupant} is {occupant.Plot} and not a Plot.`)

		assert(plot.Owner == occupant, `Called callback 'OnServerEvent' of {KickOccupantRemote} while property 'Owner' of {plot} is {plot.Owner} and not equal to {occupant}.`)

		local occupantToKick = OccupantClass.GetOccupant(playerToKick)

		assert(occupantToKick.Plot == plot, `Called callback 'OnServerEvent' of {KickOccupantRemote} while property 'Plot' of {occupantToKick} is {occupantToKick.Plot} and not equal to {plot}.`)

		local isOwner = IsPlayerExperienceOwner(playerToKick)

		assert(not isOwner, `Called callback 'OnServerEvent' of {KickOccupantRemote} while return value of {IsPlayerExperienceOwner} is {isOwner} and not a falsy value.`)

		occupantToKick:SetPlot(nil)
	end, function(message: string)
		warn(debug.traceback(message))
	end, ...)
end)

-- </Script #89 End>
--[[
<Script #90 Begin>
<Metadata Begin>
Name: "Settings"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Controllers.Settings
Size: 396 Character(s), 14 Line(s)
</Metadata End>
]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Classes = Modules:WaitForChild("Classes")
local ValueWrapper = require(Classes:WaitForChild("ValueWrapper"))

return {
	Gui = {
		Scale = ValueWrapper.new(if not RunService:IsStudio() then 3 / 2 else 1)
	}
}

-- </Script #90 End>
--[[
<Script #91 Begin>
<Metadata Begin>
Name: "Table"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Libraries.Table
Size: 1443 Character(s), 65 Line(s)
</Metadata End>
]]

--!strict
--!native
local Table = {}

--[=[
	Returns the concatenation of variadic <strong>arrays</strong> <code>...</code>
]=]
function Table.ConcatenateArrays<Value>(...: {Value}): {Value}
	local concatenation = {}

	for _, source in {...} do
		table.move(source, 1, #source, #concatenation + 1, concatenation)
	end

	return concatenation
end

--[=[
	Returns the merging of variadic <strong>tables</strong> <code>...</code>
]=]
function Table.Merge<Key, Value>(...: {[Key]: Value}): {[Key]: Value}
	local merged = {}

	for _, source in {...} do
		for key, value in source do
			merged[key] = value
		end
	end

	return merged
end

--[=[
	Returns the unpacked values of <code>Source</code> and any <strong>tables</strong> nested within it.
]=]
function Table.DeepUnpack<Source>(source: {Source}): ...Source
	local values = {}

	for _, value in source do
		if type(value) == "table" then
			for _, value in {Table.DeepUnpack(value)} do
				table.insert(values, value)
			end
		else
			table.insert(values, value)
		end
	end

	return unpack(values)
end

--[=[
	Freezes <code>Source</code> and any <strong>tables</strong> nested within it, then returns it.
]=]
function Table.DeepFreeze<Source>(source: Source & {}): Source
	for _, value in if table.isfrozen(source) then source else table.freeze(source) :: any do
		if type(value) == "table" and not table.isfrozen(value) then
			table.freeze(value)
		end
	end

	return source
end

return Table

-- </Script #91 End>
--[[
<Script #92 Begin>
<Metadata Begin>
Name: "Cuboid"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.Cuboid
Size: 9792 Character(s), 298 Line(s)
</Metadata End>
]]

--!strict
--!native
local Cuboid = {} :: CuboidImplementation
Cuboid.__index = Cuboid

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local EPSILON = CONSTANTS.ArithmeticOperations.EPSILON

local Classes = Modules:WaitForChild("Classes")
local OrthogonalCuboid = require(Classes:WaitForChild("OrthogonalCuboid"))

local Libraries = Modules:WaitForChild("Libraries")
local Table = require(Libraries:WaitForChild("Table"))

type CuboidImplementation = {
	__index: CuboidImplementation,
	__tostring: (self: Cuboid) -> string,
	__eq: (self: Cuboid, value: any) -> boolean,
	__add: (self: Cuboid, value: Cuboid | Vector3) -> Cuboid,
	__sub: (self: Cuboid, value: Cuboid | Vector3) -> Cuboid,
	__mul: (self: Cuboid, value: Cuboid | CFrame) -> Cuboid,
	__div: (self: Cuboid, value: Cuboid | CFrame) -> Cuboid,
	IsCuboid: (value: any) -> boolean,
	new: (cframe: CFrame?, size: Vector3?) -> Cuboid,
	FromCFrame: (cframe: CFrame) -> Cuboid,
	FromSize: (size: Vector3) -> Cuboid,
	GetNormals: (self: Cuboid) -> {Vector3},
	GetVertices: (self: Cuboid) -> {Vector3},
	IsPointIntersecting: (self: Cuboid, point: Vector3, epsilon: number?) -> boolean,
	IsCuboidIntersecting: (self: Cuboid, cuboid: Cuboid, epsilon: number?) -> boolean,
	IsCuboidEnclosed: (self: Cuboid, cuboid: Cuboid, epsilon: number?) -> boolean,
	ToAxisAlignedBoundingBox: (self: Cuboid) -> OrthogonalCuboid.OrthogonalCuboid,
	ResolveIntersection: (self: Cuboid, static: Cuboid) -> Cuboid,
	SnapToIncrement: (self: Cuboid, increment: number) -> Cuboid
}

type CuboidProperties = {
	CFrame: CFrame,
	Size: Vector3
}

export type Cuboid = typeof(
	setmetatable(
		{} :: CuboidProperties,
		{} :: CuboidImplementation
	)
)

--[=[
	Returns the minimum and maximum scalar dot products of each <strong>Vector3</strong> in <code>Points</code> onto <code>Vector</code>.
]=]
local function GetScalarDotProductExtents(points: {Vector3}, vector: Vector3): (number, number)
	local products = table.create(#points)

	for _, point in points do
		table.insert(products, point:Dot(vector))
	end

	return math.min(unpack(products)), math.max(unpack(products))
end

function Cuboid:__tostring(): string
	return `{self.CFrame}, {self.Size}`
end

function Cuboid:__eq(value: any): boolean
	return Cuboid.IsCuboid(value) and self.CFrame == value.CFrame and self.Size == value.Size
end

function Cuboid:__add(value: Cuboid | Vector3): Cuboid
	local isCuboid = Cuboid.IsCuboid(value)

	assert(isCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__add' of Cuboid on {self} is {value} and not a Cuboid or Vector3.`)

	if isCuboid then
		return Cuboid.new(self.CFrame + (value :: any).CFrame.Position, self.Size + (value :: any).Size)
	else
		return Cuboid.new(self.CFrame + value, self.Size)
	end
end

function Cuboid:__sub(value: Cuboid | Vector3): Cuboid
	local isCuboid = Cuboid.IsCuboid(value)

	assert(isCuboid or type(value) == "vector", `Argument 'Value' to metamethod '__sub' of Cuboid on {self} is {value} and not a Cuboid or Vector3.`)

	if isCuboid then
		return Cuboid.new(self.CFrame - (value :: any).CFrame.Position, self.Size - (value :: any).Size)
	else
		return Cuboid.new(self.CFrame - value, self.Size)
	end
end

function Cuboid:__mul(value: Cuboid | CFrame): Cuboid
	local isCuboid = Cuboid.IsCuboid(value)

	assert(isCuboid or typeof(value) == "CFrame", `Argument 'Value' to metamethod '__mul' of Cuboid on {self} is {value} and not a Cuboid or CFrame.`)

	if isCuboid then
		return Cuboid.new(self.CFrame * (value :: any).CFrame, self.Size * (value :: any).Size)
	else
		return Cuboid.new(self.CFrame * value, self.Size)
	end
end

function Cuboid:__div(value: Cuboid | CFrame): Cuboid
	local isCuboid = Cuboid.IsCuboid(value)

	assert(isCuboid or typeof(value) == "CFrame", `Argument 'Value' to metamethod '__div' of Cuboid on {self} is {value} and not a Cuboid or CFrame.`)

	if isCuboid then
		return Cuboid.new(self.CFrame * (value :: any).CFrame:Inverse(), self.Size / (value :: any).Size)
	else
		return Cuboid.new(self.CFrame * value:Inverse(), self.Size)
	end
end

function Cuboid.IsCuboid(value: any): boolean
	return type(value) == "table" and getmetatable(value) == Cuboid
end

--[=[
	Returns a new <strong>Cuboid</strong> with <code>CFrame</code> and <code>Size</code>.
]=]
local function Construct(cframe: CFrame, size: Vector3): Cuboid
	return setmetatable({
		CFrame = cframe,
		Size = size
	}, Cuboid)
end

function Cuboid.new(cframe: CFrame?, size: Vector3?): Cuboid
	assert(cframe == nil or typeof(cframe) == "CFrame", `Argument 'CFrame' to constructor 'new' of Cuboid is {cframe} and not a CFrame or nil.`)
	assert(size == nil or type(size) == "vector", `Argument 'Size' to constructor 'new' of Cuboid is {size} and not a Vector3 or nil.`)

	return Construct(cframe or CFrame.new(), size or Vector3.zero)
end

function Cuboid.FromCFrame(cframe: CFrame): Cuboid
	assert(typeof(cframe) == "CFrame", `Argument 'CFrame' to constructor 'FromCFrame' of Cuboid is {cframe} and not a CFrame.`)

	return Construct(cframe, Vector3.zero)
end

function Cuboid.FromSize(size: Vector3): Cuboid
	assert(type(size) == "vector", `Argument 'Size' to constructor 'FromSize' of Cuboid is {size} and not a Vector3.`)

	return Construct(CFrame.new(), size)
end

function Cuboid:GetNormals(): {Vector3}
	local cframe = self.CFrame

	return {
		cframe.XVector, cframe.YVector, cframe.ZVector,
		-cframe.XVector, -cframe.YVector, -cframe.ZVector
	}
end

function Cuboid:GetVertices(): {Vector3}
	local cframe, halfSize = self.CFrame, self.Size / 2

	return {
		cframe * halfSize,
		cframe * Vector3.new(halfSize.X, halfSize.Y, -halfSize.Z),
		cframe * Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
		cframe * Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
		cframe * Vector3.new(-halfSize.X, halfSize.Y, halfSize.Z),
		cframe * Vector3.new(-halfSize.X, halfSize.Y, -halfSize.Z),
		cframe * Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
		cframe * -halfSize
	}
end

function Cuboid:IsPointIntersecting(point: Vector3, epsilon: number?): boolean
	epsilon = epsilon or EPSILON

	local cframe = self.CFrame
	local vertices = Cuboid.new(cframe, self.Size + Vector3.one * (epsilon :: any * 2)):GetVertices()

	for _, vector in {cframe.XVector, cframe.YVector, cframe.ZVector} do
		local min, max = GetScalarDotProductExtents(vertices, vector)
		local product = point:Dot(vector)

		if product < min or product > max then
			return false
		end
	end

	return true
end

function Cuboid:IsCuboidIntersecting(cuboid: Cuboid, epsilon: number?): boolean
	epsilon = epsilon or EPSILON

	local vertices1, vertices2 = Cuboid.new(self.CFrame, self.Size - Vector3.one * (epsilon :: any * 2)):GetVertices(), cuboid:GetVertices()

	for _, normal in Table.ConcatenateArrays(self:GetNormals(), cuboid:GetNormals()) do
		local min1, max1 = GetScalarDotProductExtents(vertices1, normal)
		local min2, max2 = GetScalarDotProductExtents(vertices2, normal)

		if min1 > max2 or max1 < min2 then
			return false
		end
	end

	return true
end

function Cuboid:IsCuboidEnclosed(cuboid: Cuboid, epsilon: number?): boolean
	epsilon = epsilon or EPSILON

	local vertices1, vertices2 = self:GetVertices(), Cuboid.new(cuboid.CFrame, cuboid.Size + Vector3.one * (epsilon :: any * 2)):GetVertices()

	for _, normal in Table.ConcatenateArrays(self:GetNormals(), cuboid:GetNormals()) do
		local min1, max1 = GetScalarDotProductExtents(vertices1, normal)
		local min2, max2 = GetScalarDotProductExtents(vertices2, normal)

		if min1 < min2 or max1 > max2 then
			return false
		end
	end

	return true
end

local AxisEnums = Enum.Axis:GetEnumItems()

function Cuboid:ToAxisAlignedBoundingBox(): OrthogonalCuboid.OrthogonalCuboid
	local vertices = self:GetVertices()
	local minComponents: {number}, maxComponents: {number} = table.create(3), table.create(3)

	for index, axis in AxisEnums do
		minComponents[index], maxComponents[index] = GetScalarDotProductExtents(vertices, Vector3.FromAxis(axis))
	end

	local min, max = Vector3.new(unpack(minComponents)), Vector3.new(unpack(maxComponents))

	return OrthogonalCuboid.new((max + min) / 2, max - min)
end

function Cuboid:ResolveIntersection(static: Cuboid): Cuboid
	local dynamicVertices, staticVertices = self:GetVertices(), static:GetVertices()
	local translation, minDelta = Vector3.zero, math.huge

	for _, normal in Table.ConcatenateArrays(self:GetNormals(), static:GetNormals()) do
		local dynamicMin, dynamicMax = GetScalarDotProductExtents(dynamicVertices, normal)
		local staticMin, staticMax = GetScalarDotProductExtents(staticVertices, normal)

		if dynamicMin > staticMax or dynamicMax < staticMin then
			return self
		end

		local delta = staticMax - dynamicMin
		local scaledDelta = delta / (dynamicMax - dynamicMin)

		if scaledDelta < minDelta then
			translation, minDelta = normal * delta, scaledDelta
		end
	end

	return self + Cuboid.FromCFrame(CFrame.new(translation))
end

local AxisNames: {string} = table.create(3)

for _, axis in AxisEnums do
	table.insert(AxisNames, axis.Name)
end

function Cuboid:SnapToIncrement(increment: number): Cuboid
	local aabb = self:ToAxisAlignedBoundingBox()
	local position, size = aabb.Position, aabb.Size

	local components: {number} = table.create(3)

	for _, name in AxisNames do
		local coordinate = (position :: any)[name]
		local component: number

		if math.round((size :: any)[name] * increment) % 2 == 0 then
			component = math.round(coordinate / increment) * increment
		else
			component = coordinate // increment * increment + increment / 2
		end

		table.insert(components, component)
	end

	return Cuboid.new(self.CFrame.Rotation + Vector3.new(unpack(components)), self.Size)
end

return Cuboid

-- </Script #92 End>
--[[
<Script #93 Begin>
<Metadata Begin>
Name: "AssetBudgets"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Values.AssetBudgets
Size: 593 Character(s), 31 Line(s)
</Metadata End>
]]

--!strict
-- Schema: {[<Asset ID #>]: <Asset Budget #>}
return table.freeze(setmetatable({
	Total = 5_000,

--[[
	 ↓ ID ↓ Budget      ↓ Name?
]]	[1] = math.huge, -- Cube
	[2] = math.huge, -- Beam 7x1x1
	[3] = math.huge, -- Half Slab

	[4] = math.huge, -- Wedge
	[5] = math.huge, -- Corner Wedge

	[6] = math.huge, -- Cylinder
	[7] = math.huge, -- Sphere

	[8] = 1_000, -- Truss 2x8x2

	[9] = 500, -- Traction Wheel 0.5x3x3

	[10] = 250, -- Motor
	[11] = 500, -- Suspension

	[12] = 100, -- Chair
	[13] = 50 -- Control Chair
}, {
	__index = function(): number
		return math.huge
	end
}))

-- </Script #93 End>
--[[
<Script #94 Begin>
<Metadata Begin>
Name: "FirstGuiReparenter"
Type: LocalScript
Path: ReplicatedFirst.Gui.FirstGuiReparenter
Size: 247 Character(s), 12 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
local Folder = script.Parent
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

for _, child in Folder:GetChildren() do
	if child:IsA("ScreenGui") then
		child.Parent = PlayerGui
	end
end

Folder:Destroy()

-- </Script #94 End>
--[[
<Script #95 Begin>
<Metadata Begin>
Name: "String"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Libraries.String
Size: 4581 Character(s), 154 Line(s)
</Metadata End>
]]

--!strict
--!native
local String = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local Libraries = Modules:WaitForChild("Libraries")
local Table = require(Libraries:WaitForChild("Table"))

--[=[
	Returns <code>Source</code> converted to <em>CamelCase</em>.
]=]
function String.ToCamelCase(source: string): string
	return source:gsub("(%S+)", function(word)
		return word:sub(1, 1):upper() .. word:sub(2):lower()
	end):gsub("%s+", "")
end

--[=[
	Returns <code>Source</code> with all rich text magic characters replaced with their escape forms.
]=]
function String.EscapeRichText(source: string): string
	return source
		:gsub("&", "&amp;")
		:gsub("<", "&lt;")
		:gsub(">", "&gt;")
		:gsub('"', "&quot;")
		:gsub("'", "&apos;")
end

--[=[
	Returns a <strong>string</strong> representing <code>Value</code> formatted to <code>Precision</code> with comma thousands separators, and trailing zeroes and extraneous decimal points truncated.
]=]
function String.FormatNumber(value: number, precision: number?): string
	precision = precision or 0

	local sign, integer, fraction = (select :: any)(3, string.format(`%.{precision}f`, value):find("([-]?)(%d+)([.]?%d*)"))

	return sign
		.. integer:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		.. fraction:gsub("%.?0+$", "")
end

--[=[
	Returns a <strong>string</strong> representing <code>Source</code> in <strong>dictionary</strong>-like formatting.
]=]
function String.FormatTable(source: {[any]: any}): string
	local traversed: {[{[any]: any}]: true} = {}

	local function Recursor(values: {[any]: any}): string
		if traversed[values] then
			return "*Cyclic*"
		end

		traversed[values] = true

		local metatable = getmetatable(values :: any)
		local hasMetatableIndex = false

		if metatable and rawget(metatable, "__index") == metatable then
			local prefixedKeysMetatable = {}

			for key, value in metatable do
				prefixedKeysMetatable[`*{key}`] = value
			end

			values = Table.Merge(values, prefixedKeysMetatable)

			traversed[metatable], hasMetatableIndex = true, true
		end

		if not next(values) then
			return "{}"
		end

		local conversions: {string} = {}

		local function Convert(value: any): string
			local conversion = tostring(value)
			local typeName = typeof(value)

			if typeName == "table" then
				return `{conversion} {Recursor(value):gsub("\n", "\n\t")}`
			elseif typeName == "string" then
				return `{typeName} "{conversion}"`
			elseif typeName == "number" then
				return `{typeName}{if math.abs(value) == math.huge or value ~= value then " " elseif value % 1 == 0 then " int " else " float "}{conversion}`
			elseif typeName == "function" then
				local line: number, name: string, arity: number, isVariadic: boolean = debug.info(value, "lna")

				return `'{conversion}' Line: {line}, Name: {if name ~= "" then `'{name}'` else "<Anonymous>"}, Arity: {arity}, Variadic: {isVariadic}`
			elseif typeName == "Instance" then
				return `{value.ClassName} {typeName} '{conversion}'`
			end

			if conversion:sub(1, #typeName) ~= typeName then
				conversion = `{typeName} {conversion}`
			end

			return conversion
		end

		for key, value in values do
			table.insert(conversions, `[{Convert(key)}]: {Convert(value)}`)
		end

		table.sort(conversions, function(value1, value2)
			local index1 = tonumber(value1:match("%[number.-(%-?[%d%.]+)"))
			local index2 = tonumber(value2:match("%[number.-(%-?[%d%.]+)"))

			return if index1 and index2 then index1 < index2 else value1 < value2
		end)

		return `\{\n\t{table.concat(conversions, ",\n\t")}\n\}{if hasMetatableIndex then " *Meta*" else ""}`
	end

	return `{source} {Recursor(source)}`
end

--[=[
	Returns a <strong>string</strong> representing the descendant hierarchy tree of <code>Instances</code> in <strong>dictionary</strong>-like formatting.
]=]
function String.FormatHierarchy(instances: {Instance}): string
	local function Recursor(instances: {Instance}): string
		if not next(instances) then
			return "{}"
		end

		local conversions: {string} = {}

		local function Convert(instance: Instance): string
			local descendants = Recursor(instance:GetChildren())
			local conversion = `{instance.ClassName} "{instance.Name}"`

			if descendants ~= "{}" then
				conversion ..= ` {descendants:gsub("\n", "\n\t")}`
			end

			return conversion
		end

		for _, instance in instances do
			table.insert(conversions, Convert(instance))
		end

		return `\{\n\t{table.concat(conversions, ",\n\t")}\n\}`
	end

	return Recursor(instances)
end

return String

-- </Script #95 End>
--[[
<Script #96 Begin>
<Metadata Begin>
Name: "CameraInitializer"
Type: LocalScript
Path: ReplicatedFirst.Scripts.Setup.CameraInitializer
Size: 662 Character(s), 18 Line(s)
</Metadata End>
]]

--!strict
--!optimize 2
local FIELD_OF_VIEW = math.lerp(0, math.deg(math.pi / 2), 7 / 8) -- Degree(s)

if game:GetService("UserInputService").VREnabled and game:GetService("VRService").VREnabled then
	print(`[{script}]: Virtual Reality (VR) is Enabled. Setting <LocalPlayer>.CameraMaxZoomDistance to <LocalPlayer>.CameraMinZoomDistance.`)

	local LocalPlayer = game:GetService("Players").LocalPlayer
	LocalPlayer.CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance
end

local SetFieldOfView = function()
	workspace.CurrentCamera.FieldOfView = FIELD_OF_VIEW
end

SetFieldOfView()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(SetFieldOfView)

-- </Script #96 End>
--[[
<Script #97 Begin>
<Metadata Begin>
Name: "Callback"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Libraries.Callback
Size: 2558 Character(s), 71 Line(s)
</Metadata End>
]]

--!nocheck
--!native
local Callback = {}

--[=[
	Calls <code>Callback</code> with varargs <code>...</code> and returns it.
]=]
function Callback.CallAndReturn<Callback, Arguments...>(callback: Callback & (Arguments...) -> (), ...: Arguments...): Callback
	callback(...)

	return callback
end

--[=[
	Returns an <strong>array</strong> of each <strong>RBXScriptConnection</strong> to each <strong>RBXScriptSignal</strong> in <code>Signals</code>.
]=]
function Callback.ConnectToEach<Arguments...>(callback: (Arguments...) -> (), signals: {RBXScriptSignal}): {RBXScriptConnection}
	local connections: {RBXScriptConnection} = table.create(#signals)

	for _, signal in signals do
		table.insert(connections, signal:Connect(callback))
	end

	return connections
end

--[=[
	Calls <code>Callback</code> with varargs <code>...</code> and returns its <strong>RBXScriptConnection</strong> to <code>Signal</code>.
]=]
function Callback.CallAndConnect<Arguments...>(callback: (Arguments...) -> (), signal: RBXScriptSignal, ...: Arguments...): RBXScriptConnection
	callback(...)

	return signal:Connect(callback)
end

--[=[
	Calls <code>Callback</code> with varargs <code>...</code> and returns an <strong>array</strong> of each <strong>RBXScriptConnection</strong> to each <strong>RBXScriptSignal</strong> in <code>Signals</code>.
]=]
function Callback.CallAndConnectToEach<Arguments...>(callback: (Arguments...) -> (), signals: {RBXScriptSignal}, ...: Arguments...): {RBXScriptConnection}
	callback(...)

	return Callback.ConnectToEach(callback, signals)
end

--[=[
	Calls <code>Callback</code> for each vararg in <code>...</code> and returns its <strong>RBXScriptConnection</strong> to <code>Signal</code>.
]=]
function Callback.CallForEachVarargAndConnect<Arguments...>(callback: (Arguments...) -> (), signal: RBXScriptSignal, ...: Arguments...): RBXScriptConnection
	local arguments = {...}

	for index = 1, #arguments do
		(callback :: any)(arguments[index])
	end

	return signal:Connect(callback)
end

--[=[
	Calls <code>Callback</code> for each vararg in <code>...</code> and returns an <strong>array</strong> of each <strong>RBXScriptConnection</strong> to each <strong>RBXScriptSignal</strong> in <code>Signals</code>.
]=]
function Callback.CallForEachVarargAndConnectToEach<Arguments...>(callback: (Arguments...) -> (), signals: {RBXScriptSignal}, ...: Arguments...): {RBXScriptConnection}
	local arguments = {...}

	for index = 1, #arguments do
		(callback :: any)(arguments[index])
	end

	return Callback.ConnectToEach(callback, signals)
end

return Callback

-- </Script #97 End>
--[[
<Script #98 Begin>
<Metadata Begin>
Name: "AssetSelector"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Classes.AssetSelector
Size: 12757 Character(s), 453 Line(s)
</Metadata End>
]]

--!strict
local AssetSelector = {} :: AssetSelectorImplementation
AssetSelector.__index = AssetSelector

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local CONSTANTS = require(Modules:WaitForChild("Constants"))

local ASSET_TAG = CONSTANTS.Assets.TAG

local ASSET_SELECTOR_MODE_KEYS = CONSTANTS.AssetSelectorModeKeys
local MARQUEE_MODE_KEY = ASSET_SELECTOR_MODE_KEYS.MARQUEE
local INVERT_MODE_KEY = ASSET_SELECTOR_MODE_KEYS.INVERT

local MAX_RAYCAST_LENGTH = CONSTANTS.SpatialQueries.MAX_RAYCAST_LENGTH

local Classes = Modules:WaitForChild("Classes")
local Destructor = require(Classes:WaitForChild("Destructor"))

local Libraries = Modules:WaitForChild("Libraries")
local Callback = require(Libraries:WaitForChild("Callback"))
local Hierarchy = require(Libraries:WaitForChild("Hierarchy"))

local Services = Modules:WaitForChild("Services")
local Plots = require(Services:WaitForChild("PlotsClient"))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local LocalOccupant = Plots.LocalOccupant

local LocalPlot: Plots.Plot
local LocalPlotChanged = Instance.new("BindableEvent")

Callback.CallAndConnect(function()
	LocalPlot = LocalOccupant.Plot :: any
	LocalPlotChanged:Fire()
end, LocalOccupant.PlotChanged)

local RaycastParameters = RaycastParams.new()
RaycastParameters.IgnoreWater = true
RaycastParameters.FilterType = Enum.RaycastFilterType.Include
RaycastParameters.FilterDescendantsInstances = {workspace.Terrain}

task.spawn(function()
	RaycastParameters:AddToFilter(Hierarchy.FromPath("Root.Plots", workspace, true))
end)

type AssetSelectorImplementation = {
	__index: AssetSelectorImplementation,
	_Predicate: (self: AssetSelector, asset: Model) -> boolean,
	_AddToSelection: (self: AssetSelector, asset: Model) -> (),
	_RemoveFromSelection: (self: AssetSelector, asset: Model) -> (),
	IsAssetSelector: (value: any) -> boolean,
	new: () -> AssetSelector,
	Destruct: (self: AssetSelector) -> (),
	Enable: (self: AssetSelector) -> (),
	Disable: (self: AssetSelector) -> (),
	SetHover: (self: AssetSelector, asset: Model?) -> (),
	AddToSelection: (self: AssetSelector, assets: {Model}) -> (),
	RemoveFromSelection: (self: AssetSelector, assets: {Model}) -> (),
	SetSelection: (self: AssetSelector, assets: {Model}) -> (),
	InvertSelection: (self: AssetSelector, assets: {Model}) -> (),
	ClearSelection: (self: AssetSelector) -> ()
}

type AssetSelectorProperties = {
	_Destructor: Destructor.Destructor,
	_Destructing: BindableEvent,
	_Callback: {RBXScriptConnection},
	_HoverConnection: RBXScriptConnection?,
	_SelectionConnections: {[Model]: RBXScriptConnection},
	_EnabledChanged: BindableEvent,
	_HoverChanged: BindableEvent,
	_HoverClicked: BindableEvent,
	_SelectionAdded: BindableEvent,
	_SelectionRemoving: BindableEvent,
	_SelectionClicked: BindableEvent,
	Enabled: boolean,
	EnabledChanged: RBXScriptSignal,
	Hover: Model?,
	HoverChanged: RBXScriptSignal,
	HoverClicked: RBXScriptSignal,
	Selection: {Model},
	SelectionAdded: RBXScriptSignal,
	SelectionRemoving: RBXScriptSignal,
	SelectionClicked: RBXScriptSignal,
	OnPredicate: ((asset: Model) -> boolean)?,
	Destructing: RBXScriptSignal
}

export type AssetSelector = typeof(
	setmetatable(
		{} :: AssetSelectorProperties,
		{} :: AssetSelectorImplementation
	)
)

--[=[
	Returns the ancestor of <code>Instance</code> that is parented by <code>Parent</code>.
]=]
local function FindAncestringChildOfAncestor(instance: Instance, parent: Instance): Instance
	while instance do
		local currentParent = instance.Parent

		if currentParent == parent then
			return instance
		end

		instance = currentParent :: any
	end

	return nil :: any
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>Asset</strong> parented by <code>LocalPlot.BuildModel</code>.
]=]
local function IsAssetAndChildOfBuildModel(value: any): boolean
	return typeof(value) == "Instance" and value:HasTag(ASSET_TAG) and value.Parent == LocalPlot.BuildModel
end

--[=[
	Returns a <strong>boolean</strong> indicating whether <code>Value</code> is an <strong>array</strong> of <strong>Assets</strong> parented by <code>LocalOccupant.Plot.BuildModel</code>.
]=]
local function IsArrayOfAssetsParentedByBuildModel(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	for _, value in value do
		if not IsAssetAndChildOfBuildModel(value) then
			return false
		end
	end

	return true
end

function AssetSelector:_Predicate(asset: Model): boolean
	local predicate = self.OnPredicate

	if predicate == nil then
		return true
	end

	local _, result = xpcall(predicate, function(message: string)
		warn(debug.traceback(message))
	end, asset)

	local name = debug.info(predicate, "n")

	task.spawn(assert, type(result) == "boolean", `Called method {if name then `'{name}'` else "<Anonymous>"} of AssetSelector on {self} while callback 'OnPredicate' is {predicate} and not a function returning a boolean.`)

	return not not result
end

function AssetSelector:_AddToSelection(asset: Model)
	self._SelectionConnections[asset] = asset:GetPropertyChangedSignal("Parent"):Connect(function()
		self:_RemoveFromSelection(asset)
	end)

	table.insert(self.Selection, asset)
end

function AssetSelector:_RemoveFromSelection(asset: Model)
	local selectionConnections = self._SelectionConnections
	selectionConnections[asset]:Disconnect()
	selectionConnections[asset] = nil

	local selection = self.Selection

	table.remove(selection, table.find(selection, asset))
end

function AssetSelector.IsAssetSelector(value): boolean
	return type(value) == "table" and getmetatable(value) == AssetSelector
end

function AssetSelector.new(): AssetSelector
	local self = setmetatable({} :: AssetSelectorProperties, AssetSelector)

	self._Destructor = Destructor.new()

	self._Destructor:Add(function()
		self._Destructing:Fire()

		self:Disable()
	end)

	self._Destructing = self._Destructor:Add(Instance.new("BindableEvent"))

	self._Callback = {}

	self._HoverConnection = nil

	self._SelectionConnections = {}

	self._EnabledChanged = self._Destructor:Add(Instance.new("BindableEvent"))

	self._HoverChanged = self._Destructor:Add(Instance.new("BindableEvent"))
	self._HoverClicked = self._Destructor:Add(Instance.new("BindableEvent"))

	self._SelectionAdded = self._Destructor:Add(Instance.new("BindableEvent"))
	self._SelectionRemoving = self._Destructor:Add(Instance.new("BindableEvent"))
	self._SelectionClicked = self._Destructor:Add(Instance.new("BindableEvent"))

	self.Destructing = self._Destructing.Event

	self.Enabled = false
	self.EnabledChanged = self._EnabledChanged.Event

	self.Hover = nil
	self.HoverChanged = self._HoverChanged.Event
	self.HoverClicked = self._HoverClicked.Event

	self.Selection = {}
	self.SelectionAdded = self._SelectionAdded.Event
	self.SelectionRemoving = self._SelectionRemoving.Event
	self.SelectionClicked = self._SelectionClicked.Event

	return self
end

function AssetSelector:Destruct()
	self._Destructor:Destruct()
end

function AssetSelector:Enable()
	if self.Enabled or not LocalPlot then
		return
	end

	table.insert(self._Callback, LocalPlotChanged.Event:Connect(function()
		if LocalPlot then
			self:SetHover(nil)
			self:ClearSelection()
		else
			self:Disable()
		end
	end))

	for _, connection in
		Callback.CallAndConnectToEach(@native function()
			if not LocalPlot then
				return
			end

			local location = UserInputService:GetMouseLocation()
			local ray = workspace.CurrentCamera:ViewportPointToRay(location.X, location.Y)
			local result = workspace:Raycast(ray.Origin, ray.Direction * MAX_RAYCAST_LENGTH, RaycastParameters)

			local asset = result and FindAncestringChildOfAncestor(result.Instance, LocalPlot.BuildModel)

			self:SetHover(if IsAssetAndChildOfBuildModel(asset) and self:_Predicate(asset) then asset else nil)
		end, {RunService.PreRender, LocalPlotChanged.Event})
	do
		table.insert(self._Callback, connection)
	end

	local selection = self.Selection

	table.insert(self._Callback, Mouse.Button1Down:Connect(@native function()
		local hover = self.Hover

		if UserInputService:IsKeyDown(MARQUEE_MODE_KEY) then
		elseif UserInputService:IsKeyDown(INVERT_MODE_KEY) then
			if hover then
				self:InvertSelection({hover})
			end
		elseif #selection > 0 then
			if hover and table.find(selection, hover) then
				self._SelectionClicked:Fire(selection)
			else
				self:ClearSelection()
			end
		elseif hover then
			self._HoverClicked:Fire(hover)
		end
	end))

	self.Enabled = true
	self._EnabledChanged:Fire(true)
end

function AssetSelector:Disable()
	if not self.Enabled then
		return
	end

	local connections = self._Callback

	for index = #connections, 1, -1 do
		connections[index]:Disconnect()
		connections[index] = nil
	end

	self:SetHover(nil)
	self:ClearSelection()

	self.Enabled = false
	self._EnabledChanged:Fire(false)
end

function AssetSelector:SetHover(asset: Model?)
	assert(asset == nil or IsAssetAndChildOfBuildModel(asset), `Argument 'Asset' to method 'SetHover' of AssetSelector on {self} is {asset} and not a Model with tag '{ASSET_TAG}' and parent {LocalPlot and LocalPlot.BuildModel} or nil.`)

	if asset ~= self.Hover and (not asset or self:_Predicate(asset)) then
		self.Hover = asset
		self._HoverChanged:Fire(asset)
	end
end

@native
function AssetSelector:AddToSelection(assets: {Model})
	assert(IsArrayOfAssetsParentedByBuildModel(assets), `Argument 'Assets' to method 'AddToSelection' of AssetSelector on {self} is {assets} and not an array of Models with tag '{ASSET_TAG}' and parent {LocalPlot and LocalPlot.BuildModel}.`)

	local added: {Model} = {}
	local selection = self.Selection

	for _, asset in assets do
		if not table.find(selection, asset) and self:_Predicate(asset) then
			table.insert(added, asset)
		end
	end

	if #added == 0 then
		return
	end

	for _, asset in added do
		self:_AddToSelection(asset)
	end

	self._SelectionAdded:Fire(added)
end

@native
function AssetSelector:RemoveFromSelection(assets: {Model})
	assert(IsArrayOfAssetsParentedByBuildModel(assets), `Argument 'Assets' to method 'RemoveFromSelection' of AssetSelector on {self} is {assets} and not an array of Models with tag '{ASSET_TAG}' and parent {LocalPlot and LocalPlot.BuildModel}.`)

	local removed: {Model} = {}

	for _, asset in self.Selection do
		if not table.find(assets, asset) then
			table.insert(removed, asset)
		end
	end

	if #removed == 0 then
		return
	end

	self._SelectionRemoving:Fire(removed)

	for _, asset in removed do
		self:_RemoveFromSelection(asset)
	end
end

@native
function AssetSelector:SetSelection(assets: {Model})
	assert(IsArrayOfAssetsParentedByBuildModel(assets), `Argument 'Assets' to method 'SetSelection' of AssetSelector on {self} is {assets} and not an array of Models with tag '{ASSET_TAG}' and parent {LocalPlot and LocalPlot.BuildModel}.`)

	local added: {Model}, removed: {Model} = {}, {}
	local selection = self.Selection

	for _, asset in assets do
		if not table.find(selection, asset) and self:_Predicate(asset) then
			table.insert(added, asset)
		end
	end

	for _, asset in selection do
		if not table.find(assets, asset) then
			table.insert(removed, asset)
		end
	end

	if #removed > 0 then
		self._SelectionRemoving:Fire(removed)

		for _, asset in removed do
			self:_RemoveFromSelection(asset)
		end
	end

	if #added == 0 then
		return
	end

	for _, asset in added do
		self:_AddToSelection(asset)
	end

	self._SelectionAdded:Fire(added)
end

@native
function AssetSelector:InvertSelection(assets: {Model})
	assert(IsArrayOfAssetsParentedByBuildModel(assets), `Argument 'Assets' to method 'InvertSelection' of AssetSelector on {self} is {assets} and not an array of Models with tag '{ASSET_TAG}' and parent {LocalPlot and LocalPlot.BuildModel}.`)

	local added: {Model}, removed: {Model} = {}, {}
	local selection = self.Selection

	for _, asset in assets do
		if table.find(selection, asset) then
			table.insert(removed, asset)
		elseif self:_Predicate(asset) then
			table.insert(added, asset)
		end
	end

	if #removed > 0 then
		self._SelectionRemoving:Fire(removed)

		for _, asset in removed do
			self:_RemoveFromSelection(asset)
		end
	end

	if #added == 0 then
		return
	end

	for _, asset in added do
		self:_AddToSelection(asset)
	end

	self._SelectionAdded:Fire(added)
end

@native
function AssetSelector:ClearSelection()
	local selection = self.Selection

	if #selection == 0 then
		return
	end

	self._SelectionRemoving:Fire(selection)

	for index = #selection, 1, -1 do
		self:_RemoveFromSelection(selection[index])
	end
end

return AssetSelector

-- </Script #98 End>
--[[
<Script #99 Begin>
<Metadata Begin>
Name: "GetGlobalTimestamp"
Type: ModuleScript
Path: ReplicatedStorage.Modules.Functions.GetGlobalTimestamp
Size: 379 Character(s), 9 Line(s)
</Metadata End>
]]

--!strict
--[=[
	Returns a <strong>number</strong> representing the current UTC Unix timestamp with millisecond resolution.
]=]
return function(): number
	local utcTime = DateTime.now():ToUniversalTime()

	return DateTime.fromUniversalTime(utcTime.Year, utcTime.Month, utcTime.Day, utcTime.Hour, utcTime.Minute, utcTime.Second, utcTime.Millisecond).UnixTimestampMillis / 1e3
end

-- </Script #99 End>
--[[
<Script #100 Begin>
<Metadata Begin>
Name: ""
Type: Script
Context: Client
Path: ReplicatedFirst.
Size: 9719 Character(s), 341 Line(s)
</Metadata End>
]]

--!strict
-- TODO: Extend Source Code.
script.Parent = nil

local table = table.clone(table)
local buffer = table.clone(buffer)
local Random = table.clone(Random)
local NumberRange = table.clone(NumberRange)
local coroutine = table.clone(coroutine)
local task = table.clone(task)
local math = table.clone(math)
local Instance = table.clone(Instance)
local debug = table.clone(debug)
local os = table.clone(os)
local string = table.clone(string)

_G[""] = buffer.fromstring(("dd"):pack(0xD70C800B, 0x1C1CD248D):reverse())

local SCRIPT_PSEUDO_NAME = "AntiCheatClient"

local REAL_PHYSICS_FPS_THRESHOLD = 60 + 4 -- <Target Rate> + <Trigger Tolerance>

local TOKEN_LENGTH = 2 ^ 5 -- Character(s)
local TOKEN_CAESAR_CIPHER_SHIFT = Random.new(tick()):NextInteger(-2 ^ 7, 2 ^ 7 - 1)

local MAX_SAFE_INTEGER = 2 ^ 53
local MIN_SAFE_INTEGER = -MAX_SAFE_INTEGER

local HANG_DELAY = 5 -- Second(s)

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TestService = game:GetService("TestService")

local LocalPlayer = Players.LocalPlayer

if RunService:IsStudio() then
	print(`[{SCRIPT_PSEUDO_NAME}]: Run-time environment is Studio. Killing root {coroutine.running()}`)

	script:Destroy()

	return
end

local TrippedRemote: UnreliableRemoteEvent

task.spawn(function()
	local Remotes = ReplicatedFirst:WaitForChild("Remotes", math.huge)
	local AntiCheatRemotes = Remotes:WaitForChild("AntiCheat", math.huge)

	TrippedRemote = AntiCheatRemotes:WaitForChild("Tripped", math.huge)
	TrippedRemote.Parent = nil
	TrippedRemote.Name = ""
end)

local Thread = Instance.new("BindableEvent")
local Threads: {thread} = {}

-- DFIntDebugDefaultTargetWorldStepsPerFrame Override
table.insert(Threads, task.spawn(function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} DFIntDebugDefaultTargetWorldStepsPerFrame Override`)

	repeat
		task.wait(1)
	until workspace:GetRealPhysicsFPS() > REAL_PHYSICS_FPS_THRESHOLD

	Thread:Fire(true, `Workspace.GetRealPhysicsFPS returned a value greater than {REAL_PHYSICS_FPS_THRESHOLD}`)
end))

-- LocalPlayer Idled Disconnect/Deactivate
table.insert(Threads, task.spawn(function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} LocalPlayer Idled Disconnect/Deactivate`)

	while true do
		local connection = LocalPlayer.Idled:Connect(function() end)

		task.wait(1)

		if not connection.Connected then
			break
		end

		connection:Disconnect()
	end

	Thread:Fire(true, "Connection was disconnected or disabled.")
end))

-- DataModel Save
table.insert(Threads, task.spawn(function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} DataModel Save`)

	while not game:FindService("UGCValidationService") do
		game.ServiceAdded:Wait()
	end

	Thread:Fire(true, "UGCValidationService was created.")
end))

-- CoreGui Reference
table.insert(Threads, task.spawn(@native function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} CoreGui Reference`)

	while not game:FindService("CoreGui") do
		game.ServiceAdded:Wait()
	end

	local random = Random.new(-tick() + os.clock())

	while true do
		local honeyPot: any = setmetatable({
			{},
			newproxy(true),
			newproxy(),
			'\69\120\112\108\111\105\116\105\110\103'
				.. '\32'
				.. '\105\115'
				.. '\32'
				.. '\108\105\107\101'
				.. '\32'
				.. '\116\114\121\105\110\103'
				.. '\32'
				.. '\116\111'
				.. '\32'
				.. '\99\104\101\97\116'
				.. '\32'
				.. '\97\116'
				.. '\32'
				.. '\77\111\110\111\112\111\108\121'
				.. '\46'
			-- Plaintext: "Exploiting is like trying to cheat at Monopoly."
		} :: {any}, {
			__tostring = function(): string
				Thread:Fire(true, "'__tostring' metamethod was invoked.")

				return tostring({})
			end
		})

		random:Shuffle(honeyPot)

		table.insert(honeyPot, 1, game:FindService("CoreGui"))

		setmetatable(honeyPot, {
			__mode = "v" -- Set values to weak for GC to mark white and sweep.
		})

		repeat
			RunService.PreAnimation:Wait()

			local wasCollected = false

			for index = 2, 5 do
				if not honeyPot[index] then
					wasCollected = true

					break
				end
			end
		until wasCollected

		if honeyPot[1] then
			Thread:Fire(true, "CoreGui was not collected by the Garbage Collector.")
		end
	end
end))

-- Anti-Cheat Script Terminate
table.insert(Threads, task.spawn(function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} Script Terminate`)

	script.Destroying:Wait()

	Thread:Fire(true, `{SCRIPT_PSEUDO_NAME} was destroyed.`)
end))

-- Anti-Cheat Script Kill
table.insert(Threads, task.spawn(function()
	debug.setmemorycategory(`{SCRIPT_PSEUDO_NAME} Script Kill`)

	local Modules = ReplicatedStorage:WaitForChild("Modules", math.huge)

	local Functions = Modules:WaitForChild("Functions", math.huge)
	local IsPlayerExperienceOwner = require(Functions:WaitForChild("IsPlayerExperienceOwner", math.huge))

	if IsPlayerExperienceOwner(LocalPlayer) then
		print(`[{SCRIPT_PSEUDO_NAME}]: Client is an Owner of the Experience. Destroying {SCRIPT_PSEUDO_NAME} and killing {coroutine.running()}`)

		Thread:Fire(false)

		return
	end

	local Remotes = ReplicatedStorage:WaitForChild("Remotes", math.huge)
	local AntiCheatRemotes = Remotes:WaitForChild("AntiCheat", math.huge)
	local GetTokenRemote = AntiCheatRemotes:WaitForChild("GetToken", math.huge)
	local HandshakeRemote = AntiCheatRemotes:WaitForChild("Handshake", math.huge)

	HandshakeRemote.Parent = nil
	HandshakeRemote.Name = ""

	-- TODO::Acknowledgement: Encryption is cryptographically insecure.
	local ToCodepoints = function(source: string): {number}
		return {source:byte(1, #source)}
	end

	local CaesarCipher = @native function(codes: {number}, shift: number): {number}
		local encrypted: {number} = table.create(#codes)

		for _, code in codes do
			table.insert(encrypted, (code + shift) % 256)
		end

		return encrypted
	end

	local XorCipher = @native function(codes: {number}, key: number): {number}
		local encrypted: {number} = table.create(#codes)

		for _, code in codes do
			table.insert(encrypted, bit32.bxor(code, key))
		end

		return encrypted
	end

	local GetSum = @native function(...: number): number
		local sum = 0

		for _, value in {...} do
			sum += value
		end

		return sum
	end

	-- Do not declare unciphered secret Handshake values as up-values in persistent memory; pass through functions.
	-- Declare Key up-value as buffer of packed double; less cipherable in memory than number.
	local clientKey1: buffer?, clientKey2: buffer?, clientKey3: buffer?, clientKey4: buffer? = buffer.fromstring(
		("d"):pack(
			Random.new(-tick() + os.clock()):NextInteger(
				MAX_SAFE_INTEGER,
				MIN_SAFE_INTEGER
			)
		):reverse()
	)

	-- Declare Token up-value as buffer of packed UTF-8 codepoints encrypted with Caesar and XOR ciphers for obfuscation; less cipherable in memory than plaintext.
	local tokenBuffer1: buffer?, tokenBuffer2: buffer?, tokenBuffer3: buffer?, tokenBuffer4: buffer? = buffer.fromstring(
		string.pack(
			("d"):rep(TOKEN_LENGTH),
			unpack(
				XorCipher(
					CaesarCipher(ToCodepoints(buffer.tostring(GetTokenRemote:InvokeServer()):reverse()), TOKEN_CAESAR_CIPHER_SHIFT),
					("d"):unpack(buffer.tostring(clientKey1 :: any):reverse()) % GetSum(("dd"):unpack(buffer.tostring(_G[""]):reverse()))
				)
			)
		):reverse()
	)

	HandshakeRemote.OnClientInvoke = @native function(challengeKey: buffer): buffer
		-- Shuffle Token and Client Key up-value memory layout; less cipherable in memory than static layout.
		local random = Random.new(-tick() + os.clock())
		local tokenBuffers = {tokenBuffer1, tokenBuffer2, tokenBuffer3, tokenBuffer4}

		random:Shuffle(tokenBuffers)

		tokenBuffer1, tokenBuffer2, tokenBuffer3, tokenBuffer4 = table.unpack(tokenBuffers)

		local clientKeyBuffers = {clientKey1, clientKey2, clientKey3, clientKey4}

		random:Shuffle(clientKeyBuffers)

		clientKey1, clientKey2, clientKey3, clientKey4 = table.unpack(clientKeyBuffers)

		return buffer.fromstring(
			string.pack(
				("d"):rep(TOKEN_LENGTH),
				unpack(
					XorCipher(
						CaesarCipher(
							XorCipher(
								{
									string.unpack(
										("d"):rep(TOKEN_LENGTH),
										buffer.tostring(tokenBuffer1 or tokenBuffer2 or tokenBuffer3 or tokenBuffer4 :: any):reverse()
									)
								},
								("d"):unpack(buffer.tostring(clientKey1 or clientKey2 or clientKey3 or clientKey4 :: any):reverse()) % GetSum(("dd"):unpack(buffer.tostring(_G[""]):reverse()))
							), -TOKEN_CAESAR_CIPHER_SHIFT
						),
						("d"):unpack(buffer.tostring(challengeKey):reverse())
					)
				)
			):reverse():sub(1, TOKEN_LENGTH * 8) -- string.pack returns trailing extraneous bytes when 'format' argument is greater than or equal to 32 doubles; trim.
		)
	end
end))

local WasTripped: boolean, Message: string? = Thread.Event:Wait()

for _, thread in Threads do
	task.cancel(thread)
end

if WasTripped then
	-- Hang Client if LocalPlayer is in DataModel after HANG_DELAY second(s).
	task.delay(HANG_DELAY, function()
		if not LocalPlayer.Parent then
			return
		end

		while true do
			Instance.new("Part", workspace)
		end
	end)

	if TrippedRemote then
		task.spawn(function()
			TrippedRemote:FireServer(Message)
			TrippedRemote:Destroy()
		end)
	end

	-- Try methods to remove LocalPlayer from DataModel.
	task.defer(LocalPlayer.Remove, LocalPlayer)
	task.defer(LocalPlayer.Destroy, LocalPlayer)

	task.defer(Players.ClearAllChildren, Players)

	task.spawn(TestService.Error, TestService, `[{SCRIPT_PSEUDO_NAME}]: 🟥 Anti-Cheat Tripped:\n{Message}`)

	LocalPlayer:Kick(`[{SCRIPT_PSEUDO_NAME}]: Client Anti-Cheat tripped with message: {Message}`)
end

script:Destroy()

-- Remove 'script' global for GC.
getfenv().script = nil

-- </Script #100 End>
