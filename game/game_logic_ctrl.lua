--------------------------------------
-- 客户端桌子上玩家管理
--------------------------------------

local GameLogicCtrl = class("GameLogicCtrl", HotRequire(luafile.CtrlBase))
local this

function GameLogicCtrl:ctor( ... )
	self.super.ctor(self, ... )
	this = self
	self:init()
end

function GameLogicCtrl:init()
	self.players = {}
	self.cardsInfo = {}

    self.outCardData = {} -- 保存出牌信息

    self.WeaveItemArray = {} -- 保存每个玩家的组合牌 

    -- 编号为1 的 创建是自己的 显示在最下面
	self.players[1] = new_class(loadlua.majorPlayerCtrl, {localSite=1})
	for i=2, MAX_PLAYER do
        -- 其它的玩家，
		self.players[i] = new_class(loadlua.minorPlayerCtrl, {localSite=i})
	end

--	self.handlerList = self:addEventListenerList({
--        {RoomEvent.CONNECT_ROOM_SUCCESS, handler(self, self.onConnectRoomSucess)},
--    })

    self.handCardCount = {13, 13, 13, 13}

    -- 常规结束数据
    self.CMD_S_GameEnd = {}

    -- 保存当前操作的数据
    self.operateData = {}

    -- 胡牌信息
    self.CMD_S_ChiHu = {}

end


function GameLogicCtrl:setPrivateEndInfo(data)
    self.CMD_GF_Private_End_Info = data
end

function GameLogicCtrl:getPrivateEndInfo()
    return self.CMD_GF_Private_End_Info 
end

function GameLogicCtrl:normalEnd(CMD_S_GameEnd)

-- 结算界面，这里直接开始
--    gameMainUser:UserReady()
    
    if CMD_S_GameEnd == nil then return end
    self.CMD_S_GameEnd = CMD_S_GameEnd

    LayerManager.show(loadlua.ResultLayer)
end

function GameLogicCtrl:getnormalEnd()
    return self.CMD_S_GameEnd
end

function GameLogicCtrl:onGameStart(PDK_CMD_S_GameStart)
    self:getPlayers()[1]:setCards( PDK_CMD_S_GameStart.cbHandCardList )
    self:getPlayers()[2]:reSetHandCards( 71 )
    self:getPlayers()[3]:reSetHandCards( 71 )
    self:getPlayers()[4]:reSetHandCards( 71 )
    -- 这里要转换一次显示的编号，因为编号为1 的都是自己的位置
    local localplayeridx = self:getLocalPlayerIdx(PDK_CMD_S_GameStart.wCurrentUser)
    localplayeridx = localplayeridx + 1
    if localplayeridx == 1 then
        self.players[1]:setActive(true)
    else
        self.players[1]:setActive(false)
    end
end

function GameLogicCtrl:setChiHuInfo(CMD_S_ChiHu)
    self.CMD_S_ChiHu = CMD_S_ChiHu
end

function GameLogicCtrl:getChiHuInfo()
    return self.CMD_S_ChiHu
end


--local function OnProGetUserPropResponse(event)
--	local msg = event.data.msg
--	UserManager:getMajorData():setPropInfo(msg.propInfo)
--	this:dispatchEvent({name = UserDataEvent.USER_DATA_UPDATE})--发出用户数据更新事件
--end

--function GameLogicCtrl:EnterGameRoom(nRoomNumber)
--	local rinfo = UserManager:getGameData():getRoomInfo()
--	local r 
--	for k,v in pairs(rinfo.room) do
--		if v.game_id == GAME_ID and v.room_id == nRoomNumber and v.room_type == Constant.RoomType.CARD_ROOM then
--			r = v
--			break
--		end
--	end


--end
function GameLogicCtrl:getCardCountFrmPlayerIdx(playeridx)
    return self.handCardCount[playeridx]
end

-- 减少牌数量
function GameLogicCtrl:decCardCountFrmPlayerIdx(playeridx,count)
    if count == nil then
        count = 1
    end
    self.handCardCount[playeridx] = self.handCardCount[playeridx] - count
end

-- 增加牌数量
function GameLogicCtrl:incCardCountFrmPlayerIdx(playeridx,count)
    if count == nil then
        count = 1
    end
    self.handCardCount[playeridx] = self.handCardCount[playeridx] + count
end

function GameLogicCtrl:addOutCard(playeridx, carddata) 
    if self.outCardData[playeridx] == nil then
        self.outCardData[playeridx] = {}
    end

    table.insert(self.outCardData[playeridx], carddata)
end

function GameLogicCtrl:delOutCard(playeridx, carddata) 
    if self.outCardData[playeridx] == nil then return end 

    for i, card in pairs(self.outCardData[playeridx]) do
        if carddata == card then 
            table.remove(self.outCardData[playeridx], i)
            break
        end
    end
