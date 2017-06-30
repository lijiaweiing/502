------------------------------------
-- 游戏桌子
------------------------------------

local RoomLayer = class("RoomLayer", cocosMake.viewBase)


--cocos studio生成的csb
RoomLayer.ui_resource_file = {GameResources.csb.RoomLayerUI}

--csb上的控件绑定
RoomLayer.ui_binding_file = {
	Btn_tishi    = {event = "click", method = "tishi_btnClick"},
    Btn_chupai    = {event = "click", method = "chupai_guestbtnClick"},

    headFrame1 = {
        name = "RoomLayerUI.leftbottomPanel.player1_headPanel.headFrame",
        event = "click", 
        method = "headFrame1Click"
    }, 

    headFrame2 = {
        name = "RoomLayerUI.rightPanel.player2_headPanel.headFrame",
        event = "click", 
        method = "headFrame2Click"
    }, 

    headFrame3 = {
        name = "RoomLayerUI.topPanel.player3_headPanel.headFrame",
        event = "click", 
        method = "headFrame3Click"
    }, 

    headFrame4 = {
        name = "RoomLayerUI.leftPanel.player4_headPanel.headFrame",
        event = "click", 
        method = "headFrame4Click"
    }, 

    chatBtn = {event = "click", method = "chatBtnClick"}, 

    menuSetBtn = {
        name = "RoomLayerUI.lefttopPanel.menuSetBtn",
        event = "click", 
        method = "menuSetBtnClick"
    }, 
}

function RoomLayer:onCreate(param)
    gameManager:getpubInfo():setInRoom(true)

    -- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)

    -- 监听事件
    -- 监听事件
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.STATE_MODIFY, handler(self, self.onStateModify))
    -- 玩家其它信息返回
    _, self.showTextEventHandler = self:addEventListener(UserDataEvent.USER_OTHER_INFO, handler(self, self.onOtherInfoRet))

    -- 事件  显示房间信息
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.SHOW_ROOMINFO, handler(self, self.onShowRoomInfo))
    -- 事件  显示 游戏开始时初始牌信息
    --_, self.showTextEventHandler = self:addEventListener(updateUIEvent.SHOW_CARDINFO, handler(self, self.onShowCard))
    -- 事件  显示玩家出牌信息
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.OUT_CARDINFO, handler(self, self.onPlayerOutCard))
    -- 事件 发牌
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.SEND_CARDINFO, handler(self, self.onPlayerSendCard))
    -- 过牌
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.CARD_PASS, handler(self, self.onPassCard))
    -- 清理
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.CLEAN_ROOM, handler(self, self.onClean))


    -- 飞行道具
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.FIRE_TOOL, handler(self, self.onfireTool))

    --  聊天信息
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.CHAT_MSG, handler(self, self.onChatInfo))

    -- 解散 自己发起解散事件
    _, self.showTextEventHandler = self:addEventListener(updateUIEvent.ROOM_DISMISS, handler(self, self.onDisMissRoom))

    -- 别人发起的解散事件
    self.isOpenDisMissFrame = false
    _, self.DisMissInfoHander = self:addEventListener(updateUIEvent.ROOM_DISMISSINFO, handler(self, self.onDisMissInfo))

    self.updateHandler = RealTimer:RegTimerLoop(1, handler(self, self.onRoomUpdate))

    self:Init()
end

function RoomLayer:onPassCard(event)
    local data = event.data
    if data == nil then return end
    GameLogicCtrl:PassCard(data)

    self:playPassSound(data)
end

function RoomLayer:playPassSound(chatdata)
--struct PDK_CMD_S_PassCard
--{
--	BYTE							bNewTurn;							//一轮开始
--	WORD				 			wPassUser;							//放弃玩家
--	WORD				 			wCurrentUser;						//当前玩家
--}    
    if chatdata == nil then return end 

    local gameOptInfo = UserManager:getUserData():getGameOptInfo()
    if gameOptInfo == nil then return end

    -- 1 普通话，  2  方言
    local SoundType = gameOptInfo.SoundType

    local localplayeridx = GameLogicCtrl:getLocalPlayerIdx(chatdata.wPassUser)
    localplayeridx = localplayeridx + 1
    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    local useritem = userinfo[localplayeridx]

    local sexpath = ""
    if useritem.cbGender <= 1 then
        sexpath = "man/"
    else
        sexpath = "woman/"
    end

    local soundpath = ""
    --if SoundType == 1 then 
        local n = tostring(math.random(1, 2) )
        cardsound = "pass" .. n .. ".mp3"
    --else    
    --    cardsound = "peng1.mp3"
    --end

    --if SoundType == 1 then 
        soundpath = "res/sound/putong/pk/putonghua/" .. sexpath .. cardsound
    --elseif SoundType == 2 then 
    --    soundpath = "res/gamesres/491/res_502/sound/fangyan/" .. sexpath .. cardsound
    --end

    audioCtrl:playEff(soundpath)    
