package com.nutritrack.nutritrack.usuario.api.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PatchUsuarioRequest {

    @Email(message = "El email debe tener un formato válido")
    private String correo;

    @Size(min = 8, message = "La contraseña debe tener al menos 8 caracteres")
    @Pattern(
            regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=<>?{}\\[\\]-]).+$",
            message = "La contraseña debe tener una mayúscula, una minúscula, un número y un carácter especial"
    )
    private String contrasena;


    private String sexo;

    @Min(value = 1, message = "La edad debe ser mayor a 0")
    @Max(value = 120, message = "La edad debe ser menor a 120")
    private Integer edad;

    @Min(value = 20, message = "El peso debe ser mayor o igual que 20")
    private Double peso;

    @Min(value = 1, message = "La altura debe ser mayor a 0")
    private Double altura;
    private String nivelActividadFisica;
    private String objetivoPersonal;

    @Pattern(regexp = "^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\\s]+$", message = "El nombre solo puede contener letras y espacios")
    private String nombre;

    @Pattern(regexp = "^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\\s]+$", message = "Los apellidos solo pueden contener letras y espacios")
    private String apellidos;

    @Min(value = 800, message = "El objetivo mínimo de calorías debe ser superior a 800")
    @Max(value = 8000, message = "El objetivo mínimo de calorías debe ser inferior a 8000")
    private Long caloriasDiarias;
}