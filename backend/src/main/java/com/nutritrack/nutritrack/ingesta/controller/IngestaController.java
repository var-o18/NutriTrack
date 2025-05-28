package com.nutritrack.nutritrack.ingesta.controller;

import com.nutritrack.nutritrack.ingesta.api.IngestaApi;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.response.PostIngestaResponse;
import com.nutritrack.nutritrack.ingesta.service.IngestaService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;

@RestController
@AllArgsConstructor
public class IngestaController implements IngestaApi {

    private final IngestaService ingestaService;

    @SneakyThrows
    @Override
    public ResponseEntity<PostIngestaResponse> save(PostIngestaRequest postIngestaRequest) {
        return ResponseEntity.created(new URI(
                "ingestas/" + ingestaService.save(postIngestaRequest)
        )).build();
    }
}
