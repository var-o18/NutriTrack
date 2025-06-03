package com.nutritrack.nutritrack.ingesta.service;

import com.nutritrack.nutritrack.alimento.service.AlimentoService;
import com.nutritrack.nutritrack.ingesta.api.request.PatchIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import com.nutritrack.nutritrack.ingesta.mapper.IngestaMapper;
import com.nutritrack.nutritrack.ingesta.repository.IngestaRepository;
import com.nutritrack.nutritrack.ingesta.specification.IngestaSpecifications;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class IngestaService {

    private final IngestaRepository ingestaRepository;
    private final IngestaMapper ingestaMapper;
    private final AlimentoService alimentoService;
    private final UsuarioService usuarioService;

    public Optional<Ingesta> findById(Long id) {
        return ingestaRepository.findById(id);
    }

    @Transactional
    public Long save(PostIngestaRequest postIngestaRequest) {
        if (alimentoService.findById(postIngestaRequest.getAlimentoId()).isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ALIMENTO_NO_EXISTENTE");
        }


        String usuarioAutenticado = SecurityContextHolder.getContext().getAuthentication().getName();
        Optional<Usuario> usuario = usuarioService.findByCorreo(usuarioAutenticado);

        if (usuario.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Usuario no autenticado");
        }

        if (!usuario.get().getId().equals(postIngestaRequest.getUsuarioId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes crear ingestas para otro usuario");
        }

        postIngestaRequest.setFechaConsumo(LocalDate.now());
        postIngestaRequest.setHoraConsumo(LocalTime.now());

        Ingesta ingesta = ingestaMapper.toEntity(postIngestaRequest);
        return ingestaRepository.save(ingesta).getId();
    }

    public List<Ingesta> findAll(Long usuarioId, LocalDate fechaConsumo) {
        Specification<Ingesta> ingestaSpecification = Specification.where(null);

        if (Objects.nonNull(usuarioId)) {
            if (usuarioService.findById(usuarioId).isEmpty()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "USUARIO_NO_EXISTENTE");
            }

            ingestaSpecification = ingestaSpecification.and(IngestaSpecifications.usuarioIdEqual(usuarioId));
        }

        if (Objects.nonNull(fechaConsumo)) {
            ingestaSpecification = ingestaSpecification.and(IngestaSpecifications.fechaConsumoEqual(fechaConsumo));
        }

        return ingestaRepository.findAll(ingestaSpecification);
    }

    @Transactional
    public void patch(PatchIngestaRequest patchRequest, Ingesta ingesta) {
        String usuarioAutenticado = SecurityContextHolder.getContext().getAuthentication().getName();
        if (!ingesta.getUsuario().getCorreo().equals(usuarioAutenticado)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes modificar ingestas de otro usuario");
        }

        if (patchRequest.getAlimentoId() != null) {
            if (alimentoService.findById(patchRequest.getAlimentoId()).isEmpty()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ALIMENTO_NO_EXISTENTE");
            }
        }

        ingestaMapper.toPatchIngesta(patchRequest, ingesta);

        ingestaRepository.save(ingesta);
    }
}
