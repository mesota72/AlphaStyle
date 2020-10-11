std = {"max"}

-- these globals can be set and accessed.
globals = {
-- I17n

-- Integration

-- AStyle
    "ASModel",
    "ASApp",
    "ASUI",
    "AS_Main",
    "ASAPI",
    "ASLang",
    "ASESPD",

 -- AlphaStyle UI
    "ASEditStylePropertiesDialog",
    "",
    "",
    "",
    "",

-- LibAdonMenu
    "LibAddonMenu2",

-- ESO UI
    "SLASH_COMMANDS",
    "KEYBINDING_MANAGER",
    "ZO_SavedVars",
    "ZO_OUTFIT_MANAGER",
    "zo_strformat",
}

-- these globals can only be accessed.
read_globals = {
    "",
    "",
    "",
    "",

-- ESO API
    "COLLECTIBLE_CATEGORY_TYPE_VANITY_PET",
	"COLLECTIBLE_CATEGORY_TYPE_VANITY_PET", 
	"COLLECTIBLE_CATEGORY_TYPE_COSTUME",
	"COLLECTIBLE_CATEGORY_TYPE_MOUNT",
	"COLLECTIBLE_CATEGORY_TYPE_POLYMORPH",
	"COLLECTIBLE_CATEGORY_TYPE_SKIN",
	"COLLECTIBLE_CATEGORY_TYPE_PERSONALITY",
	"COLLECTIBLE_CATEGORY_TYPE_HAT",
	"COLLECTIBLE_CATEGORY_TYPE_HAIR",
	"COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS",
	"COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY",
	-- "COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY",
	"COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING",
    "COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING",
    -- "COLLECTIBLE_CATEGORY_TYPE_OUTFIT_STYLE"
	"COLLECTIBLE_CATEGORY_TYPE_VANITY_PET",
	"COLLECTIBLE_CATEGORY_TYPE_COSTUME",
	"COLLECTIBLE_CATEGORY_TYPE_MOUNT",
	"COLLECTIBLE_CATEGORY_TYPE_POLYMORPH",
	"COLLECTIBLE_CATEGORY_TYPE_SKIN",
	"COLLECTIBLE_CATEGORY_TYPE_PERSONALITY",
	"COLLECTIBLE_CATEGORY_TYPE_HAT",
	"COLLECTIBLE_CATEGORY_TYPE_HAIR",
	"COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS",
	"COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY",
	-- "COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY",
	"COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING",
    "COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING",
    "GetNumCollectibleCategories",
    "GetCollectibleCategoryInfo",
    "GetCollectibleSubCategoryInfo",
    "GetCollectibleCategoryId",
    "GetCollectibleCategoryGamepadIcon",
    "d",
    "ITEMTYPE_DISGUISE",
    "ITEMTYPE_COSTUME",
    "Id64ToString",
    "SHARED_INVENTORY",
    "BAG_BACKPACK",
    "ITEMTYPE_TABARD",
    "GetItemUniqueId",
    "BAG_WORN",
    "EQUIP_SLOT_COSTUME",
    "GetItemInstanceId",
    "GetNumBagFreeSlots",
    "GetItemLink",
    "EquipItem",
    "UnequipItem",
    "GetActiveCollectibleByType",
    "GetCurrentTitleIndex",
    "UnequipOutfit",
    "SelectTitle",
    "COLLECTIBLE_CATEGORY_TYPE_INVALID",
    "UseCollectible",
    "SCENE_MANAGER",
    "EVENT_MANAGER",
    "WINDOW_MANAGER",
    "ZO_ColorDef",
    "SET_SECTIONS",
    "TEXT_ALIGN_LEFT",
    "BOTTOM",
    "InformationTooltip",
    "SetTooltipText",
    "InitializeTooltip",
    "ClearTooltip",
    "ItemTooltip",
    "RIGHT",
    "LEFT",
    "TOPLEFT",
    "TOPRIGHT",
    "BOTTOMLEFT",
    "BOTTOMRIGHT",
    "GetCollectibleInfo",
    "GetItemLinkIcon",
    "GetTitle",
    "ZO_Dialogs_ShowDialog",
    "zo_callLater",
    "ZO_ScrollList_MouseEnter",
    "ZO_ScrollList_MouseExit",
    "ZO_ScrollList_MouseClick",
    "GetControl",
    "ZO_ScrollList_AddDataType",
    "ZO_ScrollList_EnableHighlight",
    "ZO_ScrollList_EnableSelection",
    "ZO_ScrollList_SetEqualityFunction",
    "ZO_ScrollList_GetDataList",
    "ZO_ScrollList_Clear",
    "ZO_ScrollList_CreateDataEntry",
    "ZO_ScrollList_Commit",
    "ZO_ScrollList_SelectData",
    "ZO_CreateStringId",
    "EVENT_ADD_ON_LOADED",
    "ZO_CheckButton_IsChecked",
    "ZO_CheckButton_SetChecked",
    "ZO_CheckButton_SetUnchecked",
    "ZO_Dialogs_RegisterCustomDialog",
    "SI_DIALOG_ACCEPT",
    "SI_DIALOG_CANCEL",
    "",
    "",


-- lua tools
    "table",
    "pairs",
    "unpack",
    "string",
    "tonumber",
    "math",
    "select",
    "tostring",
    "",
    "",
    "",
    "",
}


 ignore = {
    "612", -- A line contains trailing whitespace.
    "611", -- A line consists of nothing but whitespace.
    "631", -- Line is too long.
    "212", -- unused argument
    "542", -- An empty if branch.
    "614", -- Trailing whitespace in a comment.
    "311", -- Value assigned to a local variable is unused.
    "211", -- Local variable is set but never accessed.
}
