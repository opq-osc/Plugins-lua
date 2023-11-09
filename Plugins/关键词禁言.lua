package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local Go = require("Fans")

function ReceiveFriendMsg(CurrentQQ, data) return 1 end

function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgHead.SenderUin == tonumber(CurrentQQ) then return 1 end

	if data.MsgHead.MsgType == 82 then
		if string.find(data.MsgBody.Content, "!蛋疼") then
			math.randomseed(os.time())
			num = math.random(1, 5) * 60
			Go.setGroupBan(CurrentQQ, data, num)
			Go.sendGroupMsg(CurrentQQ, data, "恭喜您荣获 " .. num .. "秒 禁言，特此表彰")
			return 1
		end

		local black_list = swear(data.MsgBody.Content)
		if black_list ~= "pass" then
			log.info("黑名单关键词匹配成功==============>%s", black_list)
			math.randomseed(os.time())
			shut_time = math.random(1, 5) * 60
			Go.setGroupBan(CurrentQQ, data, shut_time)
			Go.sendGroupMsg(CurrentQQ, data, "恭喜你喜提禁言套餐一份，约" .. shut_time .. "秒后解除禁言", data.MsgHead.SenderUin)
		end
	end
	return 1

end

function ReceiveEvents(CurrentQQ, data)
	return 1
end

function swear(content)
	black_list = {
		"来.*禁言套餐", "有种禁言我", "求禁言", "狗管理", "狗群主"
	}
	for i = 1, #black_list, 1 do
		if string.find(content, black_list[i]) then
			return black_list[i]
		end
	end
	return "pass"
end
