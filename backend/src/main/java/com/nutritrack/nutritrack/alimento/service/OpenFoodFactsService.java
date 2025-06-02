package com.nutritrack.nutritrack.alimento.service;

import com.nutritrack.nutritrack.alimento.api.response.OpenFoodFactsResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class OpenFoodFactsService {

    private final RestTemplate restTemplate;

    public OpenFoodFactsService(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    public OpenFoodFactsResponse buscarPorCodigoBarras(String codigoBarras) {
        String url = "https://world.openfoodfacts.org/api/v0/product/" + codigoBarras + ".json";
        try {
            return restTemplate.getForObject(url, OpenFoodFactsResponse.class);
        } catch (Exception e) {
            log.error("Error inesperado", e);
            throw new RuntimeException("Fallo en la consulta a OpenFoodFacts");
        }
    }
}
