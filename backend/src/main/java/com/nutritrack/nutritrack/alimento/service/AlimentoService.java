package com.nutritrack.nutritrack.alimento.service;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.alimento.repository.AlimentoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlimentoService {

    private final AlimentoRepository alimentoRepository;

    public Optional<Alimento> findById(Long id) {
        return alimentoRepository.findById(id);
    }

    public List<Alimento> findAll() {
        return alimentoRepository.findAll();
    }

}
