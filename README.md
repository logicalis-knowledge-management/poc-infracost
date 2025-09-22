# 🚀 Demo de Infracost con Terraform

Este proyecto muestra cómo integrar **Infracost** en un flujo de trabajo con **Terraform** para:

1. Consultar los costes de la infraestructura en local.  
2. Bloquear automáticamente Pull Requests cuando el incremento de costes supere un umbral del **15%**.  
3. Añadir comentarios automáticos en los PRs con el desglose de costes.  

La demo se basa en una infraestructura mínima en AWS y permite provocar fácilmente dos escenarios:  
- **Cambio pequeño** (incremento < 15%, no se bloquea la PR).  
- **Cambio grande** (incremento > 15%, la PR se bloquea).

---

## 📦 Infraestructura base

Se define un único recurso en AWS:

- **Instancia EC2 `t3.micro`** con un **volumen EBS gp3 de 20 GiB** (root).  
- La AMI es Ubuntu 22.04 (última versión publicada por Canonical en la región).  
- Se utiliza la **VPC por defecto** para simplificar.

Archivos principales:
- `providers.tf` → configuración del proveedor AWS.  
- `variables.tf` → variables globales (ej. región).  
- `main.tf` → recursos de la infraestructura.

---

## 🧪 Escenarios de prueba

### Escenario A — Cambio pequeño (< 15%)
Incrementar el tamaño del volumen EBS de 20 GiB → 22 GiB:

```diff
 root_block_device {
   volume_type = "gp3"
-  volume_size = 20
+  volume_size = 22
 }
