ts=require("ts")
require("TSLib")
--添加字段
function SQLAddField(DBpath, tbl, field)
		if field:find(",") then
			local fields = strSplit(field, ",")
			for _, v in ipairs(fields) do
				sql = string.format("ALTER TABLE %s ADD COLUMN %s", tbl, v)
				result,msg = ts.dborder(DBpath,sql)
			end
		else
			sql = string.format("ALTER TABLE %s ADD COLUMN %s", tbl, field)
			result,msg = ts.dborder(DBpath,sql)
		end
end
--查询表
function SQLSelect(DBpath, tbl, field, where)
	--"select * from event where id=2"
	if field == "" or field == nil then field = "*" end
	where = where or ""
	--生成语句
	local sql = string.format("SELECT %s FROM %s %s", field, tbl, where)
	local result,msg = ts.dborder(DBpath,sql)
	if type(result)=='number' then
		mSleep(40)
		if next(msg) == nil then
			return nil
		else
			return msg
		end
	else
		mSleep(40)
		return nil
	end
end
function SQLInsert(DBpath, tbl, valtbl)
	--增加表
	local keys, vals
	for k, v in pairs(valtbl) do
		if keys == nil then
			keys = k
		else
			keys = keys .."," .. k
		end
		if vals == nil then
			vals = string.format("\"%s\"", v)
		else
			vals = vals .."," .. string.format("\"%s\"", v)
		end
	end
	--生成语句
	local sql = string.format("INSERT INTO %s(%s) VALUES(%s)", tbl, keys, vals)
	local result,msg = ts.dborder(DBpath,sql)
	mSleep(40)
	if result==1 then
		return true
	else
		return false
	end
end
function SQLUpdate(DBpath, tbl, valtbl, where)
	local sql
	local str, ret
	for k, v in pairs(valtbl) do
		if str == nil then
			str = string.format("%s=\"%s\"", k, v)
		else
			str = str .. "," ..string.format("%s=\"%s\"", k, v)
		end
	end
	where = where or " "
	sql = string.format("UPDATE %s SET %s %s", tbl, str, where)
	--sql = "insert into data(nickname, username) values('袁大头','袁大头')"
	local result,msg = ts.dborder(DBpath,sql)
	mSleep(40)
	if result==1 then
		return true
	else
		return false
	end
end
--删除数据
function SQLDelete(DBpath, tbl, where)
	if where == nil or where=="" then
		return false
	end
	local sql
	local str, ret
	sql = string.format("DELETE FROM %s %s", tbl, where)
	local result,msg = ts.dborder(DBpath,sql)
	mSleep(40)
	if result==1 then
		return true
	else
		return false
	end
end