package com.nutritrack.nutritrack.alimento.controller;

import com.nutritrack.nutritrack.alimento.api.AlimentoApi;
import com.nutritrack.nutritrack.alimento.api.request.PostAlimentoRequest;
import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import com.nutritrack.nutritrack.alimento.api.response.PostAlimentoResponse;
import com.nutritrack.nutritrack.alimento.mapper.AlimentoMapper;
import com.nutritrack.nutritrack.alimento.service.AlimentoService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.util.List;

@RestController
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
    public ResponseEntity<List<AlimentoResponse>> findAll() {
        return ResponseEntity.ok(alimentoService.findAll().stream().map(alimentoMapper::toAlimentoResponse).toList());
    }

    @Override
    public ResponseEntity<AlimentoResponse> findByCodigoBarras(@PathVariable String codigoBarras) {
        return ResponseEntity.ok(
                alimentoMapper.toAlimentoResponse(alimentoService.findByCodigoBarras(codigoBarras))
        );
    }

    @Override
    @SneakyThrows
    public ResponseEntity<PostAlimentoResponse> save(PostAlimentoRequest postAlimentoRequest) {
        return ResponseEntity.created(new URI(
                "alimentos/" + alimentoService.save(postAlimentoRequest)
        )).build();
    }
}
