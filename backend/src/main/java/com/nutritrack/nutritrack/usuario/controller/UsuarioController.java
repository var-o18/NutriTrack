package com.nutritrack.nutritrack.usuario.controller;

import com.nutritrack.nutritrack.usuario.api.UsuarioApi;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import com.nutritrack.nutritrack.usuario.mapper.UsuarioMapper;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class UsuarioController implements UsuarioApi {

    private final UsuarioService usuarioService;
    private final UsuarioMapper usuarioMapper;

    @Override
    public ResponseEntity<UsuarioResponse> findById(Long id) {
        return usuarioService.findById(id).map(usuarioMapper::toUsuarioResponse).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
