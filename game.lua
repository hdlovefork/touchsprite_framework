require("ready")
require("login")
require("core")
require("start")
require("dates")
require("login")
require("user")
require("stroe")
require("bank")
require("mission")--任务相关
require("equip")--装备相关
require("skill")--技能相关
require("weeks")--周俸任务
function check_lv()
	intoMain()
	local num
	num = numOcr('人物等级')
	if num>0 then
		role['lv']=num
	end
end
function intoMain()
	--到达游戏
	killXX()
	if multiColor(特征.左上_战斗力) then
		return
	end
	local pass,res
	res = 0
	repeat
		pass = check_panel()
		if pass==7 then
			tracePrint("到达主界面")
			return
		elseif pass==0 then
			killXX()
			mSleep(1000)
			res = res +1
		else
			set_restart()
		end
	until(res>=10)
	
end
function check_panel(set)
	--返回值->0:游戏外,10:登陆有账号,11:登陆没账号,20:选角色,30游戏中,31副本中
	local isfront,ret
	set = set or 1
	repeat
		--检测游戏是否在运行
		isfront = isFrontApp(gameApp);
		if set >=1 and isfront==0 then
			--游戏不在运行中
			tracePrint("游戏不在运行中")
			set_restart()
		elseif set == 2 then
			return 0
		elseif set ==0 and isfront==0 then
			return -1
		end
		--游戏界面判断
		--先看是否在登陆界面
		ret = _多比色({'登陆_选角','登陆_建角',"登陆_注销","登陆_微信","登陆_LOAD","游戏浏览器","左上_战斗力"})
		if ret==5 then
			sj('登陆_继续下载',1500,5)
		elseif ret== 6 then
			sj('关浏览器',3000)
			ret = 5
		elseif ret == 3 or ret == 4 then
			login['qu'] = 0
			if ret == 4 then
				login['type'] = 0
			end
			set_restart()
		end
	until (ret~=5)
	return ret
end
function loading()
	local temp,num
	num = 0
	repeat
		temp = multiColor(特征.登陆_LOAD)
		if temp== true then
			sj('登陆_继续下载',1000,5)
			num = num +1
			if num>180 then
				exception(phoneInfo['zid'].."卡loading三分钟","Loading卡住",2)
			end
		end
	until(temp==false)
end
function _姓名(range)
	range = range or 范围.选角色名字
	windows()
	name = ocrText(range[1],range[2],range[3],range[4], 1);
	tracePrint("识别出名字为:"..name)
	mSleep(20)
	return name
end
function _在线时间()
	-- body 
	if multiColTap(特征.在线时间弹窗) then
		mSleep(500)
	end
end
function _新称号()
	-- body
	if multiColTap(特征.新称号) then
		tracePrint("点掉新称号")
		mSleep(400)
	end
end
function broke(set)
	local isfront
	--解决弹窗set=-1时忽略在线礼包
	windows()
	--游戏内
	if isFrontApp(gameApp)==0 then
		set_restart()
		mSleep(100)
	end
	--点掉立即装备和在线时间
	_在线时间()
	_新称号()
	guild()
	set = set or 0
	if set~=-1 then
		online(set)
	end
end
function online(set)
	--set->0:不点X,1:点x
	windows()
	set = set or 0
	local res,temp
	--zb:有战斗力
	--先看有没有小xx
	repeat
		if set==0 then
			temp = multiColor(特征.在线_小红XX)
			if temp then
				res = multiColor(特征.在线_装备战力)
				sj('在线_立即领取')
				if res then
					sj('底部_经验条')
				else
					mSleep(1500)
					sj('底部_经验条',500)
					sj('底部_经验条')
				end
			end
		else
			temp = multiColTap(特征.在线_小红XX)
			mSleep(300)
		end
	until (temp==false)
end
function guild()
	--行会
	if multiColTap(特征.弹窗_行会邀请) then
		tracePrint("点掉行会邀请")
		mSleep(200)
	end
end
function killXX()
	local x,y,res
	res = 0
	checkApp()
	repeat
		_新称号()
		_在线时间()
		windows()
		if res == 0 then
			if multiColor(特征.任务_对话) then
				sj('任务_对话_关闭',500)
			end
--			if multiColTap(特征.包满_确定) then
--				role['break'] = 0
--			end
			x,y = _找面(xx.h,范围.xxh,75,1)
			if x~=-1 then
				mSleep(300)
			end
		end
		for i=1,2 do
			x,y = _找面(xx[i],范围.xx)
		end
		x,y = _找色(xx.r,范围.xxr,75,1)
		if x~=-1 then
			mSleep(500)
			res = res +1
		end
		if res>6 then
			if _CloseNPC() then
				break
			end
			if multiColor(特征.礼券_购买) then
				sj('礼券_购买_关闭',500)
				res = 1
			end
		end
	until (x==-1 or res>6)
	return res
