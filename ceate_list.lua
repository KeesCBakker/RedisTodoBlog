--! file: create_list.lua

-- create new list key:
local list_key = "list:" .. redis.call("INCR", "list:id")

-- store list reference:
local score = redis.call("ZREVRANGEBYSCORE", "lists", "+inf", "-inf", "LIMIT", 0, 1)
score = score + 1
redis.call("ZADD", "lists", score, list_key)

-- store fields for list:
for i = 1, #KEYS do
    redis.call("HMSET", list_key, KEYS[i], ARGV[i])
end

-- return new id
return {"id", list_key}
