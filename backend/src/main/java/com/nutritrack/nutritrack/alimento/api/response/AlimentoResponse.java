package com.nutritrack.nutritrack.alimento.api.response;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlimentoResponse {

    private Long id;

    private String nombre;

    private Double calorias;

    private Double proteinas;

    private Double carbohidratos;

    private Double grasas;

    private String codigoBarras;

    private String ingredientes;

    public static AlimentoResponse fromEntity(Alimento alimento) {
        AlimentoResponse response = new AlimentoResponse();
        response.setId(alimento.getId());
        response.setNombre(alimento.getNombre());
        response.setCalorias(alimento.getCalorias());
        return response;
    }

}
