package com.nutritrack.nutritrack.usuario.api.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioResponse {

    private String correo;

    private String sexo;

    private int edad;

    private double peso;

    private double altura;

    private String nivelActividadFisica;

    private String objetivoPersonal;

    private String nombre;

    private String apellidos;

    private Long caloriasDiarias;

    private Long caloriasRestantes;

}
