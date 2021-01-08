-- ! clean_list.lua
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
