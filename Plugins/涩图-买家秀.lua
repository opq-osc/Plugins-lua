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

	if string.find(data.MsgBody.Content, "!买家秀") then
		local res = Go.uploadRes(CurrentQQ, 2, 'https://api.uomg.com/api/rand.img3')
		sendGroupMsg(CurrentQQ, 79379938, "请鉴赏 15s后销毁该条消息", res.ResponseData.FileId, res.ResponseData.FileMd5, res.ResponseData.FileSize)
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end

--发送群消息
function sendGroupMsg(CurrentQQ, ToUin, Content, FileId, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = ToUin,
			ToType = 2,
			Content = Content
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