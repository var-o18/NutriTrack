package com.nutritrack.nutritrack.alimento.mapper;

import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import com.nutritrack.nutritrack.alimento.api.response.OpenFoodFactsResponse;
import com.nutritrack.nutritrack.alimento.entity.Alimento;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface AlimentoMapper {

    AlimentoResponse toAlimentoResponse(Alimento alimento);

    @Mapping(source = "nombre", target = "nombre")
    @Mapping(source = "nutriments.energy", target = "calorias", qualifiedByName = "mapTokCal")
    @Mapping(source = "nutriments.proteins", target = "proteinas")
    @Mapping(source = "nutriments.carbohydrates", target = "carbohidratos")
    @Mapping(source = "nutriments.fat", target = "grasas")
    @Mapping(source = "codigoBarras", target = "codigoBarras")
    @Mapping(source = "ingredientes", target = "ingredientes")
    Alimento productoToAlimento(OpenFoodFactsResponse.Producto producto);

    @Named("mapTokCal")
    default Double mapTokCal(Double energy) {
        return Math.round((energy / 4.184) * 100.0) / 100.0;
    }

}
