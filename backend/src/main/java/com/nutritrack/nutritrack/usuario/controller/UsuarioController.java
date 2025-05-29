package com.nutritrack.nutritrack.usuario.controller;

import com.nutritrack.nutritrack.config.JwtUtil;
import com.nutritrack.nutritrack.ingesta.repository.IngestaRepository;
import com.nutritrack.nutritrack.usuario.api.UsuarioApi;
import com.nutritrack.nutritrack.usuario.api.request.LoginRequest;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.LoginResponse;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.mapper.UsuarioMapper;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.util.Optional;

@RestController
@AllArgsConstructor
public class UsuarioController implements UsuarioApi {

    private final UsuarioService usuarioService;
    private final UsuarioMapper usuarioMapper;
    private final JwtUtil jwtUtil;

    private final IngestaRepository ingestaRepository;

    @Override
    public ResponseEntity<UsuarioResponse> findById(Long id) {
        Optional<Usuario> usuario = usuarioService.findById(id);

        if (usuario.isEmpty()) {
            return ResponseEntity.notFound().build();
        } else {
            Long caloriasConsumidas = ingestaRepository.caloriasConsumidasHoy(usuario.get().getId());
            Long caloriasRestantes = usuario.get().getCaloriasDiarias() - caloriasConsumidas;

            UsuarioResponse usuarioResponse = usuarioMapper.toUsuarioResponse(usuario.get());
            usuarioResponse.setCaloriasRestantes(caloriasRestantes);

            return ResponseEntity.ok(usuarioResponse);
        }
    }

    @SneakyThrows
    @Override
    public ResponseEntity<UsuarioResponse> save(PostUsuarioRegistro postUsuarioRegistro) {
        Long usuarioId = usuarioService.save(postUsuarioRegistro);
        Optional<Usuario> usuarioOpt = usuarioService.findById(usuarioId);

        if (usuarioOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        UsuarioResponse usuarioResponse = usuarioMapper.toUsuarioResponse(usuarioOpt.get());
        URI location = new URI("usuarios/" + usuarioId);
        return ResponseEntity.created(location).body(usuarioResponse);
    }

    @Override
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest) {
        Usuario usuario = usuarioService.login(loginRequest.getCorreo(), loginRequest.getContrasena());
        String token = jwtUtil.generateToken(usuario.getCorreo());
        Long id = usuario.getId();
        return ResponseEntity.ok(new LoginResponse(id, token));
    }

}
