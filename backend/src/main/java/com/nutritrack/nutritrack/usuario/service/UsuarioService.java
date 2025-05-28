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

    public Usuario login(String email, String rawPassword) {
        Usuario usuario = usuarioRepository.findByCorreo(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        if (!passwordEncoder.matches(rawPassword, usuario.getContrasena())) {
            throw new RuntimeException("Contraseña incorrecta");
        }

        return usuario;
    }

    public Long save(PostUsuarioRegistro postUsuarioRegistro) {
        if (usuarioRepository.findByCorreo(postUsuarioRegistro.getCorreo()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "CORREO_EXISTENTE");
        }

        postUsuarioRegistro.setContrasena(passwordEncoder.encode(postUsuarioRegistro.getContrasena()));

        double tmb;
        if (postUsuarioRegistro.getSexo().equalsIgnoreCase("masculino")) {
            tmb = 10 * postUsuarioRegistro.getPeso() + 6.25 * (postUsuarioRegistro.getAltura() * 100) - 5 * postUsuarioRegistro.getEdad() + 5;
        } else if (postUsuarioRegistro.getSexo().equalsIgnoreCase("femenino")) {
            tmb = 10 * postUsuarioRegistro.getPeso() + 6.25 * (postUsuarioRegistro.getAltura() * 100) - 5 * postUsuarioRegistro.getEdad() - 161;
        } else {

            double tmbH = 10 * postUsuarioRegistro.getPeso() + 6.25 * (postUsuarioRegistro.getAltura() * 100) - 5 * postUsuarioRegistro.getEdad() + 5;
            double tmbM = 10 * postUsuarioRegistro.getPeso() + 6.25 * (postUsuarioRegistro.getAltura() * 100) - 5 * postUsuarioRegistro.getEdad() - 161;
            tmb = (tmbH + tmbM) / 2.0;
        }

        double factorActividad;
        switch (postUsuarioRegistro.getNivelActividadFisica().toLowerCase()) {
            case "sedentario":
                factorActividad = 1.2;
                break;
            case "ligero":
                factorActividad = 1.375;
                break;
            case "moderado":
                factorActividad = 1.55;
                break;
            case "activo":
                factorActividad = 1.725;
                break;
            case "muy activo":
                factorActividad = 1.9;
                break;
            default:
                throw new IllegalArgumentException("Nivel de actividad no válido.");
        }

        double tdee = tmb * factorActividad;

        switch (postUsuarioRegistro.getObjetivoPersonal().toLowerCase()) {
            case "mantenimiento":
                postUsuarioRegistro.setCaloriasDiarias(Math.round(tdee));
                break;
            case "ganancia muscular":
                postUsuarioRegistro.setCaloriasDiarias(Math.round(tdee) + 250);
                break;
            case "ganancia muscular rapida":
                postUsuarioRegistro.setCaloriasDiarias(Math.round(tdee) + 500);
                break;
            case "pérdida de grasa":
                postUsuarioRegistro.setCaloriasDiarias(Math.round(tdee) - 250);
                break;
            case "pérdida de grasa rapida":
                postUsuarioRegistro.setCaloriasDiarias(Math.round(tdee) - 550);
                break;
            default:
                throw new IllegalArgumentException("Objetivo no válido.");
        }

        Usuario usuario = usuarioMapper.toEntity(postUsuarioRegistro);
        return usuarioRepository.save(usuario).getId();
    }


}
