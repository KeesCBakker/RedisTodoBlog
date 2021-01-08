-- ! file create_list_with_validation.lua
-- input validation
local req_name_missing = true
local req_slug_missing = true

for i, k in ipairs(KEYS) do
    if k == "name" and ARGV[i] then
        req_name_missing = false
    elseif k == "slug" and ARGV[i] then
        req_slug_missing = false
    end
end

if req_name_missing then
    return redis.error_reply("'name' key/value required")
elseif req_slug_missing then
    return redis.error_reply("'slug' key/value required")
end

-- create new list key:
local list_key = "list:" .. redis.call("INCR", "list:id")

-- store list reference:
local score = redis.call("ZCOUNT", "lists", "-inf", "+inf")
score = score + 1
redis.call("ZADD", "lists", score, list_key)

-- store fields for list:
for i = 1, #KEYS do
    redis.call("HMSET", list_key, KEYS[i], ARGV[i])
end

-- return new id
return {"id", list_key}
