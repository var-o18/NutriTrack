package com.nutritrack.nutritrack.ingesta.api.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IngestaResponse {

    private Long id;

    private Long usuarioId;

    private Long alimentoId;
    private String alimento;

    private Double cantidad;

    private Double calorias;
    private Double proteinas;
    private Double carbohidratos;
    private Double grasas;

    private LocalDate fechaConsumo;

    private LocalTime horaConsumo;

    private String tipoIngesta;

}
