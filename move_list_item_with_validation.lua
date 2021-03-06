-- ! move_list_item_with_validation.lua
if not KEYS[1] or string.len(KEYS[1]) <= 5 or not string.sub(KEYS[1], 1, 5) == 'list:' then
    return redis.error_reply("list:{id} key is required.")
end

local item = KEYS[1]
local reference_score = -1

-- infer list
local d1 = string.find(item, ":")
local d2 = string.find(item, ":", d1 + 1)
local list = string.sub(item, 1, d2) .. "items"

-- check if a reference if given and use that score
if #KEYS > 1 then
    local reference = KEYS[2]

    -- reference does not have to exist
    local score = redis.call("ZSCORE", list, reference)
    if score then
        reference_score = score
    end
end

-- set item score
local item_score = reference_score + 0.1
redis.call("ZADD", list, item_score, item)

-- recalc scores
local items = redis.call("ZRANGEBYSCORE", list, item_score, "+inf")
local score = reference_score + 1
for _, key in ipairs(items) do
    redis.call("ZADD", list, score, key)
    score = score + 1
end

-- return list keys in the "new" order
return redis.call("ZRANGE", list, 0, -1)
