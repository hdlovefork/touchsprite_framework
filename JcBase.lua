require("TSLib")
require("sql")
function quotient(L,S)
	-- 取商方法
	local t1,t2 = math.modf(L/S);
	return t1
end
--三元运算
function iif(exp,rTrue,rFalse)
	if exp == false or exp == nil then
		return rFalse
	else 
		return rTrue
	end 
end 
function IsNull(set)
	if set == nil then
		return true
	else
		return false
	end
end
function _多比色(data,delay,click,fly)
	local temp,ret,ls
	temp = 0
	delay = delay or -1
	click = click or 0
	fly = fly or 0
	repeat
		windows()
		for k,v in ipairs(data) do
			if type(v)=="string" then
				ls = v
				v ={}
				v["data"] = 特征[ls];
				v["precision"] = 85
				v["click"] = 0
			else
				v["precision"] = v["precision"] or 85
				v["click"] = v["click"] or 0
			end
			if v["click"]==0 and click==0 then
				ret =multiColor(v["data"],v["precision"],true)
			else
				ret =multiColTap(v["data"],v["precision"])
			end
			if ret then
				temp = k
				break
			end
		end
		if temp ==0 then
			if fly==1 then
				_点飞鞋()
			end
			if delay > 0 then
				delay = delay - 500
				if delay < -1 then
					break;
				end
			end
			mSleep(400)
		end
	until (temp>0 or delay<0)
	return temp
end
function _找色(data,range,precision,click)
	precision = precision or 80
	click = click or 0
	windows()
	if type(data)=="string" then
		range = 范围[data]
		data = 特征[data]
	end
	local x,y=findMultiColorInRegionFuzzyByTable(data,precision,range[1],range[2],range[3],range[4])
	if x ~= -1 and click>0 then
		if click==2 then
			randomsTap(x,y,10)
		else
			tap(x,y)
		end
	end
	return x,y
end
function _单色(color,range,delay,precision)
	delay = delay or 0
	precision = precision or 100
	local x, y 
	repeat
		x, y = findColorInRegionFuzzy(color, precision, range[1],range[2],range[3],range[4]); 
		if x==-1 and delay<=0 then
			return false
		elseif x>-1 then
			return true
		else
			delay = delay - 500
		end
	until (x>-1)
	return true
end
function _等多色(data,delay,click)
	--data={table-特征,table-范围,}
	local x,y,sort,ls
	sort = 0
	x = -1
	y = -1
	delay = delay or -1
	click = click or 0
	repeat
		windows()
		for k,v in ipairs(data) do
			windows()
			if type(v)=="string" then
				ls = v
				v = {}
				v["data"] = 特征[ls];
				v["range"] = 范围[ls];
				v["precision"] = 85
				v["click"] = 0
			else
				v["precision"] = v["precision"] or 85
				v["click"] = v["click"] or 0
			end
			if click == 1 then
				v["click"] = 1
			end
			x,y =_找色(v["data"],v["range"],v["precision"],v["click"])
			if x > -1 then
				sort = k
				break
			end
		end
		if x == -1 then
			if delay >= 0 then
				delay = delay - 399
				if delay < -1 then
					break;
				end
			end
			mSleep(400)
		end
	until (sort>0)
	return sort,x,y
end
function _等色(data,range,delay,click,precision,set)
	--默认做点在线礼包
	local x,y
	local x1,y1
	delay = delay or -1
	set = set or 0
	if type(data) == "string" then
		range = 范围[data]
		data = 特征[data]
	end
	repeat
		broke(set)
		x,y =_找色(data,range,precision,click)
		if x == -1 then
			if delay >= 0 then
				delay = delay - 399
				if delay < -1 then
					break
				end
			end
			mSleep(400)
		end
	until(x > -1)
	return x,y
