package com.nutritrack.nutritrack.alimento.api.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class OpenFoodFactsResponse {

    @JsonProperty("product")
    private Producto producto;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Producto {
        @JsonProperty("product_name")
        private String nombre;

        @JsonProperty("nutriments")
        private Nutriments nutriments;

        @JsonProperty("ingredients_text")
        private String ingredientes;

        @JsonProperty("code")
        private String codigoBarras;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Nutriments {
        private Double energy;
        private Double proteins;
        private Double carbohydrates;
        private Double fat;
    }
}