end
function _打开下拉按钮(set)
	local res,num
	set = set or 0
	num =0
	tracePrint("打开下拉按钮")
	intoMain()
	repeat
		-- body
		broke()
		res = _多比色({"底部_社交1","底部_社交2"})
		if res >0 then
			break
		else
			if num >=2 then
				guild()
			end
			sj('底部_经验条',1200)
			num = num +1
		end
	until (num>6)
	if num>6 then
		set_restart()
	elseif set>0 then
		num = iif(set>4,偏移.底部_按钮[4],0)
		ss(偏移.底部_按钮[1]+num+偏移.底部_按钮[3]*(set-1),偏移.底部_按钮[2],400)
	end
end
function task()
	-- 展开任务列表
	if multiColTap(特征.任务栏_任务B) then
		tracePrint("展开任务列表")
		mSleep(300)
	end
end
function colorful(range,set)
	local color,data,x,y
	set = set or 0
	color = -1
	data = {0xA8A79D,0x42ebff,0x009aff,0x30e7ff,0xEE5DF5,0x40ff99,0x1ebe50,0xfffb6b,0xffdb31,0xeb6d31}
	if set == 0 then
		keepScreen(true)
	end
	for i= #data,1,-1 do
		x,y =findColorInRegionFuzzy(data[i], 85, range[1],range[2],range[3],range[4]); 
		if x~=-1 then
			color = i
			break
		end
	end
	if set == 0 then
		keepScreen(true)
	end
	if color== -1 then
		return -1
	elseif color >7 then
		return 4
	elseif color >5then
		return 3
	elseif color ==5 then
		return 2
	elseif color >1 then
		return 1
	else
		return 0
	end
end
function ss(x,y,delay,z)
	windows()
	z = z or 10
	delay = delay or 200
	randomTap(x,y,z)
	mSleep(delay)
end
function sj(data,delay,z)
	windows()
	_新称号()
    _在线时间()
	z = z or 10
	delay = delay or 200
	randomTap(点击[data][1],点击[data][2],z)
	mSleep(delay)
end
function _点飞鞋()
    local data,x,y
    for i = 1,12 do
		keepScreen(true);
		for i = 15,0,-1 do
			windows()
			x,y = findMultiColorInRegionFuzzy(特点.fly[1],特点.fly[3], 90,范围.fly[1], 范围.fly[2], 范围.fly[3], 范围.fly[4],{orient =1 ,main = 特点.fly[2]})
			if x>0 then
				tap(x,y)
				keepScreen(false);
				return true
			end
		end
		keepScreen(false);
		mSleep(10)
    end
	return false
end
function NPC_click(set)
	set = set or 0
	ss(偏移.地图_NPC[1],偏移.地图_NPC[2]+偏移.地图_NPC[3]*set)
end
function _购买列表(set)
	set = set or 0
	ss(偏移.购买_列表[1],偏移.购买_列表[2]+偏移.购买_列表[3]*set)
	ss(偏移.购买_列表[1],偏移.购买_列表[2]+偏移.购买_列表[3]*set,500)
end
function NPC_say(say,delay,click,fly,range)
	local x,y
	delay = delay or 4000
	fly = fly or 0
	click = click or 0
	range = range or 范围.对话框
	x,y=_找字("对话",say,range,85,字色.对话,click,delay,fly)
	return x,y
end
function mapNPC(map,delay,fly)
	fly = fly or 0
	delay=delay or 60000
	local temp,num,ret
	num = 0
	ret =0
	repeat
		if num == 0 then
			if multiColor(特征.顶按_世界地图)==false then
				killXX()
				sj('关页面')
				temp = _多比色({'顶按_世界地图'},3100)
				if temp == 0 then
					return false
				end
			end
			NPC_click(map)
			sj('关页面',500)
		end
		if fly>0 then
			_点飞鞋()
		end
		temp = _多比色({'NPC对话框','任务_接受','任务_完成'})
		if temp==1 then
			return true
		elseif temp>1 then
			sj('任务_提交',1000)
			ret = _剧情引导()
			if ret<2 then
				killXX()
				_切换线路()
			end
		else
			mSleep(980)
			num = num+1
			delay = delay - 1000
		end
	until(delay<=0)
	return false
end
function _切换线路(set)
	set = set or 0
	local temp,ret
	intoMain()
	sj('左上_线路')
	ret = 0
	temp = _多比色({'线路_1线'},5100,0)
	if temp ==0 then
		return ret
	else
		if multiColTap(特征.任务_引导) then
			mSleep(400)
			ret = 2
		else
			ret = 1
		end
		ss(偏移.线路[1]+偏移.线路[3]*set,偏移.线路[2],400)
		return ret
	end
