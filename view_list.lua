-- view_list.lua
local list = KEYS[1] .. ":items"
local list_items = {}

local items = redis.call("ZRANGE", list, 0, -1)
for _, key in ipairs(items) do

    table.insert(list_items, "id")
    table.insert(list_items, key)

    local fields = redis.call("HGETALL", key)
    for _, field in ipairs(fields) do
        table.insert(list_items, field)
    end

end

return list_items
