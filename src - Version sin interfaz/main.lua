local utils = require("utils")
local crafting = require("crafting")
local recipe_manager = require("recipe_manager")

-- Conectamos el recipe_manager al módulo utils
utils.setRecipeManager(recipe_manager)

-- Cargamos los json 
local inv = utils.loadJson("data/inventario.json")
local recetas = utils.loadJson("data/recetas.json")
local mochila = utils.loadJson("data/mochila.json")



-- ... (código de carga inicial) ...

--- INICIO DEL BUCLE DE JUEGO ---
while true do
    print("\n--- Estado Actual ---")

    print("Inventario:")
    utils.printTable(inv)
    print("Mochila:")
    utils.printTable(mochila)

    utils.printRecetas(recetas)
    ---- Solicita al usuario el objeto a craftear
    print("\n¿Que quieres craftear? (o escribe 'salir'):")
    local objetivo = io.read("*l")
    
    -- Condición de salida
    if objetivo == "salir" then
        print("\n¡Adios! El estado se ha guardado en los archivos JSON.")
        break
    end

    -- Construimos la receta final con herencia
    local receta_final = recipe_manager.buildRecipe(recetas, objetivo)

    if receta_final then
        -- Usamos la receta_final que ya incluye los materiales heredados
        local nuevoInv, nuevaMochila, ok = crafting.craft(inv, mochila, receta_final)

        if ok then
            -- ... (lógica de éxito) ...
            print("\n✔ Objeto crafteado:", objetivo)
            inv = nuevoInv
            mochila = nuevaMochila
            
        else
            -- Si falla, es porque no tenía los materiales (base + específicos)
            print("\n✘ No tienes materiales suficientes. (Revisar materiales base y específicos)")
        end
    else
        print("\n✘ La receta no existe.")
    end
end
--- FIN DEL BUCLE DE JUEGO ---