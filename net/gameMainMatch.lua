-------------------------------------------------
-- 比赛消息
-------------------------------------------------

local gameMainMatch = class("gameMainMatch", HotRequire(luafile.CtrlBase))


function gameMainMatch:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainMatch:init()

end



--		//比赛消息
function gameMainMatch:OnSocketMainMatch(wMainCmdID, wSubCmdID, packet)

	--//费用查询
	if wSubCmdID == SUB_GR_MATCH_FEE then 
        self:OnSocketSubMatchFee(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_NUM then 
        self:OnSocketSubMatchNum(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_INFO then
        self:OnSocketSubMatchInfo(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_WAIT_TIP then 
        self:OnSocketSubWaitTip(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_RESULT then 
        self:OnSocketSubMatchResult(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_STATUS then 
        self:OnSocketSubMatchStatus(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_GOLDUPDATE then 
        self:OnSocketSubMatchGoldUpdate(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_ELIMINATE then 
        self:OnSocketSubMatchEliminate(wMainCmdID, wSubCmdID, packet)
	elseif wSubCmdID ==  SUB_GR_MATCH_JOIN_RESOULT then 
        self:OnSocketSubMatchJoinResoult(wMainCmdID, wSubCmdID, packet)
    end

end

function gameMainMatch:OnSocketSubMatchFee(wMainCmdID, wSubCmdID, packet)
--[[

//费用提醒
struct CMD_GR_Match_Fee
{
	SCORE							lMatchFee;							//报名费用
	char							szNotifyContent[128];				//提示内容
};
]]
    
    local CMD_GR_Match_Fee = {}

    CMD_GR_Match_Fee.lMatchFee = 0--							//报名费用
    CMD_GR_Match_Fee.szNotifyContent = ""--[128];				//提示内容

    local len, lMatchFee = string.unpack( packet, "d")
    packet = string.sub( packet, len )

    CMD_GR_Match_Fee.lMatchFee = lMatchFee

    CMD_GR_Match_Fee.szNotifyContent, packet = pubFun.ReadString( packet, 128 )



end

function gameMainMatch:OnSocketSubMatchNum(wMainCmdID, wSubCmdID, packet)
--[[
//比赛人数
struct CMD_GR_Match_Num
{
	dword							dwWaitting;							//等待人数
	dword							dwTotal;							//开赛人数
};
]]

    local CMD_GR_Match_Num = {}

    CMD_GR_Match_Num.dwWaitting = 0--							//等待人数
    CMD_GR_Match_Num.dwTotal = 0--							//开赛人数

    local len, dwWaitting, dwTotal = string.unpack( packet, "d")
    CMD_GR_Match_Num.dwWaitting = dwWaitting--							//等待人数
    CMD_GR_Match_Num.dwTotal = dwTotal--							//开赛人数

end

function gameMainMatch:OnSocketSubMatchInfo(wMainCmdID, wSubCmdID, packet)
--[[
//赛事信息
struct CMD_GR_Match_Info
{
	char							szTitle[4][64];						//信息标题
	word							wGameCount;							//游戏局数
	word							wRank;								//当前名次
};
]]
    local CMD_GR_Match_Info = {}


    
    CMD_GR_Match_Info.szTitle = {} --[4][64];						//信息标题
    CMD_GR_Match_Info.wGameCount = 0--							//游戏局数
    CMD_GR_Match_Info.wRank = 0 --								//当前名次



    for i = 1, 4, 1 do
        
        local desc = ""
        desc, packet = pubFun.ReadString( packet, 60 )

        table.insert(CMD_GR_Match_Info.szTitle, desc)

    end


    local len, wGameCount, wRank = string.unpack( packet, "HH")

    CMD_GR_Match_Info.wGameCount = wGameCount--							//游戏局数
    CMD_GR_Match_Info.wRank = wRank --								//当前名次

end

function gameMainMatch:OnSocketSubWaitTip(wMainCmdID, wSubCmdID, packet)
--[[
//提示信息
struct CMD_GR_Match_Wait_Tip
{
	SCORE							lScore;								//当前积分
	word							wRank;								//当前名次
	word							wCurTableRank;						//本桌名次
	word							wUserCount;							//当前人数
	word							wCurGameCount;						//当前局数
	word							wGameCount;							//总共局数
	word							wPlayingTable;						//游戏桌数
	char							szMatchName[LEN_SERVER];			//比赛名称
};
]]

    local CMD_GR_Match_Wait_Tip = {}



    CMD_GR_Match_Wait_Tip.lScore = 0 --								//当前积分
    CMD_GR_Match_Wait_Tip.wRank = 0 --								//当前名次
    CMD_GR_Match_Wait_Tip.wCurTableRank = 0 --						//本桌名次
    CMD_GR_Match_Wait_Tip.wUserCount = 0 --							//当前人数
    CMD_GR_Match_Wait_Tip.wCurGameCount = 0 --						//当前局数
    CMD_GR_Match_Wait_Tip.wGameCount = 0 --							//总共局数
    CMD_GR_Match_Wait_Tip.wPlayingTable = 0 --						//游戏桌数
    CMD_GR_Match_Wait_Tip.szMatchName = "" --[LEN_SERVER];			//比赛名称


    local len, lScore, wRank, wCurTableRank, wUserCount, wCurGameCount, wGameCount, wPlayingTable = string.unpack( packet, "dH6")
    CMD_GR_Match_Wait_Tip.lScore = lScore --								//当前积分
    CMD_GR_Match_Wait_Tip.wRank = wRank --								//当前名次
    CMD_GR_Match_Wait_Tip.wCurTableRank = wCurTableRank --						//本桌名次
    CMD_GR_Match_Wait_Tip.wUserCount = wUserCount --							//当前人数
    CMD_GR_Match_Wait_Tip.wCurGameCount = wCurGameCount --						//当前局数
    CMD_GR_Match_Wait_Tip.wGameCount = wGameCount --							//总共局数
    CMD_GR_Match_Wait_Tip.wPlayingTable = wPlayingTable --						//游戏桌数

    packet = string.sub( packet, len )

    CMD_GR_Match_Wait_Tip.szMatchName, packet = pubFun.ReadString( packet, LEN_SERVER )

end

function gameMainMatch:OnSocketSubMatchResult(wMainCmdID, wSubCmdID, packet)
--[[
//比赛结果
struct CMD_GR_MatchResult
{	
	SCORE							lGold;								//金币奖励
	dword							dwIngot;							//元宝奖励
	dword							dwExperience;						//经验奖励
	char							szDescribe[256];					//得奖描述
};
		
]]
    local CMD_GR_MatchResult = {}


    CMD_GR_MatchResult.lGold = 0--								//金币奖励
    CMD_GR_MatchResult.dwIngot = 0--							//元宝奖励
    CMD_GR_MatchResult.dwExperience = 0--						//经验奖励
    CMD_GR_MatchResult.szDescribe = ""--[256];					//得奖描述

    local len, lGold, dwIngot, dwExperience = string.unpack( packet, "dII")
    packet = string.sub( packet, len )

    CMD_GR_MatchResult.lGold = lGold--								//金币奖励
    CMD_GR_MatchResult.dwIngot = dwIngot--							//元宝奖励
    CMD_GR_MatchResult.dwExperience = dwExperience--						//经验奖励

    CMD_GR_MatchResult.szDescribe, packet = pubFun.ReadString( packet, 256 )
end
	
function gameMainMatch:OnSocketSubMatchStatus(wMainCmdID, wSubCmdID, packet)
    -- 不用
end
	
function gameMainMatch:OnSocketSubMatchGoldUpdate(wMainCmdID, wSubCmdID, packet)
--[[
//金币更新
struct CMD_GR_MatchGoldUpdate
{
	SCORE							lCurrGold;							//当前金币
	SCORE							lCurrIngot;							//当前元宝
	dword							dwCurrExprience;					//当前经验
};
]]
  
    local CMD_GR_MatchGoldUpdate = {}

	CMD_GR_MatchGoldUpdate.lCurrGold = 0 --							//当前金币
	CMD_GR_MatchGoldUpdate.lCurrIngot = 0 --							//当前元宝
	CMD_GR_MatchGoldUpdate.dwCurrExprience = 0 --				//当前经验
    
    local len, lCurrGold, lCurrIngot, dwCurrExprience = string.unpack( packet, "ddI")
	CMD_GR_MatchGoldUpdate.lCurrGold = lCurrGold --							//当前金币
	CMD_GR_MatchGoldUpdate.lCurrIngot = lCurrIngot --							//当前元宝
	CMD_GR_MatchGoldUpdate.dwCurrExprience = dwCurrExprience --				//当前经验




end
	
function gameMainMatch:OnSocketSubMatchEliminate(wMainCmdID, wSubCmdID, packet)
    -- 不用
end
	
function gameMainMatch:OnSocketSubMatchJoinResoult(wMainCmdID, wSubCmdID, packet)
--[[
//费用提醒
struct CMD_GR_Match_JoinResoult
{
	word							wSucess;
};
]]
    local CMD_GR_Match_JoinResoult = {}

    CMD_GR_Match_JoinResoult.wSucess = 0

    local len, wSucess = string.unpack( packet, "H")

    CMD_GR_Match_JoinResoult.wSucess = wSucess


end

return gameMainMatch
