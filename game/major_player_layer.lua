-------------------------------------------------
-- 显示玩家自己牌 处理类 
-------------------------------------------------

local majorPlayeLayer = class("majorPlayeLayer", HotRequire(loadlua.basePlayerLayer))

--local MAX_CARDCOUNT = 13

local SCALE = 0.9
--local CARD_WIDTH = (88 - 5) * SCALE
--local MAX_WIDTH = CARD_WIDTH * MAX_CARDCOUNT

-- 初始化手上的牌
function majorPlayeLayer:initHandCards(data)
	local ids = 1
	local x,y = 0,0

    --local cardcount = #data
    --local maxwidth = cardcount * CARD_WIDTH * SCALE

    --x = maxwidth
	for k,v in pairs(data) do
        if ids == 14 then break end
		local c = new_class(loadlua.Card, {id=ids, value=v, black=false, normal=true, site=self.localSite})

        if c ~= nil then 
            c:setScale(SCALE)

		    c:setPosition(x, y)
		    self.ui.handCardPanel:addChild(c)
		
            c:setTouch(true, touchEndCallback)
		    ids = ids + 1
		
            x = x - (c:getSize().width * SCALE + 4)
		    --x = x + c:getSize().width - 4
        end
	end
end

function majorPlayeLayer:setActive(enable)
    self.m_booActive = enable
    self.m_ui.Btn_tishi:setVisible(enable)
    self.m_ui.Btn_chupai:setVisible(enable)
    self.m_ui.player1_playedCardPanel:removeAllChildren()
end

function majorPlayeLayer:reSetHandCards(cards)
    self.ui.handCardPanel:removeAllChildren()
    self:initHandCards(cards)
end