end
function _找字(lib,word,range,precision,color,click,delay,fly)
	--字库,文字,范围,
	click = click or 0
	precision = precision or 85
	delay = delay or 0
	fly = fly or 0
	range = range or 范围[lib]
	color = color or 字色[lib]
	if font[lib.."_"..word] == nil then
		font[lib.."_"..word]=addTSOcrDictEx(文字[lib.."_"..word])
	end
	repeat
		windows()
		keepScreen(true)
		local x, y = tsFindText(font[lib.."_"..word], word, range[1],range[2],range[3],range[4], color, precision)
		keepScreen(false)
		if x>-1 and click>0 then
			windows()
			tap(x+12,y+12,500)
		elseif x==-1 then
			if fly ==1 then
				_点飞鞋()
			end
			if delay>0 then
				delay = delay -500
				mSleep(480)
			end
		end
	until (delay<=0 or x>-1)
	return x,y
end
function _找面(data,range,delay,click,direction,host,lite)
	direction = direction or 2
	delay = delay or -1
	click = click or 0
	host = host or 0x101010
	lite = lite or 0x101010
	if type(data)=="string" then
		range = 范围[data]
		data = 特点[data]
	end
	local set={orient = direction,main = host, list = lite}
	repeat
		broke()
		x,y = findMultiColorInRegionFuzzy(data[1],data[2], 90,range[1],range[2],range[3],range[4],set)
		if x == -1 then
			if delay >= 0 then
				delay = delay - 399
				if delay < -1 then
					break
				end
				mSleep(400)
			end
		end
	until (delay<0 or x>-1)
	if x>-1 and click==1 then
		randomTap(x,y)
	end
	return x,y
end
function numOcr(range,set,num,whitelist)
	local text
	set = set or 0
	num = num or 0
	whitelist = whitelist or "0123456789"
	windows()
	if type(range)=="string" then
		range=范围[range]
	end
	text = ocrText(range[1],range[2],range[3],range[4], set,whitelist);
	if whitelist~= "0123456789" then
		text = string.gsub(text, " ","")
		text = string.gsub(text, "[%(%)]","")
	end
	if num ==0 then
		text = tonumber(text)
		if text == nil then
			text = 0
		end
	end
	return text
end
function _识字(lib,range,precision,color)
	precision = precision or 85
	delay = delay or 0
	range = range or 范围[lib]
	color = color or 字色[lib]
	if font[lib] == nil then
		font[lib]=addTSOcrDict(lib..phoneInfo['PPI']..".txt")
	end
	tsOcrText(font[lib],range[1],range[2],range[3],range[4], color, precision)
end
function _请求(php,data,set)
	local ret,url,quit,x,y
	quit = 0
	if set==nil then
		url = "http://wx.hte9.com/legend/v2/"..php..".php"
	else
		url = "http://wx.hte9.com/index.php?g=Home&m=Mir&a="..php
	end
	repeat
		ret = httpPost(url, data);
		x,y =string.find(ret,"DOCTYPE")
		if x==nil then
			quit = 1
		else
			mSleep(2500)
		end
	until (quit ==1)
	ret = ts.json.decode(ret);
	return ret
end
function callMaster(data,set)
	--请求人工协助
	set = set or 0
	local msg
	msg = "&uid="..role['uid'].."&msg="..data.."&lv="..set
	_请求("master",msg)
end
function exception(msg,title,set)
	--异常处理
	title = title or "登陆失效通知"
	set = set or 0
	wLog("test","[DATE] "..msg);
	ts.smtp("50494558@qq.com",title,msg,"smtp.163.com","newtonld@163.com","Yme8cksk")
	mSleep(200)
	ts.smtp("402497525@qq.com",title,msg,"smtp.163.com","newtonld@163.com","Yme8cksk")
	if set == 1 then
		set_restart()
	elseif set == 2 then
		lua_exit();
		mSleep(10)
		mSleep(10)
	end
	return set
end
function checkApp(bao)
	-- body
	local isfront,res
	bao = bao or gameApp
	if isFrontApp(bao)==1 then
		return
	elseif bao == gameApp then
		tracePrint('KillXX时发现不在游戏了,重启')
		set_restart()
	end
	res = 0
	repeat
		runApp(bao)
		mSleep(5000)
		windows()
		isfront = isFrontApp(bao);
		if res >=20 then
			exception("打开"..bao.."异常",bao.."打不开",2)
		else
			res = res +1
		end
	until (isfront==1)
