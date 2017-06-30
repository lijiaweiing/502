-------------------------------------------------
-- 显示其它玩家自己牌 处理类 
-------------------------------------------------

local minorPlayeLayer = class("minorPlayeLayer", HotRequire(loadlua.basePlayerLayer))

local CARD_HEIGHT = 57 - (2 * 57 / 3) -- 显示在左右两边牌
local CARD_WIDTH = 52 - 4 -- 显示在正上方牌 

-- 初始化 手上的牌 
function minorPlayeLayer:initHandCards(count)
    self:setCardCount(count)
end

function minorPlayeLayer:setCardCount(count)
    self.m_cardCount = count
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.Img_cardnum.text_num,
        self.m_ui.topPanel.Img_cardnum.text_num, self.m_ui.leftPanel.Img_cardnum.text_num }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:setString( self.m_cardCount )
    end
end

function minorPlayeLayer:outCard(cards)
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.player2_playedCardPanel,
        self.m_ui.topPanel.player3_playedCardPanel, self.m_ui.leftPanel.player4_playedCardPanel }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:removeAllChildren()
        local cb = new_class(loadlua.CardGroup, { cards = cards, gap = 10 } )
        cb:setScale( 0.5 )
        cb:setPosition( 30, 40 )
        myPan:addChild( cb )
    end
    self:setCardCount( self.m_cardCount - #cards )
end

function minorPlayeLayer:passCard()
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.player2_playedCardPanel,
        self.m_ui.topPanel.player3_playedCardPanel, self.m_ui.leftPanel.player4_playedCardPanel }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:removeAllChildren()
        local Img = cocosMake.newSprite("res/gamesres/502/res_502/card/yaobuqi.png")
        Img:setPosition( 30, 40 )
        myPan:addChild(Img)
    end
end

function minorPlayeLayer:setActive(enable)
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.player2_playedCardPanel,
        self.m_ui.topPanel.player3_playedCardPanel, self.m_ui.leftPanel.player4_playedCardPanel }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:removeAllChildren()
    end
end

function minorPlayeLayer:reSetHandCards(count)
    self:setActive(false)
    self:initHandCards(count)
end

