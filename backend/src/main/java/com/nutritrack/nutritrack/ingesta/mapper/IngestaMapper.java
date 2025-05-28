package com.nutritrack.nutritrack.ingesta.mapper;

import com.nutritrack.nutritrack.alimento.entity.Alimento;
import com.nutritrack.nutritrack.ingesta.api.request.PostIngestaRequest;
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

    @Named("mapToUsuario")
    default Usuario mapToUsuario(final Long id) {
        return Usuario.builder().id(id).build();
    }

    @Named("mapToAlimento")
    default Alimento mapToAlimento(final Long id) {
        return Alimento.builder().id(id).build();
    }

}