end

function GameLogicCtrl:getOutCardsFrmPlayerIdx(playeridx)
    return self.outCardData[playeridx]
end


function GameLogicCtrl:getPlayers() 
    return self.players 
end

function GameLogicCtrl:setGameStartInfo(cards)
    if cards == nil then return end 
    self.cardsInfo = cards
end 

function GameLogicCtrl:getGameStartInfo()
    return self.cardsInfo
end

function GameLogicCtrl:getplayerCardFrmIdx(playeridx)
    local re = nil

    if self.cardsInfo ~= nil then 
        if playeridx >= 1 and playeridx <= GAME_PLAYER then 
            re = self.cardsInfo.cbCardData[playeridx]
        end
    end

    return re
end

function GameLogicCtrl:delselfCardCountFrmPlayerIdx(cardvalue)
    if self.cardsInfo ~= nil then 
        if self.cardsInfo.cbCardData[1] ~= nil then 
            for i, v in pairs(self.cardsInfo.cbCardData[1]) do
                if v == cardvalue then 
                    self.cardsInfo.cbCardData[1][i] = 0
                    break
                end
            end
        end

        -- 把所有的有效数据向前移动
        local tem = {}
        for i, v in pairs(self.cardsInfo.cbCardData[1]) do
            if v ~= 0 then 
                table.insert(tem, v)
            end
        end

        self.cardsInfo.cbCardData[1] = {}
        for i, v in pairs(tem) do
            table.insert(self.cardsInfo.cbCardData[1], v)
        end
    end
end

--function GameLogicCtrl:getCardCountFrmPlayerIdx(playeridx)
--    local re = 0
--    if self.cardsInfo ~= nil then 
--        if playeridx >= 1 and playeridx <= GAME_PLAYER then 
--            for i, carddata in pairs(self.cardsInfo.cbCardData[playeridx]) do
--                if carddata > 0 then 
--                    re = re + 1
--                end 
--            end
--        end
--    end
--    return re
--end

function GameLogicCtrl:getLocalPlayerIdx(playeridx)
    local re = playeridx
    local meitem = gameManager:getpubInfo():getmeitem()

    if meitem ~= nil then 
        re = (meitem.wChairID - playeridx + MAX_PLAYER) % MAX_PLAYER
    end

    return re
end

--[[ 添加显示打出去的牌
    当一个玩家打出牌时，游戏服务器会转发出牌的协议 并且每个玩家都可以接收到
    也就是说，在这个协议函数里要实现 数据的同步 以及动画
]]
function GameLogicCtrl:getMaxCards()
    return self.m_curMaxCards
end

function GameLogicCtrl:addOutCardData(outdata)
    if outdata == nil then return end
    self.m_curMaxCards = outdata.cbOutCardList

    -- 这里要转换一次显示的编号，因为编号为1 的都是自己的位置
    local localplayeridx = self:getLocalPlayerIdx(outdata.wOutCardUser)
    localplayeridx = localplayeridx + 1
    if localplayeridx < 1 or localplayeridx > 4 then return end 

    local player = self.players[localplayeridx]
    if player then
        player:outCard( outdata.cbOutCardList )
    end

    -- 当前用户
    localplayeridx = self:getLocalPlayerIdx(outdata.wCurrentUser)
    localplayeridx = localplayeridx + 1
    if localplayeridx < 1 or localplayeridx > 4 then return end 

    player = self.players[localplayeridx]
    if player then
        player:setActive(true)
    end

    if localplayeridx == 1 then
        self:Hint()
    end
end

function GameLogicCtrl:PassCard(outdata)
    -- 这里要转换一次显示的编号，因为编号为1 的都是自己的位置
    local localplayeridx = self:getLocalPlayerIdx(outdata.wPassUser)
    localplayeridx = localplayeridx + 1
    if localplayeridx < 1 or localplayeridx > 4 then return end 

    local player = self.players[localplayeridx]
    if player then
        player:passCard()
    end

    -- 当前用户
    localplayeridx = self:getLocalPlayerIdx(outdata.wCurrentUser)
    localplayeridx = localplayeridx + 1
    if localplayeridx < 1 or localplayeridx > 4 then return end 

    player = self.players[localplayeridx]
    if player then
        player:setActive(true)
    end
    if localplayeridx == 1 then
        if outdata.bNewTurn == 1 then
            self.m_curMaxCards = nil
        end
        self:Hint()
    end
end

function GameLogicCtrl:Hint()
    local player = self.players[1]
    local idx = player:GetEatIdx( self.m_curMaxCards )
    if idx then
        self:setOutputCard( idx )
    else
        -- 过牌
        player:setActive(false)
        self:SendGamePack(MDM_GF_GAME, SUB_C_PASS_CARD, "")    
    end
