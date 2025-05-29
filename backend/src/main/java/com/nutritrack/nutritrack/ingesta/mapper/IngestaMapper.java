package com.nutritrack.nutritrack.ingesta.mapper;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
import com.nutritrack.nutritrack.ingesta.api.response.IngestaResponse;
import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface IngestaMapper {

    @Mapping(source = "usuarioId", target = "usuario", qualifiedByName = "mapToUsuario")
    @Mapping(source = "alimentoId", target = "alimento", qualifiedByName = "mapToAlimento")
    Ingesta toEntity(PostIngestaRequest postIngestaRequest);

    @Mapping(source = "usuario.id", target = "usuarioId")
    @Mapping(source = "alimento.id", target = "alimentoId")
    @Mapping(source = "alimento.nombre", target = "alimento")
    @Mapping(source = ".", target = "calorias", qualifiedByName = "calcularCalorias")
    @Mapping(source = ".", target = "proteinas", qualifiedByName = "calcularProteinas")
    @Mapping(source = ".", target = "carbohidratos", qualifiedByName = "calcularCarbohidratos")
    @Mapping(source = ".", target = "grasas", qualifiedByName = "calcularGrasas")
    IngestaResponse toIngestaResponse(Ingesta ingesta);

    @Named("mapToUsuario")
    default Usuario mapToUsuario(final Long id) {
        return Usuario.builder().id(id).build();
    }

    @Named("mapToAlimento")
    default Alimento mapToAlimento(final Long id) {
        return Alimento.builder().id(id).build();
    }

    @Named("calcularCalorias")
    default Double calcularCalorias(Ingesta ingesta) {
        double calorias = ingesta.getAlimento().getCalorias() * (ingesta.getCantidad() / 100.0);
        return Math.round(calorias * 100.0) / 100.0;
    }

    @Named("calcularProteinas")
    default Double calcularProteinas(Ingesta ingesta) {
        double proteinas = ingesta.getAlimento().getProteinas() * (ingesta.getCantidad() / 100.0);
        return Math.round(proteinas * 100.0) / 100.0;
    }

    @Named("calcularCarbohidratos")
    default Double calcularCarbohidratos(Ingesta ingesta) {
        double carbohidratos = ingesta.getAlimento().getCarbohidratos() * (ingesta.getCantidad() / 100.0);
        return Math.round(carbohidratos * 100.0) / 100.0;
    }

    @Named("calcularGrasas")
    default Double calcularGrasas(Ingesta ingesta) {
        double grasas = ingesta.getAlimento().getGrasas() * (ingesta.getCantidad() / 100.0);
        return Math.round(grasas * 100.0) / 100.0;
    }

}
