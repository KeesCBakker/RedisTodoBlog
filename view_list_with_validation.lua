-- ! view_list_with_validation.lua
if not KEYS[1] or string.len(KEYS[1]) <= 5 or not string.sub(KEYS[1], 1, 5) == 'list:' then
    return redis.error_reply("list:{id} key is required.")
end

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
