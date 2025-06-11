package com.nutritrack.nutritrack.alimento.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "alimentos")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Alimento {

    public static String ID_FIELD = "id";
    public static String NOMBRE_FIELD = "nombre";
    public static String CALORIAS_FIELD = "calorias";
    public static String PROTEINAS_FIELD = "proteinas";
    public static String CARBOHIDRATOS_FIELD = "carbohidratos";
    public static String GRASAS_FIELD = "grasas";
    public static String CODIGO_BARRAS_FIELD = "codigoBarras";
    public static String INGREDIENTES_FIELD = "ingredientes";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "calorias")
    private Double calorias;

    @Column(name = "proteinas")
    private Double proteinas;

    @Column(name = "carbohidratos")
    private Double carbohidratos;

    @Column(name = "grasas")
    private Double grasas;

    @Column(name = "codigo_barras")
    private String codigoBarras;

    @Column(name = "ingredientes")
    private String ingredientes;

}
