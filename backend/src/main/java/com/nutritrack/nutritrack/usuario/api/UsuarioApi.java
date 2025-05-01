package com.nutritrack.nutritrack.usuario.api;

import com.nutritrack.nutritrack.usuario.api.request.LoginRequest;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.LoginResponse;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

public interface UsuarioApi {

    @GetMapping("api/usuarios/{id}")
    ResponseEntity<UsuarioResponse> findById(@PathVariable(value = "id") Long id);

    @PostMapping("api/usuarios/registro")
    ResponseEntity<UsuarioResponse> save(@RequestBody @Valid PostUsuarioRegistro postUsuarioRegistro);

    @PostMapping("api/usuarios/login")
    ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest);

}
