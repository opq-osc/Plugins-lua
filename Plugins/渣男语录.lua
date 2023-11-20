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

	if data.MsgHead.SenderUin == 88888888 then--防止自我复读
		return 1
	end

	if data.MsgHead.MsgType == 82 then
		if string.find(data.MsgBody.Content, "!渣男语录") then
			local msg = nil
			local response, error_message =
				http.request(
				"GET",
				"https://api.lovelive.tools/api/SweetNothings/Web/1"
			)
			local html = response.body
			local info = json.decode(html)
			local msg = info.returnObj.content
			Go.sendGroupMsg(CurrentQQ, data, msg)
			msg = nil
		end
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end
