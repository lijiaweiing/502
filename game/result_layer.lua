--------------------------------------------
-- 结算
--------------------------------------------

local ResultLayer = class("ResultLayer", cocosMake.viewBase)


--cocos studio生成的csb
ResultLayer.ui_resource_file = {GameResources.csb.ResultLayerUI}

--csb上的控件绑定
ResultLayer.ui_binding_file = {
    Btn_Continue =  {event = "click", method = "Btn_ContinueClick"}, 
    Btn_Close =  {event = "click", method = "Btn_CloseClick"},     
    Btn_Share =  {event = "click", method = "Btn_ShareClick"},  
       
}

function ResultLayer:onCreate(param)
    -- 设置事件派发器
    cc.load("event"):setEventDispatcher(self, GameController)
     
    self:Init()
end

function ResultLayer:Init()
    gameManager:getpubInfo():setInRoom(false)

    self.data = GameLogicCtrl:getnormalEnd()
    if self.data == nil then return end 

    local privateinfo = gameManager:getpubInfo():getPrivateRoomInfo()
    if privateinfo ~= nil then
        self.Text_RoomNum:setString("房号：" .. privateinfo.dwRoomNum)
        self.Text_JuNum:setString("局数：" .. privateinfo.dwPlayCout .. "/" .. privateinfo.dwPlayTotal)
    end

    -- 时间
    local timestr = os.date("%Y-%m-%d %H:%M:%S");
    self.Text_Time:setString(timestr)

    self:showEndInfo()

end

function ResultLayer:Btn_ShareClick(event)
end

function ResultLayer:Btn_CloseClick(event)
    LayerManager.show(loadlua.RoomLayer)
    gameMainUser:UserReady()
end

function ResultLayer:Btn_ContinueClick(event)
    LayerManager.show(loadlua.RoomLayer)
    gameMainUser:UserReady()
end


--struct PDK_EndInfo
--{
--	WORD  wChairID;
--	SCORE lGameScore;
--	BYTE  nBombCount;
--	std::vector<BYTE> cbCardList;

--	void StreamValue(datastream& kData,bool bSend)
--	{
--		Stream_VALUE(wChairID);
--		Stream_VALUE(lGameScore);
--		Stream_VALUE(nBombCount);
--		Stream_VECTOR(cbCardList);
--	}
--};

--struct PDK_CMD_S_GameEnd
--{
--	SCORE lGameTax;
--	std::vector<PDK_EndInfo> kEndInfoList;
--	void StreamValue(datastream& kData,bool bSend)
--	{
--		Stream_VALUE(lGameTax);
--		StructVecotrMember(PDK_EndInfo,kEndInfoList);
--	}
--};
function ResultLayer:showEndInfo()
    if self.data == nil then return end 

    --self.niaocount:setVisible(false)

    local ctrl = nil
    local userinfos = gameManager:getpubInfo():getUserInfo()
    if userinfos == nil then return end 

    for i = 1, GAME_PLAYER do
        local userinfo = userinfos[i]
        local iChirID = userinfo.wChairID

        -- 显示昵称
        local localcharidx = GameLogicCtrl:getLocalPlayerIdx(iChirID)
        localcharidx = localcharidx + 1
        local ctrl = nil
        if localcharidx == 1 then 
            ctrl = self["Panel_Main"]["panel_Information1"]["Text_Name"]--:setString(item.szNickName)
        elseif localcharidx == 2 then 
            ctrl = self["Panel_Main"]["panel_Information2"]["Text_Name"]--:setString(item.szNickName)
        elseif localcharidx == 3 then 
            ctrl = self["Panel_Main"]["panel_Information3"]["Text_Name"]--:setString(item.szNickName)
        elseif localcharidx == 4 then 
            ctrl = self["Panel_Main"]["panel_Information4"]["Text_Name"]--:setString(item.szNickName)
        end
        if ctrl ~= nil then
            ctrl:setString(userinfo.szNickName)
        end

        local PDK_CMD_S_GameEnd = GameLogicCtrl:getnormalEnd()

        if PDK_CMD_S_GameEnd ~= nil then 

            for i, enditem in pairs(PDK_CMD_S_GameEnd.kEndInfoList) do

