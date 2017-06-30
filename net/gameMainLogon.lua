-------------------------------------------------
-- 登录消息
-------------------------------------------------

local gameMainLogon = class("gameMainLogon", HotRequire(luafile.CtrlBase))


function gameMainLogon:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainLogon:init()
    
end

--		//登录消息
function gameMainLogon:OnSocketMainLogon(wMainCmdID, wSubCmdID, packet)

    if wSubCmdID == SUB_GR_LOGON_SUCCESS then
--		//登录成功 100
        self:OnSocketSubLogonSuccess(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID ==  SUB_GR_LOGON_FAILURE then
--		//登录失败 101
    	self:OnSocketSubLogonFailure(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID ==  SUB_GR_LOGON_FINISH then
--		//登录完成 102
    	self:OnSocketSubLogonFinish(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID ==  SUB_GR_UPDATE_NOTIFY then
--		//更新提示 200
    	self:OnSocketSubUpdateNotify(wMainCmdID, wSubCmdID, packet)
    end
end

--		//登录成功
function gameMainLogon:OnSocketSubLogonSuccess(wMainCmdID, wSubCmdID, packet)
    gameManager:getpubInfo():setServiceStatus(ServiceStatus_RecvInfo)

--[[
//登录成功消息
struct CMD_GR_LogonSuccess
{
//	unsigned int					dwUserID;							//用户 I D
	dword							dwUserRight;						//用户权限
	dword							dwMasterRight;						//管理权限
};
]]

    local CMD_GR_LogonSuccess = {}
    CMD_GR_LogonSuccess.dwUserID = 0
    CMD_GR_LogonSuccess.dwUserRight = 0
    CMD_GR_LogonSuccess.dwMasterRight = 0

    local len, dwUserID, dwUserRight, dwMasterRight = string.unpack( packet, "III")
    CMD_GR_LogonSuccess.dwUserID = dwUserID
    CMD_GR_LogonSuccess.dwUserRight = dwUserRight
    CMD_GR_LogonSuccess.dwMasterRight = dwMasterRight


    gameManager:getpubInfo():getmeitem(true)

    -- 不直接显示
    --LayerManager.show("game.game_layer")
end
--		//登录失败

function gameMainLogon:OnSocketSubLogonFailure(wMainCmdID, wSubCmdID, packet)
--[[
//登录失败
struct CMD_GR_LogonError
{
	unsigned int					lErrorCode;							//错误代码
	char							szErrorDescribe[128];				//错误消息
};
]]
    local CMD_GR_LogonError = {}
    CMD_GR_LogonError.lErrorCode = 0
    CMD_GR_LogonError.szErrorDescribe = ""

    local len, lErrorCode = string.unpack( packet, "I")
    packet = string.sub( packet, len )

    CMD_GR_LogonError.lErrorCode = lErrorCode

    CMD_GR_LogonError.szErrorDescribe, packet = pubFun.ReadString( packet, 128 )
    gameManager:getpubInfo():getmeitem(false)

    TipView:showTip(CMD_GR_LogonError.szErrorDescribe, TipView.tipType.ERROR)
--[[
	if (mIStringMessageSink)
	{
		mIStringMessageSink->InsertSystemString(pGameServer->szErrorDescribe);
	}
	
	//关闭连接
	IntermitConnect(true);
]]


end
--		//登录完成

function gameMainLogon:OnSocketSubLogonFinish(wMainCmdID, wSubCmdID, packet)
    gameManager:getpubInfo():setServiceStatus(ServiceStatus_ServiceIng)

    local userdata = UserManager:getUserInfo():getData()
    if userdata == nil then return end 

    local mUserAttribute = {}
    mUserAttribute.dwUserID = userdata.dwUserID
    mUserAttribute.wChairID = INVALID_CHAIR
    mUserAttribute.wTableID = INVALID_TABLE

    gameManager:getpubInfo():getmeitem(true)
    self:SitDown()
end

function gameMainLogon:SitDown()
--[[ 
//查找桌子
struct tagFindTable
{
	bool								bOneNull;							//一个空位
	bool								bTwoNull;							//两个空位
	bool								bAllNull;							//全空位置
	bool								bNotFull;							//不全满位
	bool								bFilterPass;						//过滤密码
	word								wBeginTableID;						//开始索引
	word								wResultTableID;						//结果桌子
	word								wResultChairID;						//结果椅子
};
]]
    local tagFindTable = {}

    
    tagFindTable.bOneNull = 0--							//一个空位
    tagFindTable.bTwoNull = 0--;							//两个空位
    tagFindTable.bAllNull = 0--;							//全空位置
    tagFindTable.bNotFull = 0--;							//不全满位
    tagFindTable.bFilterPass = 0--;						//过滤密码
    tagFindTable.wBeginTableID = 0--;						//开始索引
    tagFindTable.wResultTableID = 0--;						//结果桌子
    tagFindTable.wResultChairID = 0--;						//结果椅子


--[[
//请求坐下
struct CMD_GR_UserSitDown
{
	word							wTableID;							//桌子位置
	word							wChairID;							//椅子位置
	char							szTablePass[PASS_LEN];				//桌子密码
};

]]

    local CMD_GR_UserSitDown = {}
    CMD_GR_UserSitDown.wTableID= INVALID_TABLE--							//桌子位置
    CMD_GR_UserSitDown.wChairID= INVALID_CHAIR--;							//椅子位置
    CMD_GR_UserSitDown.szTablePass= ""--[PASS_LEN];				//桌子密码

    local s = string.pack( "HH", CMD_GR_UserSitDown.wTableID,CMD_GR_UserSitDown.wChairID)
    s = s .. pubFun.FillString( szPassword, LEN_PASSWORD )


    -- maincmd 3  subcmd 3
    self:SendGamePack(MDM_GR_USER,SUB_GR_USER_SITDOWN,s);
end


--		//更新提示

function gameMainLogon:OnSocketSubUpdateNotify(wMainCmdID, wSubCmdID, packet)
    ------- 没用

end

return gameMainLogon