end
function windows()
	--处理iOS弹窗
	if 设备>=3 then
		return
	end
	local x,y,direction,need,ret
	direction = -1
	need = 0
	--先查范围内找有没有以后字颜色
	--横屏
	x, y = findColorInRegionFuzzy( 0x007aff, 100,387, 392, 481, 443);
	if x==-1 then
		--竖屏
		x, y = findColorInRegionFuzzy( 0x007aff, 100,113, 633, 255, 696);
		if x==-1 then
			return
		end
		direction = 0
	else
		direction = 1
	end
	if direction==-1 then
		return
	elseif direction==0 then
		ocrChar = ocrText(113, 633, 255, 696, 1);
	else
		ocrChar = ocrText(387, 392, 481, 443, 1);
	end
	x,y =string.find(ocrChar,"以后")
	if x~=nil then
		need = 1
	else
		x,y =string.find(ocrChar,"不允许")
		if x~=nil then
			need = 1
		end
	end
	if need>=1 then
		ret = windowsTap(need)
		--点掉iOS弹窗
		tap(ret[1+direction*2],ret[1+direction*1])
		mSleep(488)
	end
end
function windowsTap(set)
	local w,h
	w, h = getScreenSize();
	if width == 640 and height == 1136 then         --iPhone SE,5,5S,iPod touch 5
		--12,是竖屏,34是横屏
		return {198,224,430,413}
	elseif width == 1080 and height == 1920 then
		--小米2等
	elseif width == 720 and height == 1280 then
		--360N5等
	end
end
function roleWrite()
	--保存内容到json文件
	if role==nil then
		return false
	end
	local times=os.time()
	role['endTime']=times
	writeFileString(media.."/jcmir/role.json", ts.json.encode(role),"w")
	mSleep(20)
end
function loginWrite()
	--保存内容到json文件
	if login==nil then
		return false
	end
	local times=os.time()
	login['endTime']=times
	writeFileString(media.."/jcmir/login.json", ts.json.encode(login),"w") 
	mSleep(20)
end
function jsonRead(file)
	local res
	file = file or media.."/jcmir/role.json"
	if isFileExist(file) == false then
		return false
	end
	res = readFileString(file)
	if res == '' then
		return false
	end
	return ts.json.decode(res)
end
function keyDel(num)
	num = num or 1
	for i = 1,num do
		if phoneInfo['sys']==0 then
			os.execute("input keyevent KEYCODE_DEL")
			mSleep(10)
		else
			keyDown("DeleteOrBackspace")
			mSleep(5)
			keyUp("DeleteOrBackspace")
			mSleep(5)
		end
	end
	mSleep(50)
end
function _截图(range,file,suffix)
	file = file or os.date("%Y-%m-%d_%H:%M:%S")
	file = media ..'/jcmir/'..phoneInfo['zid']..'/snap/'..file
	local w,h = getScreenSize();
	range = range or {0, 0, w-1, h-1}
	suffix = suffix or ".png"
	-- 右下角顶点坐标最大为 (宽度最大值 - 1，高度最大值 - 1)
	snapshot(file..suffix, range[1],range[2],range[3],range[4]);
	mSleep(40)
end
function dump(self)
	if type(self) ~= "table" then nLog(self) return end
	local space, deep = string.rep(' ', 4), 0 
	--内部循环
	local function _dump(t)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if type(v) == "table" then
				deep = deep + 3
				nLog(string.format("%s[%s] = {",string.rep(space, deep-3),key,string.rep(space, deep)))
				_dump(v)
				nLog(string.format("%s}",string.rep(space, deep-1)))
				deep = deep - 3	
			else
				nLog(string.format("%s[%s] = %s",string.rep(space, deep),key,v)) 
			end 
		end 
	end
	_dump(self)
end
function tracePrint(msg,set)
	-- body
	if base.set == 0 then
		return
	elseif base.set == 2 then
		nLog(msg)
	end
end