# Oracle Cloud Infrastructure as Code — Terraform + GitHub Actions

Réplica del lab del video **"Oracle Cloud Infrastructure as Code Using Terraform and GitHub Actions"**
([Cloud Quick Labs](https://www.youtube.com/watch?v=3rmROBpBu9A)).

La infraestructura se define con **Terraform**, se versiona en **GitHub** y se despliega con
**GitHub Actions** (nada se ejecuta en la máquina local).

```
main.tf (HCL)  →  Repositorio GitHub  →  GitHub Actions  →  Oracle Cloud
                                                       terraform init / validate / plan / apply
```

## Qué despliega (6 recursos)

| Recurso Terraform | Recurso OCI |
|---|---|
| `oci_identity_compartment` | Compartment |
| `oci_core_vcn` | Virtual Cloud Network `10.23.0.0/20` |
| `oci_core_subnet` | Subred pública `10.23.11.0/24` |
| `oci_core_internet_gateway` | Internet Gateway |
| `oci_core_default_route_table` | Route Table (`0.0.0.0/0` → IG) |
| `oci_core_instance` | Instancia compute (Always Free) |

## Estructura

```
.github/workflows/OCI.yml   Pipeline (workflow_dispatch)
Terraform/provider.tf       Proveedor OCI, perfil DEFAULT
Terraform/terraform.tf      required_providers + backend http remoto
Terraform/terraform.tfvars  compartment_id (raíz de la tenancy)
Terraform/variables.tf      VCN, subnet, IG, instancia, imagen, shape
Terraform/main.tf           Los 6 recursos
Terraform/outputs.tf        Salida compartment_id
HelpScript.ps1              Obtiene shapes e imágenes con OCI CLI
```

## Requisitos

- Cuenta de Oracle Cloud (Free Trial sirve)
- Un par de claves de API en **My profile → Tokens and keys → API keys**
- Un bucket de Object Storage con un objeto `terraform.tfstate` y una
  **pre-authenticated request** de tipo `ObjectReadWrite`
- Terraform ≥ 1.x (sólo para validación local opcional)

## Configuración (una sola vez)

### 1. Credenciales en Oracle Cloud

`My profile → Tokens and keys → API keys → Add API key` y anotar:

| Dato | Dónde |
|---|---|
| `tenancy` OCID | My profile → Tenancy |
| `user` OCID | My profile → User OCID |
| `fingerprint` | My profile → API keys |
| `region` | Barra superior de la consola |
| clave privada | Descargada al crear la API key |

### 2. Secretos en GitHub

`Settings → Secrets and variables → Actions → New repository secret`:

| Secreto | Contenido |
|---|---|
| `OCI_USER_OCID` | OCID del usuario |
| `OCI_FINGERPRINT` | Fingerprint de la API key |
| `OCI_REGION` | Región, p. ej. `sa-saopaulo-1` |
| `OCI_TENANCY_OCID` | OCID de la tenancy |
| `OCI_KEY_FILE` | Contenido completo del `private.pem` |
| `OCI_STATE_URL` | URL PAR del objeto `terraform.tfstate` |

> `OCI_STATE_URL` se inyecta en `terraform init -backend-config="address=…"` para **no**
> publicar una URL con permiso de escritura sobre el estado en un repositorio público.

## Ejecutar el pipeline

**Actions → Create OCI With Terraform → Run workflow → rama `main`.**

Pasos que ejecuta el job:

1. `Checkout`
2. `Setup Terraform` (`hashicorp/setup-terraform@v3`)
3. `Write Config & Key Files` — genera `~/.oci/config` y `~/.oci/key.pem`
4. `Install OCI CLI`
5. `Fix OCI Config File Permissions` — OCI exige permisos `0600`
6. `terraform init` — estado remoto en Object Storage
7. `terraform validate`
8. `terraform plan`
9. `terraform apply -auto-approve`

## Validación local (opcional)

```bash
cd Terraform
terraform init  -backend-config="address=$OCI_STATE_URL"
terraform validate
terraform plan
```

## Limpieza

```bash
cd Terraform
terraform init -backend-config="address=$OCI_STATE_URL"
terraform destroy -auto-approve
```

## Notas

- **Capacidad**: en regiones saturadas OCI devuelve `500-InternalError, Out of host capacity`
  para las VM gratuitas. Se comprueba la capacidad con
  `create_compute_capacity_report` antes de reintentar.
- **`VM.Standard.A1.Flex`** es ARM: exige una imagen `aarch64`
  (`Oracle-Linux-8.10-aarch64`).
- El nombre del compartment incluye un `timestamp()` en `main.tf`, por lo que
  cambia en cada `apply` (update in-place, no destructivo).
- Claves fuera de git: `.gitignore` excluye `*.pem`, `keys/` e `id_rsa*`.

## Referencias

- [Video original](https://www.youtube.com/watch?v=3rmROBpBu9A)
- [Repositorio original del autor](https://github.com/RekhuGopal/OracleCloudInfrastructure)
- [Tutorial oficial de Oracle: Terraform + OCI](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm)
