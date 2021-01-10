-- ! create_list_item2.lua
-- last key contains list id
local list_key = KEYS[#KEYS]

-- generate new list item id
local list_item_key = redis.call("INCR", list_key .. ":id")
list_item_key = list_key .. ":" .. list_item_key

local reference = nil

-- store fields
for i = 1, #KEYS - 1 do
    if KEYS[i] == "reference" then
        reference = ARGV[i]
    else
        redis.call("HMSET", list_item_key, KEYS[i], ARGV[i])
    end
end

-- move the item
redis.call("EVALSHA", "131cc4ab871f486b727e3a9ea746aa3f43aaced5", 2, list_item_key, reference)

-- retrieve fields
return {"id", list_item_key}
