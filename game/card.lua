--------------------------------------------------
-- 麻将牌 类
--------------------------------------------------

--[[

//麻将数据
//这里定义了所有的麻将数据
//在游戏初始化时用
const BYTE CGameLogic::m_cbCardDataArray[MAX_REPERTORY]=
{
	0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,	//方块 3 -  A -2
	0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,	//梅花 3 -  A -2
	0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,	//红桃 3 -  A -2
	0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,	//黑桃 3 -  A -2
	0x40,0x51,// 小王 大王
};
]]

local Card = class("Card", cocosMake.Node)


function Card:ctor(args)
    self.m_Selected = false
    self.m_cardValue = args.value
    local Img = cocosMake.newSprite("res/gamesres/502/res_502/card/poker_bg_big.png")

	local function onMyTouchEnded(touch,event)
        local pos = touch:getLocation()
        self:setPosition( pos )
	end

    self:addChild( Img )
    local number = bit._and( self.m_cardValue, 15 )
    local color = bit._rshift( self.m_cardValue, 4 )
    local str
    local x, y, yy = 43, 60, 25
    if color == 0 or color == 2 then
        if number > 10 and number < 14 then
            -- J Q K
            str = string.format( "res/gamesres/502/res_502/card/red_p%d_big.png", number )
            Img = cocosMake.newSprite(str)
            self:addChild( Img )
        end
        str = string.format( "res/gamesres/502/res_502/card/red_%d_big.png", number )
    elseif color < 4 then
        if number > 10 and number < 14 then
            str = string.format( "res/gamesres/502/res_502/card/black_p%d_big.png", number )
            Img = cocosMake.newSprite(str)
            self:addChild( Img )
        end
        str = string.format( "res/gamesres/502/res_502/card/black_%d_big.png", number )
    elseif color == 4 then
        str = "res/gamesres/502/res_502/card/small_joker_big.png"
    else
        str = "res/gamesres/502/res_502/card/red_joker_big.png"
    end
    if color < 4 then
        -- 数字
        Img = cocosMake.newSprite(str)
        Img:setPosition( -x, y )
        self:addChild( Img )
        Img = cocosMake.newSprite(str)
        Img:setRotation( 180 )
        Img:setPosition( x, -y )
        self:addChild( Img )
        -- 花色
        str = string.format( "res/gamesres/502/res_502/card/color_%d.png", color )
        Img = cocosMake.newSprite(str)
        Img:setPosition( -x, yy )
        self:addChild( Img )
        Img = cocosMake.newSprite(str)
        Img:setRotation( 180 )
        Img:setPosition( x, -yy )
        self:addChild( Img )
    else
        -- 王
        Img = cocosMake.newSprite(str)
        self:addChild( Img )
    end
end

function Card:getSize()
	local sx = self:getScaleX() or 1
    local sy = self:getScaleY() or 1
	local size = self:getContentSize()
	size.width = size.width * sx
	size.height = size.height * sy
	return size
end

function Card:resetPos()
	--if not self.resetIndex then
		self:setPosition(self.originalPosition.x, self.originalPosition.y)	
	--end
	--self.resetIndex = true
end

function Card:setTouch(enable, touchEndCallback)
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

function Card:setPos(x,y)
	self:setPosition(x, y)

    self.originalPosition = cc.p(x or 0, y or 0)
end

function Card:setTouchEnable(b)
	self.touchEnable = b
end

return Card