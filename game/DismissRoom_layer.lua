-------------------------------------------------
-- 解散房间
-------------------------------------------------

local DismissRoomlayer = class("DismissRoomlayer", cocosMake.DialogBase)

local this

--cocos studio生成的csb
DismissRoomlayer.ui_resource_file = {GameResources.csb.DismissRoomlayerUI}

DismissRoomlayer.ui_binding_file = {
	Btn_Close    = {event = "click", method = "Btn_CloseClick"},

    Btn_Disagree = {event = "click", method = "Btn_DisagreeClick"},

    Btn_Agree = {event = "click", method = "Btn_AgreeClick"},
}

function DismissRoomlayer:onCreate(param)
	this = self
	self.param = param

	-- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)

    -- 解散
    --_, self.DisMissInfoHander = self:addEventListener(updateUIEvent.ROOM_DISMISS, handler(self, self.onDisMissCheck))

    _, self.DisMissInfoHander = self:addEventListener(updateUIEvent.ROOM_DISMISSINFO, handler(self, self.onDisMissInfo))

    self.MaxCount = 999

    self:init()

    self.showTipFrame = false

    local data = self.param.data
    if data ~= nil then 
        self:disposeDisMissInfo(data)
    end
end

function DismissRoomlayer:init( ... )
    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    for i, item in pairs(userinfo) do
        if item ~= nil then
            self["Text_PlayerID"..i]:setString(item.szNickName)
            self["Text_Tipesult"..i]:setString("不同意")
        end
    end

    self.updateHandler = RealTimer:RegTimerLoop(1, handler(self, self.onTimerUpdate))
end

function DismissRoomlayer:onDisMissCheck(event)
--    local data = event.data
--    if data == nil then return end 

--    if data == RoomDisMissState.DisMiss_Check_Ok then 
--        LayerManager.closeFloat(loadlua.DismissRoomTiplayer, self)   
--        GameLogicCtrl:DisMissRoolMsg(1) -- 发送解散协议
--    elseif data == RoomDisMissState.DisMiss_Check_Cancel then 
--        LayerManager.closeFloat(loadlua.DismissRoomTiplayer, self)   
--        --self:DisMissRoolMsg(0) 
--    end
end

function DismissRoomlayer:DisMissRoolMsg(value)

end

function DismissRoomlayer:onDisMissInfo(event)
    local CMD_GF_Private_Dismiss_Info = event.data
    if CMD_GF_Private_Dismiss_Info == nil then return end 

    if self.showTipFrame then
        self.showTipFrame = false
        LayerManager.closeFloat(loadlua.DismissRoomTiplayer, self)    
    end

    self:disposeDisMissInfo(CMD_GF_Private_Dismiss_Info)
end

function DismissRoomlayer:disposeDisMissInfo(CMD_GF_Private_Dismiss_Info)
    if CMD_GF_Private_Dismiss_Info == nil then return end

    self.MaxCount = CMD_GF_Private_Dismiss_Info.dwValue2

    if CMD_GF_Private_Dismiss_Info.dwDissUserCout == 0 then return end 

    --for i, chairid in pairs(CMD_GF_Private_Dismiss_Info.dwDissChairID) do
    for i = 1, CMD_GF_Private_Dismiss_Info.dwDissUserCout do
        local chairid = CMD_GF_Private_Dismiss_Info.dwDissChairID[i]
        local localchair = GameLogicCtrl:getLocalPlayerIdx(chairid)
        if self["Text_Tipesult"..i] ~= nil then
            self["Text_Tipesult"..i]:setString("同意")
        end
    end

    -- 判断自己如果同意 隐藏 按钮
    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil then return end 

    local mechair = meitem.wChairID
    local findidx = false

    for i = 1, CMD_GF_Private_Dismiss_Info.dwDissUserCout do
        local chairid = CMD_GF_Private_Dismiss_Info.dwDissChairID[i]
        if mechair == chairid then 
            findidx = true 
            break
        end
    end

    if findidx == true then 
        self.Btn_Close:setVisible(false)
        self.Btn_Disagree:setVisible(false)
        self.Btn_Agree:setVisible(false)
    end
end

function DismissRoomlayer:onTimerUpdate(dt)
    self.MaxCount = self.MaxCount - 1
    self.Text_Time:setString(self.MaxCount)
    if self.MaxCount == 0 then 
        GameLogicCtrl:DisMissRoolMsg(1) -- 发送解散协议
    end
end

function DismissRoomlayer:Btn_DisagreeClick(event)
    GameLogicCtrl:DisMissRoolMsg(0) -- 发送解散协议
end

function DismissRoomlayer:Btn_AgreeClick(event)
    self.showTipFrame = true
    LayerManager.showFloat(loadlua.DismissRoomTiplayer, self)
end

function DismissRoomlayer:Btn_CloseClick(event)
	--self.param.closeCallback()
end

function DismissRoomlayer:onClose( ... )
    if self.DisMissInfoHander then 
        self:removeEventListener(self.DisMissInfoHander)
        self.DisMissInfoHander = nil        
    end

    if self.updateHandler then 
		RealTimer:UnRegTimer(self.updateHandler)
		self.updateHandler = nil
    end	
end

return DismissRoomlayer