end

function RoomLayer:headFrame1Click(event)
    --self:playerPiaoQing(1, 1)

    self:showheadview(1)

--// 使用道具
--struct CMDJ_GF_S_UserItem
--{
--	word							wItemIndex;							//道具索引
--	byte							cbSendUserChair;					//发送用户
--	byte							cbTargetChair;						//目标用户
--};

--    local CMDJ_GF_S_UserItem = {}

--    CMDJ_GF_S_UserItem.wItemIndex = 3 --;							//道具索引
--    CMDJ_GF_S_UserItem.cbSendUserChair = 1 --;					//发送用户
--    CMDJ_GF_S_UserItem.cbTargetChair  = 3 --;						//目标用户
--    self:playerTools(CMDJ_GF_S_UserItem)
end

function RoomLayer:headFrame2Click(event)
    self:showheadview(2)
end

function RoomLayer:headFrame3Click(event)
    self:showheadview(3)
end

function RoomLayer:headFrame4Click(event)
    self:showheadview(4)
end

function RoomLayer:showheadview(idx)
    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    if idx > #userinfo then return end 

    local useritem = userinfo[idx]
    if useritem == nil then return end 

	local l = self:showFloat(loadlua.HeadLayer, {
		closeCallback = function()
			self:closeFloat(loadlua.HeadLayer)
		end,
	modal=true, offClose=true, param=idx})    
end

function RoomLayer:Init()
    GameLogicCtrl:initPlayersUI(self)
    self:onClean()

    self.lastUpdateCount = 0
    self:updatePhoneState()

    self:onShowRoomInfo()

    self:playPkBackMusic()
end

function RoomLayer:playPkBackMusic()
    local filename = "putong/pk/PublicSound/"
    local n = tostring(math.random(1, 2) )
    filename = filename .. "bgm" .. n .. ".mp3"
    print(" RoomLayer:playPkBackMusic()")
    audioCtrl:playBackMusic(filename)
end

function RoomLayer:onfireTool(event)
    local CMDJ_GF_S_UserItem = event.data
    if CMDJ_GF_S_UserItem == nil then return end
    self:playerTools(CMDJ_GF_S_UserItem)
end

function RoomLayer:playerTools(CMDJ_GF_S_UserItem)

    if CMDJ_GF_S_UserItem == nil then return end

--[[
// 使用道具
struct CMDJ_GF_S_UserItem
{
	word							wItemIndex;							//道具索引
	byte							cbSendUserChair;					//发送用户
	byte							cbTargetChair;						//目标用户
};
]]

    -- 这里只发送协议

    local toolsrc = {
        [1] = "res_502/Prop/Prop_slipper.csb",
        [2] = "res_502/Prop/Prop_flower.csb",
        [3] = "res_502/Prop/Prop_egg.csb",
    }

    local localsrcchair = GameLogicCtrl:getLocalPlayerIdx(CMDJ_GF_S_UserItem.cbSendUserChair)
    local localdestchair = GameLogicCtrl:getLocalPlayerIdx(CMDJ_GF_S_UserItem.cbTargetChair)

    local srcpos
    local destpos

    local shownode = nil
    if localsrcchair == 1 then 
        shownode = self["leftbottomPanel"]["Node_Emotion"]
    elseif localsrcchair == 2 then 
        shownode = self["rightPanel"]["Node_Emotion"]
    elseif localsrcchair == 3 then 
        shownode = self["topPanel"]["Node_Emotion"]
    elseif localsrcchair == 4 then 
        shownode = self["leftPanel"]["Node_Emotion"]
    end

    if shownode == nil then return end 
    srcpos = shownode:convertToWorldSpace(cc.p(0,0))

    shownode = nil
    if localdestchair == 1 then 
        shownode = self["leftbottomPanel"]["Node_Emotion"]
    elseif localdestchair == 2 then 
        shownode = self["rightPanel"]["Node_Emotion"]
    elseif localdestchair == 3 then 
        shownode = self["topPanel"]["Node_Emotion"]
    elseif localdestchair == 4 then 
        shownode = self["leftPanel"]["Node_Emotion"]
    end
    if shownode == nil then return end 
    destpos = shownode:convertToWorldSpace(cc.p(0,0))

    local movesp = {
        [1] = "res_502/Prop/animation_tuoxie.png",
        [2] = "res_502/Prop/animation_yishuhua.png",
        [3] = "res_502/Prop/animation_jidan.png",
    }

    local img = cocosMake.newSprite(movesp[CMDJ_GF_S_UserItem.wItemIndex])
    self:addChild(img)--添加显示内容k
    img:setPosition(srcpos)

    local function movefinish()
        if CMDJ_GF_S_UserItem.wItemIndex == 1 then 
            audioCtrl:playprop_shoesSound()
        elseif CMDJ_GF_S_UserItem.wItemIndex == 2 then 
            audioCtrl:playprop_flowerSound()
        elseif CMDJ_GF_S_UserItem.wItemIndex == 3 then 
            audioCtrl:playprop_eggSound()
        end
        
        img:getParent():removeChild(img, true)

        local csdfile = toolsrc[CMDJ_GF_S_UserItem.wItemIndex]

        local node = cc.CSLoader:createNode(csdfile)
        if node == nil then return end 

        shownode:addChild(node)

        local action = cc.CSLoader:createTimeline(csdfile)
        if action == nil then return end 
        action:play("animation_prop", false)-- 设置播放属性 最后一个参数  true  循环 播放动画 
        --shownode:runAction(action)-- 执行动画  

        local function removeThis()
            node:getParent():removeChild(node, true)
        end

        node:runAction(action)

        -- 最后一帧动画 事件 这里得到的是所有的动画帧的事件
        local function onFrameEvent(frame)
            if nil == frame then
                return
            end

            -- 获取 动画事件名称
            local str = frame:getEvent()

            -- 按事件名称 分开处理 
            if str == "Play_Over" then
                -- 这里开始更新资源
                node:getParent():removeChild(node, true)
            end
        end
        action:setFrameEventCallFunc(onFrameEvent)
    end

    img:runAction( cc.Sequence:create( cc.MoveTo:create(1.2, destpos) , cc.CallFunc:create(movefinish)) )    
