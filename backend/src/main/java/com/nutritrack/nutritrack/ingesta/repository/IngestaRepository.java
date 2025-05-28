package com.nutritrack.nutritrack.ingesta.repository;

import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface IngestaRepository extends JpaRepository<Ingesta, Long>, JpaSpecificationExecutor<Ingesta> {

    @Query("""
                SELECT COALESCE(SUM((a.calorias * i.cantidad) / 100), 0)
                FROM Ingesta i
                JOIN i.alimento a
                WHERE i.usuario.id = :usuarioId
                AND DATE(i.fechaConsumo) = CURRENT_DATE
            """)
    Long caloriasConsumidasHoy(@Param("usuarioId") Long usuarioId);

}
