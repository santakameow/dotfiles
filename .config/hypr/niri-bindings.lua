-- Niri-style controls for Hyprland's scrolling layout.
local M = {}

function M.apply(mod)
    local function bind(key, action)
        hl.bind(mod .. " + " .. key, action)
    end

    local function column(window)
        local layout = window and window.layout
        return type(layout) == "table" and layout.column or nil
    end

    -- Preserve the whole column, its order, width, and focused window.
    local function move_column(delta)
        local active = hl.get_active_window()
        local workspace = hl.get_active_workspace()
        if not active or not workspace or workspace.special then return end
        local destination = math.max(1, workspace.id + delta)
        if destination == workspace.id then return end
        local col = column(active)
        local windows = col and col.windows or { active }
        local anchor = windows[1]
        for i, window in ipairs(windows) do
            hl.dispatch(hl.dsp.window.move({ window = window, workspace = destination, follow = true }))
            if i > 1 then
                hl.dispatch(hl.dsp.focus({ window = anchor }))
                hl.dispatch(hl.dsp.layout("consume"))
            end
        end
        hl.dispatch(hl.dsp.focus({ window = active }))
        if col then hl.dispatch(hl.dsp.layout("colresize " .. col.width)) end
    end

    for key, direction in pairs({ H = "l", J = "d", K = "u", L = "r" }) do
        bind(key, hl.dsp.layout("focus " .. direction))
    end
    bind("SHIFT + H", hl.dsp.layout("swapcol l"))
    bind("SHIFT + L", hl.dsp.layout("swapcol r"))
    bind("SHIFT + J", hl.dsp.window.move({ direction = "down" }))
    bind("SHIFT + K", hl.dsp.window.move({ direction = "up" }))

    -- Hyprland calls wheel down mouse_down, wheel up mouse_up.
    bind("mouse_down", hl.dsp.focus({ workspace = "+1" }))
    bind("mouse_up", hl.dsp.focus({ workspace = "-1" }))
    bind("CTRL + mouse_down", function() move_column(1) end)
    bind("CTRL + mouse_up", function() move_column(-1) end)
    bind("SHIFT + mouse_down", hl.dsp.layout("focus r"))
    bind("SHIFT + mouse_up", hl.dsp.layout("focus l"))
    bind("CTRL + SHIFT + mouse_down", hl.dsp.layout("swapcol r"))
    bind("CTRL + SHIFT + mouse_up", hl.dsp.layout("swapcol l"))

    bind("SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", layout_aware = false }))
    bind("V", hl.dsp.window.float({ action = "toggle" }))
end

return M