end
function _填写字符(data,num)
    if 设备>=3 then
		return _AndriodInput(data,num)
	end
	local ret
	num = num or 1
    mSleep(800)
	for k,v in ipairs(word) do
		ret = multiColor(v,90,true)
		if ret then
			keyDel(num+1)
			inputText(data)
			mSleep(500)
			sj('关键盘',500)
			break
		end
	end
    return ret
end
function _AndriodInput(data,num)
	
end
function _FindShop(set)
	set = set or 0
	local x,y=_找面(特点.右上_商城,范围.右上_商城,0,set)
	if x>0 then
		return true
	else
		return false
	end
end
function _CloseNPC()
	if multiColor(特征.NPC对话框) then
		sj('NPC对话框_关闭',500)
		return true
	end
	return false
end
function _点确定(click,first)
	click = click or 0
	local ret
	if type(first)=="string" then
		--先精准点击
		if click==0 then
			ret =multiColor(确定[first],90)
		else
			ret =multiColTap(确定[first],90)
		end
		if ret == true then
			mSleep(230)
			nLog("局部点击"..first)
			return true
		end
	end
	for k,v in pairs(确定) do
		if click==0 then
			ret =multiColor(v,90)
		else
			ret =multiColTap(v,90)
		end
		if ret == true then
			mSleep(230)
			nLog("全局点击"..k)
			return true
		end
	end
	return false
end
function _点确认(click,delay,first)
	delay = delay or 100
	click = click or 0
	local ret
	mSleep(delay)
	if type(first)=="string" then
		--先精准点击
		if click==0 then
			ret =multiColor(确认[first],90)
		else
			ret =multiColTap(确认[first],90)
		end
		if ret == true then
			mSleep(230)
			nLog("局部点击"..first)
			return true
		end
	end
	mSleep(500)
	for k,v in pairs(确认) do
		if click==0 then
			ret =multiColor(v,90)
		else
			ret =multiColTap(v,90)
		end
		if ret == true then
			mSleep(230)
			nLog("全局点击"..k)
			return true
		end
	end
	return false
end
function _等公告消失()
    local color
	repeat
		color = multiColor(特征.公告条,95)
		if color then
			mSleep(500)
		end
	until (color==false)
end
function _顶按滑动(set)
	if set == nil then
		--默认向左划
		moveTo(滑动.顶按[1],滑动.顶按[2],滑动.顶按[3],滑动.顶按[4])
	else
		moveTo(滑动.顶按[3],滑动.顶按[4],滑动.顶按[2],滑动.顶按[1])
	end
	mSleep(400)
end
function _动作查询(name)
	local ret,data
	ret = SQLSelect(角色库, "act", "", "WHERE name='" .. name .. "' AND hid=0")
	if IsNull(ret) then 
		tracePrint("角色数据库查询失败")
		return 0
	end
	if tonumber(ret[1]["finish"]) >= 1 and tonumber(ret[1]["date"]) == today then 
		if name == "算卦" and tonumber(ret[1]["finish"]) == 1 then 
        	return tonumber(ret[1]["finish"])
		else
			tracePrint("角色已经完成过:"..name)
			return 0
		end
	end
	return ret[1]
end
function _动作修改(name,hy,num,hid)
	local ret,data,finish,times
	ret = SQLSelect(角色库, "act", "", "WHERE name='" .. name .. "'")
	if IsNull(ret) then 
		tracePrint("角色数据库查询失败")
	else 
		data = ret[1]
	end
	hy = hy or 0
	num = num or 0
	hid = hid or 0
	data["status"] = iif(num>0,tonumber(data["status"])+1,0)
	finish = iif(data["status"] >= num, 1, 0)
	if hy > 0 and finish == 1 then 
		role["hy"] = role["hy"] + hy
		SQLUpdate(数据库,"user", {["hy"]=role["hy"]},"WHERE id=" .. role["id"])
	end
	times=os.time()
	SQLUpdate(角色库,"act", {["hid"]=hid,["status"]=data["status"],["time"]=times,["date"]=today,["finish"]=finish},"WHERE name='" .. name .. "'")
end
function loginSet()
	login = {['type']=0,['qu']=0,['uid']=0,['runtype']=0,['endTime']=0,}
	role = false
end
function set_restart(set)
	set = set or 0
	if login['type']>0 and set==0 then
		loginWrite()
		if role~= nil then
			roleWrite()
		end
	end
	lua_restart()
	nLog('start')
end
