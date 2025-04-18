package com.nutritrack.nutritrack.usuario.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "usuarios")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "correo")
    private String correo;

    @Column(name = "contrasena")
    private String contrasena;

    @Column(name = "sexo")
    private String sexo;

    @Column(name = "edad")
    private int edad;

    @Column(name = "peso")
    private double peso;

    @Column(name = "altura")
    private double altura;

    @Column(name = "nivel_actividad_fisica")
    private String nivel_actividad_fisica;

    @Column(name = "objetivo_personal")
    private String objetivo_personal;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellidos")
    private String apellidos;

}
