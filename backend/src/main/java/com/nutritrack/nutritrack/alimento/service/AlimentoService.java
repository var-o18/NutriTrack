package com.nutritrack.nutritrack.alimento.service;

import com.nutritrack.nutritrack.alimento.api.response.OpenFoodFactsResponse;
import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.alimento.mapper.AlimentoMapper;
import com.nutritrack.nutritrack.alimento.repository.AlimentoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlimentoService {

    private final AlimentoRepository alimentoRepository;
    private final OpenFoodFactsService openFoodFactsService;
    private final AlimentoMapper alimentoMapper;

    public Optional<Alimento> findById(Long id) {
        return alimentoRepository.findById(id);
    }

    public List<Alimento> findAll() {
        return alimentoRepository.findAll();
    }

    @Transactional
    public Alimento findByCodigoBarras(String codigoBarras) {
        Optional<Alimento> alimentoOpt = alimentoRepository.findByCodigoBarras(codigoBarras);
        if (alimentoOpt.isPresent()) {
            return alimentoOpt.get();
        }

        OpenFoodFactsResponse response = openFoodFactsService.buscarPorCodigoBarras(codigoBarras);
        if (response != null && response.getProducto() != null && response.getProducto().getNombre() != null) {
            Alimento alimento = alimentoMapper.productoToAlimento(response.getProducto());
            return alimentoRepository.save(alimento);
        }

        throw new ResponseStatusException(NOT_FOUND, "Alimento no encontrado por código de barras");
    }

}
