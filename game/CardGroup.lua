local CardGroup = class("Card", cocosMake.Node)

function CardGroup:ctor(args)
    for i, v in pairs( args.cards ) do
        local c = new_class(loadlua.Card, { value=v } )
        c:setPosition( ( i - 1 ) * args.gap, 0 )
        self:addChild( c )
    end
    self.m_Exwidth = ( #args.cards - 1 ) * args.gap
    self:addChild( cocosMake.newLabel( #args.cards, #args.cards * args.gap - 50, -60 ):setColor(cc.c3b(255, 0, 0)) )
end

function CardGroup:setTouch(enable, touchEndCallback)
	local tbx,tby=0,0
	local x,y=self:getPosition()
	self.originalPosition = {x=x, y=y}
    local size = self:getContentSize()
	local parent = self:getParent()
	self.touchEnable = enable

    self.startTouchPos = {}

	local function onMyTouchBegan( touch,event )
        return true
    end

	local function onMyTouchEnded(touch,event)
        self:setPositionY( self:getPositionY() + 30 )
	end

	if self.touchEnable then
		local touchListen = cc.EventListenerTouchOneByOne:create()
		touchListen:registerScriptHandler(onMyTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
		touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
		touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_CANCELLED)
		
		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(touchListen,self)
	end
end


return CardGroup