# Arquitectura y Organización de Computadores

Prácticas en ensamblador MIPS: búsqueda de raíces en coma flotante, conversiones entre enteros y cadenas, optimización para el pipeline y conversión de fechas a tiempo epoch.

> Asignatura **Arquitectura y Organización de Computadores** · 2º curso, 1º cuatrimestre · curso 2022-2023 · Grado en Ingeniería Informática, Universidad de Valladolid.

## Qué hace

- **Prácticas 1 y 2:** subrutina `RegulaFalsi`, que busca raíces por el método de la falsa posición con la FPU (`$f12`–`$f14`: tolerancia e intervalo `[a, b]`) y controla los errores de tolerancia.
- **Práctica 3:** `itoa` convierte un entero en cadena en binario natural o complemento a 2, con 8, 16 o 32 bits según `$a1`, y trata aparte el caso de −2³¹.
- **Práctica 4:** `atoi` convierte una cadena en entero. Ignora los espacios iniciales, acepta los signos `+` y `-`, y detecta caracteres no válidos y desbordamiento.
- **Práctica 5:** rutinas de producto de matrices (`MatMul`) y de máximo y mínimo de un vector (`vecMaxMin`), con variantes para un pipeline con *forwarding* y sin él (*stall*). `main.asm` las comprueba contra un resultado conocido.
- **Trabajo final:** subrutina `Epoch`, que recibe una fecha con el formato `HH:MM:SS GMT±N DD/MES/AA` (por ejemplo `23:59:59 GMT-1 31/DIC/99`), valida cada campo, calcula los segundos transcurridos y los devuelve como cadena reutilizando `atoi` e `itoa`.

## Tecnologías

- Ensamblador MIPS32 (incluida la FPU, coprocesador 1)
- Simulador MARS; la práctica 5 incluye `MARS-F.jar` con configuraciones de pipeline en XML

## Aspectos técnicos destacados

- **Convenio de llamada respetado:** las subrutinas guardan en la pila los registros `$s*`, `$f20`–`$f26` y `$ra` que usan, y los restauran al salir.
- **Desbordamiento en `atoi`:** solo se comprueba cuando el valor acumulado se acerca al límite (`>= 0x0ccccccd`), así el bucle normal no paga ese coste.
- **Caso −2³¹ en `itoa`:** su opuesto no cabe en 32 bits, así que se escriben directamente los caracteres en lugar de operar con él.
- **Planificación para el pipeline:** en la práctica 5, las versiones entregadas reordenan instrucciones y sustituyen saltos condicionales por `slt` para reducir los riesgos de datos y de control. `forward.xml` (con *forwarding*, saltos en ID) y `stall.xml` (sin *forwarding*, saltos en MEM) definen los dos escenarios.
- **Años bisiestos en `Epoch`:** se tienen en cuenta, incluido el caso especial del año 2100, y se usa una tabla de días acumulados por mes.
- La memoria de la práctica 5 está en [`Practica5/g105_Practica5.pdf`](Practica5/g105_Practica5.pdf).

## Estructura del repositorio

```
AOC/
├── Practica1/      # RegulaFalsi (versiones de trabajo y entregadas)
├── Practica2/      # RegulaFalsi revisada
├── Practica3/      # itoa
├── Practica4/      # atoi
├── Practica5/      # MatMul y vecMaxMin para pipeline, main.asm de prueba,
│                   # forward.xml / stall.xml, MARS-F.jar y memoria en PDF
└── TrabajoFinal/   # Epoch, versiones de prueba y depuración
```

Los ficheros con nombre numérico (por ejemplo `05876.asm`) son las versiones enviadas al corrector automático de la asignatura. Los `.bat` son los scripts de Windows que se usaban para enviarlas.

## Requisitos

- Java, para ejecutar el simulador MARS (`Practica5/MARS-F.jar`)

## Cómo compilar y ejecutar

Casi todos los ficheros contienen solo una subrutina, sin programa principal, así que para ejecutarlos hace falta un `main` que la llame. El corrector de la asignatura lo aportaba y no está en el repositorio.

Lo que sí se puede ejecutar es la comprobación de la práctica 5: `main.asm` junto con la rutina. Los ficheros usan finales de línea antiguos (CR), así que conviene normalizarlos antes de unirlos:

```bash
cd Practica5
(tr '\r' '\n' < main.asm; echo; tr -d '\r' < p5-matrixFORW.asm) > /tmp/p5.asm
java -jar MARS-F.jar nc sm /tmp/p5.asm
# Resultado Correcto
```

Este comando se ha probado en Linux. El resto de las subrutinas pueden abrirse en la interfaz gráfica de MARS (`java -jar MARS-F.jar`) junto con un programa principal propio.

## Autoría

Todos los commits son de Javier García (JavivuG).

---

Forma parte de [UVa-Projects](https://github.com/JavivuG/UVa-Projects).
