package com.nutritrack.nutritrack.ingesta.entity;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "ingestas")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Ingesta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "alimento_id", nullable = false)
    private Alimento alimento;

    @Column(nullable = false)
    private Double cantidad;

    @Column(name = "fecha_consumo", nullable = false)
    private LocalDate fechaConsumo;

    @Column(name = "hora_consumo", nullable = false)
    private LocalTime horaConsumo;

}