end

function RoomLayer:showDisMissFrame(param)
	local l = self:showFloat(loadlua.DismissRoomlayer, {
		closeCallback = function()
			self:closeFloat(loadlua.DismissRoomlayer)
		end,
	modal=true, offClose=true, data=param or nil})  
end

function RoomLayer:onRoomUpdate()
    self.lastUpdateCount = self.lastUpdateCount or 0 + 1
    
    if self.startGame then 
        self.gameTimeSecond = self.gameTimeSecond + 1
        local ctrl = self["Panel_PhoneState"]["Text_Time"]
        local d,h,m,s = pubFun.GetDetailTime(self.gameTimeSecond)
        local timestr = string.format("%02d:%02d", m, s)
        ctrl:setString(timestr)
    end

    -- 更新电池 wifi 等
    if self.lastUpdateCount > 3 then
        self.lastUpdateCount = 0
        self:updatePhoneState()
    end
end

function RoomLayer:chatBtnClick(event)
	local l = self:showFloat(loadlua.CharLayer, {
		closeCallback = function()
			self:closeFloat(loadlua.CharLayer)
		end,
	modal=true, offClose=true})       
end

function RoomLayer:menuSetBtnClick(event)
	local l = self:showFloat(loadlua.Settinglayer, {
		closeCallback = function()
			self:closeFloat(loadlua.Settinglayer)
		end,
	modal=true, offClose=true})     
end

