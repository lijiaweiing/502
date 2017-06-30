----------------------------------------------
-- 公共信息 类
----------------------------------------------

local pubInfo = class("pubInfo")

--[[
//用户属性
struct tagUserAttribute
{
	//用户属性
	dword							dwUserID;							//用户标识
	word							wTableID;							//桌子号码
	word							wChairID;							//椅子号码

	//权限属性
	dword							dwUserRight;						//用户权限
	dword							dwMasterRight;						//管理权限
};

//用户信息  userItem 
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
    
    
    double dLatitude;  //精度
    double dLongtitude; //纬度
    tchar szPosition[LEN_POSITION];//位置信息
};
]]

-- 构造函数
function pubInfo:ctor( ... )

    self:clearInfo()
    -- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)
end

function pubInfo:clearInfo()
    self.serviceState = {}
    self.createRoom = {}

    self.gameState = {} -- 游戏状态

    self.privateRoomInfo = {}

    self.tagUserInfo = {}    
    self.isInGameRoom = false
    self.loginGameServer = false
end

function pubInfo:setLoginGameServer(succ)
    self.loginGameServer = succ
end

function pubInfo:setInRoom(inroom)
    return self.loginGameServer
end

function pubInfo:setInRoom(inroom)
    self.isInGameRoom = inroom
end

function pubInfo:getInRoom()
    return self.isInGameRoom
end

function pubInfo:getUserInfo()
    return self.tagUserInfo
end

function pubInfo:findUserInfo(dwUserID)
    local re = nil
    local findidx = 0
    for i, item in pairs(self.tagUserInfo) do
        if item ~= nil then 
            if item.dwUserID == dwUserID then 
                re = item
                findidx = i
                break
            end
        end
    end
    return re, findidx
end

function pubInfo:removeUserInfo(dwUserID)
    local finduser,findidx = self:findUserInfo(dwUserID)
    if finduser == nil or findidx == 0 then return end 
    table.remove(self.tagUserInfo, findidx)
end

-- 修改状态
function pubInfo:modifyUserInfoState(dwUserID, stateItem)
    if stateItem == nil then return end 
    local finduser,findidx = self:findUserInfo(dwUserID)
    if finduser == nil or findidx == 0 then return end 

    for k, v in pairs(stateItem) do
        self.tagUserInfo[findidx][k] = v
    end

    ---- 判断状态
    if not self.isInGameRoom then return end 


    self:dispatchEvent({name = updateUIEvent.STATE_MODIFY, data = StateModifyType.Ready_State})
end

-- 修改积分
function pubInfo:modifyUserInfoScore(dwUserID, scoreItem)
    if stateItem == nil then return end 
    local finduser,findidx = self:findUserInfo(dwUserID)
    if finduser == nil or findidx == 0 then return end 

	self.tagUserInfo[findidx].lScore=scoreItem.lScore
	self.tagUserInfo[findidx].lInsureScore=scoreItem.lInsure
	self.tagUserInfo[findidx].lWinCount=scoreItem.dwWinCount
	self.tagUserInfo[findidx].lLostCount=scoreItem.dwLostCount
	self.tagUserInfo[findidx].lDrawCount=scoreItem.dwDrawCount
	self.tagUserInfo[findidx].lFleeCount=scoreItem.dwFleeCount
	self.tagUserInfo[findidx].lExperience=scoreItem.dwExperience
end

function pubInfo:addUserItem(item)
    print("pubInfo:addUserItem " .. item.dwUserID)
    local finduser,findidx = self:findUserInfo(item.dwUserID)

    if finduser ~= nil then
        for k, v in pairs(item) do
            self.tagUserInfo[findidx][k] = v
        end
    else
        table.insert(self.tagUserInfo, item)
    end
end

function pubInfo:getmeitem()
    local re = nil
    if #self.tagUserInfo > 0 then
        re = self.tagUserInfo[1]
    end
    return re
end

function pubInfo:setPrivateRoomInfo(info)
    self.privateRoomInfo = info
end

function pubInfo:getPrivateRoomInfo()
    return self.privateRoomInfo
end

function pubInfo:setCreateRoom(item)
    self.createRoom = item
end

function pubInfo:getCreateRoom()
    return self.createRoom
end

function pubInfo:setServiceStatus(ServiceStatus_)
    self.serviceState = ServiceStatus_
end

function pubInfo:getServiceStatus()
    return self.serviceState
end

function pubInfo:setGameStatus(state_)
    self.gameState = state_
end

function pubInfo:getGameStatus()
    return self.gameState
end

function pubInfo:Chair2Idx(ChairId)
    local me = self:getmeitem()
    if not me then
        return -1
    end
    return ( ChairId - me.wChairID ) % GAME_PLAYER + 1
end

--[[
//个人资料
struct TAG_UserIndividual
{
	dword							dwUserID;							//用户 I D

	std::string						kIP;
	std::string						kHttp;
	std::string						kChannel;
    double dLatitude;  //精度
    double dLongtitude; //纬度
	std::string						kGPS;
};

//用户信息  userItem 
struct tagUserInfo
{
	//基本属性
	dword							dwUserID;							//用户 I D

	char							szLogonIP[LEN_ACCOUNTS];			//登录IP
	char							szHeadHttp[LEN_USER_NOTE];			//头像HTTP

    double dLatitude;  //精度
    double dLongtitude; //纬度
    tchar szPosition[LEN_POSITION];//位置信息
};

]]
function pubInfo:modifyOtherInfo(TAG_UserIndividual)
    if TAG_UserIndividual == nil then return end 

    for i, useritem in pairs(self.tagUserInfo) do
        if useritem ~= nil then 

            --for j , UserIndividual in pairs(TAG_UserIndividual) do
                --if UserIndividual ~= nil then
                    if useritem.dwUserID == TAG_UserIndividual.dwUserID then 
                        self.tagUserInfo[i].szLogonIP = TAG_UserIndividual.kIP
                        self.tagUserInfo[i].szHeadHttp = TAG_UserIndividual.kHttp
                        self.tagUserInfo[i].dLatitude = TAG_UserIndividual.dLatitude
                        self.tagUserInfo[i].dLongtitude = TAG_UserIndividual.dLongtitude
                        self.tagUserInfo[i].szPosition = TAG_UserIndividual.kGPS
                    end
                --end
            --end

        end
    end
end

return pubInfo