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

    @Min(value = 1, message = "La edad debe ser mayor a 0")
    @Max(value = 120, message = "La edad debe ser menor a 120")
    private int edad;

    @Min(value = 20, message = "El peso debe ser mayor o igual que 20")
    private double peso;

    @Min(value = 1, message = "La altura debe ser mayor a 0")
    private double altura;

    @NotBlank(message = "El nivel de actividad física es obligatorio")
    private String nivel_actividad_fisica;

    @NotBlank(message = "El nivel objetivo personal es obligatorio")
    private String objetivo_personal;

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    private String apellidos;

}
