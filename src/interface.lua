-- interface.lua
---@diagnostic disable: undefined-global

local M = {}

-- Variables locales
local inv, mochila, recetas, crafting_ref, recipe_manager_ref 
local seleccion = nil
local mensaje = ""
local estado_actual = "Recetas"

local TABS = {"Recetas", "Inventario", "Mochila"}
local TAB_WIDTH, TAB_HEIGHT = 120, 30
local TAB_X_START = 20
local FONT_SIZE = 12

-- Tabla para almacenar imágenes cargadas
local images = {}

-- Tamaño y padding de cada ítem en la grilla
local ITEM_SIZE = 48
local ITEM_PADDING_X = 60
local ITEM_PADDING_Y = 50

-- ====================================================================
-- === FUNCIÓN DE CARGA ===============================================
-- ====================================================================
function M.load(global_inv, global_mochila, global_recetas, global_crafting, global_recipe_manager, global_background_img, global_background_img2)
    inv = global_inv
    mochila = global_mochila
    recetas = global_recetas
    crafting_ref = global_crafting
    recipe_manager_ref = global_recipe_manager
    background_img_ref = global_background_img
    deco_img_ref = global_background_img2
    

    love.window.setTitle("Crafteo del Tío René")
    love.window.setMode(1400, 800) -- Recomiendo poner estas dimensiones aquí
    love.graphics.setFont(love.graphics.newFont(FONT_SIZE))


    -- Cargar todas las imágenes PNG
    local function loadImagesFromTable(t)
        for nombre, _ in pairs(t) do
            local path = "assets/" .. nombre .. ".png"
            if love.filesystem.getInfo(path) then
                images[nombre] = love.graphics.newImage(path)
            end
        end
    end

    loadImagesFromTable(recetas)
    loadImagesFromTable(inv)
    loadImagesFromTable(mochila)
end

-- ====================================================================
-- === MANEJO DE EVENTOS =============================================
-- ====================================================================
function M.mousepressed(x, y, button)
    if button == 1 and y >= 20 and y <= 20 + TAB_HEIGHT then
        for i, tab_name in ipairs(TABS) do
            local x_start = TAB_X_START + (i - 1) * (TAB_WIDTH + 5)
            local x_end = x_start + TAB_WIDTH
            if x >= x_start and x <= x_end then
                estado_actual = tab_name
                seleccion = nil
                return
            end
        end
    end

    if estado_actual == "Recetas" then
        local yPos = 80
        if button == 1 then
            for nombre, receta in pairs(recetas) do
                if receta.Salida then
                    if x >= 20 and x <= 220 and y >= yPos and y <= yPos + 30 then
                        seleccion = nombre
                    end
                    yPos = yPos + 40
                end
            end
        end
        if button == 2 and seleccion then
            local receta_final = recipe_manager_ref.buildRecipe(recetas, seleccion)
            local nuevoInv, nuevaMochila, ok =
                crafting_ref.craft(inv, mochila, receta_final)

            if ok then
                for k, v in pairs(nuevoInv) do inv[k] = v end
                for k in pairs(inv) do if not nuevoInv[k] then inv[k] = nil end end
                for k, v in pairs(nuevaMochila) do mochila[k] = v end
                for k in pairs(mochila) do if not nuevaMochila[k] then mochila[k] = nil end end
                mensaje = "Crafteado: " .. seleccion
            else
                mensaje = "No tienes materiales suficientes"
            end
        end
    end
end

-- ====================================================================
-- === FUNCIONES DE DIBUJO ===========================================
-- ====================================================================
local function drawTabs()
    for i, tab_name in ipairs(TABS) do
        local x = TAB_X_START + (i - 1) * (TAB_WIDTH + 5)
        if estado_actual == tab_name then
            love.graphics.setColor(1, 0.6, 0.0)
            love.graphics.rectangle("fill", x, 20, TAB_WIDTH, TAB_HEIGHT)
            love.graphics.setColor(0,0,0)
        else
            love.graphics.setColor(0.3,0.3,0.3)
            love.graphics.rectangle("fill", x, 20, TAB_WIDTH, TAB_HEIGHT)
            love.graphics.setColor(1,1,1)
        end
        love.graphics.print(tab_name, x+10, 20+8)
    end
end

-- Dibuja ítems en grilla con más espacio
local function drawItemsGrid(items_table, y_start, x_start)
    x_start = x_start or 60
    local x = x_start
    local y = y_start
    local max_width = love.graphics.getWidth() - 100

    for name, cant in pairs(items_table) do
        if images[name] then
            love.graphics.draw(images[name], x, y, 0, ITEM_SIZE/images[name]:getWidth(), ITEM_SIZE/images[name]:getHeight())
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print(name .. " x" .. cant, x, y + ITEM_SIZE + 2)

        x = x + ITEM_SIZE + ITEM_PADDING_X
        if x + ITEM_SIZE > max_width then
            x = x_start
            y = y + ITEM_SIZE + FONT_SIZE + ITEM_PADDING_Y
        end
    end
end

local function drawPanelBackground(x, y, w, h)
    -- Color semitransparente: Gris Oscuro (0.1, 0.1, 0.1) y Alfa 80% (0.8)
    love.graphics.setColor(0.1, 0.1, 0.1, 0.8) 
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1, 1) -- Restablecer color a blanco opaco para el contenido
end


