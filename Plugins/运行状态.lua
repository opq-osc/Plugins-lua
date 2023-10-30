package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local utils = require("Utils")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgHead.SenderUin == 9778566 then --换为自己的QQ号
		if data.MsgBody.Content == '状态' then
			local response, error_message = http.request("GET", "http://0.0.0.0:9204/v1/clusterinfo?isShow=1")
			local result = json.decode(response.body).ResponseData
			Go.sendGroupMsg(CurrentQQ, data, "BOT运行状态: " .. "\n在线QQ数量: " ..result.QQUsersCounts.. "\nVersion: " ..result.Version.. "\nServerRuntime: " ..result.ServerRuntime)
			result = nil
		end
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end
