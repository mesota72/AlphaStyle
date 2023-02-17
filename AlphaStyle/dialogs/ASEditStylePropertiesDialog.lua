--[[

Dialog to edit Style properties

--]]

ASESPD = {}

function ASESPD:Commit(control)
    local currentId = ASUI.GetCurrentStyleSetId()
	local style = ASModel.GetStyleById(currentId)

	if not style then return end

    local ctrlContent = GetControl(control, "Content")
    local editStyleName = GetControl(ctrlContent, "StyleName")
    local editStyleSortKey = GetControl(ctrlContent, "StyleSortKey")
    local checkIgnoreTitle = GetControl(ctrlContent, "IgnoreTitleCheck")
    local checkIgnoreRole = GetControl(ctrlContent, "IgnoreRoleCheck")

	local oldName = style.Name
	
	style.Name = editStyleName:GetText()
    style.SortKey = editStyleSortKey:GetText()
    style.IgnoreTitle =  ZO_CheckButton_IsChecked(checkIgnoreTitle)
    style.IgnoreRole = ZO_CheckButton_IsChecked(checkIgnoreRole)
	
	if oldName ~= style.Name  then
		d("Style '"..oldName.."' renamed to '"..style.Name.."'")
	end

    ASUI.ShowStyleSetsTab()
end

function ASESPD:Setup(control)
    local currentId = ASUI.GetCurrentStyleSetId()
	local style = ASModel.GetStyleById(currentId)

	if not style then return end

    local ctrlContent = GetControl(control, "Content")
    local editStyleName = GetControl(ctrlContent, "StyleName")
    local editStyleSortKey = GetControl(ctrlContent, "StyleSortKey")
    local checkIgnoreTitle = GetControl(ctrlContent, "IgnoreTitleCheck")
    local checkIgnoreRole = GetControl(ctrlContent, "IgnoreRoleCheck")

	editStyleName:SetText(style.Name)
    editStyleSortKey:SetText(style.SortKey or '')
    
    if (style.IgnoreTitle) then
        ZO_CheckButton_SetChecked(checkIgnoreTitle)
    else
        ZO_CheckButton_SetUnchecked(checkIgnoreTitle)
    end    
    
    if (style.IgnoreRole) then
        ZO_CheckButton_SetChecked(checkIgnoreRole)
    else
        ZO_CheckButton_SetUnchecked(checkIgnoreRole)
    end   
end


function ASESPD.Initialize()
	local control = ASEditStylePropertiesDialog

    ZO_Dialogs_RegisterCustomDialog("AS_EDIT_STYLE_PROPERTIES_DIALOG", {
        customControl = control,
        title = { text = "Style Properties" },
		setup = function(self) ASESPD:Setup(control) end,
        buttons =
        {
            {
                control =   GetControl(control, "Accept"),
                text =      SI_DIALOG_ACCEPT,
                keybind =   "DIALOG_PRIMARY",
                callback =  function(dialog)
                                ASESPD:Commit(control)
                            end,
            },  
            {
                control =   GetControl(control, "Cancel"),
                text =      SI_DIALOG_CANCEL,
                keybind =   "DIALOG_NEGATIVE",
                callback =  function(dialog)
                            end,
            },
		
        },
    })
end

ASESPD.Initialize()