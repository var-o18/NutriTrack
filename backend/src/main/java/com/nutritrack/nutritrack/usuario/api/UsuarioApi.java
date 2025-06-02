package com.nutritrack.nutritrack.usuario.api;

import com.nutritrack.nutritrack.usuario.api.request.LoginRequest;
import com.nutritrack.nutritrack.usuario.api.request.PatchUsuarioRequest;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.LoginResponse;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

public interface UsuarioApi {

    @GetMapping("api/usuarios/{id}")
    ResponseEntity<UsuarioResponse> findById(@PathVariable(value = "id") Long id);

    @PostMapping("api/usuarios/registro")
    ResponseEntity<UsuarioResponse> save(@RequestBody @Valid PostUsuarioRegistro postUsuarioRegistro);

    @PostMapping("api/usuarios/login")
    ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest);

    @PatchMapping("api/usuarios/{id}")
    ResponseEntity<Void> patch(
            @PathVariable(value = "id") Long id,
            @RequestBody @Valid PatchUsuarioRequest patchRequest);
}
