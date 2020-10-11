-- Helper
local OFMGR = ZO_OUTFIT_MANAGER
local ZOSF = zo_strformat


-- locals
local categories = {
	COLLECTIBLE_CATEGORY_TYPE_VANITY_PET,           -- 3
	COLLECTIBLE_CATEGORY_TYPE_COSTUME,              -- 4
	COLLECTIBLE_CATEGORY_TYPE_MOUNT,                -- 2
	COLLECTIBLE_CATEGORY_TYPE_POLYMORPH,            -- 12
	COLLECTIBLE_CATEGORY_TYPE_SKIN,                 -- 11
	COLLECTIBLE_CATEGORY_TYPE_PERSONALITY,          -- 9
	COLLECTIBLE_CATEGORY_TYPE_HAT,                  -- 10
	COLLECTIBLE_CATEGORY_TYPE_HAIR,                 -- 13
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS,    -- 14
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY,     -- 15
	-- COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY,     -- 16
	COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING,         -- 17
    COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING,         -- 18
    -- COLLECTIBLE_CATEGORY_TYPE_OUTFIT_STYLE          -- 24
}

local categoryIds = {
	[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = 3,
	[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = 2,
	[COLLECTIBLE_CATEGORY_TYPE_MOUNT] = 4,
	[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = 11,
	[COLLECTIBLE_CATEGORY_TYPE_SKIN] = 10,
	[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = 12,
	[COLLECTIBLE_CATEGORY_TYPE_HAT] = 9,
	[COLLECTIBLE_CATEGORY_TYPE_HAIR] = 14,
	[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = 15,
	[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = 18,
	-- [COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = 19,
	[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = 17,
    [COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = 16,
   -- [COLLECTIBLE_CATEGORY_TYPE_OUTFIT_STYLE] = ?
}

--- Writes trace messages to the console
-- fmt with %d, %s,
local function trace(fmt, ...)
	if ASModel.isDebug then
		d(string.format(fmt, ...))
    end
end

-- Model
ASModel = {}

-- Debug mode
ASModel.isDebug = false

-- Settings
ASModel.SavedSettings = {}
ASModel.SavedSettings.Name = 'AlphaStyle_Settings'
ASModel.SavedSettings.Version = '1'
ASModel.SavedSettings.Defaults = {}
ASModel.Settings = {}

-- StyleData
--[[
    StyleData = {
        LastId = <Number of last used Id
        Styles { 
            [style id] = {
                Name = <given name>
                SortKey = <key to sort styles>
                OutfitId = <id of selected outfit>
                TitleId = <id of selected title>
                IgnoreTitle = <true: don't set title>
                Collectibles {
                    [collectible category id] = <item id>
                }
                Costume = {
                    id = ...
                    link = ...
                }
            }
        }

    }

--]]

ASModel.SavedStyles = {}
ASModel.SavedStyles.Name = 'AlphaStyle_Styles'
ASModel.SavedStyles.Version = '1'
ASModel.SavedStyles.Defaults = {  
    LastId = 0,
    Styles = {}
}
ASModel.StyleData = {}
ASModel.CategoryData = {}
ASModel.NO_OUTFIT_ID = -1
ASModel.NO_TITLE_ID = -1

--- Map Category_Type_ID to Name/Index
function ASModel.InitCategoryData()

    for i=1, #categories do
        trace("Index %d: %d", i, categories[i])
    end

    
    for categoryIndex=1, GetNumCollectibleCategories() do
         -- toplevelindex
		local name, numSubCatgories = GetCollectibleCategoryInfo(categoryIndex)

		if numSubCatgories > 0 then

            for subCategoryIndex=1, numSubCatgories do
                -- toplevelindex/subCategoryIndex
				local subCategoryName = GetCollectibleSubCategoryInfo(categoryIndex, subCategoryIndex)

                -- toplevelindex/subCategoryIndex
				local catId = GetCollectibleCategoryId(categoryIndex, subCategoryIndex)

                local cd = {}
                cd["catName"] = name
                cd["subName"] = subCategoryName
                cd["catIndex"] = categoryIndex
                cd["subIndex"] = subCategoryIndex
                cd["texture"] = GetCollectibleCategoryGamepadIcon(categoryIndex, subCategoryIndex)
    
                ASModel.CategoryData[catId] = cd

                --trace("Name: %s/%s; catId: %d", name, subCategoryName, catId)

				-- d("Cat: "..name.."/"..subCategoryName.." CatIndex: "..categoryIndex.." CatId: "..catId)
			end
		else
            local catId = GetCollectibleCategoryId(categoryIndex, nil)
            
            local cd = {}
            cd["catName"] = name
            cd["catIndex"] = categoryIndex
            cd["texture"] = GetCollectibleCategoryGamepadIcon(categoryIndex, nil)

            --trace("Name: %s catId: %d", name, catId)

            ASModel.CategoryData[catId] = cd

			-- d("Cat: "..name.." CatIndex: "..categoryIndex.." CatId: "..catId)
		end
	end

end

function ASModel.GetCategories()
    return categories
end

function ASModel.GetCatInfoByCatType (cattype)
--[[
    local zom = ZO_CollectibleDataManager:New()

    local catData = zom:GetCategoryDataById(catId)

    return catData:GetName()
--]]

    local catId = categoryIds[cattype]

    local cd = ASModel.CategoryData[catId]

    if not cd then 
        return "Unknown Category: "..cattype, "esoui/art/buttons/decline_up.dds"
    end

    local name

    if cd["subName"] then
        name = cd["catName"].."/"..cd["subName"] 
    else
        name = cd["catName"]
    end

    return name, cd["texture"]
end


function ASModel.CheckConsistency()
    if #ASModel.StyleData.Styles == 0 then
        ASModel.NewStyle()
    end
end

function ASModel.GetStyleByName(name)
    local styles = ASModel.StyleData.Styles

    for _, style in pairs(styles) do 
        if style.Name == name then
            return style 
        end
    end

    return false
end

function ASModel.GetStyleById(id)
    local style = ASModel.StyleData.Styles[id]
    return style 
end

function ASModel.NewStyle()
    local style = ASModel.CreateNewStyle()
	ASModel.StoreStyle(style)
end

function ASModel.CreateNewStyle(name)
    trace("CreateNewStyle")
    local style = {}

    -- increment last id
    ASModel.StyleData.LastId = ASModel.StyleData.LastId + 1

    if not name then
        name = "New Style "..ASModel.StyleData.LastId
    end

    style.Name = name
    style.SortKey = name

    ASModel.StyleData.Styles[ASModel.StyleData.LastId] = style
    
    return style
end

function ASModel.GetCostumeFromBag(id)

    local function GetItemDataFilterComparator()
        return function(itemData)
            if itemData.itemType == ITEMTYPE_DISGUISE or itemData.itemType == ITEMTYPE_COSTUME or itemData.itemType == ITEMTYPE_TABARD then
                -- precalculate the IDString for later use
                itemData.IdStringAG = Id64ToString(itemData.uniqueId)
                return true
            end
        end
    end

    if not id then return false end

    local itemCache = SHARED_INVENTORY:GenerateFullSlotData(GetItemDataFilterComparator(), BAG_BACKPACK)

    for _, itemData in pairs(itemCache) do 
        if id == itemData.IdStringAG then 
            trace("Found in cache: "..itemData.name.." Bag/Slot: "..itemData.bagId.."/"..itemData.slotIndex)
            return itemData.bagId, itemData.slotIndex 
        end 
    end
    
    return false
end


function ASModel.SetCostume(costume)
    -- return true, if we must wait
    local mustWait = false

    if not costume then
        costume = { id = 0, link = 0 } 
    end

	-- anything to change?
    if Id64ToString(GetItemUniqueId(BAG_WORN, EQUIP_SLOT_COSTUME)) ~= costume.id then

        if costume.id == 0 then
            -- unequip cosutume
            if GetItemInstanceId(BAG_WORN, EQUIP_SLOT_COSTUME) then
                if GetNumBagFreeSlots(BAG_BACKPACK) > 0 then
                    trace("Unequipping slot %d", EQUIP_SLOT_COSTUME)
                    UnequipItem(EQUIP_SLOT_COSTUME)
                    mustWait = true
                else
                    local link = GetItemLink(BAG_WORN, EQUIP_SLOT_COSTUME)
                    d(ZOSF("AlphaStyle: Not enough space in backpack for <<1>>.", link))         
                end
            else
                trace("Nothing to unequip in slot %d", EQUIP_SLOT_COSTUME)
            end
        else            
            -- find item in one of the bags
            local sourceBag, sourceBagSlot = ASModel.GetCostumeFromBag(costume.id)

            if sourceBagSlot then 
                -- equip the found item
                EquipItem(sourceBag, sourceBagSlot, EQUIP_SLOT_COSTUME)
                mustWait = true
            else
                d(ZOSF("AlphaStyle: Costume not found: <<1>>.", costume.link)) 
            end	
        end
	end
	
	return mustWait
end

function ASModel.StoreStyleByName(name)
    local style = ASModel.GetStyleByName(name)
    if not style then
        style = ASModel.CreateNewStyle(name)
    end
    ASModel.StoreStyle(style)
end

function ASModel.StoreStyle(style)
    if not style then
        d("AlphaStyle: Style not found")
        return
    end

    -- get outfit
    local ofid = OFMGR:GetEquippedOutfitIndex()
    if ofid then
        style.OutfitId = ofid;
    else
        style.OutfitId = ASModel.NO_OUTFIT_ID
    end

    -- get title
    local titleId = GetCurrentTitleIndex()
    if titleId then
        style.TitleId = titleId;
    else
        style.TitleId = ASModel.NO_TITLE_ID
    end


    -- get collectibles
    style.Collectibles = {}
    for categoryIndex = 1, #categories do
        local activeCollectible = GetActiveCollectibleByType(categories[categoryIndex])
        style.Collectibles[categories[categoryIndex]] = activeCollectible
    end

    -- costume
    if GetItemInstanceId(BAG_WORN, EQUIP_SLOT_COSTUME) then
        style.Costume = { id = Id64ToString(GetItemUniqueId(BAG_WORN, EQUIP_SLOT_COSTUME)), link = GetItemLink(BAG_WORN, EQUIP_SLOT_COSTUME) }
    else
        style.Costume = { id = 0, link = 0 } 
    end
end

function ASModel.LoadStyleByName (name)
    local style = ASModel.GetStyleByName(name)
    ASModel.LoadStyle(style)
end

function ASModel.LoadStyleById(id)
    if not id then
        return
    end

    local style = ASModel.GetStyleById(id)
    ASModel.LoadStyle(style)
end


function ASModel.LoadStyle(style)
    if not style then
        d("AlphaStyle: Style not found!")
        return
    end

    -- set outfit
    if style.OutfitId == ASModel.NO_OUTFIT_ID then
        UnequipOutfit()
    else
        OFMGR:EquipOutfit(style.OutfitId)
    end

    -- set title
    if not style.IgnoreTitle then
        if not style.TitleId or style.TitleId == ASModel.NO_TITLE_ID then
            SelectTitle(nil)
        else
            SelectTitle(style.TitleId)
        end
    end

    -- set collectibles
    for categoryIndex = 1, #categories do
        local collectibleId = style.Collectibles[categories[categoryIndex]]
        local activeCollectible = GetActiveCollectibleByType(categories[categoryIndex])


        if collectibleId ~= activeCollectible then
            -- only change if necessary

            if collectibleId == COLLECTIBLE_CATEGORY_TYPE_INVALID then
                -- un-use current
                UseCollectible(activeCollectible)
            else
                UseCollectible(collectibleId)
            end
        end
    end

    -- set costume
    ASModel.SetCostume(style.Costume)
end

function ASModel.DeleteStyle(id)
    trace("DeleteStyle")
    if not id then
        return
    end

    local style = ASModel.GetStyleById(id)
    if not style then
        d("AlphaStyle: Style not found. ID: "..id)
        return
    end

    trace("Delete Style "..style.Name)
    ASModel.StyleData.Styles[id] = nil
end

function ASModel.ReloadStyle(id)
    trace("ReloadStyle")
    if not id then
        return
    end
    local style = ASModel.GetStyleById(id)
    if not style then
        d("AlphaStyle: Style not found. ID: "..id)
        return
    end

    trace("Reload Style "..style.Name)
    ASModel.StoreStyle(style)
end


--- returns a sorted list of styles
function ASModel.GetStylesSorted() 
	trace('GetStylesSorted')

	--- sorts the styles according to their sortKey
	-- a style w/o sortKey will be sorted to the end of the list 
	local function StyleSortHelper(item1, item2)
		local sortKey1 = item1.sortKey
		if not sortKey1 or sortKey1 == "" then
			sortKey1 = 'zzzzzzzzzzzzzzzzzzzzzzzz'..item1.name
		end
		
		local sortKey2 = item2.sortKey
		if not sortKey2 or sortKey2 == "" then
			sortKey2 = 'zzzzzzzzzzzzzzzzzzzzzzzz'..item2.name
		end

        return (sortKey1 < sortKey2)
    end

	local styleData = {}
	
	local styles = ASModel.StyleData.Styles

	for styleId, style in pairs(styles) do 
		local data = {
			id = styleId,
			name = style.Name,
			sortKey = style.SortKey
		}
	
		table.insert(styleData, data)
	end

    -- Sort the style according to their sortkey
    table.sort(styleData, function(item1, item2) return StyleSortHelper(item1, item2) end)	

    return styleData
end

-- Initialize Data
ASModel.InitCategoryData()
