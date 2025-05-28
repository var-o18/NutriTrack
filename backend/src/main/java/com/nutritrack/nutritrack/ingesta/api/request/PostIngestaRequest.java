package com.nutritrack.nutritrack.ingesta.api.request;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
public class PostIngestaRequest {
        
    @NotNull
    private Long usuarioId;

    @NotNull
    private Long alimentoId;

    @NotNull
    private Double cantidad;

    private LocalDate fechaConsumo;
    private LocalTime horaConsumo;

}
