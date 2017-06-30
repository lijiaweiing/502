local majorPlayerCtrl = class("majorPlayerCtrl", HotRequire(loadlua.basePlayerCtrl))


function majorPlayerCtrl:initHandCards(data)
	self.playerLayer:initHandCards(data)
end

function majorPlayerCtrl:reSetHandCards(data)
	self.playerLayer:reSetHandCards(data)
end


function majorPlayerCtrl:addPlayedCard(OutCardData)
	self.playerLayer:addPlayedCard(OutCardData)
end

function majorPlayerCtrl:reSetPlayedCard(cards)
	self.playerLayer:reSetPlayedCard(cards)
end

function majorPlayerCtrl:showSendCard(sendcard)
	self.playerLayer:showSendCard(sendcard)
end

function majorPlayerCtrl:showOperateTool(operdata)
	self.playerLayer:showOperateTool(operdata)
end

function majorPlayerCtrl:setTouchEnable(enable)
	self.playerLayer:setTouchEnable(enable)
end

function majorPlayerCtrl:showOperateCard(cards)
	self.playerLayer:showOperateCard(cards)
end

function majorPlayerCtrl:setOutput(groupIdx)
    local groups = self:getCardGroups()
    local booCanEat = false
    if groupIdx and groups[groupIdx] then
        booCanEat = self:CanEat( groups[groupIdx], GameLogicCtrl:getMaxCards() ) and true or false
    end

    self.playerLayer:setOutput(groupIdx, booCanEat)
end

function majorPlayerCtrl:outCard(cards)
    self.playerLayer:outCard(cards)
end

function majorPlayerCtrl:setActive(booActiv)
    self.playerLayer:setActive(booActiv)
end

return majorPlayerCtrl