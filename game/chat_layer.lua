-------------------------------------------------
-- 聊天
-------------------------------------------------

local ChatLayer = class("ChatLayer", cocosMake.DialogBase)

local this

--cocos studio生成的csb
ChatLayer.ui_resource_file = {GameResources.csb.ChatLayerUI}

ChatLayer.ui_binding_file = {
	Btn_Close    = {event = "click", method = "Btn_CloseClick"},

    Btn_Phrase = {
        name = "ChatLayerUI.Img_Box.Btn_Phrase",
        event = "click", 
        method = "Btn_PhraseClick"
    }, 

    Btn_Expression = {
        name = "ChatLayerUI.Img_Box.Btn_Expression",
        event = "click", 
        method = "Btn_ExpressionClick"
    }, 

	Img_Msg1 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg1",
		event = "click", 
		method = "Img_Msg1Click"
	},
	Img_Msg2 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg2",
		event = "click", 
		method = "Img_Msg2Click"
	},
	Img_Msg3 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg3",
		event = "click", 
		method = "Img_Msg3Click"
	},
	Img_Msg4 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg4",
		event = "click", 
		method = "Img_Msg4Click"
	},
	Img_Msg5 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg5",
		event = "click", 
		method = "Img_Msg5Click"
	},
	Img_Msg6 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg6",
		event = "click", 
		method = "Img_Msg6Click"
	},
	Img_Msg7 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg7",
		event = "click", 
		method = "Img_Msg7Click"
	},
	Img_Msg8 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg8",
		event = "click", 
		method = "Img_Msg8Click"
	},
	Img_Msg9 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg9",
		event = "click", 
		method = "Img_Msg9Click"
	},
	Img_Msg10 = {
		name = "ChatLayerUI.Img_Box.ScrollView_Phrase.Img_Msg10",
		event = "click", 
		method = "Img_Msg10Click"
	},

    Btn_Send = {
		name = "ChatLayerUI.Img_Box.Panel_Phrase.Panel_Input.Btn_Send",
		event = "click", 
		method = "Btn_SendClick"
    },

	Btn_EE1 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE1",
		event = "click", 
		method = "Btn_EE1Click"
	},
	Btn_EE2 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE2",
		event = "click", 
		method = "Btn_EE2Click"
	},
	Btn_EE3 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE3",
		event = "click", 
		method = "Btn_EE3Click"
	},
	Btn_EE4 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE4",
		event = "click", 
		method = "Btn_EE4Click"
	},
	Btn_EE5 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE5",
		event = "click", 
		method = "Btn_EE5Click"
	},
	Btn_EE6 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE6",
		event = "click", 
		method = "Btn_EE6Click"
	},
	Btn_EE7 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE7",
		event = "click", 
		method = "Btn_EE7Click"
	},
	Btn_EE8 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE8",
		event = "click", 
		method = "Btn_EE8Click"
	},
	Btn_EE9 = {
		name = "ChatLayerUI.Img_Box.Panel_Expression.Btn_EE9",
		event = "click", 
		method = "Btn_EE9Click"
	},

}

function ChatLayer:onCreate(param)
	this = self
	self.param = param

	-- 设置事件派发器
    --cc.load("event"):setEventDispatcher(self, GameController)

    self:init()
end

function ChatLayer:init( ... )
    self:Btn_PhraseClick()
end

function ChatLayer:Btn_PhraseClick(event)
    self.Panel_Phrase:setVisible(true)

    self.Panel_Expression:setVisible(false)    
--[[
   设置禁用
button.setBright(false);
button.setEnabled(false);
]]
    self.Btn_Phrase:setBright(true)
    self.Btn_Expression:setBright(false)
end

function ChatLayer:Btn_ExpressionClick(event)
    self.Panel_Phrase:setVisible(false)

    self.Panel_Expression:setVisible(true)    

    self.Img_Box.Btn_Phrase:setBright(false)
    self.Img_Box.Btn_Expression:setBright(true)
end

function ChatLayer:Btn_SendClick(event)
    local talkstr = self.TextField_1:getString()

    self:sendTalkString(talkstr)
end

function ChatLayer:Img_Msg1Click(event)
    self:sendTalkDefine(1)
end

function ChatLayer:Img_Msg2Click(event)
    self:sendTalkDefine(2)
end

function ChatLayer:Img_Msg3Click(event)
    self:sendTalkDefine(3)
end

function ChatLayer:Img_Msg4Click(event)
    self:sendTalkDefine(4)
end

function ChatLayer:Img_Msg5Click(event)
    self:sendTalkDefine(5)
