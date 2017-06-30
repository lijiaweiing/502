-------------------------------------------------
-- 游戏入口 文件
-------------------------------------------------
HotRequire("games.502.init")

local gamemain = class("gamemain", HotRequire(luafile.CtrlBase))

function gamemain:ctor( ... )
	self.super.ctor(self, ... )
    self:Init()
end

function gamemain:Init( ... )
    -- 设置事件派发器
    --cc.load("event"):setEventDispatcher(self, GameController)

    --self.ServerItemInfo = {} -- 服务器信息

    self.serviceState = {}
    print( "gamemain:Init" )
    self:initEvent()
    --self:GetServerInfo()
    self:initCtrl()

    gameManager:getpubInfo():setServiceStatus(enServiceStatus.ServiceStatus_Unknow)

    --self:InitTcp()
end

function gamemain:initEvent()
    --self.eventHandler = self:addEventListener(CreateGame.CONNECT_GAMESERVER_SUCC, handler(self, self.onConnectSucc)) -- 连接事件
    self.eventHandler = self:addEventListener(CreateGame.CREATE_GAME, handler(self, self.onCreateGame)) -- 创建事件
    self.eventHandler = self:addEventListener(CreateGame.BACK_HALL, handler(self, self.onBackHall)) -- 返回大厅
    self.eventHandler = self:addEventListener(CreateGame.GAME_DATA, handler(self, self.onGameData)) -- 游戏数据返回
    self.eventHandler = self:addEventListener(CreateGame.ENTER_ROOM, handler(self, self.onEnterRoom)) -- 进入房间
end

function gamemain:initCtrl()
    -- 游戏逻辑控制器
    GameLogicCtrl       = new_class(loadlua.GameLogicCtrl)

    -- 通信类
    gameMainConfig      = new_class(loadlua.gameMainConfig)
    gameMainGameFrame   = new_class(loadlua.gameMainGameFrame)
    gameMainLogon       = new_class(loadlua.gameMainLogon)
    gameMainMatch       = new_class(loadlua.gameMainMatch)
    gameMainPrivate     = new_class(loadlua.gameMainPrivate)
    gameMainStatus      = new_class(loadlua.gameMainStatus)
    gameMainSystem      = new_class(loadlua.gameMainSystem)
    gameMainUser        = new_class(loadlua.gameMainUser)

    -- 创建管理类
    gameManager = new_class(loadlua.GameManager)
    
end

function gamemain:onGameData(event)
    if event.name ~= CreateGame.GAME_DATA then return end 
    print( "gamemain:onGameData" )
    local msgtype = event.data.msgtype
    local wMainCmdID = event.data.wMainCmdID
    local wSubCmdID = event.data.wSubCmdID
    local packet = event.data.packet
    
    self:onEventTCPSocketRead(wMainCmdID, wSubCmdID, packet)

end

function gamemain:onEnterRoom(event)
    if event.name ~= CreateGame.ENTER_ROOM then return end

    LayerManager.show(loadlua.RoomLayer)
end

function gamemain:onEventTCPSocketRead(wMainCmdID, wSubCmdID, packet)
    print( "gamemain:onEventTCPSocketRead" )
