package com.nutritrack.nutritrack.usuario.api.request;

import jakarta.validation.constraints.*;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PostUsuarioRegistro {

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email debe tener un formato válido")
    private String correo;

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 8, message = "La contraseña debe tener al menos 8 caracteres")
    @Pattern(
            regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=<>?{}\\[\\]-]).+$",
            message = "La contraseña debe tener una mayúscula, una minúscula, un número y un carácter especial"
    )
    private String contrasena;

    @NotBlank(message = "El sexo es obligatorio")
    private String sexo;

    @NotNull(message = "La edad es obligatoria")
    @Min(value = 1, message = "La edad debe ser mayor a 0")
    @Max(value = 120, message = "La edad debe ser menor a 120")
    private int edad;

    @NotNull(message = "El peso es obligatorio")
    @Min(value = 20, message = "El peso debe ser mayor o igual que 20")
    private double peso;

    @NotNull(message = "La altura obligatoria")
    @Min(value = 1, message = "La altura debe ser mayor a 0")
    private double altura;

    @NotBlank(message = "El nivel de actividad física es obligatorio")
    private String nivelActividadFisica;

    @NotBlank(message = "El nivel objetivo personal es obligatorio")
    private String objetivoPersonal;

    @NotBlank(message = "El nombre es obligatorio")
    @Pattern(regexp = "^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\\s]+$", message = "El nombre solo puede contener letras y espacios")
    private String nombre;

    @Pattern(regexp = "^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\\s]+$", message = "Los apellidos solo pueden contener letras y espacios")
    private String apellidos;

    @Min(value = 800, message = "El objetivo mínimo de calorías debe ser superior a 800")
    @Max(value = 8000, message = "El objetivo mínimo de calorías debe ser inferior a 8000")
    private Long caloriasDiarias;

}
