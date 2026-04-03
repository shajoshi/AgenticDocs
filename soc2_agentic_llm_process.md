# Minimalistic SOC 2 Process for Azure-Hosted Agentic LLM Solutions

> A lean, actionable process to achieve SOC 2 Type II certification for an organization selling an Azure cloud-hosted Agentic AI/LLM product to enterprise clients.

---

## What is SOC 2?

SOC 2 (System and Organization Controls 2) is an audit framework by the AICPA that evaluates an organization's controls across **5 Trust Service Criteria (TSC)**. For selling to enterprises, **SOC 2 Type II** is the standard expectation — it covers the **design AND operating effectiveness** of controls over a 3–12 month observation period.

### Which Trust Service Criteria Apply?

| TSC | Required? | Why It Matters for Agentic LLM |
|-----|:---------:|-------------------------------|
| **Security** (Common Criteria) | **Always** | Core requirement — access control, encryption, incident response |
| **Availability** | **Yes** | Enterprises need SLA commitments for AI services |
| **Confidentiality** | **Yes** | LLM processes sensitive enterprise data (contracts, ERP data, PII) |
| **Processing Integrity** | **Recommended** | LLM outputs must be accurate and complete; hallucination risk |
| **Privacy** | **If PII involved** | Required if processing personal data (GDPR/HIPAA overlap) |

**Minimum for most enterprise sales: Security + Availability + Confidentiality**

---

## Phase 1: Readiness (Weeks 1–4)

### 1.1 Define Scope

Clearly define what is "in scope" for the audit:

| In Scope | Example |
|----------|---------|
| **Product** | The Agentic LLM platform (APIs, agent orchestration, RAG pipeline) |
| **Infrastructure** | Azure subscription(s) hosting the solution |
| **Data stores** | Azure Cosmos DB, Azure AI Search, Redis, blob storage |
| **LLM providers** | Azure OpenAI Service (or any external LLM API) |
| **People** | Engineering, DevOps, support teams with access to production |
| **Processes** | CI/CD, incident response, access provisioning, change management |

> **Tip:** Keep scope tight. Only include what touches customer data. Exclude dev/staging environments if possible.

### 1.2 Gap Assessment

Compare current state against SOC 2 controls. Use a lightweight checklist:

- [ ] Do we have documented security policies?
- [ ] Is MFA enforced for all production access?
- [ ] Is data encrypted at rest and in transit?
- [ ] Do we have an incident response plan?
- [ ] Do we have change management for code deployments?
- [ ] Do we have access reviews / offboarding procedures?
- [ ] Do we log and monitor access to customer data?
- [ ] Do we have a vendor management process (for Azure, OpenAI, etc.)?

### 1.3 Choose an Auditor

| Auditor Tier | Examples | Approx. Cost |
|-------------|----------|-------------|
| **Startup-friendly** | Prescient Assurance, Johanson Group, Sensiba | $20,000 – $50,000 |
| **Mid-market** | Coalfire, A-LIGN, Schellman | $40,000 – $80,000 |
| **Big 4** | Deloitte, EY, PwC, KPMG | $100,000+ |

> For a startup/scale-up selling an Agentic LLM product, a **startup-friendly auditor** is sufficient and accepted by most enterprise buyers.

### 1.4 Choose a Compliance Automation Platform

These tools automate 60–80% of evidence collection and dramatically reduce manual effort:

| Platform | Approx. Cost (USD/year) | Notes |
|----------|------------------------|-------|
| **Vanta** | $10,000 – $30,000 | Market leader; deep Azure integration |
| **Drata** | $10,000 – $25,000 | Strong automation, good UI |
| **Secureframe** | $10,000 – $20,000 | Developer-friendly, fast onboarding |
| **Sprinto** | $5,000 – $15,000 | Cost-effective, good for startups |
| **Tugboat Logic (OneTrust)** | $15,000 – $30,000 | Acquired by OneTrust; broader GRC |

> **Strongly recommended.** Without automation, SOC 2 prep takes 3–6x longer and requires significant manual evidence gathering.

---

## Phase 2: Implement Controls (Weeks 3–10)

### 2.1 Security Policies (Document These — Minimally)

