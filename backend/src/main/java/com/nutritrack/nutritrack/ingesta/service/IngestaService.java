package com.nutritrack.nutritrack.ingesta.service;

import com.nutritrack.nutritrack.alimento.service.AlimentoService;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import com.nutritrack.nutritrack.ingesta.mapper.IngestaMapper;
import com.nutritrack.nutritrack.ingesta.repository.IngestaRepository;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalTime;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class IngestaService {

    private final IngestaRepository ingestaRepository;
    private final IngestaMapper ingestaMapper;
    private final AlimentoService alimentoService;
    private final UsuarioService usuarioService;

    public Long save(PostIngestaRequest postIngestaRequest) {

        if (alimentoService.findById(postIngestaRequest.getAlimentoId()).isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ALIMENTO_NO_EXISTENTE");
        }

        if (usuarioService.findById(postIngestaRequest.getUsuarioId()).isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "USUARIO_NO_EXISTENTE");
        }

        postIngestaRequest.setFechaConsumo(LocalDate.now());
        postIngestaRequest.setHoraConsumo(LocalTime.now());

        Ingesta ingesta = ingestaMapper.toEntity(postIngestaRequest);
        return ingestaRepository.save(ingesta).getId();
    }


}
