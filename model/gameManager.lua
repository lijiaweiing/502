----------------------------------------------
-- 数据管理
----------------------------------------------

local GameManager = class("gameManager")

function GameManager:ctor( ... )

    self:init()
end

function GameManager:init()
    self.pubInfo = HotRequire(loadlua.pubInfo):create()    
    self.tableFrame = HotRequire(loadlua.TableFrame):create()
end


function GameManager:getpubInfo() 
    return self.pubInfo
end 


function GameManager:getTableFrame()
    return self.tableFrame
end

return GameManager