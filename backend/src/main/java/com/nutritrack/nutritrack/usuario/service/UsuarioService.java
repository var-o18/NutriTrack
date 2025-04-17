package com.nutritrack.nutritrack.usuario.service;

import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    public Optional<Usuario> findById(Long id) {
        return usuarioRepository.findById(id);
    }

}
