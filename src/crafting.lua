local inventory = require("inventory")

local M = {}

function M.craft(inv, mochila, recipe)
    if inventory.canCraft(inv, recipe) then
        -- 1. Si es exitoso, es decir, el usuario tiene los recursos suficientes, llama a applyRecipe
        local newInv, newMochila = inventory.applyRecipe(inv, recipe, mochila)
        -- 2. Devuelve los valores actualizados Y TRUE (ok)
        return newInv, newMochila, true
    end
    -- 3. Si falla, devuelve los valores originales Y FALSE (ok)
    return inv, mochila, false 
end

return M