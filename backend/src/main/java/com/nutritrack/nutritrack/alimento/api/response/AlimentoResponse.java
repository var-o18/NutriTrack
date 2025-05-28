package com.nutritrack.nutritrack.alimento.api.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlimentoResponse {

    private Long id;

    private String nombre;

    private Double calorias;

    private Double proteinas;

    private Double carbohidratos;

    private Double grasas;

    private String codigo_barras;

    private String ingredientes;

}