--[[
--	WORD  wChairID;
--	SCORE lGameScore;
--	BYTE  nBombCount;
--	std::vector<BYTE> cbCardList;
]]      
                local Text_jianNum = nil
                local Text_jiangNum = nil
                local Text_danjuNum = nil
                local Text_totalNum = nil

                if enditem.wChairID == (localcharidx - 1) then 

                    if localcharidx == 1 then 
                        Text_jianNum = self["Panel_Main"]["panel_Information1"]["Text_jianNum"]--:setString(item.szNickName)
                        Text_jiangNum = self["Panel_Main"]["panel_Information1"]["Text_jiangNum"]--:setString(item.szNickName)
                        Text_danjuNum = self["Panel_Main"]["panel_Information1"]["Text_danjuNum"]--:setString(item.szNickName)
                        Text_totalNum = self["Panel_Main"]["panel_Information1"]["Text_totalNum"]--:setString(item.szNickName)
                    elseif localcharidx == 2 then 
                        Text_jianNum = self["Panel_Main"]["panel_Information2"]["Text_jianNum"]--:setString(item.szNickName)
                        Text_jiangNum = self["Panel_Main"]["panel_Information2"]["Text_jiangNum"]--:setString(item.szNickName)
                        Text_danjuNum = self["Panel_Main"]["panel_Information2"]["Text_danjuNum"]--:setString(item.szNickName)
                        Text_totalNum = self["Panel_Main"]["panel_Information2"]["Text_totalNum"]--:setString(item.szNickName)
                    elseif localcharidx == 3 then 
                        Text_jianNum = self["Panel_Main"]["panel_Information3"]["Text_jianNum"]--:setString(item.szNickName)
                        Text_jiangNum = self["Panel_Main"]["panel_Information3"]["Text_jiangNum"]--:setString(item.szNickName)
                        Text_danjuNum = self["Panel_Main"]["panel_Information3"]["Text_danjuNum"]--:setString(item.szNickName)
                        Text_totalNum = self["Panel_Main"]["panel_Information3"]["Text_totalNum"]--:setString(item.szNickName)
                    elseif localcharidx == 4 then 
                        Text_jianNum = self["Panel_Main"]["panel_Information4"]["Text_jianNum"]--:setString(item.szNickName)
                        Text_jiangNum = self["Panel_Main"]["panel_Information4"]["Text_jiangNum"]--:setString(item.szNickName)
                        Text_danjuNum = self["Panel_Main"]["panel_Information4"]["Text_danjuNum"]--:setString(item.szNickName)
                        Text_totalNum = self["Panel_Main"]["panel_Information4"]["Text_totalNum"]--:setString(item.szNickName)
                    end

                    if Text_jianNum ~= nil then
                        Text_jianNum:setString("0")
                    end

                    if Text_jiangNum ~= nil then
                        Text_jiangNum:setString(""..enditem.nBombCount)
                    end

                    if Text_danjuNum ~= nil then
                        Text_danjuNum:setString(""..enditem.lGameScore)
                    end

                    if Text_totalNum ~= nil then
                        Text_totalNum:setString("0")
                    end

                end
            end
            
        end

    end

    -- 显示头像
    self:setuserheadimg(userinfos, 1)
    self:setuserheadimg(userinfos, 2)
    self:setuserheadimg(userinfos, 3)
    self:setuserheadimg(userinfos, 4)

end

function ResultLayer:setuserheadimg(userinfos, idx)
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
                                ctrl = self["Panel_Main"]["panel_Information1"]["headFrame"]--:loadTexture(fileName)
                            elseif localcharidx == 2 then 
                                ctrl = self["Panel_Main"]["panel_Information1"]["headFrame"]--:loadTexture(fileName)
                            elseif localcharidx == 3 then 
                                ctrl = self["Panel_Main"]["panel_Information1"]["headFrame"]--:loadTexture(fileName)
                            elseif localcharidx == 4 then 
                                ctrl = self["Panel_Main"]["panel_Information1"]["headFrame"]--:loadTexture(fileName)
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

return ResultLayer