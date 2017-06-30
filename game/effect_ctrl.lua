------------------------------------
-- desc:效果控制器
------------------------------------
local CtrlBase = HotRequire(luafile.CtrlBase)
local EffectCtrl = class("EffectCtrl", CtrlBase)

function EffectCtrl:ctor(...)
    CtrlBase.ctor(self,...)
end

function EffectCtrl:Init()
    CtrlBase.Init(self)

end

function EffectCtrl:InitView()
    self.root = GameLogicCtrl:GetGameRoot()
    self.model = GameLogicCtrl:GetModel()
    self.panel_common = GameLogicCtrl:GetGamePanelCommon()
    self.fly_card = GameLogicCtrl:GetFlyCard()
    self.fly_card:setVisible(false)
    self.fly_zhu = GameLogicCtrl:GetFlyZhu()
    self.fly_zhu:setVisible(false)
    self.fly_word = GameLogicCtrl:GetFlyWord()
    self.fly_word:setVisible(false)
    self.panel_result = GameLogicCtrl:GetPanelResult()
    self.panel_result:setVisible(false)
    self.full_result = GameLogicCtrl:GetFullResult()
    self.full_result:setVisible(false)
    self.panel_common_result = GameLogicCtrl:GetPanelCommonResult()
    self.panel_common_result:setVisible(false)
    self.bet_fly_num = 0
end

function EffectCtrl:Clear()
    CtrlBase.Clear(self)
    self:RemoveWinPokerEffect()
    
    

    self.root = nil
    self.panel_common = nil
    self.bet_fly_num = 0
end

