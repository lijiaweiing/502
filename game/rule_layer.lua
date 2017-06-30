--------------------------------------
-- 创建规则 控件
--------------------------------------

HotRequire("games.502.gamedefine")

local RuleLayer = class("RuleLayer", cocosMake.viewBase)

RuleLayer.ui_resource_file = {"gamesres/502/form_502/CreateRoom.csb"}

RuleLayer.ui_binding_file = {
	CheckBox_1 = {event = "click", method = "CheckBox_1Click"},
    CheckBox_2 = {event = "click", method = "CheckBox_2Click"},
    CheckBox_3 = {event = "click", method = "CheckBox_3Click"},
    CheckBox_4 = {event = "click", method = "CheckBox_4Click"},
    CheckBox_5 = {event = "click", method = "CheckBox_5Click"},
    CheckBox_6 = {event = "click", method = "CheckBox_6Click"},
	CheckBox_7 = {event = "click", method = "CheckBox_7Click"},
    CheckBox_8 = {event = "click", method = "CheckBox_8Click"},
    CheckBox_9 = {event = "click", method = "CheckBox_9Click"},
    CheckBox_10 = {event = "click", method = "CheckBox_10Click"},
}

function RuleLayer:ctor()
    self.super.ctor(self)
    self.rule = 0
    self.playerCountIdx = 0
end


function RuleLayer:init()

end

function RuleLayer:getrule()
    return self.playerCountIdx, self.rule
end

function RuleLayer:_MASK_(v)
    return 1 * 2^v;
end

function RuleLayer:Add(v)
    local v1 = self:_MASK_(v)

    self.rule = bit._or(self.rule , v1)
end

function RuleLayer:InitRule()

    self.playerCountIdx = 0
    if self.CheckBox_2:isSelected() then
        self.playerCountIdx = 1
    end

    self.rule = 0
    if self.CheckBox_4:isSelected() then --同色加一奖
        self.rule = bit._or(self.rule , GAME_RULE_TONGSEJIAYI)
    elseif self.CheckBox_5:isSelected() then --同色加N奖
        self.rule = bit._or(self.rule , GAME_RULE_TONGSEJIAN)
    end

    if self.CheckBox_7:isSelected() then -- 顺奖连一奖
        self.rule = bit._or(self.rule , GAME_RULE_SHUNJIANGLIANYI)
    elseif self.CheckBox_8:isSelected() then -- 顺奖连N奖
        self.rule = bit._or(self.rule , GAME_RULE_SHUNJIANGLIANN)
    end

    if self.CheckBox_9:isSelected() then -- 单牌奖
        self.rule = bit._or(self.rule , GAME_RULE_DANPAIJIANG)
    end

    if self.CheckBox_10:isSelected() then -- 独奖
        self.rule = bit._or(self.rule , GAME_RULE_DUJIANG)
    end
end

function RuleLayer:CheckBox_1Click()
    local check = self.CheckBox_1:isSelected()

    if check then
        self.CheckBox_2:setSelectedState(false)
    end

    self:InitRule()
end

function RuleLayer:CheckBox_2Click()
    local check = self.CheckBox_2:isSelected()

    if check then
        self.CheckBox_1:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_3Click()
    local check = self.CheckBox_3:isSelected()

    if check then
        self.CheckBox_4:setSelectedState(false)
        self.CheckBox_5:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_4Click()
    local check = self.CheckBox_4:isSelected()

    if check then
        self.CheckBox_3:setSelectedState(false)
        self.CheckBox_5:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_5Click()
    local check = self.CheckBox_5:isSelected()

    if check then
        self.CheckBox_3:setSelectedState(false)
        self.CheckBox_4:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_6Click()
    local check = self.CheckBox_6:isSelected()

    if check then
        self.CheckBox_7:setSelectedState(false)
        self.CheckBox_8:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_7Click()
    local check = self.CheckBox_7:isSelected()

    if check then
        self.CheckBox_6:setSelectedState(false)
        self.CheckBox_8:setSelectedState(false)
    end
    self:InitRule()
end

function RuleLayer:CheckBox_8Click()
    local check = self.CheckBox_8:isSelected()

    if check then
        self.CheckBox_6:setSelectedState(false)
        self.CheckBox_7:setSelectedState(false)
    end
    self:InitRule()
end


function RuleLayer:CheckBox_9Click()
    self:InitRule()
end


function RuleLayer:CheckBox_10Click()
    self:InitRule()
end


return RuleLayer