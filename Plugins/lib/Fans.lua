local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")

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
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
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
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送好友语音消息
function Fans.sendFriendVoiceMsg(CurrentQQ, data, FileMd5, FileSize, FileToken)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--发送群卡片消息-JSON
function Fans.sendGroupJsonMsg(CurrentQQ, data, Content)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
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
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--获取群成员列表
function Fans.getGroupMemberLists(CurrentQQ, data)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "GetGroupMemberLists",
		CgiRequest = {
			Uin = data.MsgHead.FromUin,
			LastBuffer = ""
		}
	})
end

--修改群成员昵称
function Fans.setGroupMemberNick(CurrentQQ, data, Nick)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "SsoGroup.Op",
		CgiRequest = {
			OpCode = 4247,
			Uin = data.MsgHead.FromUin
		}
	})
end

--打开群红包
function Fans.openGroupRedBag(CurrentQQ, data)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "OpenREDBAG",
		CgiRequest = {
			RedBag = data.MsgBody.RedBag
		}
	})
end

--撤回消息
function Fans.deleteMsg(CurrentQQ, data)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
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
		CgiRequest = {
			CommandId = CommandId
		}
	}
	if FileUrl ~= nil then
		request.CgiRequest.FileUrl = FileUrl
	elseif FilePath ~= nil then
		request.CgiRequest.FilePath = FilePath
	elseif Base64Buf ~= nil then
		request.CgiRequest.Base64Buf = Base64Buf
	end
	return Api.Api_MagicCgiCmd(CurrentQQ, request)
end

--QueryUinByUid
function Fans.queryUinByUid(CurrentQQ, Uid)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "QueryUinByUid",
		CgiRequest = {
			Uid = Uid
		}
	})
end

--添加任务
function Fans.cronAdd(CurrentQQ, BotUin, Sepc, FileName, FuncName)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "Cron.Add",
		CgiRequest = {
			BotUin = BotUin,
			Sepc = Sepc,
			FileName = FileName,
			FuncName = FuncName
		}
	})
end

--删除任务
function Fans.cronDel(CurrentQQ, TaskId)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "Cron.Del",
		CgiRequest = {
			TaskId = TaskId
		}
	})
end

--获取任务
function Fans.cronGet(CurrentQQ)
	return Api.Api_MagicCgiCmd(CurrentQQ, {
		CgiCmd = "Cron.Get",
		CgiRequest = {}
	})
end

-- 模糊查询数组元素是否在关键词中
function Fans.fuzzySearch(array, keyword)
	for _, value in ipairs(array) do
		if string.match(keyword, value) then
			return true
		end
	end
	return false
end

-- 判断关键词是否在数组中
function Fans.isInArray(keyword, array)
	for _, value in ipairs(array) do
		if value == keyword then
			return true
		end
	end
	return false
end

-- 字符串转换为数组
function Fans.explode(delimiter, str)
	local result = {}
	local pattern = string.format("([^%s]+)", delimiter)
	for match in str:gmatch(pattern) do
		table.insert(result, match)
	end
	return result
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

-- -- 定义一个函数
function Fans.func1(test)
	io.write("这是一个公有函数！\n" .. test)
end

--睡眠
function Fans.Sleep(n)
	local t0 = os.clock()
	while os.clock() - t0 <= n do
	end
end

--时间戳->字符串 格式化时间 到秒
function Fans.FormatUnixTime2Date(t)
	return string.format(
		"%s年%s月%s日%s时%s分%s秒",
		os.date("%Y", t),
		os.date("%m", t),
		os.date("%d", t),
		os.date("%H", t),
		os.date("%M", t),
		os.date("%S", t)
	)
end

--时间戳->字符串 格式化时间 到日期
function Fans.FormatUnixTime2Day(t)
	return string.format("%s年%s月%s日", os.date("%Y", t), os.date("%m", t), os.date("%d", t))
end

--字符串分割
function Fans.split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter == "") then
		return false
	end
	local pos, arr = 0, {}
	-- for each divider found
	for st, sp in function()
		return string.find(input, delimiter, pos, true)
	end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

--Url解码
function Fans.UrlDecode(s)
	s =
		string.gsub(
		s,
		"%%(%x%x)",
		function(h)
			return string.char(tonumber(h, 16))
		end
	)
	return s
end

--随机整数
function Fans.GenRandInt(x, y)
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	num = math.random(x, y)
	return num
end
function Random(n, m)
	math.randomseed(os.clock() * math.random(1000000, 90000000) + math.random(1000000, 90000000))
	return math.random(n, m)
end

--随机字符串
function Fans.RandomLetter(len)
	local rt = ""
	for i = 1, len, 1 do
		rt = rt .. string.char(Random(97, 122))
	end
	return rt
end

--获取星期几
function Fans.GetWday()
	local wday = os.date("%w", os.time())
	local weekTab = {
		["0"] = "日",
		["1"] = "一",
		["2"] = "二",
		["3"] = "三",
		["4"] = "四",
		["5"] = "五",
		["6"] = "六"
	}
	return weekTab[wday]
end

--读取文件
function Fans.ReadFile(filePath)
	local f, err = io.open(filePath, "rb")
	if err ~= nil then
		return nil
	end
	local content = f:read("*all")
	f:close()
	return content
end

--写文件
function Fans.WriteFile(path, content)
	local file = io.open(path, "wb+")
	if file then
		if file:write(content) == nil then
			return false
		end
		io.close(file)
		return true
	else
		return false
	end
end

return Fans