end

function ChatLayer:Img_Msg6Click(event)
    self:sendTalkDefine(6)
end

function ChatLayer:Img_Msg7Click(event)
    self:sendTalkDefine(7)
end

function ChatLayer:Img_Msg8Click(event)
    self:sendTalkDefine(8)
end

function ChatLayer:Img_Msg9Click(event)
    self:sendTalkDefine(9)
end

function ChatLayer:Img_Msg10Click(event)
    self:sendTalkDefine(10)
end

function ChatLayer:sendTalkDefine(videopath)
    -- 发送系统语音
--[[
	CMD_GR_C_TableTalk kNetInfo;
	kNetInfo.cbChairID = iChair;
	kNetInfo.cbType = CMD_GR_C_TableTalk::TYPE_DEFINE;
	utility::StringToChar(strSoundPath,kNetInfo.strString,128);
	int iNetSize = sizeof(kNetInfo) - sizeof(kNetInfo.strTalkData);
	IServerItem::get()->SendSocketData(MDM_GF_FRAME,SUB_GR_TABLE_TALK,&kNetInfo,iNetSize);

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

    local CMD_GR_C_TableTalk = {}

    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil then return end 

    CMD_GR_C_TableTalk.cbType = TYPE_DEFINE
    CMD_GR_C_TableTalk.cbChairID = meitem.wChairID
    CMD_GR_C_TableTalk.strString = tostring(videopath)
    CMD_GR_C_TableTalk.strTalkSize = 0

    local s = string.pack( "bb", CMD_GR_C_TableTalk.cbType, CMD_GR_C_TableTalk.cbChairID  )
    s = s .. pubFun.FillString( CMD_GR_C_TableTalk.strString, 128 )

    GameLogicCtrl:sendcmd(MDM_GF_FRAME,SUB_GR_TABLE_TALK, s)
end

function ChatLayer:sendTalkString(talkstr)
    -- 发送输入的文字
    local CMD_GR_C_TableTalk = {}

    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil then return end 

    CMD_GR_C_TableTalk.cbType = TYPE_WORD
    CMD_GR_C_TableTalk.cbChairID = meitem.wChairID
    CMD_GR_C_TableTalk.strString = talkstr
    CMD_GR_C_TableTalk.strTalkSize = 0

    local s = string.pack( "bb", CMD_GR_C_TableTalk.cbType, CMD_GR_C_TableTalk.cbChairID  )
    s = s .. pubFun.FillString( CMD_GR_C_TableTalk.strString, 128 )

    GameLogicCtrl:sendcmd(MDM_GF_FRAME,SUB_GR_TABLE_TALK, s)
end

function ChatLayer:Btn_EE1Click(event)
    self:sendTalkBiaoQing(1)
end

function ChatLayer:Btn_EE2Click(event)
    self:sendTalkBiaoQing(2)
end

function ChatLayer:Btn_EE3Click(event)
    self:sendTalkBiaoQing(3)
end

function ChatLayer:Btn_EE4Click(event)
    self:sendTalkBiaoQing(4)
end

function ChatLayer:Btn_EE5Click(event)
    self:sendTalkBiaoQing(5)
end

function ChatLayer:Btn_EE6Click(event)
    self:sendTalkBiaoQing(6)
end

function ChatLayer:Btn_EE7Click(event)
    self:sendTalkBiaoQing(7)
end

function ChatLayer:Btn_EE8Click(event)
    self:sendTalkBiaoQing(8)
end

function ChatLayer:Btn_EE9Click(event)
    self:sendTalkBiaoQing(9)
end

function ChatLayer:sendTalkBiaoQing(idx)
    if strFilePath == "" then return end 
    -- 发送表情
    local CMD_GR_C_TableTalk = {}

    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil then return end 

    CMD_GR_C_TableTalk.cbType = TYPE_BIAOQING
    CMD_GR_C_TableTalk.cbChairID = meitem.wChairID
    CMD_GR_C_TableTalk.strString = tostring(idx)
    CMD_GR_C_TableTalk.strTalkSize = 0

    local s = string.pack( "bb", CMD_GR_C_TableTalk.cbType, CMD_GR_C_TableTalk.cbChairID  )
    s = s .. pubFun.FillString( CMD_GR_C_TableTalk.strString, 128 )

    GameLogicCtrl:sendcmd(MDM_GF_FRAME,SUB_GR_TABLE_TALK, s)
end


function ChatLayer:Btn_CloseClick(event)
	self.param.closeCallback()
	
end

return ChatLayer
