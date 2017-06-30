-------------------------------------------------
-- //框架消息--		//游戏消息
-------------------------------------------------

local gameMainGameFrame = class("gameMainGameFrame", HotRequire(luafile.CtrlBase))


function gameMainGameFrame:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainGameFrame:init()

end

--		//框架消息
function gameMainGameFrame:OnSocketMainGameFrame(wMainCmdID, wSubCmdID, packet)
--[[
	//游戏消息
	if (main==MDM_GF_GAME)
	{
		//效验状态
		ASSERT(mIClientKernelSink!=0);
		if (mIClientKernelSink==0) 
			return false;
		return mIClientKernelSink->OnEventGameMessage(sub,data,dataSize);
	}

	//内核处理
	if (main==MDM_GF_FRAME)
	{
		switch (sub)
		{
		case SUB_GF_USER_CHAT:			//用户聊天
			{
				return OnSocketSubUserChat(data,dataSize);
			}
		case SUB_GR_TABLE_TALK:			//用户聊天
			{
				return OnSocketSubUserTalk(data,dataSize);
			}
		case SUB_GF_USER_EXPRESSION:	//用户表情
			{
				return OnSocketSubExpression(data,dataSize);
			}
		case SUB_GF_GAME_STATUS:		//游戏状态
			{
				return OnSocketSubGameStatus(data,dataSize);
			}
		case SUB_GF_GAME_SCENE:			//游戏场景
			{
				return OnSocketSubGameScene(data,dataSize);
			}
		case SUB_GF_LOOKON_STATUS:		//旁观状态
			{
				return OnSocketSubLookonStatus(data,dataSize);
			}
		case SUB_GF_SYSTEM_MESSAGE:		//系统消息
			{
				return OnSocketSubSystemMessage(data,dataSize);
			}
		case SUB_GF_ACTION_MESSAGE:		//动作消息
			{
				return OnSocketSubActionMessage(data,dataSize);
			}
		case SUB_GF_USER_READY:			//用户准备
			{
				if(m_pMeUserItem ==0 || m_pMeUserItem->GetUserStatus()>=US_READY)
					return true;
				SendUserReady(0,0);
				if (mIClientKernelSink)
					mIClientKernelSink->OnGFMatchWaitTips(0);
				return true;
			}
		case SUB_GR_MATCH_INFO:				//比赛信息
			{
				if (!mIClientKernelSink)
					return true;

				return true;
			}
		case SUB_GR_MATCH_WAIT_TIP:			//等待提示
			{
				if (!mIClientKernelSink)
					return true;

				//设置参数
				if(dataSize==0)
				{
					mIClientKernelSink->OnGFMatchWaitTips(0);
				}

				return true;
			}
		case SUB_GR_MATCH_RESULT:			//比赛结果
			{
				//设置参数
				if (!mIClientKernelSink)
					return true;


				return true;
			}
		case SUB_GF_USE_ITEM:
			{
				// 使用道具
				CMDJ_GF_S_UserItem *recv = (CMDJ_GF_S_UserItem*)data;
				if(recv)
					mIClientKernelSink->OnEventUserUseTool(recv->wItemIndex, recv->cbSendUserChair, recv->cbTargetChair);
				return true;
			}
		}

		return true;
	}

]]

    if wMainCmdID == MDM_GF_GAME then 
        self:OnEventGameMessage(wMainCmdID, wSubCmdID, packet)
    elseif wMainCmdID == MDM_GF_FRAME then 
        self:otherDispose(wMainCmdID, wSubCmdID, packet)
    end

end

