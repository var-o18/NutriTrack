package com.nutritrack.nutritrack.alimento.controller;

import com.nutritrack.nutritrack.alimento.api.AlimentoApi;
import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.alimento.mapper.AlimentoMapper;
import com.nutritrack.nutritrack.alimento.service.AlimentoService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/alimentos")
@AllArgsConstructor
public class AlimentoController implements AlimentoApi {

    private final AlimentoService alimentoService;
    private final AlimentoMapper alimentoMapper;

    @Override
    public ResponseEntity<AlimentoResponse> findById(Long id) {
        return alimentoService.findById(id).map(alimentoMapper::toAlimentoResponse).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @Override
    @GetMapping
    public ResponseEntity<List<AlimentoResponse>> findAll() {
        List<Alimento> alimentos = alimentoService.findAll();
        List<AlimentoResponse> responseList = alimentos.stream()
                .map(AlimentoResponse::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseList);
    }
}
