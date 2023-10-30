package.path = package.path .. ";./Plugins/lib/?.lua;"
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
local utils = require("Utils")
local Go = require("Fans")

local admin_qq = 9778566 -- 换为自己的QQ号

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgHead.SenderUin == admin_qq then
		if data.MsgHead.SenderUin == tonumber(CurrentQQ) then return 1 end
		if string.find(data.MsgBody.Content, "停用") then -- 指令
			file = data.MsgBody.Content:gsub("停用 ", "")
			file = file:gsub("停用", "")
			log.info("停用插件===========>%s", file)
			filePath = string.format("./Plugins/%s.lua", file)
			newPath = string.format("./Plugins/%s.lua.bak", file)
			if os.rename(filePath, newPath) then
				Go.sendGroupMsg(CurrentQQ, data, "插件「" .. file .. "」停用成功")
			end
		end
		if string.find(data.MsgBody.Content, "启用") then -- 指令
			file = data.MsgBody.Content:gsub("启用 ", "")
			file = file:gsub("启用", "")
			log.info("启用插件===========>%s", file)
			filePath = string.format("./Plugins/%s.lua.bak", file)
			newPath = string.format("./Plugins/%s.lua", file)
			if os.rename(filePath, newPath) then
				Go.sendGroupMsg(CurrentQQ, data, "插件「" .. file .. "」启用成功")
			end
		end
	end
	if data.MsgBody.Content == '插件列表' then
		if data.MsgHead.SenderUin == admin_qq then
			if data.MsgHead.SenderUin == tonumber(CurrentQQ) then return 1 end
			local ts = io.popen("ls ./Plugins/*lua*")
			local ls = ts:read("*all")
			ls = ls:gsub(".lua", "")
			ls = ls:gsub("./Plugins/", "")
			log.info("插件=====%s", ls)
			Go.sendGroupMsg(CurrentQQ, data, "目前所有插件：\n" .. ls .. "15s后销毁该条消息")
		end
	end
	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end