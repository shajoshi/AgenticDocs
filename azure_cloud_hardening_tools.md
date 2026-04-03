# Azure Cloud Hardening Tools for Agentic LLM Deployments

> Tools to harden Azure cloud environments hosting Agentic AI/LLM solutions, with a focus on the level of automated feedback they provide for network and application security configuration.

---

## Tool Categories

| Category | What It Does | Examples |
|----------|-------------|---------|
| **CSPM** (Cloud Security Posture Management) | Continuously scans cloud config for misconfigurations | Defender for Cloud, Wiz, Prisma Cloud |
| **CNAPP** (Cloud-Native Application Protection) | CSPM + workload protection + container security combined | Wiz, Prisma Cloud, Lacework |
| **CWP** (Cloud Workload Protection) | Runtime protection for VMs, containers, serverless | Defender for Servers, Aqua, Sysdig |
| **CIEM** (Cloud Infrastructure Entitlement Management) | Identity & permission analysis — who has access to what | Entra Permissions Management, Ermetic |
| **IaC Scanning** | Scans Terraform/Bicep/ARM templates before deployment | Checkov, tfsec, Trivy |
| **KSPM** (Kubernetes Security Posture) | Kubernetes-specific misconfiguration and runtime scanning | Defender for Containers, Aqua, Sysdig |
| **Network Security** | Network segmentation, firewall rules, traffic analysis | Azure Firewall, NSG flow logs, Azure Network Watcher |

---

## 1. Microsoft Defender for Cloud (Native Azure)

### What It Does
Azure's built-in CSPM + CWP platform. Continuously assesses your Azure environment against security benchmarks and provides a **Secure Score** with actionable recommendations.

### Automated Feedback Level: ★★★★★ (Highest)

| Feedback Type | What You Get |
|--------------|-------------|
| **Secure Score** | Single 0–100% score across your entire Azure subscription; updates in real-time |
| **Recommendation engine** | Specific, prioritized recommendations (e.g., "Enable encryption on Cosmos DB", "Restrict public access to Azure OpenAI endpoint") |
| **Regulatory compliance dashboard** | Map your config against SOC 2, ISO 27001, CIS Benchmarks, NIST 800-53, PCI-DSS — with pass/fail per control |
| **Attack path analysis** | Visual graph of how an attacker could chain misconfigurations to reach sensitive resources |
| **Auto-remediation** | One-click or fully automated fix for many findings (e.g., "Enable HTTPS-only on App Service") |
| **Alerts** | Real-time alerts for suspicious activity (unusual Azure OpenAI calls, brute force on VMs, etc.) |
| **Container scanning** | Vulnerability scanning for ACR images, runtime threat detection for AKS |
| **API security** | Detects unprotected APIs, anomalous API traffic patterns |

### Pricing

| Tier | Cost | Notes |
|------|------|-------|
| Free (Foundational CSPM) | $0 | Secure score, basic recommendations |
| Defender CSPM | ~$5/server/month | Attack path analysis, agentless scanning, governance |
| Defender for Servers P2 | ~$15/server/month | Full CWP, vulnerability scanning, EDR |
| Defender for Containers | ~$7/vCore/month | AKS protection, image scanning |
| Defender for Key Vault | ~$0.02/10K transactions | Anomalous Key Vault access detection |
| Defender for Azure OpenAI | Included in Defender CSPM | Prompt injection detection, usage anomalies |

### Relevance to Agentic LLM
- Monitors Azure OpenAI endpoint configuration (network access, key rotation)
- Detects overprivileged managed identities accessing Cosmos DB / AI Search
- Flags publicly accessible blob containers (document storage for RAG)
- Tracks Key Vault access anomalies (LLM API key misuse)

---

## 2. Wiz

### What It Does
Agentless CNAPP that scans your entire Azure environment (VMs, containers, serverless, data stores, IAM) in minutes via Azure Resource Manager API access — no agents to install. Builds a unified security graph of all resources and their relationships.

### Automated Feedback Level: ★★★★★

