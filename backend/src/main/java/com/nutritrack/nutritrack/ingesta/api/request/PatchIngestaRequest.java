package com.nutritrack.nutritrack.ingesta.api.request;

import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PatchIngestaRequest {

    private Long alimentoId;

    @PositiveOrZero(message = "La cantidad debe ser un valor positivo o cero")
    private Double cantidad;

    private LocalDate fechaConsumo;

    private LocalTime horaConsumo;

    private String tipoIngesta;
} 