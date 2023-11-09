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
	if string.find(data.MsgBody.Content, "!吟诗") then
		response, error_message =
			http.request(
			"GET",
			"https://v1.jinrishici.com/all"
		)
		local html = response.body
		local str = html
		local j = json.decode(str)
		Go.sendGroupMsg(CurrentQQ, data, "“" ..j.content.. "”\n" ..j.author.. "《"..j.origin.. "》")
		html = nil
		str = nil
		j = nil
		end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end