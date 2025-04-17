package com.nutritrack.nutritrack.usuario.api;

import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

public interface UsuarioApi {

    @GetMapping("/usuarios/{id}")
    ResponseEntity<UsuarioResponse> findById(@PathVariable(value = "id") Long id);

}
