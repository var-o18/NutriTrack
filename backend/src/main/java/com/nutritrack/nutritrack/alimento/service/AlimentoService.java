package com.nutritrack.nutritrack.alimento.service;

import com.nutritrack.nutritrack.alimento.api.request.PostAlimentoRequest;
import com.nutritrack.nutritrack.alimento.api.response.OpenFoodFactsResponse;
import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.alimento.mapper.AlimentoMapper;
import com.nutritrack.nutritrack.alimento.repository.AlimentoRepository;
import com.nutritrack.nutritrack.ingesta.repository.IngestaRepository;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import com.nutritrack.nutritrack.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
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
    private final IngestaRepository ingestaRepository;
    private final UsuarioService usuarioService;

    private static final double MAX_CALORIAS_POR_PORCION = 800.0; // Máximo de calorías razonable por porción
    private static final double MIN_CALORIAS_POR_PORCION = 50.0;  // Mínimo de calorías razonable por porción

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

    public Long save(PostAlimentoRequest postAlimentoRequest) {
        Alimento alimento = alimentoMapper.toEntity(postAlimentoRequest);
        return alimentoRepository.save(alimento).getId();
    }

    public List<Alimento> getSugerencias(Integer limite, Double margenPorcentaje) {
        String usuarioAutenticado = SecurityContextHolder.getContext().getAuthentication().getName();
        Usuario usuario = usuarioService.findByCorreo(usuarioAutenticado)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Usuario no autenticado"));

        Long caloriasConsumidas = ingestaRepository.caloriasConsumidasHoy(usuario.getId());
        double caloriasPorPorcion = getCaloriasPorPorcion(usuario, caloriasConsumidas);

        // Calculamos el rango con el margen
        double margen = caloriasPorPorcion * margenPorcentaje;
        double minCalorias = caloriasPorPorcion - margen;
        double maxCalorias = caloriasPorPorcion + margen;

        // Intentamos obtener alimentos en el rango calculado
        List<Alimento> sugerencias = alimentoRepository.findByCaloriasBetweenOrderByCaloriasAsc(
                minCalorias,
                maxCalorias,
                PageRequest.of(0, limite)
        );

        // Si no encontramos sugerencias, ampliamos el rango
        if (sugerencias.isEmpty()) {
            // Ampliamos el margen al doble
            margen = caloriasPorPorcion * (margenPorcentaje * 2);
            minCalorias = Math.max(MIN_CALORIAS_POR_PORCION, caloriasPorPorcion - margen);
            maxCalorias = Math.min(MAX_CALORIAS_POR_PORCION, caloriasPorPorcion + margen);

            sugerencias = alimentoRepository.findByCaloriasBetweenOrderByCaloriasAsc(
                    minCalorias,
                    maxCalorias,
                    PageRequest.of(0, limite)
            );

            // Si aún no hay sugerencias, buscamos los alimentos más cercanos a las calorías objetivo
            if (sugerencias.isEmpty()) {
                sugerencias = alimentoRepository.findClosestToCalories(
                        caloriasPorPorcion,
                        PageRequest.of(0, limite)
                );
            }
        }

        return sugerencias;
    }

    private static double getCaloriasPorPorcion(Usuario usuario, Long caloriasConsumidas) {
        long caloriasRestantes = usuario.getCaloriasDiarias() - caloriasConsumidas;

        if (caloriasRestantes <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Ya has alcanzado tu objetivo de calorías diarias");
        }

        // Calculamos calorías objetivo por porción
        double caloriasPorPorcion = Math.min(caloriasRestantes / 3.0, MAX_CALORIAS_POR_PORCION);
        caloriasPorPorcion = Math.max(caloriasPorPorcion, MIN_CALORIAS_POR_PORCION);
        return caloriasPorPorcion;
    }
}
