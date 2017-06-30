-------------------------------------------------
-- 状态信息
-------------------------------------------------

local gameMainSystem = class("gameMainSystem", HotRequire(luafile.CtrlBase))


function gameMainSystem:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainSystem:init()

end


--		//系统消息
function gameMainSystem:OnSocketMainSystem(wMainCmdID, wSubCmdID, packet)
    if wSubCmdID == SUB_CM_SYSTEM_MESSAGE then 
        self:OnSocketSubSystemMessage(wMainCmdID, wSubCmdID, packet)
    end
end

--		//系统消息
function gameMainSystem:OnSocketSubSystemMessage(wMainCmdID, wSubCmdID, packet)
--[[
//系统消息
struct CMD_CM_SystemMessage
{
	word							wType;								//消息类型
	word							wLength;							//消息长度
	char							szString[1024];						//消息内容
};
]]

    local CMD_CM_SystemMessage = {}
    CMD_CM_SystemMessage.wType = 0 --								//消息类型
    CMD_CM_SystemMessage.wLength = 0 --							//消息长度
    CMD_CM_SystemMessage.szString = "" --[1024];						//消息内容

    local len, wType,wLength = string.unpack( packet, "HH")
    CMD_CM_SystemMessage.wType = wType --								//消息类型
    CMD_CM_SystemMessage.wLength = wLength --							//消息长度
    packet = string.sub( packet, len )

    CMD_CM_SystemMessage.szString, packet = pubFun.ReadString( packet, 1024 )
    TipView:showTip(CMD_CM_SystemMessage.szString, TipView.tipType.ERROR)
    GameServerNet:Disconnect()
--[[
	word wType = pSystemMessage->wType;

	//关闭处理
	if ((wType&(SMT_CLOSE_ROOM|SMT_CLOSE_LINK))!=0)
	{
		if (mIStringMessageSink)
		{
			mIStringMessageSink->InsertSystemString(pSystemMessage->szString);
		}
		OnGFGameClose(0);
	}

	//显示消息
	if (wType&SMT_CHAT) 
	{
		if (mIStringMessageSink)
		{
			mIStringMessageSink->InsertSystemString(pSystemMessage->szString);
		}
	}

	//关闭游戏
	if (wType&SMT_CLOSE_GAME)
	{
		if (mIStringMessageSink)
		{
			mIStringMessageSink->InsertSystemString(pSystemMessage->szString);
		}
		OnGFGameClose(0);
	}

	//弹出消息
	if (wType&SMT_EJECT)
	{
		if (mIStringMessageSink)
		{
			mIStringMessageSink->InsertPromptString(pSystemMessage->szString,0);
		}
	}

	//关闭房间
	if (wType&SMT_CLOSE_ROOM)
	{
		if (mIStringMessageSink)
		{
			mIStringMessageSink->InsertSystemString(pSystemMessage->szString);
		}
		OnGFGameClose(0);
	}
]]
end

return gameMainSystem
