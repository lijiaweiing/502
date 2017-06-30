-------------------------------------------------
-- 私人场消息
-------------------------------------------------

local gameMainPrivate = class("gameMainPrivate", HotRequire(luafile.CtrlBase))


function gameMainPrivate:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainPrivate:init()
    
end

--		//私人场消息
function gameMainPrivate:OnSocketMainPrivate(wMainCmdID, wSubCmdID, packet)

	if wSubCmdID ==  SUB_GR_PRIVATE_INFO then 
        --//私人场信息  401
        self:OnSocketSubPrivateInfo(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_CREATE_PRIVATE_SUCESS then 
        --创建私人场成功 403
        self:OnSocketSubPrivateCreateSuceess(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GF_PRIVATE_ROOM_INFO then 
        --私人场房间信息 405
        self:OnSocketSubPrivateRoomInfo(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GF_PRIVATE_END then 
        --私人场结算 407
        self:OnSocketSubPrivateEnd(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_PRIVATE_DISMISS then 
        --私人场请求解散  406
        self:OnSocketSubPrivateDismissInfo(wMainCmdID, wSubCmdID, packet)
    end

end


function gameMainPrivate:OnSocketSubPrivateInfo(wMainCmdID, wSubCmdID, packet)
--[[
//私人场信息
struct CMD_GR_Private_Info
{	
	word							wKindID;
	SCORE							lCostGold;
	byte							bPlayCout[4];							//玩家局数
	SCORE							lPlayCost[4];							//消耗点数
};

]]
    local CMD_GR_Private_Info = {}
    
    CMD_GR_Private_Info.wKindID = 0 --
    CMD_GR_Private_Info.lCostGold = 0 --
    CMD_GR_Private_Info.bPlayCout = {} --[4];							//玩家局数
    CMD_GR_Private_Info.lPlayCost = {} --[4];							//消耗点数    
    
      
    local len, wKindID, lCostGold = string.unpack( packet, "Hd")
    packet = string.sub( packet, len )

    CMD_GR_Private_Info.wKindID = wKindID --
    CMD_GR_Private_Info.lCostGold = lCostGold --

    for i = 1, 4, 1 do
        local len, b = string.unpack( packet, "b")
        packet = string.sub( packet, len )
        
        table.insert(CMD_GR_Private_Info.bPlayCout , b)
    end

    for i = 1, 4, 1 do
        local len, b = string.unpack( packet, "b")
        packet = string.sub( packet, len )
        
        table.insert(CMD_GR_Private_Info.lPlayCost , b)
    end

    local createroom = gameManager:getpubInfo():getCreateRoom()
    if createroom == nil then return end 

    if createroom.roomcode == 0 then 
        -- 创建房间
--[[
//创建房间
struct CMD_GR_Create_Private
{	
	byte							cbGameType;								//游戏类型
	byte							bPlayCoutIdex;							//游戏局数
	byte							bGameTypeIdex;							//游戏类型
	dword							bGameRuleIdex;							//游戏规则
	char							stHttpChannel[LEN_NICKNAME];			//http获取
};

]]


        local CMD_GR_Create_Private = {}

        CMD_GR_Create_Private.cbGameType = Type_Private --								//游戏类型
        CMD_GR_Create_Private.bPlayCoutIdex = createroom.playerCountIdx --							//游戏局数
        CMD_GR_Create_Private.bGameTypeIdex = 0 --							//游戏类型
        CMD_GR_Create_Private.bGameRuleIdex = createroom.rule --							//游戏规则
        CMD_GR_Create_Private.stHttpChannel = "" --[LEN_NICKNAME];			//http获取


        local s = string.pack( "bbbI", CMD_GR_Create_Private.cbGameType, CMD_GR_Create_Private.bPlayCoutIdex,CMD_GR_Create_Private.bGameTypeIdex,CMD_GR_Create_Private.bGameRuleIdex)
        s = s .. pubFun.FillString( CMD_GR_Create_Private.stHttpChannel, LEN_NICKNAME )

        -- maincmd 10 sucmd 402   发送创建房间
        self:SendGamePack(MDM_GR_PRIVATE,SUB_GR_CREATE_PRIVATE, s)



    else
        -- 加入房间
--[[
//创建房间
struct CMD_GR_Join_Private
{	
	dword							dwRoomNum;								//房间ID
};

]]
    
        local CMD_GR_Join_Private = {}
        CMD_GR_Join_Private.dwRoomNum = createroom.roomcode

        local s = string.pack( "I", CMD_GR_Join_Private.dwRoomNum )

        -- maincmd 10 subcmd 404 加入房间
        self:SendGamePack(MDM_GR_PRIVATE,SUB_GR_JOIN_PRIVATE, s)
    end



--[[
	m_kPrivateInfo = *pNetInfo;

	if (m_eLinkAction == Type_Link_Create)
	{
		CServerItem::get()->SendSocketData(MDM_GR_PRIVATE,SUB_GR_CREATE_PRIVATE,&m_kCreatePrivateNet,sizeof(m_kCreatePrivateNet));
		zeromemory(&m_kCreatePrivateNet,sizeof(m_kCreatePrivateNet));
	}
	if (m_eLinkAction == Type_Link_Join)
	{
		CMD_GR_Join_Private kSendNet;
		kSendNet.dwRoomNum = utility::parseInt(m_kJoinNumTxt);
		CServerItem::get()->SendSocketData(MDM_GR_PRIVATE,SUB_GR_JOIN_PRIVATE,&kSendNet,sizeof(kSendNet));
	}
	m_eLinkAction = Type_Link_NULL;
]]

end


function gameMainPrivate:OnSocketSubPrivateCreateSuceess(wMainCmdID, wSubCmdID, packet)
--[[
//创建房间
struct CMD_GR_Create_Private_Sucess
{	
	SCORE							lCurSocre;								//当前剩余
	dword							dwRoomNum;								//房间ID
};
]]

    local CMD_GR_Create_Private_Sucess = {}

    CMD_GR_Create_Private_Sucess.lCurSocre = 0--								//当前剩余
    CMD_GR_Create_Private_Sucess.dwRoomNum = 0 --								//房间ID

    local len, lCurSocre, dwRoomNum = string.unpack( packet, "dI")

    CMD_GR_Create_Private_Sucess.lCurSocre = lCurSocre--								//当前剩余
    CMD_GR_Create_Private_Sucess.dwRoomNum = dwRoomNum --								//房间ID


end

function gameMainPrivate:OnSocketSubPrivateRoomInfo(wMainCmdID, wSubCmdID, packet)
--[[
//私人场房间信息
struct CMD_GF_Private_Room_Info
{	
	byte			bPlayCoutIdex;		//玩家局数0 1，  8 或者16局
	byte			bGameTypeIdex;		//游戏类型
	dword		    bGameRuleIdex;		//游戏规则

	byte			bStartGame;
	dword			dwPlayCout;			//游戏局数
	dword			dwRoomNum;
	dword			dwCreateUserID;
	dword			dwPlayTotal;		//总局数

	byte			cbRoomType;

std::vector<int>	kWinLoseScore;

	void StreamValue(datastream& kData,bool bSend)
	{
		Stream_VALUE(bPlayCoutIdex);
		Stream_VALUE(bGameTypeIdex);
		Stream_VALUE(bGameRuleIdex);
		Stream_VALUE(bStartGame);
		Stream_VALUE(dwPlayCout);
		Stream_VALUE(dwRoomNum);
		Stream_VALUE(dwCreateUserID);
		Stream_VALUE(dwPlayTotal);
		Stream_VECTOR(kWinLoseScore);
		Stream_VALUE(cbRoomType);
	}
};
]]

    local CMD_GF_Private_Room_Info = {}

    CMD_GF_Private_Room_Info.bPlayCoutIdex = 0--		//玩家局数0 1，  8 或者16局
    CMD_GF_Private_Room_Info.bGameTypeIdex = 0--		//游戏类型
    CMD_GF_Private_Room_Info.bGameRuleIdex = 0--		//游戏规则

    CMD_GF_Private_Room_Info.bStartGame = 0--
    CMD_GF_Private_Room_Info.dwPlayCout = 0--			//游戏局数
    CMD_GF_Private_Room_Info.dwRoomNum = 0--
    CMD_GF_Private_Room_Info.dwCreateUserID = 0--
    CMD_GF_Private_Room_Info.dwPlayTotal = 0--		//总局数

    CMD_GF_Private_Room_Info.cbRoomType = 0--

    CMD_GF_Private_Room_Info.kWinLoseScore = {}--

    local len, bPlayCoutIdex,bGameTypeIdex,bGameRuleIdex,bStartGame,dwPlayCout,dwRoomNum,dwCreateUserID,dwPlayTotal,cbRoomType = string.unpack( packet, "bbIbIIIIb")
    packet = string.sub( packet, len )

    CMD_GF_Private_Room_Info.bPlayCoutIdex = bPlayCoutIdex--		//玩家局数0 1，  8 或者16局
    CMD_GF_Private_Room_Info.bGameTypeIdex = bGameTypeIdex--		//游戏类型
    CMD_GF_Private_Room_Info.bGameRuleIdex = bGameRuleIdex--		//游戏规则

    CMD_GF_Private_Room_Info.bStartGame = bStartGame--
    CMD_GF_Private_Room_Info.dwPlayCout = dwPlayCout--			//游戏局数
    CMD_GF_Private_Room_Info.dwRoomNum = dwRoomNum--
    CMD_GF_Private_Room_Info.dwCreateUserID = dwCreateUserID--
    CMD_GF_Private_Room_Info.dwPlayTotal = dwPlayTotal--		//总局数

    CMD_GF_Private_Room_Info.cbRoomType = cbRoomType--

    for i = 1, len do
        local len, b = string.unpack( packet, "I")
        table.insert(CMD_GF_Private_Room_Info.kWinLoseScore, b)
    end

    -- 初始化桌子显示
    gameManager:getpubInfo():setPrivateRoomInfo(CMD_GF_Private_Room_Info)

    -- 修改状态
    StateMgr:ChangeState(StateType.Game)
    --self:dispatchEvent({name = updateUIEvent.SHOW_ROOMINFO})
end

function gameMainPrivate:OnSocketSubPrivateEnd(wMainCmdID, wSubCmdID, packet)
--[[
//私人场结算信息
struct CMD_GF_Private_End_Info
{	
	std::vector<SCORE> lPlayerWinLose;
	std::vector<byte> lPlayerAction;
	systemtime		kPlayTime;

	void StreamValue(datastream& kData,bool bSend)
	{
		Stream_VECTOR(lPlayerWinLose);
		Stream_VECTOR(lPlayerAction);
		Stream_VALUE_SYSTEMTIME(kPlayTime);
	}
};
]]

    local CMD_GF_Private_End_Info = {}

    CMD_GF_Private_End_Info.lPlayerWinLose = {}
    CMD_GF_Private_End_Info.lPlayerAction = {}
    CMD_GF_Private_End_Info.kPlayTime = {}

    local len, count = string.unpack( packet, "I")
    packet = string.sub( packet, len )

    for i = 1, count do
        local len, d = string.unpack( packet, "d")
        packet = string.sub( packet, len )      
        
        table.insert(CMD_GF_Private_End_Info.lPlayerWinLose, d)
    end

    local len, count = string.unpack( packet, "I")
    packet = string.sub( packet, len )
    for i = 1, count do
        local len, d = string.unpack( packet, "b")
        packet = string.sub( packet, len )      
        
        table.insert(CMD_GF_Private_End_Info.lPlayerAction, d)
    end

    local len, wMilliseconds, wSecond,wMinute,wHour,wDay,wDayOfWeek,wMonth,wYear= string.unpack( packet, "I8")
    packet = string.sub( packet, len )
--[[
	word wYear;
	word wMonth;
	word wDayOfWeek;
	word wDay;
	word wHour;
	word wMinute;
	word wSecond;
	word wMilliseconds;
]]
    local tem = {}
	tem.wYear = wYear
	tem.wMonth = wMonth
	tem.wDayOfWeek = wDayOfWeek
	tem.wDay = wDay
	tem.wHour = wHour
	tem.wMinute = wMinute
	tem.wSecond = wSecond
	tem.wMilliseconds = wMilliseconds

    CMD_GF_Private_End_Info.kPlayTime = 0

    GameLogicCtrl:setPrivateEndInfo(CMD_GF_Private_End_Info)

    LayerManager.show(loadlua.Totalresultlayer) -- 打开结算窗体
end

function gameMainPrivate:OnSocketSubPrivateDismissInfo(wMainCmdID, wSubCmdID, packet)
--[[

//私人场解散信息
struct CMD_GF_Private_Dismiss_Info
{	
	CMD_GF_Private_Dismiss_Info()
	{
		zeromemory(this,sizeof(CMD_GF_Private_Dismiss_Info));
	}
	dword			dwDissUserCout;
	dword			dwDissChairID[MAX_CHAIR-1];
	dword			dwValue1;
	dword			dwNotAgreeUserCout;
	dword			dwNotAgreeChairID[MAX_CHAIR-1];
	dword			dwValue2;
};
]]
    local CMD_GF_Private_Dismiss_Info = {}

    CMD_GF_Private_Dismiss_Info.dwDissUserCout = 0--
    CMD_GF_Private_Dismiss_Info.dwDissChairID = {}--[MAX_CHAIR-1];
    CMD_GF_Private_Dismiss_Info.dwValue1 = 0--;
    CMD_GF_Private_Dismiss_Info.dwNotAgreeUserCout = 0--;
    CMD_GF_Private_Dismiss_Info.dwNotAgreeChairID = {}--[MAX_CHAIR-1];
    CMD_GF_Private_Dismiss_Info.dwValue2 = 0--;

    local len, dwDissUserCout = string.unpack( packet, "I")
    packet = string.sub( packet, len )

    CMD_GF_Private_Dismiss_Info.dwDissUserCout = dwDissUserCout--

    for i = 1, MAX_CHAIR-1, 1 do
        local len, b = string.unpack( packet, "I")
        packet = string.sub( packet, len )        

        table.insert(CMD_GF_Private_Dismiss_Info.dwDissChairID, b)
    end

    local len, dwValue1, dwNotAgreeUserCout = string.unpack( packet, "II")
    packet = string.sub( packet, len )
    CMD_GF_Private_Dismiss_Info.dwValue1 = dwValue1--;
    CMD_GF_Private_Dismiss_Info.dwNotAgreeUserCout = dwNotAgreeUserCout--;

    for i = 1, MAX_CHAIR-1, 1 do
        local len, b = string.unpack( packet, "I")
        packet = string.sub( packet, len )        

        table.insert(CMD_GF_Private_Dismiss_Info.dwNotAgreeChairID, b)
    end

    local len, dwValue2 = string.unpack( packet, "I")
    packet = string.sub( packet, len )

    CMD_GF_Private_Dismiss_Info.dwValue2 = dwValue2

    self:dispatchEvent({name = updateUIEvent.ROOM_DISMISSINFO, data = CMD_GF_Private_Dismiss_Info})
end

return gameMainPrivate
