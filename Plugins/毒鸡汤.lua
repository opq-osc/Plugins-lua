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
	if string.find(data.MsgBody.Content, "毒鸡汤") == 1 then
		response, error_message =
			http.request(
			"GET",
			"https://api.hanximeng.com/soul/api.php",
			{
				query = "type=text",
				headers = {
					["Accept"] = "*/*",
					["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
				}
			}
		)
		local html = response.body
		log.notice("毒鸡汤--->%s", html)
		Go.sendGroupMsg(CurrentQQ, data, html)
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end