| Feedback Type | What You Get |
|--------------|-------------|
| **Risk graph** | Visual graph showing every resource, its config, vulnerabilities, exposed secrets, and connections |
| **Toxic combinations** | Identifies chains of risk (e.g., public-facing App Service → overprivileged managed identity → Cosmos DB with customer data) |
| **CSPM dashboard** | Pass/fail against CIS Azure Benchmark, SOC 2, NIST, PCI-DSS |
| **Vulnerability scanning** | Agentless OS and package scanning across VMs, containers, serverless |
| **Secret scanning** | Detects hardcoded secrets in running workloads and IaC |
| **Data scanning** | Identifies sensitive data (PII, financial) in blob storage, databases |
| **IaC scanning** | Scans Terraform/Bicep in CI/CD before deployment |
| **Container security** | Full AKS/ACR scanning with SBOM |

### Pricing

| Tier | Approx. Cost (USD/year) |
|------|------------------------|
| Startup program | Free for qualifying startups |
| Standard | ~$30,000 – $80,000 (based on cloud spend / workload count) |
| Enterprise | ~$80,000 – $300,000+ |

### Known Customers
BMW, Morgan Stanley, Salesforce, Slack, Mars, DocuSign, Priceline, Snowflake

---

## 3. Prisma Cloud (Palo Alto Networks)

### What It Does
Full CNAPP: CSPM + CWP + CIEM + IaC scanning + API security. Monitors Azure environments for misconfigurations, vulnerabilities, and compliance violations with broad policy coverage.

### Automated Feedback Level: ★★★★☆

| Feedback Type | What You Get |
|--------------|-------------|
| **Compliance posture** | Continuous compliance against 30+ frameworks (SOC 2, HIPAA, GDPR, CIS, NIST) |
| **Asset inventory** | Full inventory of Azure resources with security posture per resource |
| **Runtime protection** | Agent-based workload protection for VMs and containers |
| **IaC scanning** | Integrated Checkov (open-source) for Terraform/Bicep |
| **Network visualization** | Actual network flows between resources mapped and analyzed |
| **IAM analysis** | Overprivileged identities, unused permissions, cross-account access |
| **Auto-remediation** | Policy-based auto-fix for common misconfigurations |

### Pricing

| Tier | Approx. Cost (USD/year) |
|------|------------------------|
| Standard | ~$30,000 – $100,000 |
| Enterprise | ~$100,000 – $250,000+ |

### Known Customers
Royal Bank of Canada, Westpac, Autodesk, Zillow, ExtraHop

---

## 4. Aqua Security

### What It Does
Cloud-native security focused on containers, Kubernetes, serverless, and supply chain. Strong for organizations running Agentic LLM workloads on AKS (Azure Kubernetes Service).

### Automated Feedback Level: ★★★★☆

| Feedback Type | What You Get |
|--------------|-------------|
| **Container scanning** | Vulnerability + malware scanning for container images (ACR) |
| **Kubernetes posture** | CIS Kubernetes Benchmark compliance, RBAC analysis |
| **Runtime protection** | Behavioral monitoring — detects anomalous container activity |
| **Supply chain security** | SBOM generation, code-to-cloud artifact tracing |
| **DTA (Dynamic Threat Analysis)** | Sandbox analysis of container images for hidden threats |
| **Trivy integration** | Aqua maintains Trivy (open-source), enterprise version adds management layer |

### Pricing

| Tier | Approx. Cost (USD/year) |
|------|------------------------|
| Trivy (OSS) | Free |
| Aqua Platform | ~$30,000 – $100,000+ |

### Known Customers
PayPal, Citibank, Intuit, Samsung, Deutsche Bank

---

## 5. Microsoft Entra Permissions Management (formerly CloudKnox)

### What It Does
CIEM tool that discovers, monitors, and right-sizes permissions across Azure (and AWS/GCP). Critical for Agentic LLM deployments where managed identities and service principals may be overprivileged.

### Automated Feedback Level: ★★★★☆

| Feedback Type | What You Get |
|--------------|-------------|
| **Permission Creep Index (PCI)** | Score per identity showing gap between granted vs. used permissions |
| **Unused permission detection** | Identifies permissions granted but never exercised (e.g., managed identity with Cosmos DB write but only reads used) |
| **Just-in-time access** | Enables on-demand elevation instead of standing permissions |
| **Multi-cloud visibility** | Single view across Azure, AWS, GCP |
| **Activity alerts** | Alerts on anomalous permission usage patterns |

### Pricing
~$10.40/resource/month (Azure billable resources)