function RoomLayer:updatePhoneState(args)
    if TARGET_PLATFORM == cc.PLATFORM_OS_WINDOWS then return end 

    if sdkHelper then 
        -- 得到当前系统时间
        sdkHelper:getsystemdate( function(resultJson) 
            if not resultJson or type(resultJson) ~= "string" or resultJson == "" then

            else
                local result = json.decode(resultJson, 1)
                if result.ok == true then 

--[[
	        resultJson.put("ok", true);
	        resultJson.put("year", __year);
	        resultJson.put("month", __month);
	        resultJson.put("date", __date);
	        resultJson.put("hour", __hour);
	        resultJson.put("minute", __minute);
	        resultJson.put("second",__second);
]]
                    local timestr = result.hour .. ":" .. result.minute
                    self["Panel_PhoneState"]["Text_Time"]:setString(timestr)
                end 
            end            
        end)

        -- 得到电池电量
        sdkHelper:getbattery( function(resultJson) 
            if not resultJson or type(resultJson) ~= "string" or resultJson == "" then

            else
                local result = json.decode(resultJson, 1)
                if result.ok == true then 

--[[
	        resultJson.put("ok", true);
	        resultJson.put("level", __level);
	        resultJson.put("scale", __scale);
        				//把它转成百分比
				//tv.setText("电池电量为"+((level*100)/scale)+"%");
]]

                    local v = math.ceil((result.level * 100) / result.scale)
                    local idx = math.floor(vv / (100 / 6))
                    if idx > 5 then 
                        idx = 5
                    end
                    self["Panel_PhoneState"]["Img_Battery"]:loadTexture("res_502/PhoneState/Battery_" .. idx .. "png" )
                end
            end            
        end)

        -- 得到WIF信号强度
        sdkHelper:getwifi( function(resultJson) 
            if not resultJson or type(resultJson) ~= "string" or resultJson == "" then

            else
                local result = json.decode(resultJson, 1)
                if result.ok == true then 

--[[
	        resultJson.put("ok", true);
	        resultJson.put("bssid", __bssid);
	        resultJson.put("ssid", __ssid);
	        
	        String ipadd = ((__ipaddress & 0xFF) + "." + ((__ipaddress >>>= 8) & 0xFF) + "." + ((__ipaddress >>>= 8) & 0xFF) + "." + ((__ipaddress >>>= 8) & 0xFF));
	        
	        resultJson.put("ipaddress", ipadd);
	        resultJson.put("mac", __mac);
	        resultJson.put("netid", __netid);
	        resultJson.put("linkspeed",__linkspeed);
	        resultJson.put("level", __level); ==> wifiinfo.getRssi()

这里得到信号强度就靠wifiinfo.getRssi()；这个方法。得到的值是一个0到-100的区间值，是一个int型数据，
其中0到-50表示信号最好，-50到-70表示信号偏差，小于-70表示最差，有可能连接不上或者掉线，一般Wifi已断则值为-200。

]]
                    if result.level == 0 then 
                        self["Panel_PhoneState"]["Img_Wifi"]:loadTexture("res_502/PhoneState/wifi_4.png" )
                    elseif result.level < 0 and result.level >= -50 then 
                        self["Panel_PhoneState"]["Img_Wifi"]:loadTexture("res_502/PhoneState/wifi_3.png" )
                    elseif result.level < -50 and result.level >= -70 then 
                        self["Panel_PhoneState"]["Img_Wifi"]:loadTexture("res_502/PhoneState/wifi_2.png" )
                    elseif result.level < -70 and result.level >= -100 then 
                        self["Panel_PhoneState"]["Img_Wifi"]:loadTexture("res_502/PhoneState/wifi_1.png" )
                    else
                        self["Panel_PhoneState"]["Img_Wifi"]:loadTexture("res_502/PhoneState/wifi_0.png" )
                    end

                end 
            end            
        end)

        -- 得到手机信号强度
        sdkHelper:getphonenet( function(resultJson) 
            if not resultJson or type(resultJson) ~= "string" or resultJson == "" then

            else
                local result = json.decode(resultJson, 1)
                if result.ok == true then 

--[[
	        resultJson.put("ok", true);
	        resultJson.put("nettype", __nettype);
	        resultJson.put("lastdbm", __lastdbm);
]]      

                    if result.nettype == "wifi" then 
                        self["Panel_PhoneState"]["Img_Wifi"]:setVisible(true)
                        self["Panel_PhoneState"]["Img_Data"]:setVisible(false)
                    else
                        self["Panel_PhoneState"]["Img_Wifi"]:setVisible(false)
                        self["Panel_PhoneState"]["Img_Data"]:setVisible(true)                        

                        if result.lastdbm >= - 91 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_5.png" )
                        elseif result.lastdbm < - 91 and result.lastdbm >= -101 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_4.png" )
                        elseif result.lastdbm < - 101 and result.lastdbm >= -103 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_3.png" )
                        elseif result.lastdbm < - 103 and result.lastdbm >= -107 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_2.png" )
                        elseif result.lastdbm < - 107 and result.lastdbm >= -113 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_1.png" )
                        elseif result.lastdbm < -113 then
                            self["Panel_PhoneState"]["Img_Data"]:loadTexture("res_502/PhoneState/data_0.png" )
                        end 
                    end
                end 
            end            
        end)
    end
end

function RoomLayer:onChatInfo(data)
--[[

//用户语音聊天
struct CMD_GR_C_TableTalk
{
	enum TALK_TYPE
	{
		TYPE_FILE,        //语音
		TYPE_WORD,
		TYPE_DEFINE,		//系统语音
		TYPE_BIAOQING,
	};
	CMD_GR_C_TableTalk()
	{
		cbType = 0;
		strTalkSize = 0;
	}
	byte							cbType;								//类型
	byte							cbChairID;							//座位
	char							strString[128];						//自定义
	int								strTalkSize;
	char							strTalkData[20000];					//自定义
};
]]
    local chatdata = event.data
    if chatdata == nil then return end

    if chatdata.cbType == TYPE_FILE then 
        -- 语音
        local gameOptInfo = UserManager:getUserData():getGameOptInfo()
        if gameOptInfo == nil then return end

        if gameOptInfo.NoSound == 1 then return end 

    elseif chatdata.cbType == TYPE_WORD then 
        -- 发送的文字
        self:playerTxt(chatdata)
    elseif chatdata.cbType == TYPE_DEFINE then 
        -- 发送系统语音
        self:playSysSound(chatdata)
    elseif chatdata.cbType == TYPE_BIAOQING then 
        -- 发送的表情
        self:playerPiaoQing(chatdata.strString, chatdata.cbChairID)
    end

