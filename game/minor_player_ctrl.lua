local minorPlayerCtrl = class("minorPlayerCtrl", HotRequire(loadlua.basePlayerCtrl))


function minorPlayerCtrl:initHandCards(count)
	self.playerLayer:initHandCards(count)
end


function minorPlayerCtrl:reSetHandCards(count)
	self.playerLayer:reSetHandCards(count)
end

function minorPlayerCtrl:addPlayedCard(OutCardData)
	self.playerLayer:addPlayedCard(OutCardData)
end

function minorPlayerCtrl:reSetPlayedCard(cards)
	self.playerLayer:reSetPlayedCard(cards)
end


function minorPlayerCtrl:showSendCard(sendcard)
	self.playerLayer:showSendCard(sendcard)
end

function minorPlayerCtrl:showOperateCard(cards)
	self.playerLayer:showOperateCard(cards)
end

return minorPlayerCtrl