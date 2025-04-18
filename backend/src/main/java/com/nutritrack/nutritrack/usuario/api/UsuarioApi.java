package com.nutritrack.nutritrack.usuario.api;

import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

public interface UsuarioApi {

    @GetMapping("/usuarios/{id}")
    ResponseEntity<UsuarioResponse> findById(@PathVariable(value = "id") Long id);

    @PostMapping("/usuarios")
    ResponseEntity<UsuarioResponse> save(@RequestBody PostUsuarioRegistro postUsuarioRegistro);

}
