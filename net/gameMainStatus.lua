-------------------------------------------------
-- 状态信息
-------------------------------------------------

local gameMainStatus = class("gameMainStatus", HotRequire(luafile.CtrlBase))


function gameMainStatus:ctor(...)
	self.super.ctor(self, ... )
	self:init()
end

function gameMainStatus:init()

end


--		//状态信息
function gameMainStatus:OnSocketMainStatus(wMainCmdID, wSubCmdID, packet)
    --//桌子信息   100
    if wSubCmdID == SUB_GR_TABLE_INFO then  
        self:OnSocketSubStatusTableInfo(wMainCmdID, wSubCmdID, packet)
    elseif wSubCmdID == SUB_GR_TABLE_STATUS then
    --/桌子状态   101
        self:OnSocketSubStatusTableStatus(wMainCmdID, wSubCmdID, packet)
    end

end

--		//桌子信息
function gameMainStatus:OnSocketSubStatusTableInfo(wMainCmdID, wSubCmdID, packet)
    --没用
end
--		//桌子状态
function gameMainStatus:OnSocketSubStatusTableStatus(wMainCmdID, wSubCmdID, packet)
    -- 没用
end


return gameMainStatus
