package com.nutritrack.nutritrack.ingesta.api;

import com.nutritrack.nutritrack.ingesta.api.request.PatchIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.response.IngestaResponse;
import com.nutritrack.nutritrack.ingesta.api.response.PostIngestaResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

public interface IngestaApi {

    @PostMapping("api/ingestas")
    ResponseEntity<PostIngestaResponse> save(@RequestBody @Valid PostIngestaRequest postIngestaRequest);

    @GetMapping("api/ingestas")
    ResponseEntity<List<IngestaResponse>> findAll(
            @RequestParam(required = false) Long usuarioId,
            @RequestParam(required = false) LocalDate fechaConsumo
    );

    @GetMapping("api/ingestas/{id}")
    ResponseEntity<IngestaResponse> findById(@PathVariable(value = "id") Long id);

    @PatchMapping("api/ingestas/{id}")
    ResponseEntity<Void> patch(
            @PathVariable(value = "id") Long id,
            @RequestBody @Valid PatchIngestaRequest patchRequest);

    @DeleteMapping("api/ingestas/{id}")
    ResponseEntity<Void> delete(@PathVariable(value = "id") Long id);

}