### Relevance to Agentic LLM
- Detects if your agent's managed identity has unnecessary write access to Key Vault, Cosmos DB, or blob storage
- Flags service principals with subscription-level Contributor/Owner roles
- Enables least-privilege enforcement for LLM orchestration services

---

## 6. Checkov / tfsec / Trivy (IaC Scanning)

### What They Do
Scan Infrastructure-as-Code (Terraform, Bicep, ARM templates, CloudFormation) **before deployment** to catch misconfigurations at the PR/CI stage — "shift-left" for cloud security.

### Automated Feedback Level: ★★★★☆ (Pre-deployment)

| Tool | Checks | Azure-Specific |
|------|--------|---------------|
| **Checkov** (Prisma/Bridgecrew) | 2,500+ built-in policies; Terraform, Bicep, ARM, Helm, Dockerfile | Azure CIS Benchmark, Azure-specific rules |
| **tfsec** (Aqua) | Terraform-focused; fast, low false positives | Azure provider rules (NSG, Key Vault, storage) |
| **Trivy** (Aqua) | IaC + container + SCA combined | Terraform, Bicep, Helm for Azure |

### Pricing
**All free and open-source**

### Sample CI/CD Feedback

```
FAILED: azurerm_storage_account.rag_docs
  - Check: Ensure storage account uses HTTPS only ❌
  - Check: Ensure storage account default network access is denied ❌
  - Check: Ensure storage account has encryption enabled ✅

FAILED: azurerm_cosmosdb_account.agent_memory
  - Check: Ensure Cosmos DB has network service endpoint ❌
  - Check: Ensure Cosmos DB disables public network access ❌

PASSED: azurerm_key_vault.llm_keys
  - Check: Ensure Key Vault has purge protection enabled ✅
  - Check: Ensure Key Vault uses RBAC authorization ✅
```

---

## 7. Azure Network Watcher + NSG Flow Logs

### What It Does
Native Azure network diagnostic and monitoring tool. Captures and analyzes network traffic flows, validates NSG rules, and detects connectivity issues.

### Automated Feedback Level: ★★★☆☆ (Diagnostic, not prescriptive)

| Feature | What You Get |
|---------|-------------|
| **NSG flow logs** | Full record of allowed/denied traffic; send to Log Analytics for analysis |
| **Traffic analytics** | Visualization of traffic patterns, hot spots, and anomalies |
| **Connection monitor** | Continuous connectivity checks between resources (e.g., App Service ↔ Cosmos DB) |
| **IP flow verify** | Test if a specific packet would be allowed/denied by NSG rules |
| **Next hop** | Trace routing for a packet from source to destination |
| **Packet capture** | Capture packets on VMs for deep inspection |

### Pricing
- NSG flow logs: ~$0.50/GB logged
- Traffic analytics: ~$2.60/GB processed
- Network Watcher: Free (most features); per-use charges for captures

---

## 8. Azure Policy + Azure Blueprints

### What It Does
Governance-as-code. Define and enforce organizational rules at the Azure subscription or management group level. Prevents non-compliant resources from being created in the first place.

### Automated Feedback Level: ★★★★★ (Preventive + Detective)

| Capability | What You Get |
|-----------|-------------|
| **Deny policies** | Block creation of non-compliant resources (e.g., "Deny storage accounts without HTTPS") |
| **Audit policies** | Flag existing non-compliant resources without blocking |
| **Remediation tasks** | Auto-remediate existing resources to bring them into compliance |
| **Compliance dashboard** | Per-policy pass/fail across all subscriptions |
| **Built-in initiatives** | Pre-built policy sets: CIS Azure Benchmark, SOC 2 TSC, NIST 800-53, Azure Security Benchmark |
| **Custom policies** | Write custom policies for LLM-specific requirements (e.g., "All Azure OpenAI endpoints must use private endpoints") |

### Pricing
**Free** (included with Azure subscription)

### Example Policies for Agentic LLM

```json
// Deny Azure OpenAI without private endpoint
{
  "if": {
    "allOf": [
      { "field": "type", "equals": "Microsoft.CognitiveServices/accounts" },
      { "field": "Microsoft.CognitiveServices/accounts/publicNetworkAccess", "notEquals": "Disabled" }
    ]
  },
  "then": { "effect": "Deny" }
}
```

---

## Comparison: Automated Feedback Levels

