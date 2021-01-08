-- ! file create_list_item_with_validation.lua
local req_heading_missing = true
local req_item_missing = true
local list_key = nil

for _, k in ipairs(KEYS) do
    if k == "heading" then
        req_heading_missing = false
    elseif k == "item" then
        req_item_missing = false
    elseif string.len(k) > 5 and string.sub(k, 1, 5) == "list:" then
        list_key = k
    end
end

if req_heading_missing and req_item_missing and list_key == nil then
    return redis.error_reply("A 'heading' or 'item' key is required, together with a list identfier.")
elseif req_heading_missing and req_item_missing then
    return redis.error_reply("A 'heading' or 'item' key is required.")
elseif not req_heading_missing and not req_item_missing then
    return redis.error_reply("Cannot have both 'heading' and 'item' keys.")
elseif list_key == nil then
    return redis.error_reply("A 'list:{id}' key is required.")
end

-- generate new list item id
local list_item_key = redis.call("INCR", list_key .. ":id")
list_item_key = list_key .. ":" .. list_item_key

-- store fields
for i = 1, #KEYS - 1 do
    local value = ARGV[i]
    if value == nil then
        value = ""
    end

    redis.call("HMSET", list_item_key, KEYS[i], value)
end

-- retrieve fields
return {"id", list_item_key}