You need **written policies**. Keep them short (2–5 pages each). Minimum set:

| # | Policy | What It Covers |
|---|--------|---------------|
| 1 | **Information Security Policy** | Overall security posture, roles, responsibilities |
| 2 | **Access Control Policy** | Who gets access, how, MFA, least privilege, offboarding |
| 3 | **Change Management Policy** | Code review, PR approvals, CI/CD pipeline, rollback |
| 4 | **Incident Response Plan** | Detection, triage, containment, communication, post-mortem |
| 5 | **Data Classification & Handling** | How customer data / PII is classified, encrypted, retained, deleted |
| 6 | **Vendor Management Policy** | How third-party risk is assessed (Azure, OpenAI, etc.) |
| 7 | **Acceptable Use Policy** | Employee/contractor obligations |
| 8 | **Business Continuity / DR Plan** | RPO, RTO, backup strategy, failover |

> **AI-specific addition:** Include a section in your Data Handling policy on how data flows through the LLM pipeline — what is sent to Azure OpenAI, what is logged, what is redacted.

### 2.2 Technical Controls (Azure-Specific)

| Control | Azure Implementation | Priority |
|---------|---------------------|:--------:|
| **MFA everywhere** | Azure AD / Entra ID with Conditional Access | P0 |
| **SSO** | Azure AD SSO for all internal tools | P0 |
| **Encryption at rest** | Azure Storage Service Encryption (SSE), Cosmos DB encryption (default on) | P0 |
| **Encryption in transit** | TLS 1.2+ enforced on all endpoints | P0 |
| **Network isolation** | Azure VNet, Private Endpoints for Cosmos DB / AI Search / Redis | P0 |
| **Key management** | Azure Key Vault for secrets, API keys, connection strings | P0 |
| **Logging & monitoring** | Azure Monitor, Log Analytics, Microsoft Defender for Cloud | P0 |
| **Access reviews** | Quarterly review of Azure RBAC assignments | P1 |
| **Vulnerability scanning** | Microsoft Defender for Cloud + static code scanning (SonarQube/Snyk) | P1 |
| **Backup & recovery** | Azure Backup, Cosmos DB point-in-time restore, geo-redundancy | P1 |
| **WAF / DDoS** | Azure Front Door with WAF, Azure DDoS Protection | P1 |
| **Container security** | Azure Container Registry scanning, Trivy in CI/CD | P2 |

### 2.3 LLM-Specific Controls (Agentic AI Additions)

These are **not standard SOC 2 controls** but are expected by enterprise buyers evaluating an AI product:

| Control | Implementation |
|---------|---------------|
| **PII redaction before LLM** | Presidio / Protegrity / custom redaction in the pipeline |
| **No customer data in LLM training** | Use Azure OpenAI (data not used for training by default); document this |
| **Prompt injection defense** | Input sanitization, guardrail models, output validation |
| **LLM output logging** | Log all agent actions, tool calls, and LLM responses (PII-redacted) |
| **Human-in-the-loop for write actions** | Agent proposes → human approves for any ERP/CLM mutations |
| **Model versioning** | Track which model version produced which output |
| **Rate limiting** | Prevent runaway agent loops; cap LLM calls per session/user |
| **Data residency** | Configure Azure OpenAI region to match customer requirements |

### 2.4 Operational Controls

| Control | What to Do |
|---------|-----------|
| **Background checks** | Run for all employees with production access |
| **Security awareness training** | Annual; use a platform like KnowBe4 or Curricula |
| **Onboarding / offboarding checklist** | Documented, with access provisioned/revoked within 24 hours |
| **Quarterly access reviews** | Review who has access to Azure, databases, LLM APIs |
| **Change management** | All code changes via PR with at least 1 reviewer; CI/CD enforced |
| **Pen testing** | Annual third-party penetration test |

---

## Phase 3: Observation Period (Months 3–9)

SOC 2 Type II requires controls to be **operating effectively over a period** (minimum 3 months, typically 6–12 months).

### What Happens During This Period

- Compliance automation platform continuously collects evidence (Azure configs, access logs, PR approvals, etc.)
- You operate normally, following the policies you documented
- Any incidents are handled per your Incident Response Plan and documented
- Access reviews happen on schedule
- Changes go through the defined change management process