function gameMainGameFrame:OnEventGameMessage(wMainCmdID, wSubCmdID, packet)
    --  进入游戏后命令
    if wSubCmdID == SUB_S_GAME_START then
        self:OnSubGameStart(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_OUT_CARD then --//出牌命令 101
        self:OnSubOutCard(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_OUT_CARD_CSGANG then
        self:OnSubOutCardCSGang(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_SEND_CARD then-- 102//发送扑克
        self:OnSubSendCard(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_PASS_CARD then -- 103 过牌
        self:OnSubPass(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_OPERATE_NOTIFY then  --//操作提示104
        self:OnSubOperateNotify(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_GAME_END then -- 106 游戏结束
        self:OnSubGameEnd(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_TRUSTEE then -- 用户托管 107
        self:OnSubTrustee(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_CHI_HU then-- 107
        self:OnSubUserChiHu(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_GANG_SCORE then -- 110 
        self:OnSubGangScore(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_XIAO_HU then-- 112 小胡
        self:OnSubXiaoHu(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_MASTER_HANDCARD then
        --self:OnMasterHandCard(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_S_MASTER_LEFTCARD then -- 121 剩余牌堆
        self:OnMasterLeftCard(wMainCmdID, wSubCmdID, packet)
    end
end

function gameMainGameFrame:otherDispose(wMainCmdID, wSubCmdID, packet)

    if wSubCmdID == SUB_GF_USER_CHAT then 
        --			//用户聊天 10
        self:OnSocketSubUserChat(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID == SUB_GR_TABLE_TALK then --:			//用户聊天
        -- 12
        self:OnSocketSubUserTalk(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_USER_EXPRESSION then --:	//用户表情
        -- 11
        self:OnSocketSubExpression(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_GAME_STATUS then --:		
        -- 100 //游戏状态
        self:OnSocketSubGameStatus(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_GAME_SCENE then --:			//游戏场景
        -- 101
        self:OnSocketSubGameScene(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_LOOKON_STATUS then --:		//旁观状态
        -- 102
        self:OnSocketSubLookonStatus(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_SYSTEM_MESSAGE then --:		//系统消息
        -- 200
        self:OnSocketSubSystemMessage(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_ACTION_MESSAGE then --:		//动作消息
        -- 201
        self:OnSocketSubActionMessage(wMainCmdID, wSubCmdID, packet)

    elseif wSubCmdID ==SUB_GF_USER_READY then
        --:		2	//用户准备
        self:subGfUserReady(wMainCmdID, wSubCmdID, packet)
    elseif wSubCmdID ==SUB_GR_MATCH_INFO then 
        --:		403		//比赛信息
        self:subGrMatchInfo(wMainCmdID, wSubCmdID, packet)
    elseif wSubCmdID ==SUB_GR_MATCH_WAIT_TIP then
         --:	404		//等待提示
        self:subGrMatchWaitTip(wMainCmdID, wSubCmdID, packet)
    elseif wSubCmdID ==SUB_GR_MATCH_RESULT then 
        --:	405		//比赛结果
        self:subGrMatchResult(wMainCmdID, wSubCmdID, packet)
    elseif wSubCmdID ==SUB_GF_USE_ITEM then 
        --:13	 //使用道具
        self:subGfUseItem(wMainCmdID, wSubCmdID, packet)
    end
end


--			//用户聊天
function gameMainGameFrame:OnSocketSubUserChat(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

--:			//用户聊天
function gameMainGameFrame:OnSocketSubUserTalk(wMainCmdID, wSubCmdID, packet)
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

    local CMD_GR_C_TableTalk = {}

    CMD_GR_C_TableTalk.cbType = 0 --								//类型
    CMD_GR_C_TableTalk.cbChairID = 0 --							//座位

    CMD_GR_C_TableTalk.strString = "" --[128];						//自定义
    CMD_GR_C_TableTalk.strTalkSize = 0 --;
    CMD_GR_C_TableTalk.strTalkData = "" --[20000];					//自定义

    local len, cbType,cbChairID = string.unpack( packet, "bb")
    CMD_GR_C_TableTalk.cbType = cbType --								//类型
    CMD_GR_C_TableTalk.cbChairID = cbChairID --							//座位
    packet = string.sub( packet, len )

    CMD_GR_C_TableTalk.strString, packet = pubFun.ReadString( packet, 128 )
    local len, strTalkSize = string.unpack( packet, "i")  
    packet = string.sub( packet, len )
    CMD_GR_C_TableTalk.strTalkSize = strTalkSize

    if string.len(packet) > 0 then
        CMD_GR_C_TableTalk.strTalkData, packet = pubFun.ReadString( packet, 20000 )
    end

    self:dispatchEvent({name = updateUIEvent.CHAT_MSG, data = CMD_GR_C_TableTalk})

    -- TODO
end

--:	//用户表情
function gameMainGameFrame:OnSocketSubExpression(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

--:		//游戏状态
function gameMainGameFrame:OnSocketSubGameStatus(wMainCmdID, wSubCmdID, packet)
--[[
//游戏环境
struct CMD_GF_GameStatus
{
	byte							cbGameStatus;						//游戏状态
	byte							cbAllowLookon;						//旁观标志
};
]]

    local CMD_GF_GameStatus = {}

    CMD_GF_GameStatus.cbGameStatus = 0--						//游戏状态
    CMD_GF_GameStatus.cbAllowLookon = 0--						//旁观标志

    local len, cbGameStatus,cbAllowLookon  = string.unpack( packet, "bb")

    CMD_GF_GameStatus.cbGameStatus = cbGameStatus--						//游戏状态
    CMD_GF_GameStatus.cbAllowLookon = cbAllowLookon--						//旁观标志



    gameManager:getpubInfo():setGameStatus(CMD_GF_GameStatus.cbGameStatus)


end

--:			//游戏场景
function gameMainGameFrame:OnSocketSubGameScene(wMainCmdID, wSubCmdID, packet)
    local state = gameManager:getpubInfo():getGameStatus()


    if state == GS_MJ_FREE then 
--[[
//游戏状态
struct CMD_S_StatusFree
{
	LONGLONG							lCellScore;							//基础金币
	WORD							wBankerUser;						//庄家用户
	bool							bTrustee[GAME_PLAYER];				//是否托管

};
]]        
        local CMD_S_StatusFree = {}


        CMD_S_StatusFree.lCellScore = 0 --							//基础金币
        CMD_S_StatusFree.wBankerUser = 0-- 						//庄家用户
        CMD_S_StatusFree.bTrustee = "" --[GAME_PLAYER];				//是否托管
        
        local len, lCellScore,wBankerUser  = string.unpack( packet, "dH")
        packet = string.sub( packet, len )

        CMD_S_StatusFree.lCellScore = lCellScore --							//基础金币
        CMD_S_StatusFree.wBankerUser = wBankerUser-- 						//庄家用户

        CMD_S_StatusFree.bTrustee, packet = pubFun.ReadString( packet, GAME_PLAYER )

        --- 设置准备 TODO

    elseif state == GS_MJ_PLAY or state == GS_MJ_XIAOHU then 
--[[
//游戏状态
struct CMD_S_StatusPlay
{
	//游戏变量
	LONGLONG						lCellScore;									//单元积分
	WORD							wBankerUser;								//庄家用户
	WORD							wCurrentUser;								//当前用户

	//状态变量
	BYTE							cbActionCard;								//动作扑克
	DWORD							cbActionMask;								//动作掩码
	BYTE							cbLeftCardCount;							//剩余数目
	bool							bTrustee[GAME_PLAYER];						//是否托管
	WORD							wWinOrder[GAME_PLAYER];						//

	//出牌信息
	WORD							wOutCardUser;								//出牌用户
	BYTE							cbOutCardData;								//出牌扑克
	BYTE							cbDiscardCount[GAME_PLAYER];				//丢弃数目
	BYTE							cbDiscardCard[GAME_PLAYER][60];				//丢弃记录

	//扑克数据
	BYTE							cbCardCount;								//扑克数目
	BYTE							cbCardData[MAX_COUNT];						//扑克列表
	BYTE							cbSendCardData;								//发送扑克

	//组合扑克
	BYTE							cbWeaveCount[GAME_PLAYER];					//组合数目
	CMD_WeaveItem					WeaveItemArray[GAME_PLAYER][MAX_WEAVE];		//组合扑克

	BYTE							cbMagicIdx[2];								//宝牌信息
    dword		                    dwGameRuleIdex;		//游戏规则
};
]]
        local CMD_S_StatusPlay = {}

        CMD_S_StatusPlay.lCellScore = 0 --									//单元积分
        CMD_S_StatusPlay.wBankerUser = 0 --								//庄家用户
        CMD_S_StatusPlay.wCurrentUser = 0 --							//当前用户


        CMD_S_StatusPlay.cbActionCard = 0 --								//动作扑克
        CMD_S_StatusPlay.cbActionMask = 0 --								//动作掩码
        CMD_S_StatusPlay.cbLeftCardCount = 0 --							//剩余数目
        CMD_S_StatusPlay.bTrustee = {} --[GAME_PLAYER];						//是否托管
        CMD_S_StatusPlay.wWinOrder = {} --[GAME_PLAYER];						//


        CMD_S_StatusPlay.wOutCardUser = 0 --								//出牌用户
        CMD_S_StatusPlay.cbOutCardData = 0 --								//出牌扑克
        CMD_S_StatusPlay.cbDiscardCount = {} --[GAME_PLAYER];				//丢弃数目
        CMD_S_StatusPlay.cbDiscardCard = {} --[GAME_PLAYER][60];				//丢弃记录


        CMD_S_StatusPlay.cbCardCount = 0 --;								//扑克数目
        CMD_S_StatusPlay.cbCardData = {} --[MAX_COUNT];						//扑克列表
        CMD_S_StatusPlay.cbSendCardData = 0 --;								//发送扑克


        CMD_S_StatusPlay.cbWeaveCount = {} --[GAME_PLAYER];					//组合数目
        CMD_S_StatusPlay.WeaveItemArray = {} --[GAME_PLAYER][MAX_WEAVE];		//组合扑克

        CMD_S_StatusPlay.cbMagicIdx = {} --[2] = 0 --;								//宝牌信息
        CMD_S_StatusPlay.dwGameRuleIdex = 0 --;		//游戏规则
    

        local len, lCellScore,wBankerUser,wCurrentUser,cbActionCard,cbActionMask,cbLeftCardCount  = string.unpack( packet, "dHHbIb")
        packet = string.sub( packet, len )
        CMD_S_StatusPlay.lCellScore = lCellScore --									//单元积分
        CMD_S_StatusPlay.wBankerUser = wBankerUser --								//庄家用户
        CMD_S_StatusPlay.wCurrentUser = wCurrentUser --							//当前用户


        CMD_S_StatusPlay.cbActionCard = cbActionCard --								//动作扑克
        CMD_S_StatusPlay.cbActionMask = cbActionMask --								//动作掩码
        CMD_S_StatusPlay.cbLeftCardCount = cbLeftCardCount --							//剩余数目


        for i = 1, GAME_PLAYER, 1 do
            local len, b  = string.unpack( packet, "b")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.bTrustee, b)
        end


        for i = 1, GAME_PLAYER, 1 do
            local len, b  = string.unpack( packet, "H")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.wWinOrder, b)
        end

        local len, wOutCardUser,cbOutCardData  = string.unpack( packet, "Hb")
        packet = string.sub( packet, len )
        CMD_S_StatusPlay.wOutCardUser = wOutCardUser --								//出牌用户
        CMD_S_StatusPlay.cbOutCardData = cbOutCardData --								//出牌扑克


        for i = 1, GAME_PLAYER, 1 do
            local len, b  = string.unpack( packet, "b")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.cbDiscardCount, b)
        end


        for i = 1, GAME_PLAYER, 1 do
            
            local item = {}
            
            for j = 1, 60, 1 do
                local len, b  = string.unpack( packet, "b")
                packet = string.sub( packet, len )

                table.insert(item, b)
            end
            table.insert(CMD_S_StatusPlay.cbDiscardCard, item)

        end

        local len, cbCardCount  = string.unpack( packet, "b")
        packet = string.sub( packet, len )
        CMD_S_StatusPlay.cbCardCount = cbCardCount --;		//扑克数目

        for i = 1, MAX_COUNT, 1 do
            local len, b  = string.unpack( packet, "b")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.cbCardData, b)--			//扑克列表
        end


        local len, cbSendCardData  = string.unpack( packet, "b")
        packet = string.sub( packet, len )
        CMD_S_StatusPlay.cbCardCount = cbSendCardData --;		//发送扑克



        for i = 1, GAME_PLAYER, 1 do
            local len, b  = string.unpack( packet, "b")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.cbWeaveCount, b)--			//扑克列表
        end

--[[
//组合子项
struct CMD_WeaveItem
{
	DWORD							cbWeaveKind;						//组合类型
	BYTE							cbCenterCard;						//中心扑克
	BYTE							cbPublicCard;						//公开标志
	WORD							wProvideUser;						//供应用户
};
]]

        for i = 1, GAME_PLAYER, 1 do
            
            local item = {}
            
            for j = 1, MAX_WEAVE, 1 do
                local len, cbWeaveKind,cbCenterCard,cbPublicCard,wProvideUser  = string.unpack( packet, "IbbH")
                packet = string.sub( packet, len )

                table.insert(item, b)
            end
            table.insert(CMD_S_StatusPlay.WeaveItemArray, item) --//组合扑克

        end    
    

        for i = 1, 2, 1 do
            local len, b  = string.unpack( packet, "b")
            packet = string.sub( packet, len )

            table.insert(CMD_S_StatusPlay.cbMagicIdx, b)--			//宝牌信息
        end

        local len, dwGameRuleIdex  = string.unpack( packet, "I")
        packet = string.sub( packet, len )

        CMD_S_StatusPlay.dwGameRuleIdex = dwGameRuleIdex--//游戏规则

        -- TODO 显示麻将 牌

    end

end

--:		//旁观状态
function gameMainGameFrame:OnSocketSubLookonStatus(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

--:		//系统消息
function gameMainGameFrame:OnSocketSubSystemMessage(wMainCmdID, wSubCmdID, packet)
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

    CMD_CM_SystemMessage.wType = 0 --							//消息类型
    CMD_CM_SystemMessage.wLength = 0 --							//消息长度
    CMD_CM_SystemMessage.szString = "" --[1024];						//消息内容
    
    local len, wType, wLength = string.unpack( packet, "HH")
    packet = string.sub( packet, len )

    CMD_CM_SystemMessage.wType = wType --							//消息类型
    CMD_CM_SystemMessage.wLength = wLength --							//消息长度

    CMD_CM_SystemMessage.szString, packet = pubFun.ReadString( packet, 1024 )

    TipView:showTip(CMD_CM_SystemMessage.szString, TipView.tipType.ERROR)
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

--:		//动作消息
function gameMainGameFrame:OnSocketSubActionMessage(wMainCmdID, wSubCmdID, packet)
-- 没用
end



--:				//比赛信息
function gameMainGameFrame:subGrMatchInfo(wMainCmdID, wSubCmdID, packet)
    --没用
end
--:			//等待提示
function gameMainGameFrame:subGrMatchWaitTip(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--:			//比赛结果
function gameMainGameFrame:subGrMatchResult(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

--: 使用道具
function gameMainGameFrame:subGfUseItem(wMainCmdID, wSubCmdID, packet)
--[[

// 使用道具
struct CMDJ_GF_S_UserItem
{
	word							wItemIndex;							//道具索引
	byte							cbSendUserChair;					//发送用户
	byte							cbTargetChair;						//目标用户
};
]]
    local CMDJ_GF_S_UserItem = {}

    CMDJ_GF_S_UserItem.wItemIndex = 0--							//道具索引
    CMDJ_GF_S_UserItem.cbSendUserChair = 0--					//发送用户
    CMDJ_GF_S_UserItem.cbTargetChair = 0--						//目标用户

    
    local len, wItemIndex, cbSendUserChair,cbTargetChair = string.unpack( packet, "Hbb")
    --packet = string.sub( packet, len )

    CMDJ_GF_S_UserItem.wItemIndex = wItemIndex--							//道具索引
    CMDJ_GF_S_UserItem.cbSendUserChair = cbSendUserChair--					//发送用户
    CMDJ_GF_S_UserItem.cbTargetChair = cbTargetChair--						//目标用户

end

-----///////////////////////////////////////////////////////////////////////////////////
-- 进入游戏后通信
--------------------------------------------------------------------------------------
function gameMainGameFrame:OnSubGameStart(wMainCmdID, wSubCmdID, packet)
--//游戏开始
--struct PDK_CMD_S_GameStart
--{
--	WORD								wBankerUser;						//庄家用户
--	WORD				 				wCurrentUser;						//当前玩家
--	WORD								wChairID;
--	std::vector<BYTE>					cbHandCardList;
--}


    local packet, wBankerUser, wCurrentUser, wChairID = pubFun.Unpack( packet, "HHH" )
    local packet, size = pubFun.Unpack( packet, "I" )
    local cardList = {}
    local btCard
    for i = 1, size do
        packet, btCard = pubFun.Unpack( packet, "b" )
        table.insert( cardList, btCard )
    end
    local PDK_CMD_S_GameStart = {}
    PDK_CMD_S_GameStart.wBankerUser = wBankerUser
    PDK_CMD_S_GameStart.wCurrentUser = wCurrentUser
    PDK_CMD_S_GameStart.wChairID = wChairID
    PDK_CMD_S_GameStart.cbHandCardList = cardList
    GameLogicCtrl:onGameStart( PDK_CMD_S_GameStart )
    -- 发送事件显示牌
--    self:dispatchEvent({name = updateUIEvent.SHOW_CARDINFO})
end

function gameMainGameFrame:OnSubOutCard(wMainCmdID, wSubCmdID, packet)
    local PDK_CMD_S_OutCard = {}

    PDK_CMD_S_OutCard.wCurrentUser = 0--						//出牌用户
    PDK_CMD_S_OutCard.wOutCardUser = 0--						//出牌扑克
    PDK_CMD_S_OutCard.cbCardType = 0
    PDK_CMD_S_OutCard.cbOutCardList = {}
    local len = 0
    len, PDK_CMD_S_OutCard.wCurrentUser, PDK_CMD_S_OutCard.wOutCardUser, PDK_CMD_S_OutCard.cbCardType = string.unpack( packet, "HHb")
    packet = string.sub( packet, len )
    packet, PDK_CMD_S_OutCard.cbOutCardList = pubFun.UnpackVector( packet, "b" )

    self:dispatchEvent({name = updateUIEvent.OUT_CARDINFO, data = PDK_CMD_S_OutCard})
end
function gameMainGameFrame:OnSubOutCardCSGang(wMainCmdID, wSubCmdID, packet)
--[[
//出牌命令
struct CMD_S_OutCard_CSGang
{
	WORD							wOutCardUser;						//出牌用户
	BYTE							cbOutCardData1;						//出牌扑克
	BYTE							cbOutCardData2;						//出牌扑克
};
]]
    local CMD_S_OutCard_CSGang = {}

    CMD_S_OutCard_CSGang.wOutCardUser = 0 --					//出牌用户
    CMD_S_OutCard_CSGang.cbOutCardData1 = 0 --						//出牌扑克
    CMD_S_OutCard_CSGang.cbOutCardData2 = 0 --						//出牌扑克

    local len, wOutCardUser,cbOutCardData1,cbOutCardData2 = string.unpack( packet, "Hbb")
    packet = string.sub( packet, len )
    CMD_S_OutCard_CSGang.wOutCardUser = wOutCardUser --					//出牌用户
    CMD_S_OutCard_CSGang.cbOutCardData1 = cbOutCardData1 --						//出牌扑克
    CMD_S_OutCard_CSGang.cbOutCardData2 = cbOutCardData2 --						//出牌扑克
    
end

function gameMainGameFrame:OnSubSendCard(wMainCmdID, wSubCmdID, packet)
--[[
//发牌
struct CMD_S_SendCard
{
	BYTE							cbCardData;							//扑克数据
	DWORD							cbActionMask;						//动作掩码
	WORD							wCurrentUser;						//当前用户
	bool							bTail;								//末尾发牌
};
]]
    local CMD_S_SendCard = {}

    CMD_S_SendCard.cbCardData = 0 --							//扑克数据
    CMD_S_SendCard.cbActionMask = 0 --						//动作掩码
    CMD_S_SendCard.wCurrentUser = 0 --						//当前用户
    CMD_S_SendCard.bTail = 0 --								//末尾发牌
    local len, cbCardData,cbActionMask,wCurrentUser,bTail = string.unpack( packet, "bIHb")
    packet = string.sub( packet, len )

    CMD_S_SendCard.cbCardData = cbCardData --							//扑克数据
    CMD_S_SendCard.cbActionMask = cbActionMask --						//动作掩码
    CMD_S_SendCard.wCurrentUser = wCurrentUser --						//当前用户
    CMD_S_SendCard.bTail = bTail --								//末尾发牌

    self:dispatchEvent({name = updateUIEvent.SEND_CARDINFO, data = CMD_S_SendCard})
end

function gameMainGameFrame:OnSubPass(wMainCmdID, wSubCmdID, packet)
--struct PDK_CMD_S_PassCard
--{
--	BYTE							bNewTurn;							//一轮开始
--	WORD				 			wPassUser;							//放弃玩家
--	WORD				 			wCurrentUser;						//当前玩家
--}    
    local len, bNewTurn, wPassUser, wCurrentUser = string.unpack( packet, "bHH" )
    self:dispatchEvent({name = updateUIEvent.CARD_PASS, data = { bNewTurn = bNewTurn, wPassUser = wPassUser, wCurrentUser = wCurrentUser }})
end

function gameMainGameFrame:OnSubOperateNotify(wMainCmdID, wSubCmdID, packet)
--[[
//操作提示
struct CMD_S_OperateNotify
{
	WORD							wResumeUser;						//还原用户
	DWORD							cbActionMask;						//动作掩码
	BYTE							cbActionCard;						//动作扑克
};
]]
    local CMD_S_OperateNotify = {}

    CMD_S_OperateNotify.wResumeUser = 0--						//还原用户
    CMD_S_OperateNotify.cbActionMask = 0--						//动作掩码
    CMD_S_OperateNotify.cbActionCard = 0--						//动作扑克
    
    local len, wResumeUser,cbActionMask,cbActionCard = string.unpack( packet, "HIb")
    packet = string.sub( packet, len )

    CMD_S_OperateNotify.wResumeUser = wResumeUser--						//还原用户
    CMD_S_OperateNotify.cbActionMask = cbActionMask--						//动作掩码
    CMD_S_OperateNotify.cbActionCard = cbActionCard--						//动作扑克

    self:dispatchEvent({name = updateUIEvent.OPERATE_CODE, data = CMD_S_OperateNotify})
end


function gameMainGameFrame:OnSubGameEnd(wMainCmdID, wSubCmdID, packet)

--struct PDK_EndInfo
--{
--	WORD  wChairID;
--	SCORE lGameScore;
--	BYTE  nBombCount;
--	std::vector<BYTE> cbCardList;

--	void StreamValue(datastream& kData,bool bSend)
--	{
--		Stream_VALUE(wChairID);
--		Stream_VALUE(lGameScore);
--		Stream_VALUE(nBombCount);
--		Stream_VECTOR(cbCardList);
--	}
--};

--struct PDK_CMD_S_GameEnd
--{
--	SCORE lGameTax;
--	std::vector<PDK_EndInfo> kEndInfoList;
--	void StreamValue(datastream& kData,bool bSend)
--	{
--		Stream_VALUE(lGameTax);
--		StructVecotrMember(PDK_EndInfo,kEndInfoList);
--	}
--};

    local len, nSize
    local PDK_CMD_S_GameEnd = {}
    len, PDK_CMD_S_GameEnd.lGameTax, nSize = string.unpack( packet, "dL" )
    packet = string.sub( packet, len )
    PDK_CMD_S_GameEnd.kEndInfoList = {}
    for i = 1, nSize do
        local wChairID, lGameScore, nBombCount
        len, wChairID, lGameScore, JianScore, HistoryScore, nBombCount = string.unpack( packet, "Hdddb" )
        packet = string.sub( packet, len )
        local cbCardList
        packet, cbCardList = pubFun.UnpackVector( packet, "b" )

        local tem = {}
        tem.wChairID=wChairID
        tem.lGameScore=lGameScore
        tem.JianScore=JianScore
        tem.HistoryScore=HistoryScore
        tem.nBombCount=nBombCount
        tem.cbCardList=cbCardList

        table.insert(PDK_CMD_S_GameEnd.kEndInfoList, tem)

        --PDK_CMD_S_GameEnd.kEndInfoList = { wChairID=wChairID, lGameScore=lGameScore, nBombCount=nBombCount, cbCardList=cbCardList }
    end

    GameLogicCtrl:normalEnd(PDK_CMD_S_GameEnd)
end

function gameMainGameFrame:OnSubTrustee(wMainCmdID, wSubCmdID, packet)
--[[
//用户托管
struct CMD_S_Trustee
{
	bool							bTrustee;							//是否托管
	WORD							wChairID;							//托管用户
};
]]
    local CMD_S_Trustee = {}

    CMD_S_Trustee.bTrustee = 0--							//是否托管
    CMD_S_Trustee.wChairID = 0--							//托管用户


    local len, bTrustee,wChairID = string.unpack( packet, "bbbH")
    packet = string.sub( packet, len )

    CMD_S_Trustee.bTrustee = bTrustee--							//是否托管
    CMD_S_Trustee.wChairID = wChairID--							//托管用户

end
function gameMainGameFrame:OnSubUserChiHu(wMainCmdID, wSubCmdID, packet)
--[[
//
struct CMD_S_ChiHu
{
	WORD							wChiHuUser;							//
	WORD							wProviderUser;						//
	BYTE							cbChiHuCard;						//
	BYTE							cbCardCount;						//
	LONGLONG						lGameScore;							//
	BYTE							cbWinOrder;							//
};
]]

    local CMD_S_ChiHu = {}

    CMD_S_ChiHu.wChiHuUser = 0--							//
    CMD_S_ChiHu.wProviderUser = 0--						//
    CMD_S_ChiHu.cbChiHuCard = 0--						//
    CMD_S_ChiHu.cbCardCount = 0--						//
    CMD_S_ChiHu.lGameScore = 0--							//
    CMD_S_ChiHu.cbWinOrder = 0--							//

    local len, wChiHuUser,wProviderUser,cbChiHuCard,cbCardCount,lGameScore,cbWinOrder = string.unpack( packet, "HHbbdb")
    packet = string.sub( packet, len )
    
    CMD_S_ChiHu.wChiHuUser = wChiHuUser--							//
    CMD_S_ChiHu.wProviderUser = wProviderUser--						//
    CMD_S_ChiHu.cbChiHuCard = cbChiHuCard--						//
    CMD_S_ChiHu.cbCardCount = cbCardCount--						//
    CMD_S_ChiHu.lGameScore = lGameScore--							//
    CMD_S_ChiHu.cbWinOrder = cbWinOrder--							//

    GameLogicCtrl:setChiHuInfo(CMD_S_ChiHu)

end
function gameMainGameFrame:OnSubGangScore(wMainCmdID, wSubCmdID, packet)
--[[
//
struct CMD_S_GangScore
{
	WORD							wChairId;							//
	BYTE							cbXiaYu;							//
	LONGLONG						lGangScore[GAME_PLAYER];			//
};
]]
    local CMD_S_GangScore = {}
    CMD_S_GangScore.wChairId = 0--							//
    CMD_S_GangScore.cbXiaYu = 0--							//
    CMD_S_GangScore.lGangScore = {}--[GAME_PLAYER];			//


    local len, wChairId,cbXiaYu = string.unpack( packet, "Hb")
    packet = string.sub( packet, len )

    CMD_S_GangScore.wChairId = wChairId--							//
    CMD_S_GangScore.cbXiaYu = cbXiaYu--							//
    
    for i = 1, GAME_PLAYER do
        local len, b = string.unpack( packet, "d")
        packet = string.sub( packet, len )
        table.insert(CMD_S_GangScore.lGangScore, b)
    end
end

function gameMainGameFrame:OnSubXiaoHu(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
function gameMainGameFrame:OnMasterHandCard(wMainCmdID, wSubCmdID, packet)
--[[
struct MasterHandCardInfo
{
	int nChairId;
	std::vector<BYTE>    kMasterHandCard;

	void StreamValue(datastream& kData,bool bSend)
	{
		Stream_VALUE(nChairId);
		Stream_VECTOR(kMasterHandCard);
	}
};
]]
    -- 接收玩家手上的牌信息 
    -- 返回的是  MasterHandCardInfo  这个结构的列表  
    -- kMasterHandCard 返回的是一个列表 可以看做是 动态数组  最大数量 MAX_INDEX
    -- 在服务器发送过来的时候，在牌数据的最前面添加了发送的数量

    ---- !!!!!!!!!!!!!!!!!!!! 这里不用

--    local MasterHandCardInfo = {}

--    for i = 1, GAME_PLAYER do
--        local item = {}
--        local len, nChairId,count = string.unpack( packet, "II")
--        packet = string.sub( packet, len )

--        item.nChairId = nChairId
--        item.kMasterHandCard = {}
--        for j = 1, count do
--            local len, b = string.unpack( packet, "b")
--            packet = string.sub( packet, len )    
--            table.insert(item.kMasterHandCard, b)        
--        end
--        table.insert(MasterHandCardInfo, item)
--    end
    
end

function gameMainGameFrame:OnMasterLeftCard(wMainCmdID, wSubCmdID, packet)
--[[
struct MasterLeftCard
{
	BYTE      kMasterLeftIndex[MAX_INDEX];
	BYTE      kMasterCheakCard;
};
]]
    local MasterLeftCard = {}

    MasterLeftCard.kMasterLeftIndex = {}--[MAX_INDEX];
    MasterLeftCard.kMasterCheakCard = 0

    for i = 1, MAX_INDEX do
        local len, b = string.unpack( packet, "b")
        packet = string.sub( packet, len )
        table.insert(MasterLeftCard.kMasterLeftIndex, b)
    end

    local len, kMasterCheakCard = string.unpack( packet, "b")
    packet = string.sub( packet, len )
    MasterLeftCard.kMasterCheakCard = kMasterCheakCard

end

return gameMainGameFrame
