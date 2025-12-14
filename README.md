[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/OC59jqlQ)

COMO EJECUTAR EL CÓDIGO


Versión con interfaz:

1) Instalar love2D y añadir la carpeta del programa al PATH
2) Instalar lua y añadir al PATH (en nuestro caso se añadió al path automaticamente)
3) en el terminal ejecutar cd y agregar la direccion de ruta a la carpeta src
ej: cd C:\Users\abc\Documents\GitHub\Inventario-Minecraft\src
4) ejecutar en el terminal "love ."


Versión sin interfaz:

1) Instalar lua y añadir al PATH (en nuestro caso se añadió al path automaticamente)
2) en el terminal ejecutar cd y agregar la direccion de ruta a la carpeta src - Version sin interfaz
ej: cd C:\Users\abc\Documents\GitHub\Inventario-Minecraft\src - Version sin interfaz
4) ejecutar en el terminal "lua main.lua"

Explicación del código

Este proyecto implementa un Sistema de creacion de objetos estilo minecraft (Crafting) en Lua, utilizando el framework Love2D para la interfaz gráfica. El objetivo principal fue crear una arquitectura modular capaz de gestionar el inventario, aplicar reglas de herencia de recetas (POO) y asegurar la persistencia de datos mediante archivos JSON.

Arquitectura y Paradigmas de Programación
El programa se diseñó bajo un principio de separación de responsabilidades (Modularidad), utilizando la Inyección de Dependencias para mantener los módulos independientes. Se implementaron dos paradigmas principales:

1. Paradigma Imperativo/Procedural
Este paradigma define el flujo de control y las acciones paso a paso.

Implementación: Se encuentra principalmente en el módulo main.lua (que actúa como el loader y delegado de eventos) y en inventory.lua (que contiene los procedimientos para applyRecipe y canCraft).

Función Clave: El bucle de frames en Love2D y la secuencia de comandos para cargar y guardar los JSON son puramente imperativos.

2. Paradigma Orientado a Objetos (POO) / Herencia
Utilizamos un patrón de diseño que simula la herencia para gestionar la complejidad de las recetas de Minecraft.

Implementación: El módulo recipe_manager.lua contiene la lógica POO.

Función Clave: La función M.buildRecipe toma una receta hija (ej., Espada_Madera), identifica su clave base (ESPADAS), y recursivamente fusiona las entradas de materiales (ej., suma el Palo de la base más el Madera específico).

Logro: Esto evita la redundancia de datos en recetas.json y permite una fácil escalabilidad (por ejemplo, añadir una nueva herramienta solo requiere especificar su material principal).

Gestión de Datos y Persistencia
La integridad y persistencia del estado del juego son manejadas de la siguiente manera:

Persistencia (JSON): Todos los datos de estado (inventario.json, mochila.json, recetas.json) se almacenan externamente en formato JSON. Utilizamos la librería dkjson para serializar y deserializar estos datos.

Transaccionalidad: El sistema de crafteo garantiza que los cambios sean permanentes llamando a utils.saveJson inmediatamente después de un crafteo exitoso. Si la verificación de materiales falla, ninguna tabla en el disco es modificada.

Inmutabilidad Parcial: Dentro de la lógica de inventory.lua, se utilizan copias superficiales (utils.copyTable) del inventario y la mochila para realizar las transacciones. Esto asegura que si una operación falla, las variables originales en memoria no se corrompan.

Interfaz Gráfica (Love2D)

La interfaz se implementó con un fuerte enfoque en la modularidad y usabilidad:

Modularidad de UI: Todo el código de dibujo y manejo de eventos del ratón se delegó al módulo interface.lua, separando la presentación de la lógica del juego.

Sistema de Pestañas: La navegación se simula con un sistema de pestañas controlado por una variable de estado (estado_actual) en interface.lua y dibujado con funciones condicionales en M.draw.

Manejo de Assets: Las imágenes de fondo y de los ítems se cargan una sola vez al inicio (love.load) y se almacenan como referencias para ser dibujadas en love.draw, optimizando la performance del framerate. El fondo semitransparente se usa para mejorar el contraste sobre el fondo de Minecraft.


