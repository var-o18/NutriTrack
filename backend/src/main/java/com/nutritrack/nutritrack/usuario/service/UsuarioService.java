package com.nutritrack.nutritrack.usuario.service;

import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.mapper.UsuarioMapper;
import com.nutritrack.nutritrack.usuario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioMapper usuarioMapper;
    private final PasswordEncoder passwordEncoder;

    public Optional<Usuario> findById(Long id) {
        return usuarioRepository.findById(id);
    }

    public Long save(PostUsuarioRegistro postUsuarioRegistro) {
        if (usuarioRepository.findByCorreo(postUsuarioRegistro.getCorreo()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "CORREO_EXISTENTE");
        }

        postUsuarioRegistro.setContrasena(passwordEncoder.encode(postUsuarioRegistro.getContrasena()));

        Usuario usuario = usuarioMapper.toEntity(postUsuarioRegistro);
        return usuarioRepository.save(usuario).getId();
    }

}