local function drawInventarioPanel(y_start)
    -- Dibujar fondo para el panel de inventario
    drawPanelBackground(20, y_start, 1350, love.graphics.getHeight() - y_start - 50) 
    
    love.graphics.setColor(1,1,1)
    love.graphics.print("--- INVENTARIO (Materiales) ---", 40, y_start + 10)
    drawItemsGrid(inv, y_start + 40)
end

-- interface.lua (drawMochilaPanel)

local function drawMochilaPanel(y_start)
    -- Dibujar fondo para el panel de mochila
    drawPanelBackground(20, y_start, 1350, love.graphics.getHeight() - y_start - 50) 

    love.graphics.setColor(1,1,1)
    love.graphics.print("--- MOCHILA (Crafteados) ---", 40, y_start + 10)
    drawItemsGrid(mochila, y_start + 40)
end

-- Dibuja un fondo gris oscuro semitransparente para los paneles de contenido

local function drawRecetasPanel(y_start)
    -- === 1. FONDO Y LISTA DE RECETAS (IZQUIERDA) ===
    local y_pos = y_start
    
    -- Dibuja el fondo para la LISTA DE RECETAS
    drawPanelBackground(20, y_start, 200, love.graphics.getHeight() - y_start - 47)

    -- Dibuja la lista de recetas seleccionables
    for nombre in pairs(recetas) do
        if recetas[nombre].Salida then 
            
            -- Dibujo del botón de la receta
            love.graphics.setColor(seleccion==nombre and {1,0.8,0.2} or {1,1,1})
            love.graphics.rectangle("line", 20, y_pos, 200, 30)
            love.graphics.print(nombre, 30, y_pos + 8)

            y_pos = y_pos + 40
        end
    end

    -- === 2. PANEL DE DETALLE (DERECHA) ===
    if seleccion then
        local panel_x = love.graphics.getWidth() * 0.60 
        local panel_w = love.graphics.getWidth() - panel_x - 20
        local panel_h = love.graphics.getHeight() - y_start - 375

        -- Dibuja el fondo para el panel de DETALLE
        drawPanelBackground(panel_x, y_start, panel_w, panel_h)

        love.graphics.setColor(1,1,1)
        love.graphics.print("Receta seleccionada: " .. seleccion, panel_x + 20, y_start + 10)

        local receta_final = recipe_manager_ref.buildRecipe(recetas, seleccion)
        local y2 = y_start + 40 + 10 -- Sumar un poco de padding al inicio

        -- Materiales Necesarios
        love.graphics.print("Materiales necesarios:", panel_x + 20, y2 - 20)
        if receta_final and receta_final.Entrada then
            drawItemsGrid(receta_final.Entrada, y2, panel_x + 20)
        end

        -- Ajustar y2 después de dibujar la grilla (esto requiere que drawItemsGrid devuelva el y final)
        -- Si drawItemsGrid no devuelve el Y, tendrás que estimar el espacio ocupado. Usaremos una estimación.
        y2 = y2 + 100 

        -- Producto
        love.graphics.print("Producto:", panel_x + 20, y2)
        if receta_final and receta_final.Salida then
            drawItemsGrid(receta_final.Salida, y2 + 20, panel_x + 20)
        end

        love.graphics.print("[CLICK DERECHO] para craftear", panel_x + 20, y2 + 120)
    end
end

-- DRAW PRINCIPAL
function M.draw()

    -- 1. DIBUJAR EL FONDO PRINCIPAL (Cubre todo) PRIMERO
    if background_img_ref then
        local window_width, window_height = love.graphics.getDimensions()
        local img_width, img_height = background_img_ref:getDimensions()
        
        local scale_x = window_width / img_width
        local scale_y = window_height / img_height
        
        -- Dibuja el fondo principal en la capa más baja
        love.graphics.draw(background_img_ref, 0, 0, 0, scale_x, scale_y)
    end
    
    -- 2. DIBUJAR LA IMAGEN DECORATIVA/SECUNDARIA (La que no cubre todo) EN SEGUNDO LUGAR
-- interface.lua (Función M.draw, bloque de deco_img_ref)

    if deco_img_ref then
        local w, h = love.graphics.getDimensions()
        -- Obtenemos el tamaño original
        local img_w, img_h = deco_img_ref:getDimensions()
        
        -- Definimos los factores de escala (por ejemplo, 50% del tamaño original)
        local SCALE_FACTOR = 0.24 
        
        -- Calculamos la posición para la esquina inferior derecha con el nuevo tamaño
        local scaled_width = img_w * SCALE_FACTOR
        local scaled_height = img_h * SCALE_FACTOR
        
        local x_pos = w - scaled_width - 50  -- 50px de margen
        local y_pos = h - scaled_height - 50
        
        -- DIBUJAMOS USANDO LOS FACTORES DE ESCALA (sx, sy)
        love.graphics.draw(deco_img_ref, x_pos, y_pos, 0, SCALE_FACTOR, SCALE_FACTOR) 
        
    end

    drawTabs()
    local y_content_start = 80
    if estado_actual == "Recetas" then
        drawRecetasPanel(y_content_start)
    elseif estado_actual == "Inventario" then
        drawInventarioPanel(y_content_start)
    elseif estado_actual == "Mochila" then
        drawMochilaPanel(y_content_start)
    end

    love.graphics.setColor(1,1,1)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.graphics.print("Mensaje: " .. mensaje, w - 538, h - 400)
end

return M
