-------------------------------------------------
-- 配置信息
-------------------------------------------------

local gameMainConfig = class("gameMainConfig",HotRequire(luafile.CtrlBase))

function gameMainConfig:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainConfig:init()

end

--		//配置信息
function gameMainConfig:OnSocketMainConfig(wMainCmdID, wSubCmdID, packet)


	if wSubCmdID == SUB_GR_CONFIG_COLUMN then
--		//列表配置   100
         self:OnSocketSubConfigColumn(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_CONFIG_SERVER then
--		//房间配置  101
        self:OnSocketSubConfigServer(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_CONFIG_PROPERTY then 
--		//道具配置  102
        self:OnSocketSubConfigOrder(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_CONFIG_USER_RIGHT then
--		//配置玩家权限	103
        self:OnSocketSubConfigMmber(wMainCmdID, wSubCmdID, packet)

	elseif wSubCmdID == SUB_GR_CONFIG_FINISH then 
--		//配置完成   104
        self:OnSocketSubConfigFinish(wMainCmdID, wSubCmdID, packet)
    end

end


function gameMainConfig:OnSocketSubConfigColumn(wMainCmdID, wSubCmdID, packet)
    -- 没用
end


function gameMainConfig:OnSocketSubConfigServer(wMainCmdID, wSubCmdID, packet)
--[[
//房间配置
struct CMD_GR_ConfigServer
{
	//房间属性
	word							wTableCount;						//桌子数目
	word							wChairCount;						//椅子数目

	//房间配置
	word							wServerType;						//房间类型
	dword							dwServerRule;						//房间规则
};
]]

    local CMD_GR_ConfigServer = {}

    CMD_GR_ConfigServer.wTableCount = 0
    CMD_GR_ConfigServer.wChairCount = 0
    CMD_GR_ConfigServer.wServerType = 0
    CMD_GR_ConfigServer.dwServerRule = 0

    local len, wTableCount, wChairCount, wServerType,dwServerRule = string.unpack( packet, "HHHI")


    CMD_GR_ConfigServer.wTableCount = wTableCount
    CMD_GR_ConfigServer.wChairCount = wChairCount
    CMD_GR_ConfigServer.wServerType = wServerType
    CMD_GR_ConfigServer.dwServerRule = dwServerRule


    local mUserAttribute = {}
    mUserAttribute.wTableCount = wTableCount
    mUserAttribute.wChairCount = wChairCount

    --创建桌子  
    local tableframe = gameManager:getTableFrame()

    if tableframe == nil then return end 
    tableframe:setdata(mUserAttribute)
end


function gameMainConfig:OnSocketSubConfigOrder(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

function gameMainConfig:OnSocketSubConfigMmber(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

function gameMainConfig:OnSocketSubConfigFinish(wMainCmdID, wSubCmdID, packet)
    -- 没用
end

return gameMainConfig

