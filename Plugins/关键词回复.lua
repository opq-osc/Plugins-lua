package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

--问题
--忘记密码
local aqmy_arr = "密码我不知道了,密码忘了,这个验证密码是什么,密码我忘记,密码忘记,密码不记得,密码错误,密码我不知道,忘记了应用中心的密码"

--答案
local aqmy_da = "你的密码 问我干个毛线呢..."

function ReceiveFriendMsg(CurrentQQ, data)
	if data.MsgHead.FromType == 1 then --来源好友
		if data.MsgHead.MsgType == 166 then

			--示例
			local aqmy_res = Go.explode(",", aqmy_arr)
			if Go.fuzzySearch(aqmy_res, data.MsgBody.Content) then
				Go.Sleep(math.random(2, 3))
				Go.sendFriendMsg(CurrentQQ, data, aqmy_da)
			end

		end
	end
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)

    if data.MsgHead.SenderUin == tonumber(CurrentQQ) then
        return 1
    end

	if data.MsgHead.MsgType == 82 then

			--示例
			local aqmy_res = Go.explode(",", aqmy_arr)
			if Go.fuzzySearch(aqmy_res, data.MsgBody.Content) then
				Go.Sleep(math.random(2, 3))
				Go.sendGroupMsg(CurrentQQ, data, aqmy_da)
			end

	end

	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end