package com.nutritrack.nutritrack.ingesta.repository;

import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface IngestaRepository extends JpaRepository<Ingesta, Long>, JpaSpecificationExecutor<Ingesta> {
}
