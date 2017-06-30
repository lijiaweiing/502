--------------------------------------------
-- 总结算
--------------------------------------------

local Totalresultlayer = class("Totalresultlayer", cocosMake.viewBase)

--cocos studio生成的csb
Totalresultlayer.ui_resource_file = {GameResources.csb.TotalresultlayerUI}

--csb上的控件绑定
Totalresultlayer.ui_binding_file = {
    Btn_Back =  {event = "click", method = "Btn_BackClick"}, 

    Btn_Share =  {event = "click", method = "Btn_ShareClick"}, 

}

function Totalresultlayer:onCreate(param)
    -- 设置事件派发器
    --cc.load("event"):setEventDispatcher(self, GameController)
     
    self:Init()
end

function Totalresultlayer:Init()
    gameManager:getpubInfo():setInRoom(false)

    local privateinfo = gameManager:getpubInfo():getPrivateRoomInfo()
    if privateinfo == nil then return end 

    if privateinfo ~= nil then
        self.Text_RoomNum:setString("房号：" .. privateinfo.dwRoomNum)
        self.Text_JuNum:setString("局数：" .. privateinfo.dwPlayCout .. "/" .. privateinfo.dwPlayTotal)
    end

    self["Panel_Player1"]["Img_Bigwinner"]:setVisible(false)
    self["Panel_Player2"]["Img_Bigwinner"]:setVisible(false)
    self["Panel_Player3"]["Img_Bigwinner"]:setVisible(false)
    self["Panel_Player4"]["Img_Bigwinner"]:setVisible(false)


    self["Panel_Player1"]["Text_ScoreNum"]:setString("")
    self["Panel_Player2"]["Text_ScoreNum"]:setString("")
    self["Panel_Player3"]["Text_ScoreNum"]:setString("")
    self["Panel_Player4"]["Text_ScoreNum"]:setString("")
    
--[[
//私人场结算信息
struct CMD_GF_Private_End_Info
{	
	std::vector<SCORE> lPlayerWinLose;
	std::vector<byte> lPlayerAction;
	systemtime		kPlayTime;

	void StreamValue(datastream& kData,bool bSend)
	{
		Stream_VECTOR(lPlayerWinLose);
		Stream_VECTOR(lPlayerAction);
		Stream_VALUE_SYSTEMTIME(kPlayTime);
	}
};
]]
    local CMD_GF_Private_End_Info = GameLogicCtrl:getPrivateEndInfo()

    if CMD_GF_Private_End_Info == nil then return end 

    if #CMD_GF_Private_End_Info.lPlayerWinLose ~= MAX_PLAYER then return end
    local count = MAX_PLAYER * MAX_PRIVATE_ACTION
    if #CMD_GF_Private_End_Info.lPlayerAction ~= count then return end


    local userinfo = gameManager:getpubInfo():getUserInfo()
    if userinfo == nil then return end

--[[
	dword							dwUserID;							//用户 I D
	char							szNickName[LEN_NICKNAME];			//用户昵称
    char							szHeadHttp[LEN_USER_NOTE];			//头像HTTP

]]

    local temv = {}
    for i, item in pairs(userinfo) do
        if item ~= nil then 

            local dwUserID = item.dwUserID
            local szNickName = item.szNickName
            local szHeadHttp = item.szHeadHttp
            local iChairID = item.wChairID

            if TARGET_PLATFORM ~= cc.PLATFORM_OS_WINDOWS then
                -- 头像
	            ImageCacheCtrl:getImage(szHeadHttp, function(fileName)
		            -- 如果fileName存在，则使用该图片
		            if cc.FileUtils:getInstance():isFileExist(fileName) then
			            --self:clearIcon()
			            --WidgetHelp:setPlayerHead(fileName, self.portraits_img)
                        self["Panel_Player"..i]["Img_Head"]:loadTexture(fileName)
		            end
	            end)
            end

            local ctrl = self["Panel_Player"..i]["Text_Name"]
            ctrl:setString(szNickName)

            self["Panel_Player"..i]["Text_ID"]:setString("ID: " .. dwUserID)

