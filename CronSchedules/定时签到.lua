package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function auto_sign(CurrentQQ, task)
	sendGroupMsg(CurrentQQ, 856337734, "签到")
	Go.Sleep(math.random(5, 10))
	sendGroupMsg(CurrentQQ, 856337734, "签到88888888")
	local str = string.format("%s%s task ticks %d TaskId %d", "定时签到", "done", task.Ticks, task.TaskId)
	log.info("定时签到.lua Log\n%s", str)
	return 1
end

--发送群消息
function sendGroupMsg(CurrentQQ, ToUin, Content)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = ToUin,
			ToType = 2,
			Content = Content
		}
	}
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end