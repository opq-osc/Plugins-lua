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

    if data.MsgHead.SenderUin == tonumber(CurrentQQ) then
        return 1
    end

	if data.MsgHead.MsgType == 82 then

		if string.find(data.MsgBody.Content, "复读鸡") then
			local keyWord = data.MsgBody.Content:gsub("复读鸡", "")
			keyWord = keyWord:gsub(" ", "")
			if keyWord == "" then
				return 1
			end
			Go.sendGroupMsg(CurrentQQ, data, keyWord)
		end

	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end