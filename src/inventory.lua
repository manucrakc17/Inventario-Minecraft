local M = {}

-- Función de copia local 
function M.copyTable(t)
    local new = {}
    for k, v in pairs(t) do new[k] = v end
    return new
end


local utils = require("utils")


function M.canCraft(inventory, recipe)
    for item, amount in pairs(recipe.Entrada) do

        if (inventory[item] or 0) < amount then
            return false
        end
    end
    return true
end

function M.applyRecipe(inventory, recipe, mochila)
    local newInventory = utils.copyTable(inventory)
    local newMochila = utils.copyTable(mochila)

    -- 1. Consumimos los materiales (Entrada)
    for item, amount in pairs(recipe.Entrada) do
        newInventory[item] = (newInventory[item] or 0) - amount
    end

    -- 2. Añadimos el item crafteado (Salida)
    for item, amount in pairs(recipe.Salida) do
        newMochila[item] = (newMochila[item] or 0) + amount
    end

    -- Guardamos todo en el json 
    utils.saveJson("data/inventario.json", newInventory)
    utils.saveJson("data/mochila.json", newMochila)

    return newInventory, newMochila
end
return M

