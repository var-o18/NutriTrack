package com.nutritrack.nutritrack.usuario.controller;

import com.nutritrack.nutritrack.usuario.api.UsuarioApi;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import com.nutritrack.nutritrack.usuario.mapper.UsuarioMapper;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;

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

    @SneakyThrows
    @Override
    public ResponseEntity<UsuarioResponse> save(PostUsuarioRegistro postUsuarioRegistro) {
        return ResponseEntity.created(new URI(
                "usuarios/" + usuarioService.save(postUsuarioRegistro)
        )).build();
    }
}
