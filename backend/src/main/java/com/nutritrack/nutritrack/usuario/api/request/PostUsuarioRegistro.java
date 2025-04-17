package com.nutritrack.nutritrack.usuario.api.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PostUsuarioRegistro {

    private String correo;

    private String contrasena;

    private String sexo;

    private int edad;

    private double peso;

    private double altura;

    private String nivel_actividad_fisica;

    private String objetivo_personal;

}
