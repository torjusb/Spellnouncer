local announces = {
	['Guardian Spirit'] =  {
		'Guardian Spirit on <target>',
		['channels'] = { 'RAID', 8 }
	},
	['Hymn of Hope'] = {
		'<-- Hymn of Hope -->',
		['channels'] = { 'RAID' }
	},
	['Pain Suppression'] = {
		'Pain Suppression on <target>',
		['channels'] = { 8, 'RAID' }
	},
}

local tags = {
	['target'] = function()
		local name = UnitName'target'

		return name or 'Nifty'
	end,
}

local handleTag = function(tag)
	local handler = tags[tag]
	if(handler) then
		return handler()
	end
end

local smartSend = function(spell)
	if(not spell) then return end
	if GetNumRaidMembers > 0 do 
		msg = spell[1]:gsub('<(%w+)>', handleTag)
		for _, channel in pairs(spell['channels']) do 
			if type(channel) == 'number' then
				SendChatMessage(msg, 'CHANNEL', nil, channel)
			else 
				SendChatMessage(msg, channel)
			end				
		end
	end
end

local addon = CreateFrame('Frame')

addon:SetScript('OnEvent', function(self, event, unit, spell)
	if(unit == 'player') then
		self[event](self, event, unit, spell)
	end
end)

function addon:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell)
	local announce = announces[spell]

	if(announce) then
		smartSend(announce)
	end
end

addon:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED)'
