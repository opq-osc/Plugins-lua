package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgHead.SenderUin ==209796322 then--防止自我复读
		return 1
	end

	if string.find(data.MsgBody.Content, "!一言") then
		local text = nil
		local response, error_message =
			http.request(
			"GET",
			"https://v1.hitokoto.cn/"
		)
		local hitokoto = response.body
		local a = json.decode(hitokoto)
		if(a.from_who == nil) then
			from = "「" .. a.from .. "」"
		else
			from = a.from_who .. "「" .. a.from .. "」"
		end
		text = "『一言 hitokoto』\n" .. a.hitokoto .. "\n——" .. from
		Go.sendGroupMsg(CurrentQQ, data, text)
		text = nil
	end

	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end
