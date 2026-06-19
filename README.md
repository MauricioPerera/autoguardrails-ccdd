# Autoguardrails + CCDD Integration

Este repositorio contiene una integración de extremo a extremo que combina el motor de optimización heurística de prompts **`autoguardrails`** (creado por Santander AI Lab) con un **`CCDD Gate`** (Contract-Driven Development) para garantizar límites estrictos de tokens y robustez criptográfica en las políticas de seguridad.

## Propósito

Cuando optimizamos el *System Prompt* de un LLM para volverlo más seguro contra inyecciones de código (Jailbreaks), los modelos de IA tienden a sufrir de "alucinación de crecimiento": agregan cientos de reglas redundantes que inflan el costo económico de la aplicación y la latencia en producción.

Esta integración soluciona el problema creando un **laboratorio de pruebas de choque y notaría:**
1. **Genera/Optimiza:** El motor `autoguardrails` evalúa repetidamente el prompt contra un simulador de ataques buscando minimizar el ASR (Attack Success Rate) al 0%.
2. **Filtra (CCDD Gate):** Pasa la política ganadora por un contrato estricto (`contract/policies.txt`). Si la política excede el límite de tokens definido (ej. 1500 tokens), es descartada automáticamente.
3. **Firma:** Si todo está bien, firma criptográficamente la política (`expected-hashes.json`) garantizando que está blindada y optimizada para producción.

En nuestras pruebas internas logramos llevar el **ASR a 0.0000%** bloqueando todos los ataques del benchmark consumiendo únicamente **333 tokens**.

## Arquitectura del Repositorio

- `/engine`: Submódulo original de `autoguardrails`. (Ver `engine/README.md`).
- `/contract`: Archivos del contrato CCDD, definiendo los *slots*, metadatos y límites de tokens obligatorios.
- `/scripts`: Wrappers en PowerShell para ejecutar el bucle en máquinas locales usando LLMs de código abierto.

## Cómo Usar (LLMs Locales)

El proyecto está preparado para funcionar sin conexión a la nube usando **LM Studio** u **Ollama**.

### Prerrequisitos
1. Python 3.10+
2. Un modelo local compatible con el formato OpenAI corriendo en `localhost` (Recomendamos la familia `glm-5` o `devstral-24b`).
3. Herramienta CCDD instalada y accesible.

### Ejecución con Ollama
Hemos ampliado el *timeout* del motor a 1 hora (3600s) para dar tiempo a los LLMs locales a completar los 140 casos de la batería de pruebas.

```powershell
# En la raíz del repositorio
cd scripts
.\run_ollama.ps1
```

### Ejecución con LM Studio
Si prefieres LM Studio, asegúrate de tener el servidor local encendido en el puerto `1234`.

```powershell
# En la raíz del repositorio
cd scripts
.\run_lmstudio.ps1
```

## Licencia

Este proyecto está licenciado bajo la licencia **Apache 2.0**. Consulta el archivo `LICENSE` para más detalles.
Todos los scripts generados en esta integración respetan las normas del *Research Contract* y los derechos de autor originales del Santander Group.
