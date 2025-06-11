package com.nutritrack.nutritrack.usuario.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "usuarios")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Usuario {

    public static String ID_FIELD = "id";
    public static String CORREO_FIELD = "correo";
    public static String SEXO_FIELD = "sexo";
    public static String EDAD_FIELD = "edad";
    public static String PESO_FIELD = "peso";
    public static String ALTURA_FIELD = "altura";
    public static String NIVEL_ACTIVIDAD_FISICA_FIELD = "nivelActividadFisica";
    public static String OBJETIVO_PERSONAL_FIELD = "objetivoPersonal";
    public static String NOMBRE_FIELD = "nombre";
    public static String APELLIDOS_FIELD = "apellidos";
    public static String CALORIAS_DIARIAS_FIELD = "caloriasDiarias";

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
    private String nivelActividadFisica;

    @Column(name = "objetivo_personal")
    private String objetivoPersonal;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellidos")
    private String apellidos;

    @Column(name = "calorias_diarias")
    private Long caloriasDiarias;

}
