package com.nutritrack.nutritrack.alimento.api;

import com.nutritrack.nutritrack.alimento.api.request.PostAlimentoRequest;
import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import com.nutritrack.nutritrack.alimento.api.response.PostAlimentoResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface AlimentoApi {

    @GetMapping("api/alimentos/{id}")
    ResponseEntity<AlimentoResponse> findById(@PathVariable(value = "id") Long id);

    @GetMapping("api/alimentos")
    ResponseEntity<List<AlimentoResponse>> findAll();

    @GetMapping("api/alimentos/codigo/{codigoBarras}")
    ResponseEntity<AlimentoResponse> findByCodigoBarras(@PathVariable String codigoBarras);

    @PostMapping("api/alimentos")
    ResponseEntity<PostAlimentoResponse> save(@RequestBody @Valid PostAlimentoRequest postAlimentoRequest);

    @GetMapping("api/alimentos/sugerencias")
    ResponseEntity<List<AlimentoResponse>> getSugerencias(
            @RequestParam(required = false, defaultValue = "5") Integer limite,
            @RequestParam(required = false, defaultValue = "0.2") Double margenPorcentaje
    );
}