end

function RoomLayer:playSysSound(chatdata)
    if chatdata == nil then return end 

    local gameOptInfo = UserManager:getUserData():getGameOptInfo()
    if gameOptInfo == nil then return end

    if gameOptInfo.NoSound == 1 then return end 

    -- 1 普通话，  2  方言
    local SoundType = gameOptInfo.SoundType

    local localplayeridx = GameLogicCtrl:getLocalPlayerIdx(chatdata.cbChairID)
    localplayeridx = localplayeridx + 1
    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    local useritem = userinfo[localplayeridx]

    local sexpath = ""
    if useritem.cbGender <= 1 then
        sexpath = "man/"
    else
        sexpath = "woman/"
    end

    local soundpath = ""
    local cardsound = chatdata.strString .. ".mp3"

    if SoundType == 1 then 
        soundpath = "res/sound/putong/pk/putonghua/" .. sexpath .. cardsound
    elseif SoundType == 2 then 
        soundpath = "res/gamesres/491/res_502/sound/fangyan/" .. sexpath .. cardsound
    end

    audioCtrl:playEff(soundpath)
end

function RoomLayer:onDisMissRoom(event)
    local states = event.data
    if states == nil then return end 

    if states == RoomDisMissState.DisMiss_Check_Open then

    elseif states == RoomDisMissState.DisMiss_Check_Ok then
--        if not self.isOpenDisMissFrame then
--            self.isOpenDisMissFrame = true
--            self:showDisMissFrame()        -- 显示出解散窗体        
--        end 

        GameLogicCtrl:DisMissRoolMsg(1) -- 发送解散协议

    elseif states == RoomDisMissState.DisMiss_Check_Cancel then
        
    end

end

function RoomLayer:onDisMissInfo(event)
    local CMD_GF_Private_Dismiss_Info = event.data
    if CMD_GF_Private_Dismiss_Info == nil then return end 
        
    if self.isOpenDisMissFrame then return end

    self.isOpenDisMissFrame = true

    self:showDisMissFrame(CMD_GF_Private_Dismiss_Info)
    
end

function RoomLayer:tishi_btnClick()
    GameLogicCtrl:Hint()
end

function RoomLayer:chupai_guestbtnClick()
    local group = GameLogicCtrl:getOutputCard()
    if not group then
        return
    end

    GameLogicCtrl:sendOutCard()
end

function RoomLayer:onStateModify(event)
    -- 
    if not gameManager:getpubInfo():getInRoom() then return end 

    local data = event.data
    if data == nil then return end

    if data == StateModifyType.Ready_State then 
        -- 修改准备状态
        local ctrl = nil

        ctrl = self["bottomPanel"]["player1_readyIcon"]
        if ctrl ~= nil then
            ctrl:setVisible(false)
        end
        ctrl = self["rightPanel"]["player2_readyIcon"]
        if ctrl ~= nil then
            ctrl:setVisible(false)
        end
        ctrl = self["topPanel"]["player3_readyIcon"]
        if ctrl ~= nil then
            ctrl:setVisible(false)
        end
        ctrl = self["leftPanel"]["player4_readyIcon"]
        if ctrl ~= nil then 
            ctrl:setVisible(false)
        end

        local userinfo = gameManager:getpubInfo():getUserInfo()
        if userinfo == nil then return end
--[[
--//用户状态
US_NULL					=	0x00			--					//没有状态
US_FREE					=	0x01			--					//站立状态
US_SIT					=	0x02			--					//坐下状态
US_READY				=   0x03			--				//同意状态
US_LOOKON				=   0x04			--				//旁观状态
US_PLAYING				=	0x05			--					//游戏状态
US_OFFLINE				=	0x06			--					//断线状态
]]

        for i, item in pairs(userinfo) do
            local localcharidx = GameLogicCtrl:getLocalPlayerIdx(item.wChairID)
            localcharidx = localcharidx + 1
            local ctrl = nil
            if item.cbUserStatus == US_READY then
                if localcharidx == 1 then 
                    ctrl = self["bottomPanel"]["player1_readyIcon"]
                elseif localcharidx == 2 then 
                    ctrl = self["rightPanel"]["player2_readyIcon"]--:setVisible(true)
                elseif localcharidx == 3 then 
                    ctrl = self["topPanel"]["player3_readyIcon"]--:setVisible(true)
                elseif localcharidx == 4 then 
                    ctrl = self["leftPanel"]["player4_readyIcon"]--:setVisible(true)
                end
                if ctrl ~= nil then
                    ctrl:setVisible(true)
                end
            end
        end
    end

end

