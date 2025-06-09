package com.nutritrack.nutritrack.usuario.mapper;

import com.nutritrack.nutritrack.usuario.api.request.PatchUsuarioRequest;
import com.nutritrack.nutritrack.usuario.api.request.PostUsuarioRegistro;
import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    UsuarioResponse toUsuarioResponse(Usuario usuario);

    Usuario toEntity(PostUsuarioRegistro postUsuarioRegistro);

    @Mapping(target = "id", ignore = true)
    @Mapping(source = "correo", target = "correo", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "contrasena", target = "contrasena", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "sexo", target = "sexo", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE) // <-- Añade esto
    @Mapping(source = "edad", target = "edad", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE) // <-- Y esto
    @Mapping(source = "peso", target = "peso", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "altura", target = "altura", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "nivelActividadFisica", target = "nivelActividadFisica", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "objetivoPersonal", target = "objetivoPersonal", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "nombre", target = "nombre", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "apellidos", target = "apellidos", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(source = "caloriasDiarias", target = "caloriasDiarias", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void toPatchUsuario(PatchUsuarioRequest patchUsuarioRequest, @MappingTarget Usuario usuario);

}
