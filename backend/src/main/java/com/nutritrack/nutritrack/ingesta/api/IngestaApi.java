package com.nutritrack.nutritrack.ingesta.api;

import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.response.PostIngestaResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

public interface IngestaApi {

    @PostMapping("api/ingestas")
    ResponseEntity<PostIngestaResponse> save(@RequestBody @Valid PostIngestaRequest postIngestaRequest);

}
