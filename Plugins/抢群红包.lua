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

	if data.MsgBody.SubMsgType == 24 then --红包类型
		Go.openGroupRedBag(CurrentQQ, data)
	end

	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end