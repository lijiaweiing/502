-------------------------------------------------
-- 头像
-------------------------------------------------

local HeadLayer = class("HeadLayer", cocosMake.DialogBase)

local this

--cocos studio生成的csb
HeadLayer.ui_resource_file = {GameResources.csb.HeadLayerUI}

HeadLayer.ui_binding_file = {
	Btn_Close    = {event = "click", method = "Btn_CloseClick"},


    Btn_Prop1 = {
        name = "HeadLayerUI.Img_Box.Btn_Prop1",
        event = "click", 
        method = "Btn_Prop1Click"
    }, 

    Btn_Prop2 = {
        name = "HeadLayerUI.Img_Box.Btn_Prop2",
        event = "click", 
        method = "Btn_Prop2Click"
    },

    Btn_Prop3 = {
        name = "HeadLayerUI.Img_Box.Btn_Prop3",
        event = "click", 
        method = "Btn_Prop3Click"
    },
}

function HeadLayer:onCreate(param)
	self.param = param

    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end
    local idx = self.param.param 
    if idx > #userinfo then return end 

    local useritem = userinfo[idx]
    if useritem == nil then return end 

	self.Text_Name:setString(useritem.szNickName)

	self.Text_ID:setString("ID:".. useritem.dwUserID)
    self.Text_IP:setString("ID:".. useritem.szLogonIP)

    self.Text_Address:setString("ID:".. useritem.szPosition)
--	self.ip:setString("IP:"..UserManager:getGameData():getConfigData().login_ip)

	--设置头像
    self.Img_Sex:loadTexture("res_502/roomScene/ytmj/PlayerInfo/d.png")
    if useritem.cbGender > 1 then 
        self.Img_Sex:loadTexture("res_502/roomScene/ytmj/PlayerInfo/f.png")
    end

    if TARGET_PLATFORM == cc.PLATFORM_OS_WINDOWS then return end

	ImageCacheCtrl:getImage(useritem.szHeadHttp, function(fileName)
		-- 如果fileName存在，则使用该图片
		if cc.FileUtils:getInstance():isFileExist(fileName) then
			--self:clearIcon()
			--WidgetHelp:setPlayerHead(fileName, self.portraits_img)
            self.Img_Head:loadTexture(fileName)
		end
	end)
end

function HeadLayer:init( ... )

end

function HeadLayer:onClose( ... )
	
	--self:removeEventListenerList(self.handlerList)
end

function HeadLayer:Btn_Prop1Click(event)
    self:onfire(1)
end

function HeadLayer:Btn_Prop2Click(event)
    self:onfire(2)
end

function HeadLayer:Btn_Prop3Click(event)
    self:onfire(3)
end

function HeadLayer:onfire(idx)
--[[
	CMD_GF_C_UseItem kNetInfo;
	kNetInfo.wItemIndex = itemidx;
	kNetInfo.cbTargetChair = targetchar;
	IServerItem::get()->SendSocketData(MDM_GF_FRAME,SUB_GF_USE_ITEM,&kNetInfo,sizeof(kNetInfo));

    // 使用道具
struct CMD_GF_C_UseItem
{
	word							wItemIndex;							//道具索引
	byte							cbTargetChair;						//目标用户
};

]]    
    local CMD_GF_C_UseItem = {}

    CMD_GF_C_UseItem.wItemIndex = idx

    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    local useritem = userinfo[self.param.param]
    if useritem == nil then return end 

    CMD_GF_C_UseItem.cbTargetChair = useritem.wChairID

    local s = string.pack( "Hb", CMD_GF_C_UseItem.wItemIndex, CMD_GF_C_UseItem.cbTargetChair  )

    GameLogicCtrl:sendcmd(MDM_GF_FRAME,SUB_GF_USE_ITEM, s)

	self.param.closeCallback()
end

function HeadLayer:Btn_CloseClick(event)
	self.param.closeCallback()
	
end

return HeadLayer
