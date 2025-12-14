
---@diagnostic disable: undefined-global

-- main.lua (LIMPIO)

local utils = require("utils")
local crafting = require("crafting")
local recipe_manager = require("recipe_manager")
local interface = require("interface") 

-- Variables globales de estado del juego
local inv, recetas, mochila
local backgroundImage
local backgroundImage2

-- cargar todos los datos necesarios para la ejecución de la interfaz
function love.load()
    -- Configuración de la ventana
    love.window.setTitle("Crafteo del Tío René")
    love.window.setMode(1400, 800)
    
    -- 1. Cargar datos
    utils.setRecipeManager(recipe_manager)
    inv = utils.loadJson("data/inventario.json")
    recetas = utils.loadJson("data/recetas.json")
    mochila = utils.loadJson("data/mochila.json")
    backgroundImage = love.graphics.newImage("assets/Fondo.JPG")
    backgroundImage2 = love.graphics.newImage("assets/Mesa_Crafteo.PNG")
    
    -- 2. Inicializar la interfaz (le pasamos las variables de estado)
    interface.load(inv, mochila, recetas, crafting, recipe_manager, backgroundImage, backgroundImage2)
end

-- 3. Delegar el dibujo
function love.draw()
    interface.draw()
end

-- 4. Delegar los eventos de ratón
function love.mousepressed(x, y, button)
    interface.mousepressed(x, y, button)
end

