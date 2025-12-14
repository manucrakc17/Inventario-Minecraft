local M = {}


local utils = require("utils")
local M = {}

-- Esta es la aplicacion de programacion orientada a objetos que planteamos

function M.buildRecipe(recetas, item_name)
    local specific_recipe = recetas[item_name]
    
    if not specific_recipe then 
        return nil 
    end
    
    -- 1. Crear una COPIA del objeto específico para empezar.
    local final_recipe = utils.copyTable(specific_recipe) 

    -- 2. CRUCIAL: Crear una COPIA profunda de la tabla 'Entrada' antes de mutarla, esto fue necesario ya que sino 
    --             el costo de la receta subia cada vez que ejecutaba el codigo
    final_recipe.Entrada = utils.copyTable(specific_recipe.Entrada) or {}

    -- Verifica en el JSON si tiene una clase base para heredar sus datos
    if final_recipe.Base then
        local base_name = final_recipe.Base
        -- Llama recursivamente para construir la receta de la clase maestra y poder sumarle sus datos a la actual
        local base_recipe = M.buildRecipe(recetas, base_name) 

        if base_recipe then
            
            -- 1. Heredar propiedades generales (Durabilidad, Tipo, etc.)
            for k, v in pairs(base_recipe) do
                -- Solo hereda si la receta específica no tiene esa propiedad y NO es una de las subtablas
                if final_recipe[k] == nil and k ~= "Entrada" and k ~= "Salida" and k ~= "Base" then
                    final_recipe[k] = v
                end
            end

            -- 2. Fusionar las entradas de materiales (Entrada)
            for item, amount in pairs(base_recipe.Entrada) do
                -- Suma los materiales base a la COPIA de la entrada de la receta específica (clase heredada)
                final_recipe.Entrada[item] = (final_recipe.Entrada[item] or 0) + amount
            end
            
         
        end
    end

    final_recipe.Base = nil 
    return final_recipe
end

return M