function majorPlayeLayer:Refresh()
    local cardsList = self.m_ui.bottomPanel.player1_handCardPanel:getChildren()
    local totalWidth = 0
    for i, node in pairs(cardsList) do
        totalWidth = totalWidth + node.m_Exwidth
    end
    totalWidth = totalWidth + CARD_WIDTH
    local space = 1200 - totalWidth
    local gap = space / ( #cardsList - 1 )
    gap = math.max( math.min( gap, 40 ), 0 )
    self.m_gap = gap
    local x = ( 1200 - totalWidth - ( #cardsList - 1 ) * gap ) / 2
    for i, node in pairs(cardsList) do
        node:setPosition( 40 + x, 80 )
        x = x + node.m_Exwidth + gap
    end
end



function majorPlayeLayer:setCardGroup(Groups)
    self.m_ui.bottomPanel.player1_handCardPanel:removeAllChildren()
--    self.m_cardsNode = {}
    local gap = 10
    for i, v in pairs( Groups ) do
        local cb = new_class(loadlua.CardGroup, { cards = v, gap = gap } )
        self.m_ui.bottomPanel.player1_handCardPanel:addChild( cb )
    end
    self:Refresh()
--    for i, card in pairs(cards) do
--        local c = new_class(loadlua.Card, { value=card } )
--        c:setPosition( i * 20, 80 )
--        c:setVisible( true )
--        self.m_ui.bottomPanel.player1_handCardPanel:addChild( c )
--    end
end

function majorPlayeLayer:setOutput( idx, booCanEat )
    local panel = self.m_ui.bottomPanel.player1_handCardPanel
    if idx and idx <= panel:getChildrenCount() then
        self:Refresh()
        local v = panel:getChildren()[idx]
        if v then
            v:setPositionY( v:getPositionY() + 50 )
        end
    end

    self.m_ui.Btn_chupai:setEnabled(booCanEat)
end

function majorPlayeLayer:setTouch(enable)
	local function onMyTouchBegan( touch,event )
        if not self.m_booActive then
            return false
        end
        self:Refresh()
        local localpos = touch:getLocation()
        local panel = self.m_ui.bottomPanel.player1_handCardPanel
        local pos = panel:convertToNodeSpace(localpos)
        for i, v in pairs( panel:getChildren() ) do
            x, y = v:getPosition()
            local rect = cc.rect(x - 50,y - 80,v.m_Exwidth + self.m_gap - 10, 170)
            if i == panel:getChildrenCount() then
                rect.width = rect.width + 120
            end
            if cc.rectContainsPoint(rect, pos) then
                GameLogicCtrl:setOutputCard( i )
                return false
            end
        end
        GameLogicCtrl:setOutputCard( nil )


        return false
    end

	local function onMyTouchEnded(touch,event)
	end
    self.m_ui.bottomPanel.player1_handCardPanel:setTouchEnabled(false)

	if enable then
		local touchListen = cc.EventListenerTouchOneByOne:create()
		touchListen:registerScriptHandler(onMyTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
		touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
		touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_CANCELLED)
		
		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(touchListen,self.m_ui.bottomPanel.player1_handCardPanel)
	end
end



-- 显示打出去的牌
function majorPlayeLayer:outCard(cards)
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.player2_playedCardPanel,
        self.m_ui.topPanel.player3_playedCardPanel, self.m_ui.leftPanel.player4_playedCardPanel }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:removeAllChildren()
        local cb = new_class(loadlua.CardGroup, { cards = cards, gap = 40 } )
        cb:setPosition( 60, 50 )
        myPan:addChild( cb )
    end
end

function majorPlayeLayer:AddOperateCard(x, y, param)
    local re = 0
    local c = new_class(loadlua.Card, param)
    if c ~= nil then 
        c:setScale(SCALE)
        c:setPosition( x, y)
        self.ui.addCardPanel:addChild(c)
        re = c:getSize().width
    end
    return re
end

-- 显示出吃碰杠的牌
function majorPlayeLayer:showOperateCard(cards)
    if cards == nil then return end 

    --self.ui.addCardPanel:addChild(c)
    self.ui.addCardPanel:removeAllChildren()
    local x,y = 0,0

    for i, weave in pairs(cards) do
        if weave ~= nil then 
            local param = {}
            local w = 0
            if WIK_PENG == weave.cbWeaveKind then 
                -- 碰
                param = {id=ids, value=weave.cbCenterCard, black=false,down=true, normal=true, site=self.localSite}
                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                param = {id=ids, value=weave.cbCenterCard, black=true,down=true, normal=true, site=self.localSite}
                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                x = x + 10 --间距

            elseif WIK_GANG == weave.cbWeaveKind then 
                -- 杠

                param = {id=ids, value=weave.cbCenterCard, black=false,down=true, normal=true, site=self.localSite}
                if not weave.cbPublicCard then 
                    -- 暗杠
                    param = {id=ids, value=weave.cbCenterCard, black=true,down=true, normal=true, site=self.localSite}
                end

                w = self:AddOperateCard(x, y, param)
                x = x + w - 4

                w = self:AddOperateCard(x, y, param)


                w = self:AddOperateCard(x, y + 21, param)
                x = x + w - 4

                w = self:AddOperateCard(x, y, param)
                x = x + w - 4

                x = x + 10 --间距
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

                param = {id=ids, value=cbWeaveCard[1], black=false,down=true, normal=true, site=self.localSite}
                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                param = {id=ids, value=cbWeaveCard[2], black=false,down=true, normal=true, site=self.localSite}
                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                param = {id=ids, value=cbWeaveCard[3], black=false,down=true, normal=true, site=self.localSite}
                w = self:AddOperateCard(x, y, param)
                x = x + w - 5

                x = x + 10 --间距
            end

        end
    end
end

--[[
#define WIK_NULL					0x00000000								//没有类型
#define WIK_LEFT					0x00000001								//左吃类型
#define WIK_CENTER				0x00000002								//中吃类型
#define WIK_RIGHT					0x00000004								//右吃类型
#define WIK_PENG					0x00000008								//碰牌类型
#define WIK_GANG					0x00000010								//杠牌类型
#define WIK_XIAO_HU				0x00000020								//小胡								
#define WIK_CHI_HU				0x00000040								//吃胡类型
#define WIK_ZI_MO					0x00000080								//自摸
#define WIK_BU_ZHANG				0x00000100								//补张
#define WIK_CS_GANG				0x00000200								//长沙杠
#define WIK_DNBL					0x00000400								//东南北左
#define WIK_DNBC					0x00000800								//东南北中
#define WIK_DNBR					0x00001000								//东南北右
#define WIK_DXBL					0x00002000								//东西北左	
#define WIK_DXBC					0x00004000								//东西北中	
#define WIK_DXBR					0x00008000								//东西北右	
]]

local BtnMask = {
    {WIK_NULL,	    ""},

    {WIK_LEFT,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_CENTER,	"res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_RIGHT,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DNBL,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DNBC,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DNBR,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DXBL,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DXBC,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},
    {WIK_DXBR,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonChi.png"},

    {WIK_PENG,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonPeng.png"},
    {WIK_GANG,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonGang.png"},
    {WIK_XIAO_HU,	"res/gamesres/380/res_380/roomScene/ytmj/ButtonHu.png"},
    {WIK_CHI_HU,	"res/gamesres/380/res_380/roomScene/ytmj/ButtonHu.png"},

    --{WIK_ZI_MO,	    "res/gamesres/380/res_380/roomScene/ytmj/ButtonPeng.png"},
    --{WIK_BU_ZHANG,  "res/gamesres/380/res_380/roomScene/ytmj/ButtonPeng.png"},
    {WIK_CS_GANG,	"res/gamesres/380/res_380/roomScene/ytmj/ButtonGang.png"},
}

function majorPlayeLayer:hideToolPanel()
    self.ui.Panel_Operation:setVisible(false)
end

local function createOperateBtn(btnmask_, btnres)
    
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then

            local mask_ = sender:getTag()

            GameLogicCtrl:operateCmd(mask_)

            majorPlayeLayer:hideToolPanel()

            --self.ui.Panel_Operation:setVisible(false)
--            if mask_ == WIK_NULL then
--            elseif mask_ == WIK_LEFT then  
--            elseif mask_ == WIK_CENTER then	
--            elseif mask_ == WIK_RIGHT then	    
--            elseif mask_ == WIK_DNBL then	    
--            elseif mask_ == WIK_DNBC then	    
--            elseif mask_ == WIK_DNBR then	    
--            elseif mask_ == WIK_DXBL then	    
--            elseif mask_ == WIK_DXBC then	    
--            elseif mask_ == WIK_DXBR then	    

--            elseif mask_ == WIK_PENG then	    
--            elseif mask_ == WIK_GANG then	    
--            elseif mask_ == WIK_XIAO_HU then	
--            elseif mask_ == WIK_CHI_HU then	
--            elseif mask_ == WIK_ZI_MO then	
--            elseif mask_ == WIK_BU_ZHANG then
--            elseif mask_ == WIK_CS_GANG then	
--            end

        elseif eventType == ccui.TouchEventType.canceled then
        end
    end

    local rebtn = nil
    rebtn = ccui.Button:create()
    rebtn:setTouchEnabled(true)
    rebtn:setTag(btnmask_)
    rebtn:loadTextures(btnres, "", "")
    rebtn:addTouchEventListener(touchEvent)

    return rebtn
end

local sameMask = {
    WIK_LEFT,	
    WIK_CENTER,
    WIK_RIGHT,	
    WIK_DNBL,	
    WIK_DNBC,	
    WIK_DNBR,	
    WIK_DXBL,	
    WIK_DXBC,	
    WIK_DXBR,	
}

local function checkIsSame(btnlst, mask_)
    local re = true

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            local findit = false
            for j, v in pairs(sameMask) do
                if v == mask_ then
                    findit = true
                    break
                end
            end
            if findit == true then 
                re = false
                break
            end
        end
    end

    return re
end

function majorPlayeLayer:showOperateTool(operdata)
--[[
//操作提示
struct CMD_S_OperateNotify
{
	WORD							wResumeUser;						//还原用户
	DWORD							cbActionMask;						//动作掩码
	BYTE							cbActionCard;						//动作扑克
};
]]
    if operdata == nil then return end 

    if self.ui.Panel_Operation == nil then return end
    self.ui.Panel_Operation:removeAllChildren()
    self.ui.Panel_Operation:setVisible(true)

    local btnlst = {}
    for i, item in pairs(BtnMask) do
        local vv = bit._and(item[1], operdata.cbActionMask)
        if vv ~= 0 then
            local isok = checkIsSame(btnlst, item[1])
            if isok then 
                local btn = createOperateBtn(item[1], item[2])
                if btn ~= nil then

                    if vv ~= WIK_GANG then 
                        -- 显示 操作的麻将
                        local x,y = 0,0
	                    local c = new_class(loadlua.Card, {value=operdata.cbActionCard, out=true,black=false, down=true})
                        if c ~= nil then 
                            x = btn:getSize().width + 5
                            y = y + 50
	                        c:setPosition( x, y)
	                        btn:addChild(c)
                        end
                    end

                    table.insert(btnlst, btn)
                end 
            end
        end
    end

    -- 添加 过 按钮
    local btn = createOperateBtn(WIK_NULL, "res/gamesres/380/res_380/roomScene/ytmj/ButtonPass.png")
    if btn ~= nil then 
        table.insert(btnlst, btn)
    end

    -- 重新排序 
    -- 从左到右 胡 杠 碰 吃 过
    local temguo = {} -- 过
    local temchi = {} -- 吃
    local tempeng = {} -- 碰
    local temgang = {} -- 杠
    local temhu = {} -- 胡

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            if tag == WIK_NULL then 
                table.insert(temguo, btn)
            end
        end
    end

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            if tag ==  WIK_LEFT or  
               tag ==  WIK_CENTER or
               tag ==  WIK_RIGHT or 
               tag ==  WIK_DNBL  or 
               tag ==  WIK_DNBC  or  
               tag ==  WIK_DNBR  or 
               tag ==  WIK_DXBL  or 
               tag ==  WIK_DXBC  or 
               tag ==  WIK_DXBR  then 
                table.insert(temchi, btn)
            end
        end
    end

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            if tag == WIK_PENG then 
                table.insert(tempeng, btn)
            end
        end
    end

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            if tag == WIK_GANG then 
                table.insert(temgang, btn)
            end
        end
    end

    for i, btn in pairs(btnlst) do
        if btn ~= nil then 
            local tag = btn:getTag()
            if tag == WIK_CHI_HU then 
                table.insert(temhu, btn)
            end
        end
    end


    btnlst = {}

    for i, btn in pairs(temguo) do
        table.insert(btnlst, btn)
    end
    for i, btn in pairs(temchi) do
        table.insert(btnlst, btn)
    end
    for i, btn in pairs(tempeng) do
        table.insert(btnlst, btn)
    end
    for i, btn in pairs(temgang) do
        table.insert(btnlst, btn)
    end
    for i, btn in pairs(temhu) do
        table.insert(btnlst, btn)
    end

    -- 重新设置显示位置 从后向前 遍历数组显示
    --local idx = 1
    local x = 0
    local y = 0
    
    --for i = #btnlst, 1, -1 do
    for i, btn in pairs(btnlst) do
        --local btn = btnlst[i]
        if btn ~= nil then
            self.ui.Panel_Operation:addChild(btn)

            btn:setPosition(cc.p(x, y))
            x = x - btn:getContentSize().width * 2 + 35

            --idx = idx + 1
        end
    end

end

function majorPlayeLayer:passCard()
    local panel = { self.m_ui.bottomPanel.player1_playedCardPanel, self.m_ui.rightPanel.player2_playedCardPanel,
        self.m_ui.topPanel.player3_playedCardPanel, self.m_ui.leftPanel.player4_playedCardPanel }
    local myPan = panel[self.localSite]
    if myPan then
        myPan:removeAllChildren()
        local Img = cocosMake.newSprite("res/gamesres/502/res_502/card/yaobuqi.png")
        Img:setPosition( 60, 50 )
        myPan:addChild( Img )
    end
end

return majorPlayeLayer