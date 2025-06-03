package com.nutritrack.nutritrack.ingesta.controller;

import com.nutritrack.nutritrack.ingesta.api.IngestaApi;
import com.nutritrack.nutritrack.ingesta.api.request.PatchIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.response.IngestaResponse;
import com.nutritrack.nutritrack.ingesta.api.response.PostIngestaResponse;
import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import com.nutritrack.nutritrack.ingesta.mapper.IngestaMapper;
import com.nutritrack.nutritrack.ingesta.service.IngestaService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@AllArgsConstructor
public class IngestaController implements IngestaApi {

    private final IngestaService ingestaService;
    private final IngestaMapper ingestaMapper;

    @SneakyThrows
    @Override
    public ResponseEntity<PostIngestaResponse> save(PostIngestaRequest postIngestaRequest) {
        return ResponseEntity.created(new URI(
                "ingestas/" + ingestaService.save(postIngestaRequest)
        )).build();
    }

    @Override
    public ResponseEntity<List<IngestaResponse>> findAll(Long usuarioId, LocalDate fechaConsumo) {

        return ResponseEntity.ok(ingestaService.findAll(usuarioId, fechaConsumo).stream().map(ingestaMapper::toIngestaResponse).toList());

    }

    @Override
    public ResponseEntity<IngestaResponse> findById(Long id) {
        Optional<Ingesta> ingesta = ingestaService.findById(id);

        return ingesta.map(value -> ResponseEntity.ok(ingestaMapper.toIngestaResponse(value))).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @Override
    public ResponseEntity<Void> patch(Long id, PatchIngestaRequest patchRequest) {
        Optional<Ingesta> ingesta = ingestaService.findById(id);

        if (ingesta.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        ingestaService.patch(patchRequest, ingesta.get());

        return ResponseEntity.noContent().build();
    }

}
