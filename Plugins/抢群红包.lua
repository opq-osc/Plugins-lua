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

	if data.MsgBody.SubMsgType == 24 then --红包类型
		info = Go.openGroupRedBag(CurrentQQ, data)

		math.randomseed(os.time())

		successIndex = math.random(1, 6)
		failIndex = math.random(1, 4)
		successArray = {
			"谢谢老板～🙏",
			"老板发财💰",
			"谢谢🙏",
			"谢谢大佬的红包",
			"发红包的好帅😂",
			"老板大发特发💰"
		}
		failArray = {
			"群里有外挂吧?😂😂😂😂",
			"卧槽 ,好多外挂.....",
			"外挂可耻",
			"这都是什么手速😂😂😂😂"
		}

		if (info.ResponseData.GetMoney == 0) then
			log.notice("没抢到%s", "===========")
			Go.sendGroupMsg(CurrentQQ, data, failArray[failIndex])
			return 1
		end

		if (info.ResponseData.GetMoney > 0) then
			Go.sendGroupMsg(CurrentQQ, data, successArray[successIndex])
		end


		str =
			string.format(
			"刚刚抢到了 %d",
			info.ResponseData.GetMoney
		)
		log.notice("%s", str)
	end

	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end