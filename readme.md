repeatable.nvim
===============

setup
-----
this plugin requires no setup. just put it in your plugin list

usage
-----

### basic mapping
this snippet creates a mapping `gp` which pastes while leaving the cursor unmoved.
it works with the `.` key automatically.
```lua
local repeatable = require("repeatable")
vim.keymap.set({"n", "v"}, "gp", repeatable("P`["), {expr = true})
```


### operator mapping
you can provide `op = true` to make the mapping await a motion.
there is also `remap = false`, which is default, but provided for demonstration.

```lua
vim.keymap.set({"n", "v"}, "~", repeatable("~", {op = true, remap = false}), {expr = true})
```

### complex mapping
```lua
vim.keymap.set({"n", "v"}, "~", repeatable(function(o)
    print(o.motion) -- "char", "line", or "block". (see :h g@)
    print(o.count)  -- number (see :h v:count)
    print(o.mode)   -- string: the mode when user called this mapping (see :h mode())
    print(o.op)     -- boolean: whether `op = true` was provided for this mapping
    print(o.remap)  -- boolean: whether `remap = true` was provided for this mapping
end, {op = true, remap = false}), {expr = true})
```

if performing actions with the function mapping, then your code will look
something like:
```lua
if o.motion == "char" then
    vim.fn.feedkeys("`[" .. action .. "`]", "tx")
else
    vim.fn.feedkeys("'[" .. action .. "']", "tx")
end
```
