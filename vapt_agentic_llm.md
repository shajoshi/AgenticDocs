# VAPT for Agentic LLM Applications

> What external security vendors do during Vulnerability Assessment and Penetration Testing (VAPT) for an Agentic AI/LLM application, what they need from you, and recommended vendors in the Pune area.

---

## 1. What VAPT Vendors Typically Do

External VAPT for an Agentic LLM application covers **standard web/API testing** plus **AI-specific attack vectors**. The engagement is usually structured in two phases:

### Phase A: Vulnerability Assessment (VA)

Automated + manual discovery of weaknesses **without active exploitation**.

| Area | What They Do | AI-Specific Focus |
|------|-------------|-------------------|
| **Network scanning** | Port scans, service fingerprinting (Nmap, Nessus, Qualys) | Check if LLM API endpoints are exposed on unexpected ports |
| **Web app scanning** | OWASP Top 10 checks — SQLi, XSS, CSRF, SSRF, auth flaws (Burp Suite, OWASP ZAP) | Check agent-facing API endpoints for injection |
| **API security** | Test REST/GraphQL endpoints for broken auth, BOLA, rate limiting | Test LLM orchestration APIs, tool-calling endpoints, MCP servers |
| **SSL/TLS config** | Certificate validation, protocol versions, cipher suites | Ensure TLS 1.2+ on all LLM API communication |
| **Cloud config review** | Azure misconfigurations — public blobs, open NSGs, overprivileged IAM | Azure OpenAI endpoint exposure, Key Vault access policies |
| **Dependency scanning** | Known CVEs in libraries (SCA scan) | LangChain, LlamaIndex, Vercel AI SDK, vector DB client vulnerabilities |
| **Secret detection** | Hardcoded API keys, tokens in repos or configs | Azure OpenAI keys, Redis passwords, vector DB credentials |

### Phase B: Penetration Testing (PT)

Active exploitation attempts — trying to **actually break in**.

| Attack Vector | What They Attempt | AI-Specific Attacks |
|--------------|-------------------|---------------------|
| **Authentication bypass** | Brute force, credential stuffing, session hijacking | Bypass auth to access agent endpoints directly |
| **Authorization testing** | Privilege escalation, IDOR, BOLA | Can User A's agent access User B's data? |
| **Prompt injection** | — | **Direct injection:** Craft inputs that override system prompts |
| **Indirect prompt injection** | — | **Poisoned documents:** Upload docs with hidden instructions that the RAG pipeline retrieves |
| **Jailbreaking** | — | Trick the agent into ignoring safety guardrails, revealing system prompts, or performing unauthorized actions |
| **Data exfiltration via LLM** | — | Manipulate agent into leaking training data, other users' context, or system internals |
| **Tool/function abuse** | — | Force the agent to call tools it shouldn't (e.g., write to ERP when only read is intended) |
| **Agent loop/DoS** | — | Trigger infinite agent loops, excessive LLM calls, or resource exhaustion |
| **RAG poisoning** | — | Upload adversarial documents to corrupt the knowledge base |
| **SSRF via agent** | — | Trick the agent into making requests to internal services |
| **Output manipulation** | — | Test if LLM output is rendered unsanitized (XSS via LLM response) |
| **MCP server exploitation** | — | Test over-fetching, unauthorized tool discovery, impersonation risks |

### Phase C: Reporting

| Deliverable | Contents |
|-------------|---------|
| **Executive summary** | High-level risk posture for leadership |
| **Detailed findings** | Each vulnerability with CVSS score, proof of concept, screenshots |
| **Risk classification** | Critical / High / Medium / Low / Informational |
| **Remediation guidance** | Specific fix recommendations for each finding |
| **Retest confirmation** | After fixes, vendor retests and confirms closure |

---

## 2. What Vendors Expect You to Provide

### Before Engagement (Scoping)

