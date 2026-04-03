# Agentic AI Security Requirements for Enterprise ERP & CLM

> Security requirements demanded by enterprises when deploying Agentic AI solutions in ERP (SAP, Oracle, Workday) and CLM (Icertis, DocuSign CLM, Ironclad) use cases.

---

## 1. PII & Sensitive Data Protection

The **#1 concern** in both ERP and CLM contexts.

- **Pre-LLM PII redaction/tokenization** — Contracts contain names, addresses, SSNs, financial terms. ERP data contains employee records, salary, vendor bank details. None of this should reach an external LLM in plaintext.
- **Field-level protection** — Tools like Protegrity, Microsoft Presidio, or Private AI tokenize individual fields (e.g., employee ID, contract value) before they enter the LLM pipeline. The response is then de-tokenized before returning to the user.
- **No document persistence** — LLM providers must not store, log, or train on enterprise data. Enforced via Data Processing Agreements (DPAs) and zero-data-retention API tiers (e.g., OpenAI Enterprise, Azure OpenAI).

### Tools & Standards

| Tool | Type | Notes |
|------|------|-------|
| **Protegrity** | Enterprise | Field-level tokenization, format-preserving encryption |
| **Microsoft Presidio** | Open-source | PII detection & anonymization |
| **Private AI** | SaaS | PII redaction API purpose-built for LLM pipelines |
| **Nightfall AI** | SaaS | DLP for cloud/SaaS — detects and redacts PII |
| **Skyflow** | SaaS | Data privacy vault with API-first design |

---

## 2. Encryption

- **In-transit** — All data exchanged between the Agentic AI system and external services (SaaS ERP, CLM, LLM APIs) must be encrypted via **TLS 1.2+**.
- **At-rest** — Any cached context, embeddings, or memory store (Redis, vector DB) must be encrypted at rest using **AES-256** or equivalent.
- **End-to-end** — For high-sensitivity CLM use cases (M&A contracts, NDAs), enterprises often require E2E encryption where even the orchestration layer cannot see plaintext.

---

## 3. Regulatory Compliance

| Regulation | ERP Relevance | CLM Relevance |
|------------|--------------|---------------|
| **GDPR** | Employee/vendor PII in EU | Counterparty PII, data subject rights in contracts |
| **HIPAA** | Healthcare employee/benefits data | Healthcare service agreements |
| **SOX** | Financial data integrity, audit trails | Revenue-impacting contract terms |
| **SOC 2 Type II** | Required for any SaaS touching ERP data | Required for CLM SaaS vendors |
| **CCPA** | California employee/consumer data | Consumer-facing contract data |
| **DORA** (EU) | Financial services ERP systems | Financial services agreements |

Enterprises will demand **proof of compliance** (audit reports, certifications) for every component in the AI stack — including the LLM provider, vector DB, memory store, and observability tools.

---

## 4. Access Control & Authorization

- **Role-based access (RBAC)** — An AI agent processing purchase orders should only access data the invoking user is authorized to see. Critical in ERP where separation of duties is mandated.
- **No impersonation** — Agents should **not** take actions on behalf of users via broad API tokens. Use scoped, short-lived tokens tied to the authenticated user's permissions.
- **Principle of least privilege** — The agent should have the minimum API permissions needed. A contract summarization agent should have read-only CLM access, never write/approve access.
- **SSO/SAML integration** — Enterprise identity (Okta, Azure AD) must flow through to the AI layer.

---

## 5. Audit Trail & Observability

Enterprises (especially under SOX, DORA, and regulated industries) require:

- **Full trace logging** — Every LLM call, tool invocation, retrieval, and decision the agent makes must be logged with timestamps, user context, and input/output payloads (with PII redacted in logs).
- **Non-repudiation** — If an agent modifies a contract clause or approves a PO, there must be an immutable record of who initiated it, what the agent did, and what the LLM returned.
- **SIEM integration** — Tools like Langfuse provide nested tracing, cost tracking, and evaluation, but enterprises often also require integration with their existing SIEM (Splunk, Sentinel) for centralized security monitoring.

### Tools

| Tool | Type | Notes |
|------|------|-------|
| **Langfuse** | Open-source | Nested tracing, cost tracking, LLM evaluation |
| **LangSmith** | SaaS | LangChain-native observability |
| **Helicone** | SaaS | Lightweight LLM observability proxy |
| **Arize Phoenix** | Open-source | MLOps-focused LLM monitoring |
| **Splunk / Sentinel** | Enterprise SIEM | Centralized security event monitoring |

---

