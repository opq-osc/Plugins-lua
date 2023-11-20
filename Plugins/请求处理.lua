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
	return 1
end

function ReceiveEvents(CurrentQQ, data)

	 --收到好友请求
	if data.EventName == "ON_EVENT_FRIEND_SYSTEM_MSG_NOTIFY" then
		if tonumber(CurrentQQ) == 88888888 then
			--Status =1未处理3已通过  其他状态自测
			if data.EventData.Status == 1 then
				Go.Sleep(math.random(10, 20))
				Go.getFriendAddRequest(CurrentQQ, data)
				local res = Go.queryUinByUid(CurrentQQ, data.EventData.ReqUid)
				Go.Sleep(math.random(2, 5))
				sendFriendMsg(CurrentQQ, res.ResponseData[1].Uin, "你好，很高兴为你服务，请描述下你的问题。")
			end
		end
	end

	--[[if data.EventName == "ON_EVENT_GROUP_SYSTEM_MSG_NOTIFY" then
		str = string.format("Events Type %s \n", data.EventName)
		log.info("%s", str)
		--1 申请进群 2 被邀请进群 13退出群聊 15取消管理员 3设置管理员
		if data.EventData.MsgType == 1 then --处理申请入群
			Go.setGroupAddRequest(CurrentQQ, data, 1)--//1同意2拒绝3忽略
		end
		if data.EventData.MsgType == 2 then --同意邀请进群
			Go.setGroupAddRequest(CurrentQQ, data, 1)--//1同意2拒绝3忽略
		end
	end]]--

	 --有人进群
	if data.EventName == "ON_EVENT_GROUP_JOIN" then
		if data.EventData.MsgHead.MsgType == 33 then
			local res = Go.queryUinByUid(CurrentQQ, data.EventData.Event.Uid)
			Go.Sleep(math.random(2, 5))
			sendGroupMsg(CurrentQQ, data.EventData.MsgHead.FromUin, res.ResponseData[1].Nick.."⬅让我一起欢迎这货入坑吧")
		end
	end

	 --有人退群
	if data.EventName == "ON_EVENT_GROUP_EXIT" then
		if data.EventData.MsgHead.MsgType == 34 then
			local res = Go.queryUinByUid(CurrentQQ, data.EventData.Event.Uid)
			Go.Sleep(math.random(2, 5))
			sendGroupMsg(CurrentQQ, data.EventData.MsgHead.FromUin, res.ResponseData[1].Nick.."这货离开了我们")
		end
	end

	return 1
end

--发送好友消息
function sendFriendMsg(CurrentQQ, ToUin, Content, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = ToUin,
			ToType = 1,
			Content = Content,
		}
	}
	if FileMd5 ~= nil then
		request.CgiRequest.Images = {
			{
				FileMd5 = FileMd5,
				FileSize = FileSize
			}
		}
	end
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送群消息
function sendGroupMsg(CurrentQQ, ToUin, Content, Uin, FileId, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = ToUin,
			ToType = 2,
			Content = Content,
		}
	}
	if Uin ~= nil then
		request.CgiRequest.AtUinLists = {
			{
				Uin = Uin
			}
		}
	end
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