function RoomLayer:onOtherInfoRet(event)
    if not gameManager:getpubInfo():getInRoom() then return end 

    local TAG_UserIndividual = event.data
    if TAG_UserIndividual ~= nil then 
        gameManager:getpubInfo():modifyOtherInfo(TAG_UserIndividual)
    end

    -- 读取大厅 信息 
    local TAG_UserIndividual = UserManager:getUserInfo():getUserIndividual()
    if TAG_UserIndividual == nil then return end 
    local ctrl = nil

--    ctrl = self["leftbottomPanel"]["player1_headPanel"]["name"]
--    if ctrl ~= nil then
--        ctrl:setString("")
--    end
--    ctrl = self["rightPanel"]["player2_headPanel"]["name"]
--    if ctrl ~= nil then
--        ctrl:setString("")
--    end
--    ctrl = self["topPanel"]["player3_headPanel"]["name"]
--    if ctrl ~= nil then
--        ctrl:setString("")
--    end
--    ctrl = self["leftPanel"]["player4_headPanel"]["name"]
--    if ctrl ~= nil then
--        ctrl:setString("")
--    end

    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end


    for i, item in pairs(userinfo) do
        local localcharidx = GameLogicCtrl:getLocalPlayerIdx(item.wChairID)
        localcharidx = localcharidx + 1
        local ctrl = nil
        if localcharidx == 1 then 
            ctrl = self["leftbottomPanel"]["player1_headPanel"]["name"]--:setString(item.szNickName)
        elseif localcharidx == 2 then 
            ctrl = self["rightPanel"]["player2_headPanel"]["name"]--:setString(item.szNickName)
        elseif localcharidx == 3 then 
            ctrl = self["topPanel"]["player3_headPanel"]["name"]--:setString(item.szNickName)
        elseif localcharidx == 4 then 
            ctrl = self["leftPanel"]["player4_headPanel"]["name"]--:setString(item.szNickName)
        end
        if ctrl ~= nil then
            ctrl:setString(item.szNickName)
        end
    end

    -- 显示头像
    self:setuserheadimg(userinfo, 1)
    self:setuserheadimg(userinfo, 2)
    self:setuserheadimg(userinfo, 3)
    self:setuserheadimg(userinfo, 4)

end

function RoomLayer:setuserheadimg(userinfo, idx)
    if #userinfo >= idx then
        local item = userinfo[idx]

        if item ~= nil then 
            local localcharidx = GameLogicCtrl:getLocalPlayerIdx(idx)
            localcharidx = localcharidx + 1

            local Individualitem = UserManager:getUserInfo():getUserIndividualByUserId(item.dwUserID)

            if Individualitem ~= nil then 

                if TARGET_PLATFORM ~= cc.PLATFORM_OS_WINDOWS then
	                ImageCacheCtrl:getImage(Individualitem.kHttp, function(fileName)

		                -- 如果fileName存在，则使用该图片
		                if cc.FileUtils:getInstance():isFileExist(fileName) then
                            local ctrl = nil
                            if localcharidx == 1 then 
                                ctrl = self["leftbottomPanel"]["player1_headPanel"]["headImage"]--:loadTexture(fileName)
                            elseif localcharidx == 2 then 
                                ctrl = self["rightPanel"]["player2_headPanel"]["headImage"]--:loadTexture(fileName)
                            elseif localcharidx == 3 then 
                                ctrl = self["topPanel"]["player3_headPanel"]["headImage"]--:loadTexture(fileName)
                            elseif localcharidx == 4 then 
                                ctrl = self["leftPanel"]["player4_headPanel"]["headImage"]--:loadTexture(fileName)
                            end
                            if ctrl ~= nil then
                                ctrl:loadTexture(fileName)
                            end
		                end
	                end)
                end
            end

        end

    end
end

-- 更新房间信息
function RoomLayer:onShowRoomInfo()
    if self.roomID == nil then return end

    local privateinfo = gameManager:getpubInfo():getPrivateRoomInfo()
    if privateinfo == nil or privateinfo.dwRoomNum == nil then return end 
    self["lefttopPanel"]["roomID"]:setString(tostring(privateinfo.dwRoomNum))

--    local userInfo = gameManager:getpubInfo():getUserInfo()
--    local myInfo = gameManager:getpubInfo():getmeitem()
--    if not myInfo then
--        return
--    end
--    for i, item in pairs(userInfo) do
--        local ChairIdx = gameManager:getpubInfo():Chair2Idx( item.wChairID )
--        local nameLable = { self.leftbottomPanel.player1_headPanel.name, self.rightPanel.player2_headPanel.name,
--            self.topPanel.player3_headPanel.name, self.leftPanel.player4_headPanel.name }
--        if ChairIdx > 0 and ChairIdx < 5 then
--            nameLable[ChairIdx]:setString( item.dwUserID )
--        end
--    end

