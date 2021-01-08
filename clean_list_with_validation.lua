-- ! clean_list_with_validation.lua
if not KEYS[1] or string.len(KEYS[1]) <= 5 or not string.sub(KEYS[1], 1, 5) == 'list:' then
    return redis.error_reply("list:{id} key is required.")
end

local list = KEYS[1] .. ":items"
local deleted_list_items = {}

local items = redis.call("ZRANGE", list, 0, -1)
for _, key in ipairs(items) do

    local checked = redis.call("HGET", key, "checked")
    if checked == "1" then

        -- remove from list
        redis.call("ZREM", list, key)

        -- remove key from the system
        redis.call("DEL", list, key)

        table.insert(deleted_list_items, key)
    end

end

return deleted_list_items
