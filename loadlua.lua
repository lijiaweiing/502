------------------------------------------
-- lua文件加载
------------------------------------------

-- 全局定义
loadlua = {}

local function R(name, def)
    if loadlua[name] and loadlua[name] == def then
        error("存在相同LuaName：" .. name)
        return
    end
    loadlua[name] = def
end

--  通信
R("GameLogicCtrl","games.502.game.game_logic_ctrl")
R("gameMainConfig","games.502.net.gameMainConfig")
R("gameMainGameFrame","games.502.net.gameMainGameFrame")
R("gameMainLogon","games.502.net.gameMainLogon")
R("gameMainMatch","games.502.net.gameMainMatch")
R("gameMainPrivate","games.502.net.gameMainPrivate")
R("gameMainStatus","games.502.net.gameMainStatus")
R("gameMainSystem","games.502.net.gameMainSystem")
R("gameMainUser","games.502.net.gameMainUser")


-- 游戏控件
R("basePlayerCtrl", "games.502.game.base_player_ctrl")
R("basePlayerLayer", "games.502.game.base_player_layer")

R("majorPlayerCtrl", "games.502.game.major_player_ctrl")
R("majorPlayerLayer", "games.502.game.major_player_layer")

R("minorPlayerLayer", "games.502.game.minor_player_layer")
R("minorPlayerCtrl", "games.502.game.minor_player_ctrl")


R("Card", "games.502.game.card")
R("CardGroup", "games.502.game.CardGroup")

R("RoomLayer", "games.502.game.room_layer")

R("ResultLayer", "games.502.game.result_layer")


R("HeadLayer", "games.502.game.head_layer")
R("CharLayer", "games.502.game.chat_layer")

R("Totalresultlayer", "games.502.game.totalresult_layer")

R("Settinglayer", "games.502.game.Setting_layer")
R("DismissRoomlayer", "games.502.game.DismissRoom_layer")
R("DismissRoomTiplayer", "games.502.game.DismissRoomTip_layer")

-- 数据管理
R("GameManager", "games.502.model.gameManager")
R("pubInfo", "games.502.model.pubinfo")
R("TableFrame", "games.502.model.TableFrame")