| Tool | Category | Feedback Type | Automation Level | Cost |
|------|----------|-------------|:---:|------|
| **Defender for Cloud** | CSPM + CWP | Secure score, recommendations, auto-fix, compliance dashboards | ★★★★★ | Free – $15/server/mo |
| **Wiz** | CNAPP | Risk graph, toxic combos, data scanning, compliance | ★★★★★ | $30K – $300K/yr |
| **Prisma Cloud** | CNAPP | Compliance, runtime, network viz, IAM analysis | ★★★★☆ | $30K – $250K/yr |
| **Aqua Security** | Container/K8s | Image scanning, runtime, SBOM, behavioral | ★★★★☆ | Free (Trivy) – $100K/yr |
| **Entra Permissions Mgmt** | CIEM | Permission creep index, unused permissions, JIT | ★★★★☆ | $10.40/resource/mo |
| **Checkov / tfsec / Trivy** | IaC Scanning | Pass/fail per resource in CI/CD, CIS checks | ★★★★☆ | Free |
| **Azure Network Watcher** | Network | Traffic flows, connectivity, packet capture | ★★★☆☆ | ~$0.50–$2.60/GB |
| **Azure Policy** | Governance | Deny/audit/remediate non-compliant resources | ★★★★★ | Free |

---

## Recommended Stack for Agentic LLM on Azure

### Minimum (Budget-Conscious)

| Layer | Tool | Cost |
|-------|------|------|
| CSPM | **Defender for Cloud** (Free + CSPM tier) | $0 – $5/server/mo |
| Governance | **Azure Policy** (CIS + custom LLM policies) | Free |
| IaC scanning | **Checkov** or **Trivy** in CI/CD | Free |
| Network | **NSG Flow Logs** + Traffic Analytics | ~$50–$200/mo |
| Identity | **Entra ID** Conditional Access + Access Reviews | Included in Azure AD P2 |
| Secrets | **Key Vault** + Defender for Key Vault | ~$0.02/10K ops |

**Total: ~$500 – $2,000/month**

### Recommended (Mid-Size / Enterprise Sales)

| Layer | Tool | Cost |
|-------|------|------|
| CSPM + CWP | **Defender for Cloud** (Full Defender plans) | ~$2,000 – $5,000/mo |
| CNAPP (optional) | **Wiz** or **Prisma Cloud** | $30K – $80K/yr |
| Governance | **Azure Policy** + **Blueprints** | Free |
| Identity | **Entra Permissions Management** | $10.40/resource/mo |
| IaC | **Checkov** in CI/CD | Free |
| Container | **Defender for Containers** + **Trivy** | ~$500 – $2,000/mo |
| Network | **Azure Firewall** + **Network Watcher** | ~$1,000 – $3,000/mo |

**Total: ~$5,000 – $15,000/month (or $60K – $180K/year)**

---

## What Level of Automated Feedback Can You Expect?

| Question | Answer |
|----------|--------|
| "Will it tell me what's wrong?" | **Yes** — All tools above provide specific findings with severity levels |
| "Will it tell me how to fix it?" | **Yes** — Defender, Wiz, Prisma provide step-by-step remediation guidance |
| "Will it fix things automatically?" | **Partially** — Defender and Azure Policy can auto-remediate many misconfigurations; others require manual action |
| "Will it prevent bad deployments?" | **Yes** — Azure Policy (Deny effect) + Checkov in CI/CD block non-compliant resources before they exist |
| "Will it map to compliance frameworks?" | **Yes** — Defender, Wiz, Prisma map findings to SOC 2, ISO 27001, CIS, NIST, HIPAA, PCI-DSS |
| "Will it monitor continuously?" | **Yes** — Defender and Wiz scan continuously (minutes to hours between scans); IaC tools scan per-commit |
| "Will it detect runtime attacks?" | **Yes** — Defender CWP, Aqua, and Prisma detect runtime anomalies (process execution, network connections, file changes) |
| "Will it cover AI-specific risks?" | **Partially** — Defender for Azure OpenAI covers some; for prompt injection and agent-level risks, you still need application-layer guardrails (NeMo Guardrails, Llama Guard) |

---

*Azure pricing reflects pay-as-you-go rates as of early 2026. Actual costs vary by resource count, region, and negotiated enterprise agreements.*
