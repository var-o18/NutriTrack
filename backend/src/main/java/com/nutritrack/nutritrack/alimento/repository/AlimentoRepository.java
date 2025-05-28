package com.nutritrack.nutritrack.alimento.repository;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface AlimentoRepository extends JpaRepository<Alimento, Long>, JpaSpecificationExecutor<Alimento> {
}
