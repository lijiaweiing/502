---------------------------------------------------
-- 游戏桌子
---------------------------------------------------


local TableFrame = class("TableFrame")


-- 构造函数
function TableFrame:ctor( ... )
    self.data = {}
end


function TableFrame:getdata()
    return self.data
end

function TableFrame:setdata(tab)
    for k,v in pairs(tab) do
		self.data[k]=v
	end
end

return TableFrame