package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data) return 1 end

function ReceiveGroupMsg(CurrentQQ, data)
	--禁止长消息刷屏
	if data.MsgBody.Content:find("%c") then
		local retTbl = {}
		for s in string.gmatch(data.MsgBody.Content, "%c") do
			if retTbl[s] then
				retTbl[s] = retTbl[s] + 1
			else
				retTbl[s] = 1
			end
		end
		if tonumber(retTbl["\n"]) >= 100 then
			Go.Sleep(1)
			Go.deleteMsg(CurrentQQ, data)
			return 1
		end
	end

	if data.MsgHead.ToUin == tonumber(CurrentQQ) then
		if data.MsgBody.Content:find('s后销毁') then
			local num = data.MsgBody.Content:match("(%d+)s后销毁.*")
			if tonumber(num) then delay = tonumber(num) end
			Go.Sleep(delay)
			Go.deleteMsg(CurrentQQ, data)
		end
		if data.MsgBody.Content:find('秒撤回') then
			local num = data.MsgBody.Content:match("(%d+)秒撤回.*")
			if tonumber(num) then delay = tonumber(num) end
				Go.Sleep(delay)
				Go.deleteMsg(CurrentQQ, data)
		end
	end

	return 1
end

function ReceiveEvents(CurrentQQ, data) return 1 end