---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

local upgradeName = 'ReducedLootChoicesShrineUpgrade'
local metaUpgradesTable = game.MetaUpgradeData
local shrineUpgradesTable = game.ShrineUpgradeOrder
local traitText = rom.path.combine(rom.paths.Content, 'Game/Text/en/TraitText.en.sjson')
--local GameState_shrineUpgrades = game.ShrineUpgrades
metaUpgradesTable.ReducedLootChoicesShrineUpgrade =
{
	InheritFrom = { "BaseMetaUpgrade", },
	Icon = "ShrineIcon_LockedChoice",
	InactiveChangeValue = 0,
	Ranks = {
		{ Points = 2, ChangeValue = 1 },
		{ Points = 3, ChangeValue = 2 },
	},
	Name = "ReducedLootChoicesShrineUpgrade",
	ShortTotal = "ReducedLootChoicesShrineUpgrade_ShortTotal",
}
game.ShrineUpgrades = {
	ReducedLootChoicesShrineUpgrade = 0, -- AP value is 0 by default
}


table.insert(shrineUpgradesTable, upgradeName)

sjson.hook(traitText, function(sjsonData)
	local order = {"Id", "DisplayName", "Description"}
	table.insert(sjsonData.Texts, sjson.to_object({
			Id = "ReducedLootChoicesShrineUpgrade",
			DisplayName = "Vow of Acceptance",
			Description = "You have {#ShrinePenaltyFormat} {$MetaUpgradeData.ReducedLootChoicesShrineUpgrade.ChangeValue} {#Prev} fewer choice(s) when offered {$Keywords.GodBoonPlural}, items, or upgrades."
	}, order))
end)

modutil.mod.Path.Override("CalcNumLootChoices", function()
	local numChoices = ScreenData.UpgradeChoice.MaxChoices - GetNumShrineUpgrades("ReducedLootChoicesShrineUpgrade")
	if (isGodLoot or treatAsGodLootByShops) and HasHeroTraitValue("RestrictBoonChoices") then
		numChoices = numChoices - 1
	end
	return numChoices
end)
