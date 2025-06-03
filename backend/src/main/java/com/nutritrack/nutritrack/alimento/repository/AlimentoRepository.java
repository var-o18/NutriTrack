package com.nutritrack.nutritrack.alimento.repository;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AlimentoRepository extends JpaRepository<Alimento, Long>, JpaSpecificationExecutor<Alimento> {
    Optional<Alimento> findByCodigoBarras(String codigoBarras);
    
    List<Alimento> findByCaloriasBetweenOrderByCaloriasAsc(
            Double minCalorias, 
            Double maxCalorias, 
            Pageable pageable
    );

    @Query("SELECT a FROM Alimento a ORDER BY ABS(a.calorias - :targetCalorias) ASC")
    List<Alimento> findClosestToCalories(@Param("targetCalorias") Double targetCalorias, Pageable pageable);
}
