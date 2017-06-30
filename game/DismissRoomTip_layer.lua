-------------------------------------------------
-- 解散房间提示
-------------------------------------------------

local DismissRoomTiplayer = class("DismissRoomTiplayer", cocosMake.DialogBase)

local this

--cocos studio生成的csb
DismissRoomTiplayer.ui_resource_file = {GameResources.csb.DismissRoomTiplayerUI}

DismissRoomTiplayer.ui_binding_file = {
    Btn_Close = {event = "click", method = "Btn_CloseClick"}, 

    Btn_Cancel = {event = "click", method = "Btn_CloseClick"}, 

    Btn_Sure = {event = "click", method = "Btn_SureClick"}, 
}

function DismissRoomTiplayer:onCreate(param)
	this = self
	self.param = param

	-- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)

    self:init()
end

function DismissRoomTiplayer:init( ... )
end

function DismissRoomTiplayer:Btn_SureClick()
    self:dispatchEvent({name = updateUIEvent.ROOM_DISMISS, data = RoomDisMissState.DisMiss_Check_Ok})
end

function DismissRoomTiplayer:Btn_CloseClick(event)
    self:dispatchEvent({name = updateUIEvent.ROOM_DISMISS, data = RoomDisMissState.DisMiss_Check_Cancel})
end


return DismissRoomTiplayer
