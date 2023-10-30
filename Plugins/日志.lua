package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data)
	if data.MsgHead.FromType == 1 then --来源好友
		if data.MsgHead.MsgType == 166 then
			local str =
				string.format(
				"收到好友: %s\n消息内容:%s",
				data.MsgHead.SenderUin,
				data.MsgBody.Content
			)
			log.notice("%s", str)
		end
	end

	if data.MsgHead.FromType == 3 then --来源私聊
		if data.MsgHead.MsgType == 141 then
		end
	end
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgHead.MsgType == 82 then
		local str =
			string.format(
			"收到群: %s(%d) 触发对象: %s(%d)\n消息内容:%s",
			data.MsgHead.GroupInfo.GroupName,
			data.MsgHead.FromUin,
			data.MsgHead.SenderNick,
			data.MsgHead.SenderUin,
			data.MsgBody.Content
		)
		log.notice("%s", str)
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end