--            local v = CMD_GF_Private_End_Info.lPlayerAction[iChairID * MAX_PRIVATE_ACTION + 1 ]
--            ctrl = self["Panel_Player"..i]["Text_zimoNum"]
--            if ctrl ~= nil then
--                ctrl:setString("自摸次数  " .. "x" .. v)
--            end
--            v = CMD_GF_Private_End_Info.lPlayerAction[iChairID * MAX_PRIVATE_ACTION + 2 ]
--            ctrl = self["Panel_Player"..i]["Text_minggangNum"]
--            if ctrl ~= nil then
--                ctrl:setString("明杠次数  " .. "x" .. v)
--            end
--            v = CMD_GF_Private_End_Info.lPlayerAction[iChairID * MAX_PRIVATE_ACTION + 3 ]
--            ctrl = self["Panel_Player"..i]["Text_angangNum"] 
--            if ctrl ~= nil then
--                ctrl:setString("暗杠次数  " .. "x" .. v)
--            end

            -- 总分数
            v = CMD_GF_Private_End_Info.lPlayerWinLose[iChairID + 1]
            ctrl = self["Panel_Player"..i]["Text_ScoreNum"]
            if ctrl ~= nil then
                ctrl:setString("" .. v)
            end

            temv[i] = v
        end
    end

--    local checmtem = {}
--    for i, v in pairs(temv) do
--        table.insert(checmtem, v)
--    end

--    local function sorttab(a, b)
--	    return a > b
--    end

--    table.sort(temv, sorttab)

--    local maxv = temv[1]

--    if maxv <= 0 then return end 

--    local findidx = -1
--    for i, v in pairs(checmtem) do
--        if v == maxv then 
--            findidx = i
--            break
--        end
--    end

--    local ctrl = self["Panel_Player"..findidx]["Img_Bigwinner"]
--    if ctrl ~= nil then
--        ctrl:setVisible(true)
--    end
    -- 显示头像
    self:setuserheadimg(userinfos, 1)
    self:setuserheadimg(userinfos, 2)
    self:setuserheadimg(userinfos, 3)
    self:setuserheadimg(userinfos, 4)

end

function Totalresultlayer:setuserheadimg(userinfos, idx)
    if #userinfos >= idx then
        local item = userinfos[idx]

        if item ~= nil then 
            local localcharidx = GameLogicCtrl:getLocalPlayerIdx(idx)
            localcharidx = localcharidx + 1

            local Individualitem = UserManager:getUserInfo():getUserIndividualByUserId(item.dwUserID)

            if Individualitem ~= nil then 

                if TARGET_PLATFORM ~= cc.PLATFORM_OS_WINDOWS then
	                ImageCacheCtrl:getImage(Individualitem.kHttp, function(fileName)

		                -- 如果fileName存在，则使用该图片
		                if cc.FileUtils:getInstance():isFileExist(fileName) then
                            local ctrl = nil
                            if localcharidx == 1 then 
                                ctrl = self["Panel_Player1"]["Img_Head"]--:loadTexture(fileName)
                            elseif localcharidx == 2 then 
                                ctrl = self["Panel_Player2"]["Img_Head"]--:loadTexture(fileName)
                            elseif localcharidx == 3 then 
                                ctrl = self["Panel_Player3"]["Img_Head"]--:loadTexture(fileName)
                            elseif localcharidx == 4 then 
                                ctrl = self["Panel_Player4"]["Img_Head"]--:loadTexture(fileName)
                            end
                            if ctrl ~= nil then
                                ctrl:loadTexture(fileName)
                            end
		                end
	                end)
                end
            end

        end

    end
end

function Totalresultlayer:Btn_BackClick(event)
    StateMgr:ChangeState(StateType.Hall)    
end

function Totalresultlayer:Btn_ShareClick(event)

end


return Totalresultlayer