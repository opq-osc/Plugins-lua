# 安装说明
将 `Fans.lua` 下载至插件目录下的 lib 文件夹中，即 `Plugins/lib/Fans.lua`

# 导入lua自定义库
在你的lua插件最上面添加
```
package.path = package.path .. ";./Plugins/lib/?.lua;"
local Go = require("Fans")
```

# 用法示例

**发送好友消息**
```
Go.sendFriendMsg(CurrentQQ, data, "Hello, World!")
```

**发送好友消息**
```
Go.sendGroupMsg(CurrentQQ, data, "Hello, World!")
```

**处理好友请求**
```
Go.getFriendAddRequest(CurrentQQ, data, "Hello, World!")
```
`...`

其他函数名称请看 Fans.lua 应该都能理解

# 注意所有插件都需要先导入lua自定义库哦~

插件的上传到插件目录 根据关键词发送即可生效!

其中定时任务的 请参考官方api添加即可 https://73s2swxb4k.apifox.cn/doc-3164909

部分插件是升级大神的旧版插件而来 感谢  https://github.com/opq-osc/lua-plugins