-- 显示打出的牌
function minorPlayeLayer:addPlayedCard(OutCardData)
    local cards = GameLogicCtrl:getOutCardsFrmPlayerIdx(self.localSite)

    local cardcount = #cards
    local x,y = 0,0

    local param = {}

    if self.localSite == 3 then 
        param = {value=OutCardData, black=false, out=true,down=true, side=false, site=self.localSite}
    else
        -- 2, 4
        param = {value=OutCardData, black=false, out=true,down=true, side=true, site=self.localSite}
    end

	local c = new_class(loadlua.Card, param)

    local px = 0
    local py = 0

    local outlst = GameLogicCtrl:getOutCardsFrmPlayerIdx(self.localSite)
    if self.localSite == 2 then 
        if #outlst <= 10 then
            px = x
            py = y + (c:getSize().height - 14) * (cardcount - 1)
        else
            px = x - 44
            py = y + (c:getSize().height - 14) * (cardcount - 10 - 1)
        end
        c:setZOrder(1000 - #outlst)
    elseif self.localSite == 3 then
        if #outlst <= 10 then
            px = x - c:getSize().width * (cardcount - 1)
            py = y
        else
            px = x - c:getSize().width * (cardcount - 10 - 1)
            py = y - 53 + 10
        end
    elseif self.localSite == 4 then
        if #outlst <= 10 then
            px = x
            py = y - (c:getSize().height - 14) * (cardcount - 1)
        else
            px = x + 44
            py = y - (c:getSize().height - 14) * (cardcount - 10 - 1)
        end
        c:setZOrder(#outlst)
    end

	c:setPosition(px, py )
	self.ui.playedCardPanel:addChild(c)
end

-- 重置打出去的牌
function minorPlayeLayer:reSetPlayedCard(cards)
    self.ui.playedCardPanel:removeAllChildren()
    for i, card in pairs(cards) do
        self:addPlayedCard(card)
    end
end

-- 添加发给自己的牌，这里处理的是除自己外的其它玩家的显示
function minorPlayeLayer:showSendCard(sendcard)
    local param =  {value=sendcard, side=true, normal=true,black=true, site=self.localSite}
    if self.localSite == 3 then
        param =  {value=sendcard, side=false,up=true, normal=false,black=true, site=self.localSite}
    end

    local x,y = 0,0
    local cardcount = GameLogicCtrl:getCardCountFrmPlayerIdx(self.localSite)
--    -- 显示在正上方
--    local maxwidth = CARD_WIDTH * cardcount
--    -- 显示在左右两边
--    local maxheight = CARD_HEIGHT * cardcount

--    x = maxwidth
--    y = 0
--    if self.localSite ~= 3 then
--        x = 0
--        y = maxheight
--    end

	local c = new_class(loadlua.Card, param)
    if c ~= nil then
        if self.localSite == 2 then
            c:setScaleX(-1)
            c:setZOrder(0)
        elseif self.localSite == 4 then
            c:setZOrder(1000)
        end

        if self.localSite == 3 then 
            x = -11 - CARD_WIDTH
        elseif self.localSite == 2 then
            y = 30
        elseif self.localSite == 4 then 
            y = -30
        end

	    c:setPosition( x, y)
	    self.ui.handCardPanel:addChild(c)

    end

end

function minorPlayeLayer:AddOperateCard(x, y, param)
    local w, h
    local c = new_class(loadlua.Card, param)
    if c ~= nil then 
        c:setPosition( x, y)
        if self.localSite == 2 then
            c:setZOrder(1000 - self.ui.addCardPanel:getChildrenCount())
        elseif self.localSite == 4 then
            c:setZOrder(self.ui.addCardPanel:getChildrenCount())
        end
        self.ui.addCardPanel:addChild(c)
        w = c:getSize().width
        h = c:getSize().height
    end
    return w, h
end


-- 显示吃碰杠的牌
function minorPlayeLayer:showOperateCard(cards)
    if cards == nil then return end 

    --self.ui.addCardPanel:addChild(c)
    self.ui.addCardPanel:removeAllChildren()
    local x,y = 0,0

    for i, weave in pairs(cards) do
        if weave ~= nil then 
            local param = {}
            local w, h = 0, 0
            if WIK_PENG == weave.cbWeaveKind then 
                -- 碰

                if self.localSite == 3 then 
                    param = {value=weave.cbCenterCard, black=false, down=true, side=false, oper=true,site=self.localSite}
                else
                    -- 2, 4
                    param = {value=weave.cbCenterCard, black=false, down=true, side=true, oper=true,site=self.localSite}
                end

                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w 
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                if self.localSite == 3 then 
                    param = {value=weave.cbCenterCard, black=true, down=true, side=false, oper=true,site=self.localSite}
                else
                    -- 2, 4
                    param = {value=weave.cbCenterCard, black=true, down=true, side=true, oper=true,site=self.localSite}
                end
                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                --间距
                if self.localSite == 3 then 
                    x = x - 10
                elseif self.localSite == 2 then 
                    y = y + 5
                elseif self.localSite == 4 then 
                    y = y - 10
                end

            elseif WIK_GANG == weave.cbWeaveKind then 
                -- 杠
                if self.localSite == 3 then 
                    param = {value=weave.cbCenterCard, black=false, down=true, side=false, oper=true,site=self.localSite}
                    if not weave.cbPublicCard then
                        -- 暗杠 
                        param = {value=weave.cbCenterCard, black=true, down=true, side=false, oper=true,site=self.localSite}
                    end
                else
                    -- 2, 4
                    param = {value=weave.cbCenterCard, black=false, down=true, side=true, oper=true,site=self.localSite}
                    if not weave.cbPublicCard then 
                        -- 暗杠
                        param = {value=weave.cbCenterCard, black=true, down=true, side=true, oper=true,site=self.localSite}
                    end
                end

                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                w, h = self:AddOperateCard(x, y, param)

                if self.localSite == 3 then 
                    w, h = self:AddOperateCard(x, y + 10, param)
                elseif self.localSite == 2 then 
                    w, h = self:AddOperateCard(x - 5, y, param)
                elseif self.localSite == 4 then 
                    w, h = self:AddOperateCard(x + 5, y, param)
                end
                
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                --间距
                if self.localSite == 3 then 
                    x = x - 10
                elseif self.localSite == 2 then 
                    y = y + 5
                elseif self.localSite == 4 then 
                    y = y - 10
                end
            else
                -- 吃牌类型

                -- 组合吃的牌
                local cbOperateCard = weave.cbCenterCard
		        local cbWeaveCard = {cbOperateCard,cbOperateCard,cbOperateCard}

		        if (weave.cbWeaveKind == WIK_LEFT) then
			        cbWeaveCard[2] = cbOperateCard+1
			        cbWeaveCard[3] = cbOperateCard+2
		        end

		        if (weave.cbWeaveKind == WIK_CENTER) then
			        cbWeaveCard[1] = cbOperateCard-1
			        cbWeaveCard[3] = cbOperateCard+1
		        end

		        if (weave.cbWeaveKind == WIK_RIGHT) then
			        cbWeaveCard[1] = cbOperateCard-2
			        cbWeaveCard[2] = cbOperateCard-1
		        end

		        if (weave.cbWeaveKind == WIK_DNBL) then
                    --//东南北左
			        cbWeaveCard[2] = cbOperateCard+1
			        cbWeaveCard[3] = cbOperateCard+3
		        end

		        if (weave.cbWeaveKind == WIK_DNBC) then
                    -- //东南北中
			        cbWeaveCard[1] = cbOperateCard-1
			        cbWeaveCard[3] = cbOperateCard+2
		        end

		        if (weave.cbWeaveKind == WIK_DNBR) then
                    --//东南北右
			        cbWeaveCard[1] = cbOperateCard-2
			        cbWeaveCard[2] = cbOperateCard-3
		        end

		        if (weave.cbWeaveKind == WIK_DXBL) then
                    --//东西北左
			        cbWeaveCard[2] = cbOperateCard+2
			        cbWeaveCard[3] = cbOperateCard+3
		        end

		        if (weave.cbWeaveKind == WIK_DXBC) then
                    --//东西北中
			        cbWeaveCard[1] = cbOperateCard-2
			        cbWeaveCard[3] = cbOperateCard+1
		        end

		        if (weave.cbWeaveKind == WIK_DXBR) then
                    --//东西北右
			        cbWeaveCard[1] = cbOperateCard-1
			        cbWeaveCard[2] = cbOperateCard-3
		        end

                if self.localSite == 3 then 
                    param = {value=cbWeaveCard[1], black=false,down=true, side=false, oper=true,site=self.localSite}
                else
                    -- 2, 4
                    param = {value=cbWeaveCard[1], black=false, down=true, side=true, oper=true,site=self.localSite}
                end

                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                if self.localSite == 3 then 
                    param = {value=cbWeaveCard[2], black=false, down=true, side=false, oper=true,site=self.localSite}
                else
                    -- 2, 4
                    param = {value=cbWeaveCard[2], black=false, down=true, side=true, oper=true,site=self.localSite}
                end
                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                if self.localSite == 3 then 
                    param = {value=cbWeaveCard[3], black=false, down=true, side=false, oper=true,site=self.localSite}
                else
                    -- 2, 4
                    param = {value=cbWeaveCard[3], black=false, down=true, side=true, oper=true,site=self.localSite}
                end
                w, h = self:AddOperateCard(x, y, param)
                if self.localSite == 3 then 
                    x = x - w
                elseif self.localSite == 2 then 
                    y = y + h - 14
                elseif self.localSite == 4 then 
                    y = y - w + 21
                end

                --间距
                if self.localSite == 3 then 
                    x = x - 10
                elseif self.localSite == 2 then 
                    y = y + 5
                elseif self.localSite == 4 then 
                    y = y - 10
                end
            end

        end
    end    
end

return minorPlayeLayer