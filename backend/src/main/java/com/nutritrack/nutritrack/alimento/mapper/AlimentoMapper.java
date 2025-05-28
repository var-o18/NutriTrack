package com.nutritrack.nutritrack.alimento.mapper;

import com.nutritrack.nutritrack.alimento.api.response.AlimentoResponse;
import com.nutritrack.nutritrack.alimento.entity.Alimento;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AlimentoMapper {

    AlimentoResponse toAlimentoResponse(Alimento alimento);

}
