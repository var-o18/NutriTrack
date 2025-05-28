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
    private String codigo_barras;

    @Column(name = "ingredientes")
    private String ingredientes;
    
}
