[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/OC59jqlQ)

COMO EJECUTAR EL CÓDIGO


Versión con interfaz:

1 Instalar love2D y añadir la carpeta del programa al PATH
2 Instalar lua y añadir al PATH (en nuestro caso se añadió al path automaticamente)
3 en el terminal ejecutar cd y agregar la direccion de ruta a la carpeta src
ej: cd C:\Users\Manuel\Documents\GitHub\proyecto-analisis-lenguaje-lauraa\src
4 ejecutar en el terminal "love ."


Versión sin interfaz:

1 Instalar lua y añadir al PATH (en nuestro caso se añadió al path automaticamente)
2 en el terminal ejecutar cd y agregar la direccion de ruta a la carpeta src - Version sin interfaz
ej: cd C:\Users\Manuel\Documents\GitHub\proyecto-analisis-lenguaje-lauraa\src - Version sin interfaz
4 ejecutar en el terminal "lua main.lua"

Explicación del código

Este proyecto implementa un Sistema de creacion de objetos estilo minecraft (Crafting) en Lua, utilizando el framework Love2D para la interfaz gráfica. El objetivo principal fue crear una arquitectura modular capaz de gestionar el inventario, aplicar reglas de herencia de recetas (POO) y asegurar la persistencia de datos mediante archivos JSON.

Arquitectura y Paradigmas de Programación
El programa se diseñó bajo un principio de separación de responsabilidades (Modularidad), utilizando la Inyección de Dependencias para mantener los módulos independientes. Cumplimos con el criterio de utilizar dos paradigmas principales:

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

PREGUNTAS DEL PROYECTO RESPECTO AL LENGUAJE LUA

1. Análisis del lenguaje Lua:
los criterios habituales son; legibilidad (readability), facilidad de escritura (writability), confiabilidad (reliability), coste (cost), portabilidad (portability), simplicidad y ortogonalidad (simplicity & orthogonality), soporte de paradigmas y abstracción (abstraction/expressiveness), seguridad (security).
   1.1
   legibilidad:
	  Su sintaxis es simple y limpia.
      No tiene muchas palabras reservadas.   
      La estructura end para cerrar bloques ayuda a entender dónde termina cada parte.
      El código suele verse compacto y fácil de seguir.

	-facilidad de escritura:
      La sintaxis es corta, lo que permite escribir rápido 
	   Es un lenguaje dinámico (no requiere declarar tipos).

	-confiabilidad:
	   El lenguaje ha sido exhaustivamente probado y utilizado en una enorme variedad de entornos, desde el desarrollo de videojuegos (como Roblox o muchos títulos de Blizzard (world of warcraft)). Y mide; robustez,
      detección    de errores y comportamiento predecible.
	
	-coste:
	   Requiere muy pocos recursos; corre incluso en hardware pequeño. Sencillo de mantener por su simplicidad.

	-portabilidad:
	   Capacidad de correr en distintos sistemas. 
	   for i = 1, 3 do
    		print("Hola desde Lua!", i)
      end
	
 	  Lua mantiene el mismo comportamiento en cualquier plataforma, porque su intérprete está diseñado para ser ligero, consistente y fácilmente embebible.

	-simplicidad y ortogonalidad:
      Pocas estructuras básicas.
      Reglas coherentes y sencillas.
      Las operaciones son predecibles.
      Aspectos en contra
      Todo se basa en tablas → simplifica el lenguaje, pero reduce la ortogonalidad (una sola estructura hace “demasiado”).
   
      t = {}
      t[1] = "a"        -- array
      t["name"] = "Ana" -- diccionario
   
      Una misma estructura cumple múltiples roles.

	-soporte de paradigmas y abstracción:
	   Imperativo
      Funcional
      Orientado a objetos “ligero” mediante metatables
      Scripting y embebido


	-seguridad:
	   Contras:
         Tipado dinámico → errores pueden pasar inadvertidos.


   El programador debe administrar su propio entorno seguro.



2. Características de Lua:
   Lua es un lenguaje simple, sencillo y fácil de aprender, se usa en videojuegos, configuración de sistemas y scripting, y 	está diseñado para ser simple, portable y eficiente. Este lenguaje no se usa tanto como lenguaje      “principal”, sino 	como una herramienta que otros sistemas usan para agregar lógica o personalización. Apareciendo en juegos como Roblox o 	World of Warcraft
   	Tipado Dinámico: Las variables no tienen tipo, los valores sí. El tipo se resuelve en tiempo de ejecución.

   	Extensible y Embebible: Diseñado primariamente para integrarse dentro de software escrito en C/C + + (como una 		  	     librería).
	
   	Basado en Tablas: Su única estructura de datos compleja es la table (array asociativo). Los objetos, módulos y paquetes 		se simulan usando tablas.
   
   Alcance Léxico (Lexical Scoping): Permite el uso de closures y funciones de orden superior.

      2.1 Proceso de Compilación/Interpretación
         El compilador de Lua (llamado luac si se usa explícitamente, aunque suele ser    transparente) traduce el código fuente a Bytecode (instrucciones de bajo nivel).La Lua VM (Virtual Machine) toma ese bytecode y lo             ejecuta.	
      2.2 Gestión de Memoria 
	      El mecanismo de gestión de memoria del sistema es de naturaleza Automática y utiliza un Recolector de Basura (Garbage Collector - GC). La operación de este GC se estructura en dos fases principales:
            Marcado: Se realiza un recorrido exhaustivo de todos los objetos que son accesibles desde el programa principal (denominado el "conjunto raíz" o "root set") y se procede a identificarlos como objetos "vivos" o                en uso.
            Barrido: Se inspecciona el espacio de memoria para identificar y liberar (eliminar) todos aquellos objetos que no fueron marcados durante la fase anterior.