end

function GameLogicCtrl:sortcards()
    -- 重新排序 麻将牌
    --if localplayeridx < 1 or localplayeridx > GAME_PLAYER then return end
    local localplayeridx = 1
    local cards = self:getplayerCardFrmIdx(localplayeridx)
    if cards == nil then return end 

    local tem0 = {}
    local tem1 = {}
    local tem2 = {}
    local tem3 = {}

    -- 类型排序 
    for i, card in pairs(cards) do
        if card ~= 0 then 
            local flag = bit._and(card, 0xF0)
            if flag == 0 then 
                table.insert(tem0, card)
            elseif flag == 16 then 
                table.insert(tem1, card)
            elseif flag == 32 then 
                table.insert(tem2, card)
            elseif flag == 48 then 
                table.insert(tem3, card)
            end
        end
    end

    -- 大小排序
    local function sorttem(a, b)
        return a > b
    end
    table.sort(tem0, sorttem)
    table.sort(tem1, sorttem)
    table.sort(tem2, sorttem)
    table.sort(tem3, sorttem)

    self.cardsInfo.cbCardData[1] = {}

    for i, card in pairs(tem3) do
        table.insert(self.cardsInfo.cbCardData[localplayeridx], card)
    end
    for i, card in pairs(tem2) do
        table.insert(self.cardsInfo.cbCardData[localplayeridx], card)
    end
    for i, card in pairs(tem1) do
        table.insert(self.cardsInfo.cbCardData[localplayeridx], card)
    end
    for i, card in pairs(tem0) do
        table.insert(self.cardsInfo.cbCardData[localplayeridx], card)
    end

    local count = #self.cardsInfo.cbCardData[localplayeridx]
    if count < 14 then 
        for i = count + 1, 14 do
            table.insert(self.cardsInfo.cbCardData[localplayeridx], 0)
        end
    end
end

function GameLogicCtrl:reSetHandCard(localplayeridx)
    if localplayeridx == 1 then 
        self:sortcards()
        local cards = self:getplayerCardFrmIdx(localplayeridx)
        if cards ~= nil then 
            self.players[localplayeridx]:reSetHandCards(cards)
        end
    else
        local count = self:getCardCountFrmPlayerIdx(localplayeridx)
        if count ~= nil then 
            self.players[localplayeridx]:reSetHandCards(count)
        end
    end
end

-- 添加手上的牌
function GameLogicCtrl:addCardData(senddata)
    if senddata == nil then return end

    -- 这里要转换一次显示的编号，因为编号为1 的都是自己的位置
    local localplayeridx = self:getLocalPlayerIdx(senddata.wCurrentUser)

    localplayeridx = localplayeridx + 1
    if localplayeridx < 1 or localplayeridx > 4 then return end

    self.players[1]:setTouchEnable(false)
    if localplayeridx == 1 then 
        -- 发的牌放到最后
        self.cardsInfo.cbCardData[localplayeridx][MAX_COUNT] = senddata.cbCardData
        self.players[localplayeridx]:setTouchEnable(true)

        -- 判断一次动作
        if senddata.cbActionMask ~= 0 then 
            local operdata = {}
            operdata.wResumeUser = senddata.wCurrentUser--						//还原用户
            operdata.cbActionMask = senddata.cbActionMask--						//动作掩码
            operdata.cbActionCard = senddata.cbCardData--						//动作扑克

            -- 判断一次杠，因为发过来的牌不一定就是可以杠的，这里判断一次暗杠的牌
            -- 就是找出有四张一样的牌
            if senddata.cbActionMask == WIK_GANG then 
                local cards = self:getplayerCardFrmIdx(1)
                local tem = {}

                local findcard = 0
                for i, card in pairs(cards) do
                    if tem[card] == nil then 
                        tem[card] = {}
                        tem[card][1] = 1
                    else    
                        tem[card][1] = tem[card][1] + 1
                    end
                end

                if tem ~= nil then 
                    for i, item in pairs(tem) do
                        if item ~= nil then 
                            if item[1] >= 4 then 
                                findcard = i
                                break          
                            end
                        end
                    end
                end

                if findcard ~= 0 then 
                    operdata.cbActionCard = findcard--						//动作扑克
                end

            end

            self:operateCard(operdata) 
        end

    end

    -- 增加 牌的数量
    self:incCardCountFrmPlayerIdx(localplayeridx)
    -- 显示在 每个玩家 位置上 提出来在打出去的牌
    self:setReadyOutCard(localplayeridx, senddata.cbCardData)


