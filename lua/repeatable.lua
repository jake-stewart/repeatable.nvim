local state = {
    action = nil,
    op = nil,
    mode = nil,
    remap = nil,
    count = 0
}

local function opfunc(motion)
    local keys = state.action({
        motion = motion,
        count = vim.v.count == 0 and state.count or vim.v.count,
        mode = state.mode,
        op = state.op,
        remap = state.remap
    })
    if keys then
        vim.fn.feedkeys(keys, "tx" .. (state.remap and "" or "n"))
    end
end

local MOTION_COMMANDS = {
    line = "'[V']",
    char = "`[v`]",
    block = vim.api.nvim_replace_termcodes("`[<c-v>]`", true, true, true)
}

return function(action, opts)
    if action == nil then
        return opfunc(opts)
    end
    return function()
        opts = opts or {}
        state = {
            action = type(action) == "function" and action or function(o)
                local select = (o.op or o.mode ~= "n")
                    and MOTION_COMMANDS[o.motion] or ""
                return select .. (o.count > 0 and o.count or "") .. action
            end,
            op = opts.op,
            remap = opts.remap,
            mode = vim.fn.mode(),
            count = vim.v.count
        }
        vim.o.opfunc = "{m->luaeval('require(\"repeatable\")(nil, _A)', m)}"
        return state.op and "g@" or "g@l"
    end
end
