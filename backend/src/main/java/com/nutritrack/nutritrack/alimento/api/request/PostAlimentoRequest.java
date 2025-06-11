package com.nutritrack.nutritrack.alimento.api.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PostAlimentoRequest {

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    @NotNull(message = "Las calorías son obligatorias")
    @PositiveOrZero(message = "Las calorías deben ser un valor positivo o cero")
    private Double calorias;

    @NotNull(message = "Las proteínas son obligatorias")
    @PositiveOrZero(message = "Las proteínas deben ser un valor positivo o cero")
    private Double proteinas;

    @NotNull(message = "Los carbohidratos son obligatorios")
    @PositiveOrZero(message = "Los carbohidratos deben ser un valor positivo o cero")
    private Double carbohidratos;

    @NotNull(message = "Las grasas son obligatorias")
    @PositiveOrZero(message = "Las grasas deben ser un valor positivo o cero")
    private Double grasas;

    private String ingredientes;
} 