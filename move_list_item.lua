-- ! move_list_item.lua
local item = KEYS[1]

-- no reference, append to top
local reference_score = 0

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
    else
        -- reference gone, append to bottom
        reference_score = redis.call("ZREVRANGEBYSCORE", list, "+inf", "-inf", "LIMIT", 0, 1)
    end
end

-- set item score
local item_score = reference_score + 0.1
redis.call("ZADD", list, item_score, item)

-- recalc scores
local items = redis.call("ZRANGEBYSCORE", list, item_score, "+inf")
local score = reference_score + 0.9
for _, key in ipairs(items) do
    redis.call("ZADD", list, score, key)
    score = score + 1
end

-- return list keys in the "new" order
return redis.call("ZRANGE", list, 0, -1)
