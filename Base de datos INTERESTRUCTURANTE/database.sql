
CREATE DATABASE aplicacion;
USE DATABASE aplicacion;

--
-- Estructura de tabla para la tabla `desafios_retos`
--

CREATE TABLE `desafios_retos` (
  `id_desafio` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `estado` enum('completado','en curso','no iniciado') DEFAULT 'no iniciado',
  `recompensa_asociada` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `objetivos_usuario`
--

CREATE TABLE `objetivos_usuario` (
  `id_objetivo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo_objetivo` enum('reducir uso','bloquear apps','mejorar productividad') NOT NULL,
  `tiempo_limite` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recompensas`
--

CREATE TABLE `recompensas` (
  `id_recompensa` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo_recompensa` varchar(100) NOT NULL,
  `puntos` int(11) NOT NULL,
  `estado` enum('reclamado','no reclamado') DEFAULT 'no reclamado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `redes_sociales_monitorizadas`
--

CREATE TABLE `redes_sociales_monitorizadas` (
  `id_red_social` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_estadisticas`
--

CREATE TABLE `reportes_estadisticas` (
  `id_reporte` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_generacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `tiempo_total_uso` int(11) NOT NULL,
  `promedio_uso_diario` int(11) NOT NULL,
  `comparacion_dias_anteriores` int(11) NOT NULL,
  `estado_objetivo` enum('cumplido','no cumplido') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `uso_redes_sociales`
--

CREATE TABLE `uso_redes_sociales` (
  `id_uso` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_red_social` int(11) NOT NULL,
  `tiempo_uso` int(11) NOT NULL,
  `fecha_registro` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `desafios_retos`
--
ALTER TABLE `desafios_retos`
  ADD PRIMARY KEY (`id_desafio`),
  ADD KEY `fk_desafio_usuario` (`id_usuario`),
  ADD KEY `fk_desafio_recompensa` (`recompensa_asociada`);

--
-- Indices de la tabla `objetivos_usuario`
--
ALTER TABLE `objetivos_usuario`
  ADD PRIMARY KEY (`id_objetivo`),
  ADD KEY `fk_objetivo_usuario` (`id_usuario`);

--
-- Indices de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD PRIMARY KEY (`id_recompensa`),
  ADD KEY `fk_recompensa_usuario` (`id_usuario`);

--
-- Indices de la tabla `redes_sociales_monitorizadas`
--
ALTER TABLE `redes_sociales_monitorizadas`
  ADD PRIMARY KEY (`id_red_social`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `reportes_estadisticas`
--
ALTER TABLE `reportes_estadisticas`
  ADD PRIMARY KEY (`id_reporte`),
  ADD KEY `fk_reporte_usuario` (`id_usuario`);

--
-- Indices de la tabla `uso_redes_sociales`
--
ALTER TABLE `uso_redes_sociales`
  ADD PRIMARY KEY (`id_uso`),
  ADD KEY `fk_uso_usuario` (`id_usuario`),
  ADD KEY `fk_uso_red_social` (`id_red_social`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `desafios_retos`
--
ALTER TABLE `desafios_retos`
  MODIFY `id_desafio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `objetivos_usuario`
--
ALTER TABLE `objetivos_usuario`
  MODIFY `id_objetivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  MODIFY `id_recompensa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `redes_sociales_monitorizadas`
--
ALTER TABLE `redes_sociales_monitorizadas`
  MODIFY `id_red_social` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reportes_estadisticas`
--
ALTER TABLE `reportes_estadisticas`
  MODIFY `id_reporte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `uso_redes_sociales`
--
ALTER TABLE `uso_redes_sociales`
  MODIFY `id_uso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `desafios_retos`
--
ALTER TABLE `desafios_retos`
  ADD CONSTRAINT `fk_desafio_recompensa` FOREIGN KEY (`recompensa_asociada`) REFERENCES `recompensas` (`id_recompensa`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_desafio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `objetivos_usuario`
--
ALTER TABLE `objetivos_usuario`
  ADD CONSTRAINT `fk_objetivo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD CONSTRAINT `fk_recompensa_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reportes_estadisticas`
--
ALTER TABLE `reportes_estadisticas`
  ADD CONSTRAINT `fk_reporte_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `uso_redes_sociales`
--
ALTER TABLE `uso_redes_sociales`
  ADD CONSTRAINT `fk_uso_red_social` FOREIGN KEY (`id_red_social`) REFERENCES `redes_sociales_monitorizadas` (`id_red_social`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_uso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;
COMMIT;
