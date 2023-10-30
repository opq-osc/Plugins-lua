package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local utils = require("Utils")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data)

	if data.MsgHead.FromType == 1 then --来源好友
		if data.MsgHead.MsgType == 166 then

			if Go.isExpression(data.MsgBody.Content) then
				local result = Go.calculator(data.MsgBody.Content)
				if result then
					Go.sendFriendMsg(CurrentQQ, data, "计算结果: " .. result)
					--print(result)
				end
			end

		end
	end

	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end