### Common Pitfalls

| Pitfall | How to Avoid |
|---------|-------------|
| MFA not enforced for a service account | Audit all accounts on Day 1; use managed identities where possible |
| Missing PR approvals | Enforce branch protection rules in GitHub/Azure DevOps |
| No evidence of access reviews | Schedule calendar reminders; use Vanta/Drata auto-reminders |
| Incident not documented | Even small incidents — document them |
| Vendor risk not assessed | Complete a vendor assessment for Azure and any LLM API provider |

---

## Phase 4: Audit (Weeks 1–4 After Observation)

### What the Auditor Does

1. **Reviews policies and procedures** — Are they documented and reasonable?
2. **Tests controls** — Samples evidence (e.g., 25 random PRs had approvals, 10 random employees had background checks)
3. **Reviews exceptions** — Any control failures during the observation period? Were they remediated?
4. **Issues the report** — SOC 2 Type II report (typically 40–80 pages)

### What You Need to Provide

| Evidence Type | Examples |
|--------------|---------|
| **Access control** | Azure AD user list, RBAC assignments, MFA status, offboarding tickets |
| **Change management** | GitHub/ADO PR history with approvals, deployment logs |
| **Monitoring** | Azure Monitor alerts, Defender for Cloud findings, incident tickets |
| **Encryption** | Azure resource configs showing encryption at rest/in transit |
| **Vendor management** | Azure and OpenAI DPA/BAA, vendor risk assessments |
| **Training** | Security awareness training completion records |
| **Background checks** | Confirmation records (from HR/vendor) |

> With a compliance automation platform, **80%+ of this evidence is auto-collected**.

---

## Timeline Summary

| Phase | Duration | Key Activities |
|-------|----------|---------------|
| **Readiness** | Weeks 1–4 | Scope, gap assessment, choose auditor + platform |
| **Implement** | Weeks 3–10 | Policies, technical controls, LLM-specific controls |
| **Observe** | Months 3–9 | Operate controls, collect evidence, fix gaps |
| **Audit** | Weeks 1–4 | Auditor reviews, report issued |
| **Total** | **~6–12 months** | First-time certification |

### Accelerated Path (3–6 Months)

If you already have decent security hygiene:
- Use a compliance automation platform from Day 1
- Start with a 3-month observation window (minimum allowed)
- Run readiness and implementation in parallel
- Choose a startup-friendly auditor with fast turnaround

---

## Budget Estimate (First Year)

| Item | Low Estimate | High Estimate |
|------|-------------|--------------|
| Compliance platform (Vanta/Drata/Sprinto) | $5,000 | $30,000 |
| Auditor (Type II) | $20,000 | $80,000 |
| Pen test (third-party) | $5,000 | $25,000 |
| Security training platform | $1,000 | $5,000 |
| Azure security tooling (Defender, WAF, etc.) | $5,000 | $20,000 |
| Staff time (opportunity cost) | $15,000 | $50,000 |
| **Total** | **~$50,000** | **~$210,000** |

> Renewal years are significantly cheaper (~40–60% of Year 1) as policies exist and controls are already operating.

---

## Enterprise Buyer FAQ (What They Will Ask)

| Question | Expected Answer |
|----------|----------------|
| "Do you have SOC 2 Type II?" | "Yes, report available under NDA" |
| "Does the LLM train on our data?" | "No — we use Azure OpenAI which does not use customer data for training" |
| "Where is our data stored?" | "Azure [region]. Data does not leave [region]" |
| "Is PII sent to the LLM?" | "PII is redacted/tokenized before reaching the LLM" |
| "Do you have a DPA?" | "Yes, available for review" |
| "What happens if we want data deleted?" | "We support data deletion requests within [X] days per our retention policy" |
| "Do you do pen testing?" | "Annually, by a third-party firm. Summary available under NDA" |
| "Is there human oversight on AI actions?" | "Yes — all mutative actions require human approval" |

---

*This is a minimalistic process. Enterprises in regulated industries (healthcare, finance) may additionally require HIPAA BAA, ISO 27001, or FedRAMP depending on sector.*
