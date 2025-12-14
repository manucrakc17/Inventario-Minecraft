local json = require("dkjson")

local M = {}


function M.loadJson(path)
    local file = assert(io.open(path, "r"), "No se pudo abrir " .. path)
    local content = file:read("*all")
    file:close()
    return json.decode(content)
end

function M.saveJson(path, data)
    local file = assert(io.open(path, "w"), "No se pudo crear/abrir " .. path)
    local content = json.encode(data, {indent=true}) -- Usamos dkjson para codificar
    file:write(content)
    file:close()
end


function M.copyTable(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v
    end
    return copy
end


function M.printTable(t)
    if t == nil or next(t) == nil then 
        print("Vacío")
        return
    end
    for k, v in pairs(t) do
        print(k, v)
    end
end

-- utils.lua

-- utils.lua

-- asegurarse de que utils pueda acceder al recipe_manager
local recipe_manager

-- Añadimos una función para inyectar el manager, ya que utils no debe requerirlo directamente
function M.setRecipeManager(manager)
    recipe_manager = manager
end

-- utils.lua (M.printRecetas)

-- ... (código anterior) ...

function M.printRecetas(recetas)
    -- Asumimos que el índice de orden está guardado en el JSON
    local nombres_ordenados = recetas["ORDEN_RECETAS"] 
    
    if not nombres_ordenados then
        print("--- ERROR: Falta el índice 'ORDEN_RECETAS' en el JSON. Imprimiendo sin orden. ---")
        -- Si falta el índice, volvemos al comportamiento desordenado
        nombres_ordenados = {}
        for nombre in pairs(recetas) do
            table.insert(nombres_ordenados, nombre)
        end
    end
    
    print("--- RECETAS DISPONIBLES (Orden de Archivo) ---")
    
    -- Recorremos la tabla en el orden garantizado (por el array)
    for i, nombre_receta in ipairs(nombres_ordenados) do
        
        -- Verificar que la receta existe y no es una clase base
        if recetas[nombre_receta] and recetas[nombre_receta].Salida then

            -- Obtener la receta final (fusionada) usando la lógica de herencia (POO)
            local receta_final = recipe_manager.buildRecipe(recetas, nombre_receta)

            -- Verificación de la receta final
            if receta_final and receta_final.Salida then
                print("  Receta:", nombre_receta)
                print("    Entrada (Materiales requeridos):")
                
                -- Imprimir los materiales de la entrada fusionada
                for material, cantidad in pairs(receta_final.Entrada) do 
                    print("      -", material, "x", cantidad) 
                end
                
                print("    Salida (Producto):")
                -- Imprimir el producto de salida
                for producto, cantidad_salida in pairs(receta_final.Salida) do
                    print("      -", producto, "x", cantidad_salida)
                end
                print("---------------------------")
            end
        end
    end
end

return M
