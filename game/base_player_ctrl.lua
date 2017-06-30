local basePlayerCtrl = class("basePlayerCtrl")
local this = basePlayerCtrl
basePlayerCtrl.pid = 0
basePlayerCtrl.nickName = ""
basePlayerCtrl.ip = "0.0.0.0"
basePlayerCtrl.sex = ""
basePlayerCtrl.localSite = 0
basePlayerCtrl.playerLayer = nil
local ui = {}

local function init(param)
	basePlayerCtrl.localSite = param.localSite
end


function basePlayerCtrl:ctor(param)
	init(param)
end

function basePlayerCtrl:initUI(data, isMajor, localSite)
	if isMajor then
    	self.playerLayer = new_class(loadlua.majorPlayerLayer,{ui=data,localSite=localSite})
        self.playerLayer:setTouch(true)
	else
	    self.playerLayer = new_class(loadlua.minorPlayerLayer,{ui=data,localSite=localSite})
	end
	--self.playerLayer:setVisible(false)
end

function basePlayerCtrl:setName(name)
    if self.playerLayer then
        self.playerLayer:setName( name )
    end
end

local function GetCardInfo(card)
    local number = bit._and( card, 15 )
    local color = bit._rshift( card, 4 )
    return number, color
end

function IsWangZha(group)
    if #group < 3 then
        return false
    end
    for i, v in pairs(group) do
        local number, color = GetCardInfo( v )
        if number > 1 then
            return false
        end
    end
    return true
end

-- 单炸
function IsDanZha(group)
    if #group < 3 then
        return false
    end
    local num = nil
    for i, v in pairs(group) do
        local number, color = GetCardInfo( v )
        if num == nil then
            num = number
        elseif number ~= num and number ~= 0 and number ~= 1 then
            return true
        end
    end
    
    return false
end

function GetBombValue(group)
    local ret = 0
    if IsWangZha(group) then
        local smalKing, bigKing = 0, 0
        for i, v in pairs(group) do
            if v == SMALL_KING then
                smalKing = smalKing + 1
            else
                bigKing = bigKing + 1
            end
        end
        if smalKing >= 4 or bigKing >= 4 then
            ret = ( ( smalKing + bigKing ) - 4 ) * 200 + 800 + ( (smalKing > bigKing) and 80 or 90 )
        elseif smalKing == 3 or bigKing == 3 then
            if ( smalKing + bigKing ) == 3 then
                ret = ( smalKing == 3 ) and 689 or 699
            else
                ret = 689 + ( smalKing + bigKing - 3 ) * 100
            end
        elseif ( smalKing + bigKing ) == 3 then
            ret = 599
        else
            ret = ( smalKing + bigKing - 3 ) * 100 + 699
        end
    elseif IsDanZha(group) then
        ret = ( #group - 3 ) * 100 + 700
    else
        local number, color = GetCardInfo( group[1] )
        ret = #group * 100 + number
    end
    return ret
end

function IsBomb(group)
    if IsDanZha(group) or IsWangZha(group) then
        return true
    end

    return #group >= 4
end

function basePlayerCtrl:CheckIsBomb(group)
    return IsBomb(group)
end

function basePlayerCtrl:getBombCount(group)
    local v = GetBombValue(group)
    return math.floor(v / 100)
end

-- 比较牌的大小, a > b 返回true
function Compare(a, b)
    if IsBomb(a) and IsBomb(b) then
        return GetBombValue(a) > GetBombValue(b)
    elseif IsBomb(a) and not IsBomb(b) then
        return true
    elseif ( not IsBomb(a) ) and IsBomb(b) then
        return false
    elseif #a ~= #b then
        return false
    else
        local na = GetCardInfo( a[1] )
        local nb = GetCardInfo( b[1] )
        na = (na < 2) and (na + 16) or na
        nb = (nb < 2) and (nb + 16) or nb
        return na > nb
    end
end

function sortFunc(a, b)
    if Compare( a, b ) then
        return true
    end
    if Compare( b, a ) then
        return false
    end
    return #a > #b
end

function basePlayerCtrl:CanEat( a, b )
    if not a then
        return false
    end
    if not b then
        return true
    end
    if Compare( a, b ) then
        return true
    end
    return false
end

function basePlayerCtrl:GetEatIdx( group )
    if group then
        for i = #self.m_Groups, 1, -1 do
            if Compare( self.m_Groups[i], group ) then
                return i
            end
        end
    else
        return #self.m_Groups
    end
end

function basePlayerCtrl:passCard()
    if self.playerLayer then
        self.playerLayer:passCard()
    end
end

function basePlayerCtrl:GroupCards(cards)
    local roomInfo = gameManager:getpubInfo():getPrivateRoomInfo()
    local rule = 0
    if roomInfo then
        rule = roomInfo.bGameRuleIdex
    end
    local booDanjiang = false;
    if bit._and(rule , GAME_RULE_DANPAIJIANG) > 0 then
        booDanjiang = true
    end

    local cCount = {}
    for i, v in ipairs( cards ) do
        local number, color = GetCardInfo( v )
        if not cCount[number] then
            cCount[number] = {}
        end
        table.insert( cCount[number], v )
    end

    local Groups = {}
    local KingGroup = {}
    local SingalGroup = {}
    if cCount[0] then
        for i, v in pairs(cCount[0]) do
            table.insert( KingGroup, v )
        end
    end
    if cCount[1] then
        for i, v in pairs(cCount[1]) do
            table.insert( KingGroup, v )
        end
    end
    if #KingGroup >= 3 then
        table.insert( Groups, KingGroup )
        cCount[0] = nil
        cCount[1] = nil
    end

    if booDanjiang then
        for i, v in pairs(cCount) do
            if #v == 1 then
                for j, w in pairs(v) do
                    table.insert( SingalGroup, w )
                end
            end
        end
    end
    if #SingalGroup >= 3 then
        table.insert( Groups, SingalGroup )
        for i, v in pairs( SingalGroup ) do
            local number, color = GetCardInfo( v )
            cCount[number] = nil
        end
    end

    for i, v in pairs( cCount ) do
        local group = {};
        for j, w in pairs(v) do
            table.insert( group, w )
        end
        table.insert( Groups, group )
    end

    table.sort( Groups, sortFunc )

    return Groups
end

function basePlayerCtrl:setCards(cards)
    self.m_cards = cards
    if self.playerLayer then
        self.m_Groups = self:GroupCards( cards )
        self.playerLayer:setCardGroup( self.m_Groups )
        self.playerLayer:setActive(true)
    end
end

function basePlayerCtrl:setActive(booActive)
    self.playerLayer:setActive(booActive)
end

function basePlayerCtrl:removeGroup(idx)
    table.remove( self.m_Groups, idx )
    self.playerLayer:setCardGroup( self.m_Groups )
end

function basePlayerCtrl:getCardGroups()
    return self.m_Groups
end

function basePlayerCtrl:outCard(cards)
    self.playerLayer:outCard(cards)
end

return basePlayerCtrl