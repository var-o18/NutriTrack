package com.nutritrack.nutritrack.usuario.service;

import com.nutritrack.nutritrack.usuario.api.request.PatchUsuarioRequest;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.mapper.UsuarioMapper;
import com.nutritrack.nutritrack.usuario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
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

    private static final double MARGEN_CALORIAS_PERMITIDO = 0.3; // 30% de margen

    public Optional<Usuario> findById(Long id) {
        return usuarioRepository.findById(id);
    }

    public Optional<Usuario> findByCorreo(String correo) {
        return usuarioRepository.findByCorreo(correo);
    }

    public Usuario login(String email, String rawPassword) {
        Usuario usuario = usuarioRepository.findByCorreo(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        if (!passwordEncoder.matches(rawPassword, usuario.getContrasena())) {
            throw new RuntimeException("Contraseña incorrecta");
        }

        return usuario;
    }

    private double calcularTMB(String sexo, double peso, double altura, int edad) {
        if (sexo.equalsIgnoreCase("masculino")) {
            return 10 * peso + 6.25 * (altura * 100) - 5 * edad + 5;
        } else if (sexo.equalsIgnoreCase("femenino")) {
            return 10 * peso + 6.25 * (altura * 100) - 5 * edad - 161;
        } else {
            double tmbH = 10 * peso + 6.25 * (altura * 100) - 5 * edad + 5;
            double tmbM = 10 * peso + 6.25 * (altura * 100) - 5 * edad - 161;
            return (tmbH + tmbM) / 2.0;
        }
    }

    private double obtenerFactorActividad(String nivelActividadFisica) {
        return switch (nivelActividadFisica.toLowerCase()) {
            case "sedentario" -> 1.2;
            case "ligero" -> 1.375;
            case "moderado" -> 1.55;
            case "activo" -> 1.725;
            case "muy activo" -> 1.9;
            default -> throw new IllegalArgumentException("Nivel de actividad no válido.");
        };
    }

    private long calcularCaloriasDiarias(double tmb, double factorActividad, String objetivoPersonal) {
        double tdee = tmb * factorActividad;

        return switch (objetivoPersonal.toLowerCase()) {
            case "mantenimiento" -> Math.round(tdee);
            case "ganancia muscular" -> Math.round(tdee) + 250;
            case "ganancia muscular rapida" -> Math.round(tdee) + 500;
            case "pérdida de grasa" -> Math.round(tdee) - 250;
            case "pérdida de grasa rapida" -> Math.round(tdee) - 550;
            default -> throw new IllegalArgumentException("Objetivo no válido.");
        };
    }

    @Transactional
    public Long save(PostUsuarioRegistro postUsuarioRegistro) {
        if (usuarioRepository.findByCorreo(postUsuarioRegistro.getCorreo()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "CORREO_EXISTENTE");
        }

        postUsuarioRegistro.setContrasena(passwordEncoder.encode(postUsuarioRegistro.getContrasena()));

        double tmb = calcularTMB(
                postUsuarioRegistro.getSexo(),
                postUsuarioRegistro.getPeso(),
                postUsuarioRegistro.getAltura(),
                postUsuarioRegistro.getEdad()
        );

        double factorActividad = obtenerFactorActividad(postUsuarioRegistro.getNivelActividadFisica());
        long caloriasDiarias = calcularCaloriasDiarias(tmb, factorActividad, postUsuarioRegistro.getObjetivoPersonal());

        postUsuarioRegistro.setCaloriasDiarias(caloriasDiarias);

        Usuario usuario = usuarioMapper.toEntity(postUsuarioRegistro);
        return usuarioRepository.save(usuario).getId();
    }

    @Transactional
    public void patch(PatchUsuarioRequest patchRequest, Usuario usuario) {
        String usuarioAutenticado = SecurityContextHolder.getContext().getAuthentication().getName();
        if (!usuario.getCorreo().equals(usuarioAutenticado)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes modificar información de otro usuario");
        }

        if (patchRequest.getContrasena() != null) {
            patchRequest.setContrasena(passwordEncoder.encode(patchRequest.getContrasena()));
        }

        usuarioMapper.toPatchUsuario(patchRequest, usuario);

        boolean cambioCaracteristicas = patchRequest.getPeso() != null ||
                patchRequest.getAltura() != null ||
                patchRequest.getEdad() != null ||
                patchRequest.getSexo() != null ||
                patchRequest.getNivelActividadFisica() != null ||
                patchRequest.getObjetivoPersonal() != null;

        if (cambioCaracteristicas && patchRequest.getCaloriasDiarias() == null) {
            double tmb = calcularTMB(usuario.getSexo(), usuario.getPeso(), usuario.getAltura(), usuario.getEdad());
            double factorActividad = obtenerFactorActividad(usuario.getNivelActividadFisica());
            long caloriasDiarias = calcularCaloriasDiarias(tmb, factorActividad, usuario.getObjetivoPersonal());
            usuario.setCaloriasDiarias(caloriasDiarias);
        } else if (patchRequest.getCaloriasDiarias() != null) {
            double tmb = calcularTMB(usuario.getSexo(), usuario.getPeso(), usuario.getAltura(), usuario.getEdad());
            double factorActividad = obtenerFactorActividad(usuario.getNivelActividadFisica());
            long caloriasRecomendadas = calcularCaloriasDiarias(tmb, factorActividad, usuario.getObjetivoPersonal());

            double diferenciaPorcentual = Math.abs(patchRequest.getCaloriasDiarias() - caloriasRecomendadas) /
                    (double) caloriasRecomendadas;

            if (diferenciaPorcentual > MARGEN_CALORIAS_PERMITIDO) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Las calorías especificadas se desvían demasiado de lo recomendado para tus características"
                );
            }
        }

        usuarioRepository.save(usuario);
    }
}
