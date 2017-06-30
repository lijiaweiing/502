-------------------------------------------------
-- 游戏配置文件
-------------------------------------------------

GAMEID = 502 -- 游戏类型编号

MAX_PLAYER = 4 -- 游戏最多玩家数

GameResources= {}

GameResources.csb = {
    RoomLayerUI = "form_502/RoomLayerUI.csb",
    ResultLayerUI = "form_502/Resule.csb",

    HeadLayerUI = "form_502/Playerinfo.csb",
    ChatLayerUI = "form_502/Chat.csb",

    DismissRoomlayerUI = "form_502/DismissRoom.csb",
    DismissRoomTiplayerUI = "form_502/DismissRoomTip.csb",
    SettinglayerUI = "form_502/Setting.csb",

    TotalresultlayerUI = "form_502/TotalResult.csb",
}

--//服务状态
enServiceStatus=
{
	ServiceStatus_Unknow,	--		//未知状态
	ServiceStatus_Entering,	--		//进入状态
	ServiceStatus_Validate,	--		//验证状态
	ServiceStatus_RecvInfo,	--		//读取状态
	ServiceStatus_ServiceIng,--		//服务状态
	ServiceStatus_NetworkDown,	--	//中断状态
}


--//游戏退出代码
enGameExitCode=
{
	GameExitCode_Normal,		--	//正常退出
	GameExitCode_CreateFailed,	--	//创建失败
	GameExitCode_Timeout,		--	//定时到时
	GameExitCode_Shutdown,		--	//断开连接
}

--//房间退出代码
enServerExitCode=
{
	ServerExitCode_Normal,		--	//正常退出
	ServerExitCode_Shutdown,	--	//断开连接
}

eventCodeBase = 500000
local function ID()
    eventCodeBase = eventCodeBase + 1
    return tostring(eventCodeBase)
end

updateUIEvent = {
    STATE_MODIFY  = ID() ,  -- 状态改变

    SHOW_ROOMINFO =  ID(), -- 更新显示文字

    SHOW_CARDINFO =  ID(), -- 显示游戏开始时的麻将牌

    OUT_CARDINFO =  ID(), -- 玩家出牌信息

    SEND_CARDINFO =  ID(), -- 发牌信息

    CARD_PASS  = ID(), -- 过牌
    CLEAN_ROOM  = ID(), -- 清理
    FIRE_TOOL = ID(), -- 飞行道具

    CHAT_MSG = ID(), -- 聊天

    ROOM_DISMISS = ID(), -- 解散

    ROOM_DISMISSINFO = ID(), -- 解散信息

}

StateModifyType =
{
    Ready_State = 1, --  准备状态
}

RoomDisMissState = 
{
    DisMiss_Check_Open = 1, -- 确定窗体
    DisMiss_Check_Ok = 2, -- 确定
    DisMiss_Check_Cancel = 3, -- 取消
}

GameAction = {}
GameAction.csb = {
    animation_aircraft = {"res_502/animation/Node_Aircraft.csb", "animation_aircraft", ""},
    animation0_bombmiddle = {"res_502/animation/Node_Bombmiddle.csb", "animation0_bombmiddle", "Snd_bombmiddle.mp3"},
    animation_bombsmall = {"res_502/animation/Node_Bombsmall.csb", "animation_bombsmall", "Snd_bombsmall.mp3"},
    animation_doubleline = {"res_502/animation/Node_DoubleLine.csb", "animation_doubleline", ""},
    animation_missile = {"res_502/animation/Node_Missile.csb", "animation_missile", "Snd_bombbig.mp3"},
    animation_oneline = {"res_502/animation/Node_OneLine.csb", "animation_oneline", ""},
}

GAME_RULE_TONGSEJIAYI		=	      1					--同色加一奖
GAME_RULE_TONGSEJIAN		=	      2					--同色加N奖
GAME_RULE_SHUNJIANGLIANYI	=		  4					--顺奖连一奖
GAME_RULE_SHUNJIANGLIANN	=		  8					--顺奖连N奖
GAME_RULE_DANPAIJIANG		=	      16				--单牌奖
GAME_RULE_DUJIANG           =         32				--独奖

SUB_S_GAME_START		=	101									--游戏开始
SUB_S_OUT_CARD			=	102									--用户出牌
SUB_S_PASS_CARD			=	103									--放弃出牌
SUB_S_GAME_END			=	104									--游戏结束
                        
--//组件属性            
GAME_PLAYER					=4--									//游戏人数

GAME_GENRE					=(GAME_GENRE_SCORE or GAME_GENRE_MATCH or GAME_GENRE_GOLD)--	//游戏类型

--//游戏状态
GS_MJ_FREE					=GAME_STATUS_FREE		--			//空闲状态
GS_MJ_PLAY					=(GAME_STATUS_PLAY+1)	--			//游戏状态
GS_MJ_XIAOHU				=(GAME_STATUS_PLAY+2)	--						//小胡状态

TIME_START_GAME				=30						--			//开始定时器
TIME_OPERATE_CARD			=15						--			//操作定时器



SUB_C_OutCard		=			1									--用户出牌
SUB_C_PASS_CARD		=		3									--放弃出牌



--//////////////////////////////////////////////////////////////////////////////////

--//用户状态
US_NULL					=	0x00			--					//没有状态
US_FREE					=	0x01			--					//站立状态
US_SIT					=	0x02			--					//坐下状态
US_READY				=   0x03			--				//同意状态
US_LOOKON				=   0x04			--				//旁观状态
US_PLAYING				=	0x05			--					//游戏状态
US_OFFLINE				=	0x06			--					//断线状态


-- 牌位置偏移
CARD_DWON_POSY = 70
CARD_UP_POSY = 110
CARD_WIDTH = 126

SMALL_KING  = 64
BIG_KING    = 81


