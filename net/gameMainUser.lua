-------------------------------------------------
-- 用户信息
-------------------------------------------------

local gameMainUser = class("gameMainUser", HotRequire(luafile.CtrlBase))


function gameMainUser:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainUser:init()

end


--		//用户信息
function gameMainUser:OnSocketMainUser(wMainCmdID, wSubCmdID, packet)

	if wSubCmdID == SUB_GR_SIT_FAILED then 
--		//请求坐下失败    103
        self:OnSocketSubRequestFailure(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_USER_ENTER then 
--		//用户进入    100
        self:OnSocketSubUserEnter(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_USER_SCORE then 
--		//用户积分  101
        self:OnSocketSubUserScore(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_USER_STATUS then 
        print( "wSubCmdID == SUB_GR_USER_STATUS" )
--		//用户状态  102
        self:OnSocketSubUserStatus(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID == SUB_GR_USER_CHAT then 
--		//用户聊天  201
        self:OnSocketSubUserChat(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_USER_EXPRESSION then 
--		//用户表情  202
        self:OnSocketSubExpression(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_WISPER_CHAT then 
--		//用户私聊  203
        self:OnSocketSubWisperUserChat(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_WISPER_EXPRESSION then
--		//私聊表情   204
        self:OnSocketSubWisperExpression(wMainCmdID, wSubCmdID, packet)


	elseif wSubCmdID == SUB_GR_PROPERTY_SUCCESS then 
--		//道具成功  301
        self:OnSocketSubPropertySuccess(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_PROPERTY_FAILURE then 
--		//道具失败 302
        self:OnSocketSubPropertyFailure(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_PROPERTY_EFFECT then
--		//道具效应     304
        self:OnSocketSubPropertyEffect(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_PROPERTY_MESSAGE then 
--		//礼物消息  303
        self:OnSocketSubPropertyMessage(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_PROPERTY_TRUMPET then 
--		//喇叭消息  305
        self:OnSocketSubPropertyTrumpet(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_GLAD_MESSAGE then 
--		//喜报消息  400
        self:OnSocketSubGladMessage(wMainCmdID, wSubCmdID, packet)
    end
end


--		//请求坐下失败
function gameMainUser:OnSocketSubRequestFailure(wMainCmdID, wSubCmdID, packet)
--[[
//请求失败
struct CMD_GR_RequestFailure
{
	unsigned int					lErrorCode;							//错误代码
	char							szDescribeString[256];				//描述信息
};
]]
    local CMD_GR_RequestFailure = {}
    CMD_GR_RequestFailure.lErrorCode = 0
    CMD_GR_RequestFailure.szDescribeString = ""

    local len, lErrorCode = string.unpack( packet, "I")
    CMD_GR_RequestFailure.lErrorCode = lErrorCode
    packet = string.sub( packet, len )

    CMD_GR_RequestFailure.szDescribeString, packet = pubFun.ReadString( packet, #packet )

    --  显示出错信息  TODO
    TipView:showTip(CMD_GR_RequestFailure.szDescribeString, TipView.tipType.ERROR)
--    GameServerNet:Disconnect()
end
--		//用户进入
function gameMainUser:OnSocketSubUserEnter(wMainCmdID, wSubCmdID, packet)
--[[
//用户基本信息结构
struct tagUserInfoHead
{
	//用户属性
	dword							dwGameID;							//游戏 I D
	dword							dwUserID;							//用户 I D
	dword							dwGroupID;							//社团 I D

	//头像信息
	word							wFaceID;							//头像索引
	dword							dwCustomID;							//自定标识

	//用户属性
	byte							cbGender;							//用户性别
	byte							cbMemberOrder;						//会员等级
	byte							cbMasterOrder;						//管理等级

	//用户状态
	word							wTableID;							//桌子索引
	word							wChairID;							//椅子索引
	byte							cbUserStatus;						//用户状态

	//积分信息
	longlong						lScore;								//用户分数
	longlong						lGrade;								//用户成绩
	longlong						lInsure;							//用户银行

	//游戏信息
	dword							dwWinCount;							//胜利盘数
	dword							dwLostCount;						//失败盘数
	dword							dwDrawCount;						//和局盘数
	dword							dwFleeCount;						//逃跑盘数
	dword							dwUserMedal;						//用户奖牌
	dword							dwExperience;						//用户经验
	unsigned int					lLoveLiness;						//用户魅力
};
]]

    local tagUserInfoHead = {}

    tagUserInfoHead.dwGameID = 0--							//游戏 I D
    tagUserInfoHead.dwUserID = 0--							//用户 I D
    tagUserInfoHead.dwGroupID = 0--							//社团 I D

    tagUserInfoHead.wFaceID = 0--							//头像索引
    tagUserInfoHead.dwCustomID = 0--							//自定标识

    tagUserInfoHead.cbGender = 0--							//用户性别
    tagUserInfoHead.cbMemberOrder = 0--						//会员等级
    tagUserInfoHead.cbMasterOrder = 0--						//管理等级

    tagUserInfoHead.wTableID = 0--							//桌子索引
    tagUserInfoHead.wChairID = 0--							//椅子索引
    tagUserInfoHead.cbUserStatus = 0--						//用户状态

    tagUserInfoHead.lScore = 0--								//用户分数
    tagUserInfoHead.lGrade = 0--								//用户成绩
    tagUserInfoHead.lInsure = 0--							//用户银行

    tagUserInfoHead.dwWinCount = 0--						//胜利盘数
    tagUserInfoHead.dwLostCount = 0--						//失败盘数
    tagUserInfoHead.dwDrawCount = 0--						//和局盘数
    tagUserInfoHead.dwFleeCount= 0 --						//逃跑盘数
    tagUserInfoHead.dwUserMedal = 0--						//用户奖牌
    tagUserInfoHead.dwExperience = 0--						//用户经验
    tagUserInfoHead.lLoveLiness = 0--						//用户魅力

    local len, dwGameID,dwUserID,dwGroupID,wFaceID,dwCustomID,cbGender,cbMemberOrder,cbMasterOrder = string.unpack( packet, "I3HIb3")
    packet = string.sub( packet, len )

    local len,wTableID,wChairID,cbUserStatus,lScore,lGrade,lInsure = string.unpack( packet, "H2bd3")
    packet = string.sub( packet, len )
        
    local len,dwWinCount,dwLostCount,dwDrawCount,dwFleeCount,dwUserMedal,dwExperience,lLoveLiness = string.unpack( packet, "I7")
    packet = string.sub( packet, len )

    tagUserInfoHead.dwGameID = dwGameID--							//游戏 I D
    tagUserInfoHead.dwUserID = dwUserID--							//用户 I D
    tagUserInfoHead.dwGroupID = dwGroupID--							//社团 I D

    tagUserInfoHead.wFaceID = wFaceID--							//头像索引
    tagUserInfoHead.dwCustomID = dwCustomID--							//自定标识

    tagUserInfoHead.cbGender = cbGender--							//用户性别
    tagUserInfoHead.cbMemberOrder = cbMemberOrder--						//会员等级
    tagUserInfoHead.cbMasterOrder = cbMasterOrder--						//管理等级

    tagUserInfoHead.wTableID = wTableID--							//桌子索引
    tagUserInfoHead.wChairID = wChairID--							//椅子索引
    tagUserInfoHead.cbUserStatus = cbUserStatus--						//用户状态

    tagUserInfoHead.lScore = lScore--								//用户分数
    tagUserInfoHead.lGrade = lGrade--								//用户成绩
    tagUserInfoHead.lInsure = lInsure--							//用户银行

    tagUserInfoHead.dwWinCount = dwWinCount--						//胜利盘数
    tagUserInfoHead.dwLostCount = dwLostCount--						//失败盘数
    tagUserInfoHead.dwDrawCount = dwDrawCount--						//和局盘数
    tagUserInfoHead.dwFleeCount= dwFleeCount --						//逃跑盘数
    tagUserInfoHead.dwUserMedal = dwUserMedal--						//用户奖牌
    tagUserInfoHead.dwExperience = dwExperience--						//用户经验
    tagUserInfoHead.lLoveLiness = lLoveLiness--						//用户魅力


--[[
//用户信息
struct tagUserInfo
{
	//基本属性
	dword							dwUserID;							//用户 I D
	dword							dwGameID;							//游戏 I D
	dword							dwGroupID;							//社团 I D
	char							szNickName[LEN_NICKNAME];			//用户昵称
	char							szGroupName[LEN_GROUP_NAME];		//社团名字
	char							szUnderWrite[LEN_UNDER_WRITE];		//个性签名
	char							szLogonIP[LEN_ACCOUNTS];			//登录IP
	char							szHeadHttp[LEN_USER_NOTE];			//头像HTTP
//	char							szGPS[LEN_NICKNAME];			//GPS

	//头像信息
	word							wFaceID;							//头像索引
	dword							dwCustomID;							//自定标识

	//用户资料
	byte							cbGender;							//用户性别
	byte							cbMemberOrder;						//会员等级
	byte							cbMasterOrder;						//管理等级

	//用户状态
	word							wTableID;							//桌子索引
	word							wLastTableID;						//游戏桌子
	word							wChairID;							//椅子索引
	byte							cbUserStatus;						//用户状态

	//积分信息
	SCORE							lScore;								//用户分数
	SCORE							lGrade;								//用户成绩
	SCORE							lInsureScore;							//用户银行
	SCORE							lGameGold;								//用户元宝

	//游戏信息
	dword							lWinCount;							//胜利盘数
	dword							lLostCount;						//失败盘数
	dword							lDrawCount;						//和局盘数
	dword							lFleeCount;						//逃跑盘数
	dword							lExperience;						//用户经验
	dword							lLoveLiness;						//用户魅力

	dword							iStarValue;						//评分
	dword							iStartCout;						//评分
	//时间信息
	tagTimeInfo						TimerInfo;
    
    
    double                          dLatitude;  //精度
    double                          dLongtitude; //纬度
    tchar                           szPosition[LEN_POSITION];//位置信息
};
]]

    local tagUserInfo = {}


    tagUserInfo.dwUserID = tagUserInfoHead.dwUserID--							//用户 I D
    tagUserInfo.dwGameID = tagUserInfoHead.dwGameID--							//游戏 I D
    tagUserInfo.dwGroupID = tagUserInfoHead.dwGroupID--							//社团 I D
    tagUserInfo.szNickName = ""--[LEN_NICKNAME];			//用户昵称
    tagUserInfo.szGroupName = ""--[LEN_GROUP_NAME];		//社团名字
    tagUserInfo.szUnderWrite = ""--[LEN_UNDER_WRITE];		//个性签名
    tagUserInfo.szLogonIP = ""--[LEN_ACCOUNTS];			//登录IP
    tagUserInfo.szHeadHttp = ""--[LEN_USER_NOTE];			//头像HTTP
    tagUserInfo.szGPS = ""--[LEN_NICKNAME];			//GPS

    tagUserInfo.wFaceID = tagUserInfoHead.wFaceID--							//头像索引
    tagUserInfo.dwCustomID = tagUserInfoHead.dwCustomID--							//自定标识

    tagUserInfo.cbGender = tagUserInfoHead.cbGender--							//用户性别
    tagUserInfo.cbMemberOrder = tagUserInfoHead.cbMemberOrder--						//会员等级
    tagUserInfo.cbMasterOrder = tagUserInfoHead.cbMasterOrder--						//管理等级

    tagUserInfo.wTableID = tagUserInfoHead.wTableID--							//桌子索引
    tagUserInfo.wLastTableID = 0--						//游戏桌子
    tagUserInfo.wChairID = tagUserInfoHead.wChairID--							//椅子索引
    tagUserInfo.cbUserStatus = tagUserInfoHead.cbUserStatus--						//用户状态

    tagUserInfo.lScore = tagUserInfoHead.lScore--								//用户分数
    tagUserInfo.lGrade = tagUserInfoHead.lGrade--							//用户成绩
    tagUserInfo.lInsureScore = 0--							//用户银行
    tagUserInfo.lGameGold = tagUserInfoHead.lGrade--								//用户元宝

    tagUserInfo.lWinCount = tagUserInfoHead.dwWinCount--							//胜利盘数
    tagUserInfo.lLostCount = tagUserInfoHead.dwLostCount--						//失败盘数
    tagUserInfo.lDrawCount = tagUserInfoHead.dwDrawCount--						//和局盘数
    tagUserInfo.lFleeCount = tagUserInfoHead.dwFleeCount--						//逃跑盘数
    tagUserInfo.lExperience = tagUserInfoHead.dwExperience--						//用户经验
    tagUserInfo.lLoveLiness = 0--						//用户魅力

    tagUserInfo.iStarValue = 0--						//评分
    tagUserInfo.iStartCout = 0--						//评分

    tagUserInfo.TimerInfo = 0--

    tagUserInfo.dLatitude = 0--  //精度
    tagUserInfo.dLongtitude = 0--//纬度
    tagUserInfo.szPosition = ""--[LEN_POSITION];//位置信息

    -- 读取扩展信息，这里主要的读取进入桌子的玩的昵称
    --local tagDataDescribe = {}
    while true do
        
        local len, wDataSize, wDataDescribe = string.unpack( packet, "HH")
        packet = string.sub( packet, len )        

        if wDataDescribe == DTP_GR_NICK_NAME then-- :		//用户昵称
            tagUserInfo.szNickName, packet = pubFun.ReadString( packet, wDataSize )

        elseif wDataDescribe == DTP_GR_GROUP_NAME then
            tagUserInfo.szGroupName, packet = pubFun.ReadString( packet, wDataSize )

        elseif wDataDescribe == DTP_GR_UNDER_WRITE then
            tagUserInfo.szUnderWrite, packet = pubFun.ReadString( packet, wDataSize )

        elseif wDataDescribe == DTP_NULL then
            break
        end

        if string.len(packet) <= 0 then break end
    end

    gameManager:getpubInfo():addUserItem(tagUserInfo)

    -- 用户进入事件，这里返回的数据 第一个是自己 后面返回的是其它的玩家
    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil or meitem.dwUserID == tagUserInfo.dwUserID then
        print("tagUserInfo.dwUserID " .. tagUserInfo.dwUserID)

        if meitem.cbUserStatus < US_READY then
            self:UserReady()
        end
    end
    local ChairIdx = gameManager:getpubInfo():Chair2Idx( tagUserInfo.wChairID )
    local player = GameLogicCtrl:getPlayers()[ ChairIdx ]
    if player then
        player:setName( tagUserInfo.dwUserID )
    end
end

--:			//用户准备
function gameMainUser:UserReady()
--[[
	if (m_pMeUserItem == 0) return false;
	return SendSocketData(MDM_GF_FRAME, SUB_GF_USER_READY, 0, 0);
]]    


    local ss = 0
    local s = string.pack( "b", ss)
    -- maincmd 100 subcmd 2
    self:SendGamePack(MDM_GF_FRAME, SUB_GF_USER_READY, s)
end

--		//用户积分
function gameMainUser:OnSocketSubUserScore(wMainCmdID, wSubCmdID, packet)
--[[
//用户分数
struct CMD_GR_UserScore
{
	dword							dwUserID;							//用户标识
	tagUserScore					UserScore;							//积分信息
};

//用户积分
struct tagUserScore
{
	//积分信息
	SCORE							lScore;								//用户分数
	SCORE							lGrade;								//用户成绩
	SCORE							lInsure;							//用户银行

	//输赢信息
	dword							dwWinCount;							//胜利盘数
	dword							dwLostCount;						//失败盘数
	dword							dwDrawCount;						//和局盘数
	dword							dwFleeCount;						//逃跑盘数

	//全局信息
	dword							dwUserMedal;						//用户奖牌
	dword							dwExperience;						//用户经验
	unsigned int					lLoveLiness;						//用户魅力
};
]]
    local CMD_GR_UserScore = {}

    CMD_GR_UserScore.dwUserID = 0---							//用户标识
    CMD_GR_UserScore.lScore = 0---								//用户分数
    CMD_GR_UserScore.lGrade = 0---								//用户成绩
    CMD_GR_UserScore.lInsure = 0---							//用户银行 
    CMD_GR_UserScore.dwWinCount = 0---						//胜利盘数
    CMD_GR_UserScore.dwLostCount = 0---						//失败盘数
    CMD_GR_UserScore.dwDrawCount = 0---						//和局盘数
    CMD_GR_UserScore.dwFleeCount = 0---						//逃跑盘数
    CMD_GR_UserScore.dwUserMedal = 0---						//用户奖牌
    CMD_GR_UserScore.dwExperience = 0---						//用户经验
    CMD_GR_UserScore.lLoveLiness = 0---						//用户魅力
    
    -- 不能换行 !!!!
    local len, dwUserID,lScore,lGrade,lInsure,dwWinCount,dwLostCount,dwDrawCount,dwFleeCount,dwUserMedal,dwExperience,lLoveLiness = string.unpack( packet, "Id3I7")

    CMD_GR_UserScore.dwUserID = dwUserID---							//用户标识
    CMD_GR_UserScore.lScore = lScore---								//用户分数
    CMD_GR_UserScore.lGrade = lGrade---								//用户成绩
    CMD_GR_UserScore.lInsure = lInsure---							//用户银行
    CMD_GR_UserScore.dwWinCount = dwWinCount---						//胜利盘数
    CMD_GR_UserScore.dwLostCount = dwLostCount---						//失败盘数
    CMD_GR_UserScore.dwDrawCount = dwDrawCount---						//和局盘数
    CMD_GR_UserScore.dwFleeCount = dwFleeCount---						//逃跑盘数
    CMD_GR_UserScore.dwUserMedal = dwUserMedal---						//用户奖牌
    CMD_GR_UserScore.dwExperience = dwExperience---						//用户经验
    CMD_GR_UserScore.lLoveLiness = lLoveLiness---						//用户魅力

    -- 更新 游戏分数
    gameManager:getpubInfo():modifyUserInfoScore(dwUserID, CMD_GR_UserScore)
    
    UserManager:getUserInfo():modifyScoreData(dwUserID, CMD_GR_UserScore)
end
--		//用户状态
function gameMainUser:OnSocketSubUserStatus(wMainCmdID, wSubCmdID, packet)
----[[
--//用户状态
--struct CMD_GR_UserStatus
--{
--	dword							dwUserID;							//用户标识
--	tagUserStatus					UserStatus;							//用户状态
--};

--]]

--    local CMD_GR_UserStatus = {}

--    CMD_GR_UserStatus.dwUserID = 0 --							//用户标识
--    CMD_GR_UserStatus.wTableID = 0 --							//桌子索引
--    CMD_GR_UserStatus.wChairID = 0 --							//椅子位置
--    CMD_GR_UserStatus.cbUserStatus = 0 --					//用户状态

--    local len, dwUserID,wTableID,wChairID,cbUserStatus = string.unpack( packet, "IHHb")

--    CMD_GR_UserStatus.dwUserID = dwUserID --							//用户标识
--    CMD_GR_UserStatus.wTableID = wTableID --							//桌子索引
--    CMD_GR_UserStatus.wChairID = wChairID --							//椅子位置
--    CMD_GR_UserStatus.cbUserStatus = cbUserStatus --					//用户状态

----[[
--//用户状态
--struct tagUserStatus
--{
--	word							wTableID;							//桌子索引
--	word							wChairID;							//椅子位置
--	byte							cbUserStatus;						//用户状态
--};
--]]

--    local lastwTableID = 0--							//桌子索引
--    local lastwChairID = 0--							//椅子位置
--    local lastcbUserStatus = INVALID_TABLE--					//用户状态

--    local useritem = gameManager:getpubInfo():findUserInfo(dwUserID)
--    if useritem ~= nil then 
--        lastwTableID = useritem.wTableID
--        lastwChairID = useritem.wChairID
--        lastcbUserStatus = useritem.cbUserStatus
--    end

--    local tagUserStatus = {}
--    tagUserStatus.wTableID = CMD_GR_UserStatus.wTableID --							//桌子索引
--    tagUserStatus.wChairID = CMD_GR_UserStatus.wChairID --							//椅子位置
--    tagUserStatus.cbUserStatus = CMD_GR_UserStatus.cbUserStatus --					//用户状态

--    if tagUserStatus.cbUserStatus == US_NULL then 
--        -- 删除用户
--        gameManager:getpubInfo():removeUserInfo(dwUserID)
--    else
--        -- 更新用户 状态
--        print(" modifyUserInfoState " .. dwUserID)
--        gameManager:getpubInfo():modifyUserInfoState(dwUserID, tagUserStatus)

--        -- 判断是否是自己
--        local meitem = gameManager:getpubInfo():getmeitem()
--        if meitem == nil then return end
--        if meitem.dwUserID == dwUserID then
--            if wTableID ~= INVALID_TABLE then
--                if wTableID ~= lastwTableID or lastwChairID ~= wChairID then
--                    self:OnGFGameReady()
--                end
--            end
--        end
--    end



--[[
//用户状态
struct CMD_GR_UserStatus
{
	dword							dwUserID;							//用户标识
	tagUserStatus					UserStatus;							//用户状态
};

]]

    local CMD_GR_UserStatus = {}

    CMD_GR_UserStatus.dwUserID = 0 --							//用户标识
    CMD_GR_UserStatus.wTableID = 0 --							//桌子索引
    CMD_GR_UserStatus.wChairID = 0 --							//椅子位置
    CMD_GR_UserStatus.cbUserStatus = 0 --					//用户状态
    
    local len, dwUserID,wTableID,wChairID,cbUserStatus = string.unpack( packet, "IHHb")

    CMD_GR_UserStatus.dwUserID = dwUserID --							//用户标识
    CMD_GR_UserStatus.wTableID = wTableID --							//桌子索引
    CMD_GR_UserStatus.wChairID = wChairID --							//椅子位置
    CMD_GR_UserStatus.cbUserStatus = cbUserStatus --					//用户状态

--[[
//用户状态
struct tagUserStatus
{
	word							wTableID;							//桌子索引
	word							wChairID;							//椅子位置
	byte							cbUserStatus;						//用户状态
};
]]

    local nowTableID = 0--							//桌子索引
    local nowChairID = 0--							//椅子位置
    local nowUserStatus = INVALID_TABLE--					//用户状态


    local checknowTableID = 0--							//桌子索引
    local checknowChairID = 0--							//椅子位置
    local checknowUserStatus = INVALID_TABLE--					//用户状态


    local useritem = gameManager:getpubInfo():findUserInfo(dwUserID)
    if useritem ~= nil then 
        nowTableID = useritem.wTableID
        nowChairID = useritem.wChairID
        nowUserStatus = useritem.cbUserStatus

        checknowTableID = nowTableID
        checknowChairID = nowChairID
        checknowUserStatus = nowUserStatus
    end

    local tagUserStatus = {}
    tagUserStatus.wTableID = CMD_GR_UserStatus.wTableID --							//桌子索引
    tagUserStatus.wChairID = CMD_GR_UserStatus.wChairID --							//椅子位置
    tagUserStatus.cbUserStatus = CMD_GR_UserStatus.cbUserStatus --					//用户状态

    local wLastTableID = CMD_GR_UserStatus.wTableID
    local wLastChairID = CMD_GR_UserStatus.wChairID
    local cbLastStatus = CMD_GR_UserStatus.cbUserStatus


    if tagUserStatus.cbUserStatus == US_NULL then 
        -- 删除用户
        gameManager:getpubInfo():removeUserInfo(dwUserID)
    else
        -- 更新用户 状态
        --print(" modifyUserInfoState " .. dwUserID)
        gameManager:getpubInfo():modifyUserInfoState(dwUserID, tagUserStatus)

        -- 判断是否是自己
        local meitem = gameManager:getpubInfo():getmeitem()
        if meitem == nil then return end
        if meitem.dwUserID == dwUserID then
            if wTableID ~= INVALID_TABLE then
--                if wTableID ~= nowTableID or nowChairID ~= wChairID then
                    self:OnGFGameReady()
--                end
            end
        end

        -- 请求信息
        -- 发送请求 玩家信息
--[[

//查询信息
struct CMD_GP_QueryIndividual
{
	dword							dwUserID;							//用户 I D
};
]]
        local QueryIndividual = {}
        QueryIndividual.dwUserID = dwUserID

        local ss = 0
        local s = string.pack( "I", QueryIndividual.dwUserID)

        -- 这里发送的是大厅的 消息 ，
        -- 也就是说这里请求的 是登陆服务器的协议 
        -- 如果发送给游戏服务器是没有任务用处的 !!!!!!!!!!!!!!!!!!!!!!
        NetworkManager:sendPack(MDM_GP_USER_SERVICE,SUB_GP_QUERY_INDIVIDUAL, s)
        --self:SendGamePack(MDM_GP_USER_SERVICE,SUB_GP_QUERY_INDIVIDUAL, s)

    end

    --------------------------------------------------------------------------------
    local useritem = gameManager:getpubInfo():findUserInfo(dwUserID)
    if useritem ~= nil then 
        nowTableID = useritem.wTableID
        nowChairID = useritem.wChairID
        nowUserStatus = useritem.cbUserStatus
    end

    local meitem = gameManager:getpubInfo():getmeitem()
    if meitem == nil then return end 

    if meitem.dwUserID ~= dwUserID then return end

    -- 判断游戏是否解散
    if (nowTableID == INVALID_TABLE) and ((checknowTableID ~= wLastTableID) or (checknowChairID ~= wLastChairID)) then 
        gameManager:getpubInfo():setInRoom(false)

        -- 返回大厅
        StateMgr:ChangeState(StateType.Hall)  
    end

end

function gameMainUser:OnGFGameReady()
--[[

//游戏配置
struct CMD_GF_GameOption
{
	byte							cbAllowLookon;						//旁观标志
	dword							dwFrameVersion;						//框架版本
	dword							dwClientVersion;					//游戏版本
};

--]]    
--    local CMD_GF_GameOption = {}

--    CMD_GF_GameOption.cbAllowLookon = 0--						//旁观标志
--    CMD_GF_GameOption.dwFrameVersion = pubFun.GetGameVersion()--						//框架版本
--    CMD_GF_GameOption.dwClientVersion = pubFun.GetGameVersion()--					//游戏版本

--    local s = string.pack( "bII", CMD_GF_GameOption.cbAllowLookon, CMD_GF_GameOption.dwFrameVersion, CMD_GF_GameOption.dwClientVersion)


--    -- maincmd 100  subcmd 1
--    self:SendGamePack(MDM_GF_FRAME,SUB_GF_GAME_OPTION,s);
    GameLogicCtrl:sendReadyMsg()
end


--		//用户聊天
function gameMainUser:OnSocketSubUserChat(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//用户表情
function gameMainUser:OnSocketSubExpression(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//用户私聊
function gameMainUser:OnSocketSubWisperUserChat(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//私聊表情
function gameMainUser:OnSocketSubWisperExpression(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

--		//道具成功
function gameMainUser:OnSocketSubPropertySuccess(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//道具失败
function gameMainUser:OnSocketSubPropertyFailure(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//道具效应
function gameMainUser:OnSocketSubPropertyEffect(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//礼物消息
function gameMainUser:OnSocketSubPropertyMessage(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//喇叭消息
function gameMainUser:OnSocketSubPropertyTrumpet(wMainCmdID, wSubCmdID, packet)
    -- 没用
end
--		//喜报消息
function gameMainUser:OnSocketSubGladMessage(wMainCmdID, wSubCmdID, packet)
    -- 没用
end




return gameMainUser