end

function RoomLayer:onShowCard()
end

function RoomLayer:onPlayerOutCard(event)
    -- 玩家出牌
    local outdata = event.data
    if outdata == nil then return end
    GameLogicCtrl:addOutCardData(outdata)

    -- 特效
    self:showOutCardEff(outdata)
    self.lastoutCardInfo = outdata -- 保存最后一次出牌信息

--    -- 播放声音
--    self:playCardSound(outdata)

--    local soundpath = "putong/pk/PublicSound/Snd_OutCard.mp3"
--    audioCtrl:playEff(soundpath)
end

function RoomLayer:showOutCardEff(outdata)
--[[
    PDK_CMD_S_OutCard.wCurrentUser = 0--						//下个将要出牌的用户
    PDK_CMD_S_OutCard.wOutCardUser = 0--						//当前出牌的用户
    PDK_CMD_S_OutCard.cbCardType = 0
    PDK_CMD_S_OutCard.cbOutCardList = {}
]]    
    -- 这里要转换一次显示的编号，因为编号为1 的都是自己的位置
    local localplayeridx = GameLogicCtrl:getLocalPlayerIdx(outdata.wOutCardUser)
    localplayeridx = localplayeridx + 1

    local players = GameLogicCtrl:getPlayers() 
    if players == nil then return end 

    local player = players[localplayeridx]

    if outdata == nil then return end
    if player == nil then return end
--    local meitem = gameManager:getpubInfo():getmeitem()
--    if meitem == nil then return end 

--    local meid = meitem.dwUserID

    -- 如果最后一次出牌与当前出牌的是同一个人那么就没有特效
    if self.lastoutCardInfo ~= nil and self.lastoutCardInfo.wOutCardUser == outdata.wOutCardUser then
        return
    end

    if not player:CheckIsBomb(outdata.cbOutCardList) then 
        self:PlayNormalSound(outdata)
        return 
    end

    local count = player:getBombCount(outdata.cbOutCardList)

    local actiontable = nil---GameAction.csb.animation_missile

    if count == 6 then 
        actiontable = GameAction.csb.animation0_bombmiddle
    else
        if count >= 4 and count <= 5 then 
            actiontable = GameAction.csb.animation_bombsmall
        elseif count >= 7 then
            actiontable = GameAction.csb.animation_missile
        end
    end
   
    local EffItem = {}
    EffItem.frmUserID = outdata.wOutCardUser
    EffItem.toUserID = self.lastoutCardInfo.wOutCardUser

    self:onOutCardEff(EffItem, actiontable)
end

function RoomLayer:PlayNormalSound(outdata)
    if outdata == nil then return end
    
    local gameOptInfo = UserManager:getUserData():getGameOptInfo()
    if gameOptInfo == nil then return end

    -- 1 普通话，  2  方言
    local SoundType = gameOptInfo.SoundType

    local localplayeridx = GameLogicCtrl:getLocalPlayerIdx(outdata.wOutCardUser)
    localplayeridx = localplayeridx + 1
    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

    local useritem = userinfo[localplayeridx]

    local sexpath = ""
    if useritem.cbGender <= 1 then
        sexpath = "man/"
    else
        sexpath = "woman/"
    end

    local soundpath = ""

    --if SoundType == 1 then 
        local n = tostring(math.random(1, 3) )
        cardsound = "dani" .. n .. ".mp3"
--    else    
--        cardsound = "peng1.mp3"
--    end

    --if SoundType == 1 then 
        soundpath = "res/sound/putong/pk/putonghua/" .. sexpath .. cardsound
    --elseif SoundType == 2 then 
    --    soundpath = "res/gamesres/491/res_491/sound/fangyan/" .. sexpath .. cardsound
    --end

    audioCtrl:playEff(soundpath)
end

function RoomLayer:onOutCardEff(EffItem, actiontable)

    if EffItem == nil then return end

    --local actiontable = GameAction.csb.animation_missile

    if actiontable == nil then return end
    if #actiontable < 2 then return end 

    local frmchairid = GameLogicCtrl:getLocalPlayerIdx(EffItem.frmUserID) + 1
    local tochairid = GameLogicCtrl:getLocalPlayerIdx(EffItem.toUserID) + 1

    -- 判断一次是炸自己 还是其它人
    local shownode = nil
    if tochairid == 1 then 
        shownode = self["leftbottomPanel"]["Node_CardAnimation"]
    elseif tochairid == 2 then 
        shownode = self["rightPanel"]["Node_CardAnimation"]
    elseif tochairid == 3 then 
        shownode = self["topPanel"]["Node_CardAnimation"]
    elseif tochairid == 4 then 
        shownode = self["leftPanel"]["Node_CardAnimation"]
    end

    if shownode == nil then return end 

    local csdfile = actiontable[1]

    local node = cc.CSLoader:createNode(csdfile)
    if node == nil then return end 

    shownode:addChild(node)

    local action = cc.CSLoader:createTimeline(csdfile)
    if action == nil then return end 
    action:play(actiontable[2], false)-- 设置播放属性 最后一个参数  true  循环 播放动画 

    node:runAction(action)

    -- 最后一帧动画 事件 这里得到的是所有的动画帧的事件
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end

        -- 获取 动画事件名称
        local str = frame:getEvent()

        -- 按事件名称 分开处理 
        if str == "Play_Over" then
            -- 这里开始更新资源
            node:getParent():removeChild(node, true)
        end
    end
    action:setFrameEventCallFunc(onFrameEvent) 
    
    -- 播放声音
    self:playOperateSound(actiontable[3])   
