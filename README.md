# Oficina DB

## Visão Geral

Este projeto implementa o provisionamento de banco de dados **Amazon RDS PostgreSQL** utilizando **Terraform** para infraestrutura como código (IaC). O banco de dados integra-se com a infraestrutura EKS criada pelo projeto `oficina-infra`, utilizando as mesmas VPCs, subnets privadas e chaves KMS.

### Pré-requisitos

- **Terraform**: v1.14.2+
- **AWS CLI**: v2.0+
- **Conta AWS** com permissões adequadas
- **Infraestrutura EKS** já provisionada pelo projeto `oficina-infra`

### Arquitetura de Módulos

#### 1. **RDS PostgreSQL Module** (`modules/rds-postgres`)
Banco de dados gerenciado:
- **Engine**: PostgreSQL 17.6
- **Instance**: db.t3.micro (single-AZ para dev)
- **Storage**: 20 GB gp3 com auto-scaling até 100 GB
- **Backup**: 5 dias de retenção automática
- **Criptografia**: KMS at-rest e SSL em trânsito
- **Subnet privada**: Sem acesso público direto
- **CloudWatch Logs**: Exportação automática de logs do PostgreSQL
- **Manutenção**: Segunda-feira 04:00-05:00 UTC

### Configuração por Ambiente

| Ambiente | Diretório | Descrição |
|----------|-----------|-----------|
| **dev** | `inventories/dev/` | Desenvolvimento - deletion_protection=false |
| **hom** | `inventories/hom/` | Homologação |
| **prod** | `inventories/prod/` | Produção - deletion_protection=true |

### Comandos Terraform

```bash
# Inicializar
terraform init

# Validar
terraform validate

# Planejar (dev)
terraform plan -var-file=inventories/dev/terraform.tfvars

# Aplicar (dev)
terraform apply -var-file=inventories/dev/terraform.tfvars

# Ver outputs
terraform output
```

### Integração com oficina-infra

Este projeto integra-se automaticamente com a infraestrutura criada pelo `oficina-infra`:
- Busca VPC pelo nome `{cluster_name}-vpc`
- Identifica subnets privadas através dos tags Kubernetes
- Obtém security group dos nodes do EKS para permitir acesso
- Utiliza a mesma chave KMS do EKS para criptografia

**Ordem de deploy:**
1. Deploy da infraestrutura EKS via `oficina-infra`
2. Deploy do banco de dados RDS via `oficina-db`

### Outputs

- `rds_endpoint`: Endpoint completo do RDS (hostname:porta)
- `rds_address`: Endereço do RDS (apenas hostname)
- `rds_port`: Porta do PostgreSQL (5432)
- `rds_database_name`: Nome do banco de dados criado
