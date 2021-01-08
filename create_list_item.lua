-- ! create_list_item.lua
-- last key contains list id
local list_key = KEYS[#KEYS]

-- generate new list item id
local list_item_key = redis.call("INCR", list_key .. ":id")
list_item_key = list_key .. ":" .. list_item_key

-- store fields
for i = 1, #KEYS - 1 do
    redis.call("HMSET", list_item_key, KEYS[i], ARGV[i])
end

-- retrieve fields
return {"id", list_item_key}
