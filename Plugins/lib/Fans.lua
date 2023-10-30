local Api = require("coreApi")

Fans = {}

--发送好友消息
function Fans.sendFriendMsg(CurrentQQ, data, Content, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
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
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送群消息
function Fans.sendGroupMsg(CurrentQQ, data, Content, Uin, FileId, FileMd5, FileSize)
	local request = {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
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
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送好友语音消息
function Fans.sendFriendVoiceMsg(CurrentQQ, data, FileMd5, FileSize, FileToken)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
			ToType = data.MsgHead.FromType,
			Voice = {
				FileMd5 = FileMd5,
				FileSize = FileSize,
				FileToken = FileToken
			}
		}
	})
end

--处理好友消息 OpCode: 3同意5拒绝 默认同意
function Fans.getFriendAddRequest(CurrentQQ, data, OpCode)
	local request = {
		CgiCmd = "SystemMsgAction.Friend",
		CgiRequest = {
			ReqUid = data.EventData.ReqUid
		}
	}
	if OpCode ~= nil then
		request.CgiRequest.OpCode = OpCode
	else
		request.CgiRequest.OpCode = 3
	end
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送群卡片消息-JSON
function Fans.sendGroupJsonMsg(CurrentQQ, data, Content)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
			ToType = data.MsgHead.ToType,
			SubMsgType = data.MsgBody.SubMsgType,
			Content = Content
		}
	})
end

--发送群卡片消息-XML
function Fans.sendGroupXmlMsg(CurrentQQ, data, Content)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
			ToType = data.MsgHead.ToType,
			SubMsgType = data.MsgBody.SubMsgType,
			Content = Content
		}
	})
end

--发送群回复消息
function Fans.sendGroupReplyMsg(CurrentQQ, data, Content)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
			ToType = data.MsgHead.FromType,
			ReplyTo = {
				MsgSeq = data.MsgHead.MsgSeq,
				MsgTime = data.MsgHead.MsgTime,
				MsgUid = data.MsgHead.MsgUid
			},
			Content = Content,
			AtUinLists = {
				{
					Nick = data.MsgHead.SenderNick,
					Uin = data.MsgHead.SenderUin
				}
			}
		}
	})
end

--发送群语音消息
function Fans.sendGroupVoiceMsg(CurrentQQ, data, FileMd5, FileSize, FileToken)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "MessageSvc.PbSendMsg",
		CgiRequest = {
			ToUin = data.MsgHead.FromUin,
			ToType = data.MsgHead.FromType,
			Voice = {
				FileMd5 = FileMd5,
				FileSize = FileSize,
				FileToken = FileToken
			}
		}
	})
end

--禁言群成员
function Fans.setGroupBan(CurrentQQ, data, BanTime)
	local request = {
		CgiCmd = "SsoGroup.Op",
		CgiRequest = {
			OpCode = 4691,
			Uin = data.MsgHead.FromUin,
			Uid = data.MsgHead.SenderUid,
		}
	}
	if BanTime ~= nil then
		request.CgiRequest.BanTime = BanTime
	else
		request.CgiRequest.BanTime = 120
	end
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--处理群系统消息 OpCode: 1同意2拒绝3忽略 默认同意
function Fans.setGroupAddRequest(CurrentQQ, data, OpCode)
	local request = {
		CgiCmd = "SystemMsgAction.Group",
		CgiRequest = {
			MsgSeq = data.MsgHead.MsgSeq,
			MsgType = data.MsgHead.MsgType,
			GroupCode = data.MsgHead.GroupInfo.GroupCode
		}
	}
	if OpCode ~= nil then
		request.CgiRequest.OpCode = OpCode
	else
		request.CgiRequest.OpCode = 1
	end
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--获取群成员列表
function Fans.getGroupMemberLists(CurrentQQ, data)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "GetGroupMemberLists",
		CgiRequest = {
			Uin = data.MsgHead.FromUin,
			LastBuffer = ""
		}
	})
end

--修改群成员昵称
function Fans.setGroupMemberNick(CurrentQQ, data, Nick)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "SsoGroup.Op",
		CgiRequest = {
			OpCode = 2300,
			Uin = data.MsgHead.FromUin,
			Uid = data.MsgHead.SenderUid,
			Nick = Nick
		}
	})
end

--移除群成员
function Fans.setGroupKick(CurrentQQ, data)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "SsoGroup.Op",
		CgiRequest = {
			OpCode = 2208,
			Uin = data.MsgHead.FromUin,
			Uid = data.MsgHead.SenderUid
		}
	})
end

--退出群聊
function Fans.setGroupLeave(CurrentQQ, data)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "SsoGroup.Op",
		CgiRequest = {
			OpCode = 4247,
			Uin = data.MsgHead.FromUin
		}
	})
end

--打开群红包
function Fans.openGroupRedBag(CurrentQQ, data)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "OpenREDBAG",
		CgiRequest = {
			Wishing = data.MsgBody.RedBag.Wishing,
			Des = data.MsgBody.RedBag.Des,
			RedType = data.MsgBody.RedBag.RedBag,
			Listid = data.MsgBody.RedBag.Listid,
			Authkey = data.MsgBody.RedBag.Authkey,
			Channel = data.MsgBody.RedBag.Channel,
			StingIndex = data.MsgBody.RedBag.StingIndex,
			TransferMsg = data.MsgBody.RedBag.TransferMsg,
			Token_17_2 = data.MsgBody.RedBag.Token_17_2,
			Token_17_3 = data.MsgBody.RedBag.Token_17_3,
			FromUin = data.MsgBody.RedBag.FromUin,
			FromType = data.MsgBody.RedBag.FromType
		}
	})
end

--撤回消息
function Fans.deleteMsg(CurrentQQ, data)
	Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "GroupRevokeMsg",
		CgiRequest = {
			Uin = data.MsgHead.FromUin,
			MsgSeq = data.MsgHead.MsgSeq,
			MsgRandom = data.MsgHead.MsgRandom
		}
	})
end

--上传资源文件
function Fans.uploadRes(CurrentQQ, CommandId, FileUrl, FilePath, Base64Buf)
	local request = {
		CgiCmd = "PicUp.DataUp",
	}
	if CommandId ~= nil then
		request.CgiRequest.CommandId = CommandId
	else
		request.CgiRequest.CommandId = 2
	end
	if FileUrl ~= nil then
		request.CgiRequest.FileUrl = FileUrl
	end
	if FilePath ~= nil then
		request.CgiRequest.FilePath = FilePath
	end
	if Base64Buf ~= nil then
		request.CgiRequest.Base64Buf = Base64Buf
	end
	Api.Api_MagicCgiCmd(CurrentQQ, request)
end


-- 检查是否是表达式
function Fans.isExpression(str)
    -- 定义表达式的模式
    local pattern = "^[%w()+*/%-%.]+$"

    -- 使用模式匹配进行判断
    if str:match(pattern) then
        return true
    else
        return false
    end
end

-- 计算器函数
function Fans.calculator(expression)
    local func = loadstring("return " .. expression)
    if func then
        setfenv(func, {})
        return func()
    else
        return nil, "无效的表达式"
    end
end

-- 延迟执行
function Fans.delayedExecution(delay, callback)
	os.execute("sleep " .. delay)  -- 在 Linux/macOS 上使用 sleep 命令
	-- os.execute("timeout /t " .. delay)  -- 在 Windows 上使用 timeout 命令
	if callback then
		callback()
	end
end

--睡眠
function Fans.Sleep(n)
	local t0 = os.clock()
	while os.clock() - t0 <= n do
	end
end

return Fans