end

function RoomLayer:playOperateSound(sound)
    if sound == "" then return end 
    local soundpath = "res/sound/putong/pk/PublicSound/" .. sound
    audioCtrl:playEff(soundpath)
end

function GameLogicCtrl:playCardSound(outdata)
--[[
//出牌命令
struct CMD_S_OutCard
{
	WORD							wOutCardUser;						//出牌用户
	BYTE							cbOutCardData;						//出牌扑克
};
]]

--    if outdata == nil then return end 

--    local gameOptInfo = UserManager:getUserData():getGameOptInfo()
--    if gameOptInfo == nil then return end

--    -- 1 普通话，  2  方言
--    local SoundType = gameOptInfo.SoundType

--    local localplayeridx = self:getLocalPlayerIdx(outdata.wOutCardUser)
--    localplayeridx = localplayeridx + 1
--    local userinfo = gameManager:getpubInfo():getUserInfo()
--    if userinfo == nil then return end

--    local useritem = userinfo[localplayeridx]

--    local sexpath = ""
--    if useritem.cbGender <= 1 then
--        sexpath = "man/"
--    else
--        sexpath = "woman/"
--    end

--    local soundpath = ""

--    local value = outdata.cbOutCardData

--	local cardvalue = bit._and(value, 0x0F)
--	local cardtype = bit._rshift(bit._and(value, 0xF0), 4)

--    -- 麻将值  0 同子  1 万子 2 条子 3 字牌
--    -- type 1 万 2 同 3 条  4  1-4 东南西北  5-7 中发白
--    local cardsound = ""

--    if cardtype == 0 then 
--        cardsound = "mjt2" .. "_" .. cardvalue .. ".mp3"
--    elseif cardtype == 1 then
--        cardsound = "mjt1" .. "_" .. cardvalue .. ".mp3"
--    elseif cardtype == 2 then
--        cardsound = "mjt3" .. "_" .. cardvalue .. ".mp3"
--    elseif cardtype == 3 then
--        cardsound = "mjt4" .. "_" .. cardvalue .. ".mp3"
--    end

--    if SoundType == 1 then 
--        soundpath = "res/sound/putong/mj/" .. sexpath .. cardsound
--    elseif SoundType == 2 then 
--        soundpath = "res/gamesres/491/res_491/sound/fangyan/" .. sexpath .. cardsound
--    end

--    audioCtrl:playEff(soundpath)
end

function RoomLayer:onPlayerSendCard(event)
    -- 发牌
    local outdata = event.data
    if outdata == nil then return end
    GameLogicCtrl:addCardData(outdata)    
end

function RoomLayer:onOperate(event)
    local operdata = event.data
    if operdata == nil then return end
    -- 吃 碰 杠 胡 操作
    GameLogicCtrl:operateCard(operdata)    
end

function RoomLayer:onClean()

    -- 最后一次出牌信息
    self.lastoutCardInfo = {}

    self["topPanel"]["Img_pass"]:setVisible(false)
    self["rightPanel"]["Img_pass"]:setVisible(false)
    self["leftPanel"]["Img_pass"]:setVisible(false)
    self["bottomPanel"]["Img_pass"]:setVisible(false)

    self["bottomPanel"]["Img_nobig"]:setVisible(false)

    self.clock:setVisible(false)
    self.player4_readyIcon:setVisible(false)
    self.player3_readyIcon:setVisible(false)
    self.player2_readyIcon:setVisible(false)
    self.player1_readyIcon:setVisible(false)
    self.Btn_chupai:setVisible(false)
    self.Btn_tishi:setVisible(false)
    self.inviteBtn:setVisible(false)
    self.leftbottomPanel.Img_cardnum:setVisible(false)
end

function RoomLayer:onClose()
    if self.showTextEventHandler then
        self:removeEventListener(self.showTextEventHandler)
        self.showTextEventHandler = nil
    end
end

return RoomLayer