--    for i, v in pairs(self.cardsInfo.cbCardData[localplayeridx]) do
--        if v == 0 then 
--            self.cardsInfo.cbCardData[localplayeridx][i] = senddata.cbCardData
--            break
--        end
--    end

end

function GameLogicCtrl:setReadyOutCard(localplayeridx, carddata)
    self.players[localplayeridx]:showSendCard(carddata)
end

-- 吃 碰 杠 胡 操作
function GameLogicCtrl:operateCard(operdata)    
    self.operateData = operdata
    self.players[1]:showOperateTool(operdata)
end



function GameLogicCtrl:operateCmd(code)
--[[
//操作命令
struct CMD_C_OperateCard
{
	DWORD							cbOperateCode;						//操作代码
	BYTE							cbOperateCard;						//操作扑克
};
]]
	local CMD_C_OperateCard = {};
	CMD_C_OperateCard.cbOperateCode = code
	CMD_C_OperateCard.cbOperateCard = self.operateData.cbActionCard

    local s = string.pack( "Ib", CMD_C_OperateCard.cbOperateCode, CMD_C_OperateCard.cbOperateCard )
    self:SendGamePack(MDM_GF_GAME, SUB_C_OPERATE_CARD, s)    
end

function GameLogicCtrl:initPlayersUI(ui)
	for i=1, MAX_PLAYER do
		self.players[i]:initUI(ui, i==1, i)
	end
end

function GameLogicCtrl:InitHandCardx(playeridx)
    if playeridx < 1 or playeridx > 4 then return end

    if playeridx == 1 then
        self:sortcards()
        local cards = self:getplayerCardFrmIdx(playeridx)
        if cards ~= nil then
            self.players[playeridx]:initHandCards(cards)
            self.players[playeridx]:setTouchEnable(false)
        end
    else
        self.players[playeridx]:setCardCount(71)
    end
end

--function GameLogicCtrl:onConnectRoomSucess()
--	StateMgr:ChangeState(StateType.Room)
--end

-- 发送出牌消息
function GameLogicCtrl:sendOutCard()
    local CardGroups = self.players[1]:getCardGroups()
    if self.m_Output > #CardGroups then
        return
    end
    local group = CardGroups[self.m_Output]
    local PDK_CMD_C_OutCard = {}
    PDK_CMD_C_OutCard.cbCardType = 0
    local s = string.pack( "b", PDK_CMD_C_OutCard.cbCardType )

    s = s .. string.pack( "L", #group )
    for i, v in pairs(group) do
        s = s.. string.pack( "b", v )
    end

    self:SendGamePack(MDM_GF_GAME,SUB_C_OutCard, s)
    self.players[1]:removeGroup( self.m_Output )
    self.players[1]:setActive(false)
    self.m_Output = 0
end

function GameLogicCtrl:exitRoom()
	for i=1, MAX_PLAYER do
		self.players[i] = nil
	end
end

function GameLogicCtrl:setOutputCard(groupIdx)
    self.m_Output = groupIdx
    self.players[1]:setOutput(groupIdx)
end

function GameLogicCtrl:getOutputCard()
    return self.m_Output
end

function GameLogicCtrl:DisMissRoolMsg(value)
--[[
//解散房间
struct CMD_GR_Dismiss_Private
{	
	byte			bDismiss;			//解散
};
]]
    local CMD_GR_Dismiss_Private = {}
    CMD_GR_Dismiss_Private.bDismiss = value

    local s = string.pack( "b", CMD_GR_Dismiss_Private.bDismiss  )
    self:sendcmd(MDM_GR_PRIVATE, SUB_GR_PRIVATE_DISMISS, s)
end

-- 发送准备
function GameLogicCtrl:sendReadyMsg()
--[[

//游戏配置
struct CMD_GF_GameOption
{
	byte							cbAllowLookon;						//旁观标志
	dword							dwFrameVersion;						//框架版本
	dword							dwClientVersion;					//游戏版本
};

]]    

    local CMD_GF_GameOption = {}

    CMD_GF_GameOption.cbAllowLookon = 0--						//旁观标志
    CMD_GF_GameOption.dwFrameVersion = pubFun.GetGameVersion()--						//框架版本
    CMD_GF_GameOption.dwClientVersion = pubFun.GetGameVersion()--					//游戏版本

    local s = string.pack( "bII", CMD_GF_GameOption.cbAllowLookon, CMD_GF_GameOption.dwFrameVersion, CMD_GF_GameOption.dwClientVersion)

    -- maincmd 100  subcmd 1
    self:sendcmd(MDM_GF_FRAME,SUB_GF_GAME_OPTION,s);
end

function GameLogicCtrl:sendcmd(maincmd, subcmd, s)
    self:SendGamePack(maincmd,subcmd, s)
end

return GameLogicCtrl
