package com.nutritrack.nutritrack.ingesta.specification;

import com.nutritrack.nutritrack.ingesta.entity.Ingesta;
import com.nutritrack.nutritrack.usuario.entity.Usuario;
import org.springframework.data.jpa.domain.Specification;

import java.time.LocalDate;

public class IngestaSpecifications {

    public static Specification<Ingesta> usuarioIdEqual(Long usuarioId) {
        return (root, query, cb) -> cb.equal(root.get(Ingesta.USUARIO_FIELD).get(Usuario.ID_FIELD), usuarioId);
    }

    public static Specification<Ingesta> fechaConsumoEqual(LocalDate fechaConsumo) {
        return (root, query, cb) -> cb.equal(root.get(Ingesta.FECHA_CONSUMO_FIELD), fechaConsumo);
    }

}