--		//登录消息 1 
	if wMainCmdID == MDM_GR_LOGON then
        gameMainLogon:OnSocketMainLogon(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==  MDM_GR_CONFIG then
--		--		//配置信息 2 
        gameMainConfig:OnSocketMainConfig(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_GR_USER then
--		//用户信息 3
        gameMainUser:OnSocketMainUser(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_GR_STATUS then
        --//状态信息 4 
        gameMainStatus:OnSocketMainStatus(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_CM_SYSTEM then 
    --		//系统消息 1000
        gameMainSystem:OnSocketMainSystem(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_GF_GAME or wMainCmdID ==   MDM_GF_FRAME then
--		//框架消息--	100	//游戏消息  200
        gameMainGameFrame:OnSocketMainGameFrame(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_GR_MATCH then
--		//比赛消息 9 
        gameMainMatch:OnSocketMainMatch(wMainCmdID, wSubCmdID, packet)
	elseif wMainCmdID ==   MDM_GR_PRIVATE then
--		//私人场消息  10
        gameMainPrivate:OnSocketMainPrivate(wMainCmdID, wSubCmdID, packet)
    end
end

function gamemain:InitTcp(roomcode, rule, playerCountIdx, ip, port)
    --if self.ServerItemInfo == nil or self.ServerItemInfo.wServerPort == nil then return end
	local function connectCallback(connectType, data)
		if connectType == CreateGame.CONNECT_GAMESERVER_SUCC then
            -- 连接成功
            -- 发送登陆信息
            self:LoginGameServer()

			--local token = UserManager:getUserInfo():getLoginToken()
			--log("ConnectGameServer.connectCallback", token)
			--if not token or token == "" then
			--	this:GuestLoginGame()
			--else
			--	this:WechatLoginGame()
			--end
		end

        if connectType == CreateGame.CONNECT_GAMESERVER_FAIL then
            -- 连接失败

        end
		---SendClientInfoRequest()
	end

    ---- 创建房间 -- 加入房间
    local createitem = {}
    
    createitem.roomcode = roomcode
    createitem.rule = rule  -- 规则
    createitem.playerCountIdx = playerCountIdx-- 8 局  16 局
    createitem.ip = ip
    createitem.port = port

    gameManager:getpubInfo():setCreateRoom(createitem)

    LinkServerController:ConnectGameServer(ip, port, connectCallback)

	--LinkServerController:ConnectGameServer(GAME_SERVER_DEFAULT.ip, self.ServerItemInfo.wServerPort, connectCallback)	
    	
end

function gamemain:LoginGameServer()
    if GameServerNet == nil then return end 

--[[
//房间 ID 登录
struct CMD_GR_LogonUserID
{
	dword							dwPlazaVersion;						//广场版本
	dword							dwFrameVersion;						//框架版本
	dword							dwProcessVersion;					//进程版本

	//登录信息
	dword							dwUserID;							//用户 I D
	char							szPassword[LEN_MD5];				//登录密码
	char							szMachineID[LEN_MACHINE_ID];		//机器序列
	word							wKindID;							//类型索引
};
]]

    local userdata = UserManager:getUserInfo():getData()
    if userdata == nil then return end 

    local CMD_GR_LogonUserID = {}

    CMD_GR_LogonUserID.dwPlazaVersion = pubFun.getPlazaVersion(10, 0, 3) --						//广场版本
    CMD_GR_LogonUserID.dwFrameVersion = 0 --;						//框架版本
    CMD_GR_LogonUserID.dwProcessVersion = pubFun.GetGameVersion() --;					//进程版本
    
    
    CMD_GR_LogonUserID.dwUserID = userdata.dwUserID --;							//用户 I D
    CMD_GR_LogonUserID.szPassword = userdata.szPassword or "" --[LEN_MD5];				//登录密码
    CMD_GR_LogonUserID.szMachineID = "" --[LEN_MACHINE_ID];		//机器序列
    CMD_GR_LogonUserID.wKindID = GAMEID --;							//类型索引


    local s = string.pack( "I4", CMD_GR_LogonUserID.dwPlazaVersion,CMD_GR_LogonUserID.dwFrameVersion, CMD_GR_LogonUserID.dwProcessVersion, CMD_GR_LogonUserID.dwUserID)
    s = s .. pubFun.FillString( CMD_GR_LogonUserID.szPassword, LEN_MD5 )
    s = s .. pubFun.FillString( CMD_GR_LogonUserID.szMachineID, LEN_MACHINE_ID )

    s = s .. string.pack( "H", CMD_GR_LogonUserID.wKindID)

    -- maincmd 1   subcmd 1
    self:SendGamePack(MDM_GR_LOGON,SUB_GR_LOGON_USERID, s)
end

function gamemain:getServerPortFrmGameId(gameid)
    --[[
//游戏房间列表结构
struct tagGameServer
{
	word							wKindID;							//名称索引
	word							wNodeID;							//节点索引
	word							wSortID;							//排序索引
	word							wServerID;							//房间索引
	//WORD                            wServerKind;                        //房间类型
	word							wServerType;						//房间类型
	word							wServerPort;						//房间端口
	SCORE							lCellScore;							//单元积分
	SCORE							lEnterScore;						//进入积分
	dword							dwServerRule;						//房间规则
	dword							dwOnLineCount;						//在线人数
	dword							dwAndroidCount;						//机器人数
	dword							dwFullCount;						//满员人数
	char							szServerAddr[32];					//房间名称
	char							szServerName[LEN_SERVER];			//房间名称
};
]]
    local re = 0
    local data = UserManager:getServerData():getRoomInfo()
    if data ~= nil then
        for i, item in ipairs(data) do
            if item ~= nil then 
                if item.wKindID == gameid then 
                    re = item.wServerPort
                    break
                end
            end
        end    
    end
    return re
end

function gamemain:onConnectSucc()
    
end

function gamemain:onCreateGame()
    print("")
end

function gamemain:onBackHall()
end

return gamemain
