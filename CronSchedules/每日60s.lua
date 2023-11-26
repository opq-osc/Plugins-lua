package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function meiri60s(CurrentQQ, task)
	local res = Go.uploadRes(CurrentQQ, 2, 'https://api.qqsuu.cn/api/dm-60s')
	sendGroupMsg(CurrentQQ, 79379938, res.ResponseData.FileId, res.ResponseData.FileMd5, res.ResponseData.FileSize)
	local str = string.format("%s%s task ticks %d TaskId %d", "每日60s", "done", task.Ticks, task.TaskId)
	log.info("每日60s.lua Log\n%s", str)
	return 1
end

--发送群消息
function sendGroupMsg(CurrentQQ, ToUin, FileId, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = ToUin,
			ToType = 2,
		}
	}
	if FileMd5 ~= nil then
		request.CgiRequest.Images = {
			{
				FileId = FileId,
				FileMd5 = FileMd5,
				FileSize = FileSize
			}
		}
	end
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end