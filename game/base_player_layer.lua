------------------------------------------------------
-- 桌子玩家基类
------------------------------------------------------

local basePlayerLayer = class("basePlayerLayer")
basePlayerLayer.ui = {}
basePlayerLayer.localSite = 0--本地位置

function basePlayerLayer:setVisible(b)
	for k,v in pairs(self.ui) do
		v:setVisible(b)
	end
end

function basePlayerLayer:init(param)
	self.localSite = param.localSite
    self.m_ui = param.ui
end

function basePlayerLayer:ctor(param)
	self:init(param)
end

function basePlayerLayer:setName(name)
    if not self.m_ui then
        return
    end

    local nameLable = { self.m_ui.leftbottomPanel.player1_headPanel.name, self.m_ui.rightPanel.player2_headPanel.name,
            self.m_ui.topPanel.player3_headPanel.name, self.m_ui.leftPanel.player4_headPanel.name }

    if self.localSite > 0 and self.localSite < 5 then
        nameLable[self.localSite]:setString( name )
    end
end

function basePlayerLayer:setCards(cards)
	return
end

return basePlayerLayer