3. Paradigmas constituyen a Lua:
  Lua usa la combinación de tres paradigmas, imperativo, funcional y orientado a objetos. Programación Imperativa: Este es 		un enfoque de "paso a paso". El programador escribe una secuencia de instrucciones que el programa ejecutará para 			cambiar el estado del sistema. 
	Variables Mutables: Permite la declaración y modificación de variables, cambiando su valor a lo largo de la ejecución.
	Asignación de Estado: El operador de asignación (=) es fundamental para modificar el estado de las variables y del 			programa en general.
	Estructuras de Control: Incluye las estructuras clásicas para controlar el flujo de ejecución:
	Condicionales: if...then...elseif...else...end

	Ejemplo: Si se le dijera a un robot que prepare café, le daría instrucciones específicas: "pon el filtro", "muele el 		café", "añade el agua", etc. 

	Programación Orientada a Objetos (POO): Se basa en la idea de "objetos" que contienen tanto datos como funciones 			(métodos) que operan sobre esos datos. 
	Tablas como Objetos: Las tablas son la única estructura de datos compleja en Lua y se utilizan para representar 			objetos, almacenando sus propiedades (datos) y métodos (funciones).
	Metatablas y Metamétodos: Las metatablas son el mecanismo clave de Lua para cambiar el comportamiento de las tablas. Se 	usan para simular la herencia y el acceso a métodos:

	Una tabla de objeto puede tener una metatabla que apunta a la "clase" o prototipo (otra tabla) usando el campo __index.
	Sintaxis de Métodos: La sintaxis especial del operador de dos puntos (:) es un azúcar sintáctico que simplifica la 			llamada a métodos, asegurando que la referencia al objeto (self) se pase automáticamente como primer argumento.

	Ejemplo: En una aplicación de red social, un objeto "Usuario" podría tener propiedades como nombre, apellido, y edad, y 	métodos como iniciarSesion() o comentar(). Es fácil de mantener y de añadir nuevas funcionalidades. 

	Programación Funcional: Se centra en la ejecución de funciones puras que no tienen efectos secundarios. Es decir, para 		las mismas entradas, siempre se obtendrán las mismas salidas. Las funciones son first-class citizens (pueden guardarse 		en variables, pasarse como parámetros, retornarse).

	Funciones de Primera Clase (First-Class Functions): Las funciones son consideradas valores (como números o cadenas). 		Esto significa que pueden:
		Asignarse a variables.
		Pasarse como argumentos a otras funciones (funciones de orden superior).
		Devolverse como resultado de otras funciones.

	Funciones Anónimas: La capacidad de declarar funciones sin un nombre explícito.

	Cierres (Closures): Las funciones retienen acceso al ámbito léxico (las variables locales) donde fueron creadas, 			incluso después de que ese ámbito haya terminado su ejecución.





5. Filosofia del lenguaje
   A diferencia de Python, que busca ser un lenguaje de propósito general con "baterías incluidas" (muchas bibliotecas listas para usar), la filosofía de Lua se centra en ser un lenguaje de scripting, extensión y              configuración diseñado para integrarse en otras aplicaciones (generalmente escritas en C o C++).

   Sus pilares principales son:
      
    1. "Mecanismos, no Políticas" (Mechanisms, not Policies), en vez de imponer una forma estricta de hacer las cosas, lua proporciona herramientas flexibles y básicas para que el programador construya su propia               estructura 

   2. Minimalismo y Ligereza, Lua posee un tamaño pequeño y una complejidad baja , su interprete completo pesa muy poco kilobytes , posee muy pocas palabras reservadas a la cual permite incrustar este lenguaje dentro de       diferentes sistemas 

   3. La Tabla como Estructura Universal, Un array en Lua es simplemente una tabla con índices numéricos. Un objeto es una tabla con funciones dentro. Esto reduce drásticamente la curva de aprendizaje de las estructuras       de datos.


   4. Portabilidad y Estándar ANSI C, Lua está diseñado para compilarse y correr en cualquier lugar donde corra C estándar.

   5. Interoperabilidad (C API),Lua se considera a sí mismo un lenguaje "pegamento". Su filosofía prioriza una comunicación excelente con el lenguaje anfitrión (C/C++).