-- 添加卡牌翻转特效
function EffectCtrl:AddCardTrunEffect(img,card,callback,need_destroy)
    if not img then
        return
    end
    if need_destroy == nil then
        need_destroy = false
    end
    
    local function scale_max()
        if need_destroy then
            img:removeFromParent()
            img = nil
        end
        if callback then
            callback()
        end
    end

    local function scale_min()
        img:stopAllActions()
        img:loadTexture(UrlHelp:GetCardsUrl(card))
        local action_list = {}
        action_list[#action_list + 1] = cc.ScaleTo:create(GameConsts.CARD_TURN_TIME,1,1)
        action_list[#action_list + 1] = cc.CallFunc:create(scale_max)
        local action = cc.Sequence:create(unpack(action_list))
        img:runAction(action)
    end

    img:stopAllActions()
    local action_list = {}
    action_list[#action_list + 1] = cc.ScaleTo:create(GameConsts.CARD_TURN_TIME,0,1)
    action_list[#action_list + 1] = cc.CallFunc:create(scale_min)
    local action = cc.Sequence:create(unpack(action_list))
    img:loadTexture(UrlHelp:GetCardsUrl("default"))
    img:runAction(action)
end

function EffectCtrl:AddCardFlyEffect(target_pos,effect_callback,need_destroy)
    local img = self.fly_card:clone()
    img:setPosition(cc.p(self.fly_card:getPosition()))
    img:setVisible(true)
    self.fly_card:getParent():addChild(img)

    local move_end = function()
        --if need_destroy then
            img:removeFromParent()
            img = nil
       -- end
        if effect_callback then
            --effect_callback(img)
			effect_callback()
        end
    end

    local action_list = {}
    local moveTo = cc.MoveTo:create(GameConsts.CARD_FLY_TIME,target_pos)
    --action_list[#action_list + 1] = cc.EaseExponentialOut:create(moveTo)
    action_list[#action_list + 1] = moveTo
    action_list[#action_list + 1] = cc.FadeOut:create(GameConsts.CARD_FLY_FADE_OUT_TIME)
    action_list[#action_list + 1] = cc.CallFunc:create(move_end)
    local action = cc.Sequence:create(unpack(action_list))
    img:runAction(action)
end

-- 添加筹码飞的特效
function EffectCtrl:AddBetFlyEft(src_pos,callback)
    local target_pos = cc.p(self.fly_zhu:getPosition())
    local arrive_num = 0

    local one_bet_fly = function()
        local img = self.fly_zhu:clone()
        img:setPosition(src_pos)
        img:setVisible(true)
        self.fly_card:getParent():addChild(img)

        local move_end = function()
            arrive_num = arrive_num + 1
            img:stopAllActions()
            img:removeFromParent()
            img = nil
            if arrive_num >= GameConsts.ZHU_FLY_NUM and callback then
                self.bet_fly_num = self.bet_fly_num - 1
                callback()
            end
        end

        local action_list = {}
        local moveTo = cc.MoveTo:create(GameConsts.ZHU_FLY_TIME,target_pos)
        action_list[#action_list + 1] = cc.EaseExponentialOut:create(moveTo)
        action_list[#action_list + 1] = cc.FadeOut:create(GameConsts.ZHU_FADE_OUT_TIME)
        action_list[#action_list + 1] = cc.CallFunc:create(move_end)
        local action = cc.Sequence:create(unpack(action_list))
        img:runAction(action)
    end

    local begin_time = 0
    for i=1,GameConsts.ZHU_FLY_NUM do
        RealTimer:RegTimerOnce(begin_time,one_bet_fly)
        begin_time = begin_time + GameConsts.ZHU_ENTER_TIME_INTERVAL
    end
    self.bet_fly_num = self.bet_fly_num + 1
end

--播放飘字动画 
function EffectCtrl:AddFloatTipsEffect(src_pos,changeValue)
    if changeValue<=0 then
        return
    end

    local img = self.fly_word:clone()
    img:setPosition(src_pos)
    img:setVisible(true)
    img:setString("+"..GameUtil:GetNumStr(changeValue))
    self.fly_word:getParent():addChild(img,GameLayerDef.WORD_FLY_LAYER)

    local move_end = function()
        img:stopAllActions()
        img:removeFromParent()
        img = nil
    end

    local action_list = {}
    local target_pos = cc.p(src_pos.x,src_pos.y+20)
    action_list[#action_list + 1] = cc.DelayTime:create(GameConsts.WORD_STAY_TIME)
    local moveTo = cc.MoveTo:create(GameConsts.WORD_FLY_TIME,target_pos)
    local fadeOut = cc.FadeOut:create(GameConsts.WORD_FLY_TIME)
    action_list[#action_list + 1] = cc.Spawn:create(moveTo,fadeOut)
    action_list[#action_list + 1] = cc.CallFunc:create(move_end)
    local action = cc.Sequence:create(unpack(action_list))
    img:runAction(action)
end

function EffectCtrl:HasBetFlyEff()
    return self.bet_fly_num > 0
end

function EffectCtrl:AddWinPokerEffect(src_pos,url1,url2,win_word)
    self:RemoveWinPokerEffect()

    local img = self.panel_result:clone()
    img:setPosition(src_pos)
    img:setVisible(true)
    self.panel_result:getParent():addChild(img,GameLayerDef.PLAYER_RESULT_LAYER)
    local card1 = img:getChildByName("card1")
    card1:loadTexture(UrlHelp:GetCardsUrl(url1))
    local card2 = img:getChildByName("card2")
    card2:loadTexture(UrlHelp:GetCardsUrl(url2))
    local word = img:getChildByName("word")
    word:setString(win_word)
    self.playing_panel_result_frame_handler = WidgetHelp:PlayFrameAnimation(img:getChildByName("effect"),COMMOD_EFFECT_INTERVAL,
        "player_win/",COMMOD_EFFECT_NUM)
    self.playing_panel_result = img

    local function effect_finished()
        self:RemoveWinPokerEffect()
    end

    local action_list = {}
    action_list[#action_list + 1] = cc.DelayTime:create(GameConsts.RESULT_STAY_TIME)
    action_list[#action_list + 1] = cc.FadeOut:create(GameConsts.RESULT_FADE_OUT_TIME)
    action_list[#action_list + 1] = cc.CallFunc:create(effect_finished)
    local action = cc.Sequence:create(unpack(action_list))
    img:runAction(action)
end

function EffectCtrl:RemoveWinPokerEffect()
    if self.playing_panel_result then
        if self.playing_panel_result_frame_handler then
            WidgetHelp:RemoveFrameAnimation(self.playing_panel_result_frame_handler)
            self.playing_panel_result_frame_handler = nil
        end
        self.playing_panel_result:removeFromParent()
        self.playing_panel_result = nil    
    end
end

function EffectCtrl:AddWinPokerFullScreenEffect(value)
	audioCtrl:playSound(Resources.sound.yingle)
	
    
    local res_name = WinResInfo[value].res
    local res_num = WinResInfo[value].num
    if res_name == "" or res_name == nil then
        return
    end

    local img = self.full_result:clone()
    img:setPosition(cc.p(self.full_result:getPosition()))
    img:setVisible(true)
    self.full_result:getParent():addChild(img,GameLayerDef.FULL_EFFECT_LAYER)
    local action_list = {}
    action_list[#action_list + 1] = cc.FadeIn:create(GameConsts.FULL_EFFECT_FADE_IN_TIME)
    local action = cc.Sequence:create(unpack(action_list))
    img:runAction(action)

	local frame_animation_handler
    local full_effect_end = function()
		WidgetHelp:RemoveFrameAnimation(frame_animation_handler)
    end

	
    local callback = function()
        local action_list = {}
        action_list[#action_list + 1] = cc.FadeOut:create(GameConsts.FULL_EFFECT_FADE_IN_TIME)
        action_list[#action_list + 1] = cc.CallFunc:create(full_effect_end)
        local action = cc.Sequence:create(unpack(action_list))
        img:runAction(action)
    end
    frame_animation_handler = WidgetHelp:PlayFrameAnimation(img,GameConsts.FULL_EFFECT_INTERVAL,
        res_name,res_num,nil,5,callback)
end



function EffectCtrl:AddWinCardTypeTip(match_card_idx_arr)
    if TableHelp:Count(match_card_idx_arr) == 0 then
        return
    end

    local panel = self.panel_common_result:clone()
    panel:setPosition(cc.p(self.panel_common_result:getPosition()))
    panel:setVisible(true)
    self.panel_common_result:getParent():addChild(panel,GameLayerDef.CARD_TYPE_RESULT_LAYER)
    
	for i=1, 10 do 
		local img = panel:getChildByName("card"..i)
		if img then
			img:setVisible(false)
		else
			break
		end
	end

    local pub_cards = self.model:GetGamePubCards()
    for idx,card_str in pairs(pub_cards) do
        local img = panel:getChildByName("card"..idx)
		img:setVisible(true)
        img:loadTexture(UrlHelp:GetCardsUrl(card_str))
    end

    for idx,_ in pairs(match_card_idx_arr) do
        local img = panel:getChildByName("card"..idx)
        local light = img:getChildByName("light")
        light:setVisible(true)
        local origin_pos = cc.p(img:getPosition())
		
        WidgetHelp:RepeatFloat(img,origin_pos,cc.p(origin_pos.x,origin_pos.y+20))
    end
	
    local action_list = {}
    action_list[#action_list + 1] = cc.DelayTime:create(0.8+0.7*4)
	action_list[#action_list + 1] = cc.CallFunc:create(function() panel:removeFromParent() end)
    panel:runAction(cc.RepeatForever:create(cc.Sequence:create(unpack(action_list))))
end


return EffectCtrl