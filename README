# 📄 Stirling PDF — Azure Kubernetes Service Deployment

![Azure](https://img.shields.io/badge/Microsoft%20Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat&logo=githubactions&logoColor=white)
![Cilium](https://img.shields.io/badge/Cilium-F8C517?style=flat&logo=cilium&logoColor=black)

---

## 📌 About the Project

This project provisions a fully working, **security-hardened** deployment of
**[Stirling PDF](https://github.com/Stirling-Tools/Stirling-PDF)** — the #1 open-source
PDF manipulation tool on GitHub — on **Azure Kubernetes Service (AKS)**.

The infrastructure is fully modularised with **Terraform**, container images are stored in
**Azure Container Registry (ACR)**, secrets are managed and auto-rotated via **Azure Key Vault**,
the network layer runs **Azure CNI Overlay with Cilium**, and the entire lifecycle
(plan, apply, destroy) is automated with **GitHub Actions CI/CD pipelines**.

Security compliance is enforced throughout using **Checkov** annotations, with deliberate
and documented trade-offs for dev/test cost optimisation.

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                          Microsoft Azure                             │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐   │
│  │                       Resource Group                         │   │
│  │                                                               │   │
│  │  ┌──────────┐  ┌──────────────┐  ┌────────────────────────┐  │   │
│  │  │  Azure   │  │ Azure  Key   │  │      AKS Cluster       │  │   │
│  │  │   ACR    │  │    Vault     │  │  (Azure CNI + Cilium)  │  │   │
│  │  │          │  │(Secret Rot.) │  │                        │  │   │
│  │  └────┬─────┘  └──────┬───────┘  │  ┌──────────────────┐  │  │   │
│  │       │               │          │  │  Frontend Pod    │  │  │   │
│  │       │ Pull images   │ Secrets  │  │   (React UI)     │  │  │   │
│  │       └───────────────┴──────────│  └────────┬─────────┘  │  │   │
│  │                                  │           │            │  │   │
│  │  ┌──────────────────┐            │  ┌────────▼─────────┐  │  │   │
│  │  │ Azure Monitoring │◀───────────│  │  Backend Pod     │  │  │   │
│  │  │  (OMS + Logs)    │            │  │ (Stirling PDF)   │  │  │   │
│  │  └──────────────────┘            │  └──────────────────┘  │  │   │
│  │                                  │  Autoscaler: 1–3 nodes  │  │   │
│  │                                  └────────────────────────┘  │   │
│  │                         Networking (VNet 10.10.0.0/16)       │   │
│  └───────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
                    ▲
         GitHub Actions CI/CD
    (Terraform Plan / Apply / Destroy)
```

---

## 🔐 Security Highlights

| Feature | Implementation |
|---|---|
| **Secrets Management** | Azure Key Vault with auto-rotation every 10 minutes |
| **Disk Encryption** | Host encryption + Disk Encryption Set |
| **OS Disks** | Ephemeral OS disks for better performance & security |
| **Network Policy** | Cilium eBPF-based network policy enforcement |
| **API Server Access** | Restricted to authorised IPs (injected at pipeline runtime) |
| **Azure Policy** | Enabled on AKS cluster |
| **Compliance** | Checkov annotations with documented trade-off decisions |
| **Node Upgrades** | Automatic patch channel + NodeImage OS updates |
| **Maintenance Windows** | Scheduled Sunday 02:00–06:00 UTC+1 |

---

## 🧰 Tech Stack

| Technology | Purpose |
|---|---|
| **Microsoft Azure** | Cloud provider |
| **AKS** | Managed Kubernetes cluster with Cluster Autoscaler |
| **Azure Container Registry** | Docker image storage |
| **Azure Key Vault** | Secrets management with rotation |
| **Azure Monitor + Log Analytics** | Observability & logging (MSI auth) |
| **Azure CNI Overlay + Cilium** | Advanced networking & network policy |
| **Terraform** | Modular Infrastructure as Code |
| **GitHub Actions** | CI/CD — Terraform Plan/Apply/Destroy |
| **Stirling PDF** | Backend PDF processing application |
| **React** | Frontend UI |

---

## 📁 Project Structure

```
stirling-pdf-aks/
├── .github/
│   └── workflows/
│       ├── Terraform-Plan-Apply.yml    # CI/CD: provision infrastructure
│       └── Terraform-Destroy-All.yml   # CI/CD: tear down all resources
├── k8s/
│   ├── namespace.yaml                  # Kubernetes namespace
│   ├── configmap-frontend.yaml         # Frontend environment config
│   ├── configmap-backend.yaml          # Backend environment config
│   ├── deployment-frontend.yaml        # React frontend deployment
│   ├── deployment-backend.yaml         # Stirling PDF backend deployment
│   ├── service-frontend.yaml           # Frontend Kubernetes service
│   └── service-backend.yaml            # Backend Kubernetes service
├── modules/
│   ├── acr/                            # Azure Container Registry
│   ├── aks/                            # AKS cluster (Cilium, autoscaler, encryption)
│   ├── key_vault/                      # Key Vault + secret rotation
│   ├── monitoring/                     # Log Analytics + OMS Agent
│   ├── networking/                     # VNet, subnets (10.10.0.0/16)
│   └── resource_group/                 # Azure Resource Group
├── main.tf                             # Root module
├── variables.tf                        # Input variables
├── outputs.tf                          # Output values
├── backend.tf                          # Remote state (Azure Storage)
├── versions.tf                         # Provider constraints (azurerm ~4.60.0)
└── .terraform.lock.hcl                 # Provider lock file
```

---

## ⚙️ Configuration

| Variable | Default | Description |
|---|---|---|
| `resource_group_name` | — | Azure Resource Group name |
| `location` | — | Azure region (e.g. `westeurope`) |
| `environment` | — | Environment tag (`dev`, `test`, `prod`) |
| `vnet_cidr` | `10.10.0.0/16` | Virtual Network CIDR |
| `vm_size` | `Standard_D2s_v3` | AKS node VM size |
| `service_cidr` | `10.0.2.0/24` | Kubernetes services CIDR |
| `dns_service_ip` | `10.0.2.10` | Kubernetes DNS service IP |
| `allowed_ips` | `[]` | IPs allowed through Key Vault ACL |

---

## 🔑 Required GitHub Actions Secrets

Before the CI/CD pipelines can run, configure these secrets under
**Settings → Secrets and variables → Actions**:

| Secret | Description |
|---|---|
| `ARM_CLIENT_ID` | Azure Service Principal App ID |
| `ARM_CLIENT_SECRET` | Azure Service Principal password |
| `ARM_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `ARM_TENANT_ID` | Your Azure Tenant ID |

---

## 🔁 CI/CD Pipelines

| Workflow | Trigger | Description |
|---|---|---|
| `Terraform-Plan-Apply.yml` | Push to `main` | Plans and applies all infrastructure |
| `Terraform-Destroy-All.yml` | Manual dispatch | Destroys all Azure resources |

---

## 📋 Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) — logged in via `az login`
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- An active **Azure subscription**
- GitHub repository secrets configured for CI/CD

---

## 🚀 Deployment

### 1️⃣ Clone the repository
```bash
git clone https://github.com/Matayush/stirling-pdf-aks.git
cd stirling-pdf-aks
```

### 2️⃣ Provision infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 3️⃣ Connect kubectl to AKS
```bash
az aks get-credentials --resource-group <resource-group-name> --name aks-<environment>
```

### 4️⃣ Deploy the application
```bash
kubectl apply -f k8s/
```

### 5️⃣ Verify deployment
```bash
kubectl get pods -A
kubectl get svc -A
```

---

## 🧹 Cleanup

Run locally:
```bash
terraform destroy
```
Or trigger **Terraform-Destroy-All** manually from the GitHub Actions tab.

---

## 📸 Screenshots

> *(Coming soon — Stirling PDF running on AKS)*

---

## 👤 Author

**Mateusz Ceniuk** — Cloud & Infrastructure Engineer based in Kraków 🇵🇱

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mateuszceniuk/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/Matayush)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat&logo=gmail&logoColor=white)](mailto:ceniuk.mateusz@gmail.com)

---

> 💡 *This project is part of my personal cloud engineering portfolio.
> Feel free to fork it, use it, or reach out if you have any questions!*