| Item | Details |
|------|---------|
| **Application URLs / endpoints** | Production or staging environment URLs, API base URLs |
| **API documentation** | OpenAPI/Swagger specs for all endpoints (agent APIs, tool-calling APIs, MCP server) |
| **Architecture diagram** | High-level diagram showing: client → API gateway → agent orchestrator → LLM → vector DB → ERP/CLM |
| **Azure subscription details** | Which Azure services are in scope (Azure OpenAI, Cosmos DB, AI Search, Redis, App Service, AKS, etc.) |
| **Authentication details** | How users authenticate (Azure AD, API keys, OAuth2); test credentials for different roles |
| **Test accounts** | At least 2 accounts with different privilege levels (admin, regular user) |
| **IP whitelisting** | Vendor's source IPs for whitelisting in Azure NSGs / firewall during testing |
| **Scope definition** | Explicitly list what is in-scope and out-of-scope (e.g., "Do NOT test the Azure OpenAI service itself") |
| **Rules of engagement** | Testing window (business hours only?), no-go areas, escalation contacts |
| **Data sensitivity classification** | What kind of data flows through the system (PII, financial, health) |

### AI-Specific Items to Provide

| Item | Why They Need It |
|------|-----------------|
| **Sample prompts / conversation flows** | To understand normal agent behavior and craft injection attacks |
| **List of agent tools / functions** | So they can test each tool for unauthorized invocation |
| **RAG pipeline details** | Document upload mechanism, chunking strategy, vector store used |
| **System prompt (optional but helpful)** | Helps testers assess prompt hardening — some orgs share, some don't |
| **Guardrail configuration** | What guardrails exist (Llama Guard, NeMo, custom filters) so they can test bypass |
| **MCP server endpoints** | If using MCP, provide the tool/resource manifest |
| **Rate limits / throttling config** | So testers know the bounds and can test DoS within limits |

### Legal / Administrative

| Document | Purpose |
|----------|---------|
| **NDA** | Vendor will see sensitive system details |
| **Statement of Work (SOW)** | Scope, timeline, cost, deliverables |
| **Authorization letter** | Written permission to test (critical — testing without authorization is illegal) |
| **Point of contact** | Technical POC available during testing for emergencies |
| **Incident escalation process** | What to do if tester accidentally causes an outage |

---

## 3. Typical VAPT Engagement Timeline & Cost

| Phase | Duration | Notes |
|-------|----------|-------|
| Scoping & planning | 3–5 days | SOW, NDA, access setup |
| Vulnerability assessment | 5–7 days | Automated + manual scanning |
| Penetration testing | 7–14 days | Active exploitation, AI-specific tests |
| Reporting | 3–5 days | Detailed report with findings |
| Remediation support | Ongoing | Guidance during fix period |
| Retest | 2–3 days | Verify fixes |
| **Total** | **~4–6 weeks** | |

### Cost Estimates

| Scope | Approx. Cost (USD) | Notes |
|-------|-------------------|-------|
| Web app + API only | $5,000 – $15,000 | Standard VAPT without AI-specific tests |
| Web + API + AI/LLM specific | $15,000 – $35,000 | Includes prompt injection, RAG poisoning, agent abuse |
| Full stack (infra + cloud + app + AI) | $25,000 – $60,000 | Azure config review + app + AI |
| Annual contract (2 tests/year) | $30,000 – $80,000 | Discounted for recurring engagement |

---

## 4. Recommended VAPT Vendors in Pune

### Tier 1: Pune-Headquartered / Strong Pune Presence

