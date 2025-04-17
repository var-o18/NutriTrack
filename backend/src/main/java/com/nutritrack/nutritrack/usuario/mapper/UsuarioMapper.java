package com.nutritrack.nutritrack.usuario.mapper;

import com.nutritrack.nutritrack.usuario.api.response.UsuarioResponse;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    UsuarioResponse toUsuarioResponse(Usuario usuario);
}