## 6. Prompt Injection & Adversarial Input Defense

### Threat Matrix

| Threat | ERP Example | CLM Example |
|--------|-------------|-------------|
| **Prompt injection** | Malicious vendor invoice with hidden instructions | Contract PDF with embedded adversarial text |
| **Jailbreaking** | User tricks agent into revealing salary data | User extracts confidential contract terms |
| **Misuse / off-topic** | Employee asks agent to suggest movies | User asks contract agent non-work questions |
| **Data exfiltration** | Agent tricked into dumping employee records | Agent leaks counterparty negotiation positions |

### Mitigations

- **Input sanitization and prompt hardening** — System prompts that resist injection
- **Guardrail models** — Llama Guard, NVIDIA NeMo Guardrails
- **Output validation** — Never return raw LLM output without checking against allowlists
- **Follow OWASP Top 10 for LLM Applications**

### OWASP LLM Top 10 (Key Items)

| # | Risk | Relevance |
|---|------|-----------|
| LLM01 | Prompt Injection | Direct & indirect injection via documents |
| LLM02 | Insecure Output Handling | Agent output used in downstream systems |
| LLM06 | Sensitive Information Disclosure | PII/confidential data leakage |
| LLM07 | Insecure Plugin Design | MCP server / tool call vulnerabilities |
| LLM08 | Excessive Agency | Agent taking unauthorized actions in ERP/CLM |

### Competing / Complementary Security Frameworks

| Framework | Notes |
|-----------|-------|
| **OWASP Top 10 for LLM** | Community-maintained, vendor-neutral |
| **NIST AI RMF** | US government AI risk management framework |
| **ISO/IEC 42001** | International AI management system standard |
| **Microsoft RAI** | Responsible AI guidelines |
| **Google SAIF** | Secure AI Framework |

---

## 7. Data Residency & Sovereignty

- Many enterprises require LLM inference to happen **within a specific geographic region** (EU data stays in EU).
- This rules out vanilla OpenAI API for some use cases and pushes toward:
  - **Azure OpenAI** (with region selection)
  - **AWS Bedrock** (regional deployment)
  - **On-prem / self-hosted models** (Ollama, vLLM)
- Vector stores, memory layers (Redis), and logs must also comply with residency requirements.

---

## 8. Agent Action Safety (Write Operations)

Critical for ERP and CLM where the agent could:

| System | Dangerous Actions |
|--------|------------------|
| **ERP** | Create a purchase order, approve an invoice, modify a vendor record |
| **CLM** | Redline a clause, send a contract for signature, accept terms |

### Requirements

- **Human-in-the-loop** for all write/mutative actions — the agent proposes, a human confirms
- **Dry-run mode** — Agent shows what it *would* do before executing
- **Rollback capability** — Actions taken by the agent must be reversible
- **Rate limiting** — Prevent runaway agents from bulk-modifying records
- **MCP Server caution** — MCP is acceptable for read-only use cases; for write operations, build direct API integrations with explicit user-scoped auth context passed through

---

## 9. Model & Supply Chain Security

- **Model provenance** — Enterprises want to know which model version is being used and that it hasn't been tampered with.
- **Dependency scanning** — LLM frameworks (LangChain, Vercel AI SDK) and their transitive dependencies must be scanned for vulnerabilities.
- **No shadow AI** — All LLM usage must go through the approved internal adapter layer, not ad-hoc direct API calls by developers.
- **SBOM (Software Bill of Materials)** — Increasingly required for enterprise AI deployments.

---

## 10. Enterprise Security Checklist Summary

| Category | Non-Negotiable? | Key Tools / Standards |
|----------|:---:|-----|
| PII redaction before LLM | **Yes** | Protegrity, Presidio, Private AI |
| Encryption in-transit + at-rest | **Yes** | TLS 1.2+, AES-256 |
| GDPR / HIPAA / SOX compliance | **Yes** | DPAs, SOC 2, audit reports |
| RBAC + scoped auth | **Yes** | Okta / Azure AD, short-lived tokens |
| Full audit trail | **Yes** | Langfuse, SIEM integration |
| Prompt injection defense | **Yes** | OWASP LLM Top 10, NeMo Guardrails |
| Data residency | **Often** | Azure OpenAI, Bedrock, on-prem |
| Human-in-the-loop for actions | **Yes** | Approval workflows, dry-run mode |
| Model supply chain security | **Growing** | SBOMs, dependency scanning |
| No shadow AI | **Yes** | Internal adapter layer, governance policy |

---

*Derived from enterprise security patterns for Agentic AI in ERP and CLM deployments.*
