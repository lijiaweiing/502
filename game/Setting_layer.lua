-------------------------------------------------
-- 设置
-------------------------------------------------

local Settinglayer = class("Settinglayer", cocosMake.DialogBase)

local this

--cocos studio生成的csb
Settinglayer.ui_resource_file = {GameResources.csb.SettinglayerUI}

Settinglayer.ui_binding_file = {

    Btn_Close = {event = "click", method = "Btn_CloseClick"}, 

    Button_DismissRoom = {event = "click", method = "Button_DismissRoomClick"}, 
}

function Settinglayer:onCreate(param)
	this = self
	self.param = param

    self.showcheckframe = false
	-- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)

    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.ROOM_DISMISS, handler(self, self.onDisMissRoom))

    self:init()
end

function Settinglayer:init( ... )
    local gameOptInfo = UserManager:getUserData():getGameOptInfo()
    if gameOptInfo == nil then return end

    -- 1 普通话，  2  方言
    local SoundType = gameOptInfo.SoundType
    if SoundType == 1 then 

        self.CheckBox_1:setSelected(true)
        self.CheckBox_2:setSelected(false)

    elseif SoundType == 2 then 
        self.CheckBox_1:setSelected(false)
        self.CheckBox_2:setSelected(true) 
    end

    local function CheckBox_1Event(event, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            gameOptInfo.SoundType = 1
            self.CheckBox_2:setSelected(false)
        elseif eventType == ccui.CheckBoxEventType.unselected then
        end
        UserManager:getUserData():modifyGameOptInfo(gameOptInfo)
    end
    self.CheckBox_1:addEventListener(CheckBox_1Event)

    local function CheckBox_2Event(event, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            gameOptInfo.SoundType = 2
            self.CheckBox_1:setSelected(false)
        elseif eventType == ccui.CheckBoxEventType.unselected then
        end
        UserManager:getUserData():modifyGameOptInfo(gameOptInfo)
    end
    self.CheckBox_2:addEventListener(CheckBox_2Event)

    -- 音乐
    local function Slider_SoundEvent(sender, eventType)
        local curp = sender:getPercent()
        gameOptInfo.BackSound = curp
        UserManager:getUserData():modifyGameOptInfo(gameOptInfo)
    end
    local EffSound = gameOptInfo.BackSound
    self.Slider_Music:setPercent(EffSound)
    self.Slider_Music:addEventListener(Slider_SoundEvent)

    -- 音效
    local function Slider_SoundEvent(sender, eventType)
        local curp = sender:getPercent()
        gameOptInfo.EffSound = curp
        UserManager:getUserData():modifyGameOptInfo(gameOptInfo)
    end
    local EffSound = gameOptInfo.EffSound
    self.Slider_Sound:setPercent(EffSound)
    self.Slider_Sound:addEventListener(Slider_SoundEvent)

end

function Settinglayer:Button_DismissRoomClick(event)
    self.showcheckframe = true

    LayerManager.showFloat(loadlua.DismissRoomTiplayer, self)

    --self:dispatchEvent({name = updateUIEvent.ROOM_DISMISS, data = RoomDisMissState.DisMiss_Check_Open})
	--self:Btn_CloseClick()
end

function Settinglayer:onDisMissRoom(event)
    local states = event.data
    if states == nil then return end 

    if states == RoomDisMissState.DisMiss_Check_Open then
        
    elseif states == RoomDisMissState.DisMiss_Check_Ok then
        self.showcheckframe = false
        LayerManager.closeFloat(loadlua.DismissRoomTiplayer, self)       
        self:Btn_CloseClick()
    elseif states == RoomDisMissState.DisMiss_Check_Cancel then
        self.showcheckframe = false
        LayerManager.closeFloat(loadlua.DismissRoomTiplayer, self)       
    end

end

function Settinglayer:Btn_CloseClick(event)
    if self.showcheckframe then return end

    UserManager:getUserData():saveOptinfo()
	self.param.closeCallback()
end

return Settinglayer
