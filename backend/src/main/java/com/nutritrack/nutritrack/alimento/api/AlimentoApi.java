package com.nutritrack.nutritrack.alimento.api;

import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

public interface AlimentoApi {

    @GetMapping("api/alimentos/{id}")
    ResponseEntity<AlimentoResponse> findById(@PathVariable(value = "id") Long id);

    @GetMapping("api/alimentos")
    ResponseEntity<List<AlimentoResponse>> findAll();

}