| Vendor | Specialization | Approx. Cost Range | Website |
|--------|---------------|-------------------|---------|
| **Pristine InfoSolutions** | VAPT, cloud security, compliance (ISO 27001, SOC 2). Pune HQ. Well-known in the enterprise segment. | ₹5L – ₹20L ($6K – $24K) | [intfraud.com](https://www.intfraud.com/) |
| **Payatu** | Offensive security, IoT + cloud + web VAPT. Pune HQ. Strong R&D team; speaks at BlackHat/DEF CON. Known for advanced pen testing. | ₹8L – ₹25L ($10K – $30K) | [payatu.com](https://payatu.com/) |
| **SecureLayer7 (SL7)** | Web/API/cloud VAPT, compliance audits. Pune HQ. Good for startups and mid-size companies. | ₹4L – ₹15L ($5K – $18K) | [securelayer7.net](https://securelayer7.net/) |
| **Suma Soft** | IT services with a cybersecurity practice. Pune HQ. Enterprise focus, good for bundled security + compliance. | ₹5L – ₹18L ($6K – $22K) | [sumasoft.com](https://www.sumasoft.com/) |
| **ISecure** | VAPT, red teaming, cloud security audits. Pune-based. | ₹3L – ₹12L ($4K – $15K) | [isecurion.com](https://www.isecurion.com/) |

### Tier 2: National Vendors with Pune Offices / Remote Capability

| Vendor | Specialization | Approx. Cost Range | Website |
|--------|---------------|-------------------|---------|
| **Sequretek** | AI-driven security operations + VAPT. Mumbai HQ, serves Pune clients. | ₹8L – ₹25L ($10K – $30K) | [sequretek.com](https://www.sequretek.com/) |
| **Aujas Cybersecurity (now Cysiv)** | Enterprise cloud security, VAPT, GRC. Bangalore HQ, Pune presence. | ₹10L – ₹30L ($12K – $36K) | [aujascybersecurity.com](https://www.aujascybersecurity.com/) |
| **Network Intelligence (NII)** | VAPT, SOC, compliance. Mumbai HQ, strong Pune client base. CERT-In empaneled. | ₹8L – ₹25L ($10K – $30K) | [niiconsulting.com](https://niiconsulting.com/) |
| **Crossbow Labs** | VAPT, cloud security. Kerala HQ, remote-first, serves Pune enterprises. | ₹4L – ₹15L ($5K – $18K) | [crossbowlabs.com](https://crossbowlabs.com/) |

### Tier 3: Global Vendors with India Presence (For Larger Budgets)

| Vendor | Notes | Approx. Cost Range |
|--------|-------|-------------------|
| **Bishop Fox** | Elite pen testing firm, US-based, works with Indian enterprises remotely | $30K – $80K |
| **Cobalt** | PtaaS (Pen Test as a Service), on-demand pen testers, some India-based | $15K – $40K |
| **HackerOne** | Bug bounty + pen testing marketplace, global talent pool | $20K – $60K |
| **Synack** | Managed crowdsourced pen testing, trusted by US DoD | $30K – $100K |

---

## 5. Selection Criteria for Choosing a Vendor

| Criteria | What to Look For |
|----------|-----------------|
| **AI/LLM testing capability** | Do they have experience testing LLM applications? Ask for case studies |
| **CERT-In empanelment** | Required for some Indian enterprises / government work |
| **CREST / OSCP certifications** | Industry-recognized pen testing certifications |
| **Cloud expertise** | Specific Azure experience (not just AWS) |
| **Retest included** | Ensure retest after remediation is included in the SOW |
| **Report quality** | Ask for a sample (redacted) report before signing |
| **Communication** | Dedicated POC, regular updates, not just a report dump at the end |
| **Insurance** | Professional indemnity insurance in case testing causes damage |

### Questions to Ask Vendors

1. "Have you tested LLM/AI-powered applications before? Can you share a redacted sample?"
2. "Do you test for OWASP Top 10 for LLM Applications specifically?"
3. "What tools do you use for prompt injection and AI-specific attacks?"
4. "Is retest included in the quoted price?"
5. "Are your testers OSCP/CREST certified?"
6. "Can you provide Azure-specific cloud configuration review?"
7. "What is your escalation process if you find a critical vulnerability during testing?"

---

## 6. VAPT Checklist for Agentic LLM Applications

### Standard Web/API Tests
- [ ] OWASP Top 10 (Web)
- [ ] OWASP API Security Top 10
- [ ] Authentication & session management
- [ ] Authorization & access control (RBAC testing)
- [ ] Input validation (SQLi, XSS, SSRF)
- [ ] Rate limiting & throttling
- [ ] SSL/TLS configuration
- [ ] Error handling & information disclosure
- [ ] File upload security

### AI/LLM-Specific Tests
- [ ] Direct prompt injection
- [ ] Indirect prompt injection (via RAG documents)
- [ ] System prompt extraction
- [ ] Jailbreak attempts
- [ ] Agent tool/function abuse
- [ ] Data exfiltration via LLM
- [ ] RAG poisoning
- [ ] Agent loop / resource exhaustion
- [ ] Output sanitization (XSS via LLM response)
- [ ] Cross-user context leakage
- [ ] MCP server over-fetching / unauthorized access
- [ ] Guardrail bypass testing

### Azure Cloud Configuration
- [ ] Azure AD / Entra ID misconfiguration
- [ ] NSG / firewall rules review
- [ ] Public blob storage exposure
- [ ] Key Vault access policies
- [ ] Azure OpenAI endpoint access restrictions
- [ ] Managed identity usage vs. hardcoded credentials
- [ ] Logging & monitoring coverage (Defender for Cloud)

---

*Pricing is approximate and varies by scope, complexity, and vendor. Always get 2–3 quotes. Costs in INR assume ₹83 = $1 USD.*
