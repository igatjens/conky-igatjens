--this is a lua script for use in conky



--==============================================================================
--                            conky-igatjens.lua
--
--  author  : Isaías Gatjens M - Twitter @igatjens
--  version : v2.0 for Conky Manager
--  license : Distributed under the terms of GNU GPL version 2 or later
--
--
--  notes   : uses conky conf newer >v1.10
--==============================================================================






require 'cairo'
require "conky-igatjens-lib-tools"
require "conky-igatjens-lib-texto"
require "conky-igatjens-lib-colores"
require "conky-igatjens-lib-graf"
require "conky-igatjens-000-ajustes"

-- variables persistentes
local dev_WiFi = "wlp5s0"
local dev_LAN = "enp2s0"
local alto_grafico = 0


function conky_main()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)

    -- Establecer tipo de fuente
    set_fuente( cr )
    set_color_blanco( cr )
    
    local posicion_x = conky_window.width - get_graf_margen_derecho(  ) + 4
    local posicion_y = conky_window.height - get_letra_size_etiqueta( 1 ) - 5

    local updates = tonumber(conky_parse("$updates"))
    if updates < 5 then
        dev_WiFi = get_red_WiFi_dev( )
        dev_LAN = get_red_LAN_dev( )
    end

    local texto = conky_parse("${if_up "..dev_LAN.."}${upspeed "..dev_LAN.."}${else}${upspeed "..dev_WiFi.."}${endif}")
    mostrar_texto_etiqueta( cr, posicion_x, posicion_y, texto, 1)

    texto = "Up"
    posicion_y = posicion_y + get_letra_size_etiqueta( 1 )
    mostrar_texto_etiqueta( cr, posicion_x, posicion_y, texto, 1)


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

function conky_dibujar_grafico( )
    local ancho = conky_window.width - get_graf_margen_derecho(  ) - get_graf_red_up_margen_izquierdo( )

    if ancho < 1 then return "" end

    if alto_grafico < 1 then
        alto_grafico = (conky_window.height - 20)
    end

    local codigo = "${goto "..get_graf_red_up_margen_izquierdo( ).."}${voffset 8}${if_up "..dev_LAN.."}${upspeedgraph "..dev_LAN.." "..alto_grafico..","..ancho.." }${else}${upspeedgraph "..dev_WiFi.." "..alto_grafico..","..ancho.." }${endif}${voffset -8}"
    return codigo
end
