# Static Code Scanning Tools for Daily Builds

> Reference guide for SAST (Static Application Security Testing), SCA (Software Composition Analysis), and code quality tools suitable for CI/CD integration in daily builds.

---

## Tool Comparison Matrix

| Tool | Category | Approx. Cost (USD/year) | Free Tier? | Best For |
|------|----------|------------------------|:---:|----------|
| **SonarQube / SonarCloud** | SAST + Code Quality | $0 – $45,000+ | Yes | Overall code quality + security |
| **Snyk** | SCA + SAST + Container | $0 – $25,000+ | Yes | Open-source dependency vulnerabilities |
| **Checkmarx (CXSAST / CxOne)** | SAST + SCA | $30,000 – $150,000+ | No | Enterprise SAST |
| **Veracode** | SAST + DAST + SCA | $24,000 – $120,000+ | No | Enterprise AppSec platform |
| **GitHub Advanced Security** | SAST + SCA + Secrets | $49/committer/month | GH public repos | GitHub-native teams |
| **Semgrep** | SAST + Custom Rules | $0 – $40,000+ | Yes | Custom rule writing, lightweight |
| **Fortify (OpenText)** | SAST + DAST | $30,000 – $200,000+ | No | Large enterprise, regulated industries |
| **CodeQL** | SAST (Semantic) | Free (via GitHub) | Yes | Deep semantic code analysis |
| **Bandit** | SAST (Python only) | Free | Yes | Python security scanning |
| **ESLint + security plugins** | SAST (JS/TS only) | Free | Yes | JavaScript/TypeScript linting |
| **Trivy** | SCA + Container + IaC | Free | Yes | Container & dependency scanning |
| **OWASP Dependency-Check** | SCA | Free | Yes | Known CVE detection in dependencies |
| **GitLeaks / TruffleHog** | Secret Detection | Free | Yes | Secrets/API keys in code |
| **Mend (formerly WhiteSource)** | SCA + License | $25,000 – $80,000+ | No | License compliance + SCA |
| **Black Duck (Synopsys)** | SCA | $30,000 – $100,000+ | No | Enterprise SCA, M&A due diligence |

---

## Detailed Breakdown

### 1. SonarQube / SonarCloud

| | |
|---|---|
| **Website** | [sonarsource.com/sonarqube](https://www.sonarsource.com/products/sonarqube/) |
| **Category** | SAST + Code Quality |
| **Languages** | 30+ (Java, Python, JS/TS, C#, Go, C/C++, etc.) |
| **CI/CD Integration** | Jenkins, GitHub Actions, GitLab CI, Azure DevOps, Bitbucket |
| **Known Customers** | Cisco, BMW, T-Mobile, Samsung, Airbus, Siemens, Deutsche Bank, Toyota, Thales |

**Pricing:**
| Edition | Cost (USD/year) | Notes |
|---------|----------------|-------|
| Community | Free | Open-source, single branch |
| Developer | ~$150/year (per 100K LOC) | Branch analysis, PR decoration |
| Enterprise | ~$20,000 – $45,000+ | Portfolio management, SAST rules |
| Data Center | ~$100,000+ | HA, multi-node |
| SonarCloud | Free for public repos; ~$10–$130/month for private | Cloud-hosted |

**Pros:** Industry standard for code quality; great dashboard; CI/CD native; covers bugs, vulnerabilities, code smells, and duplication.
**Cons:** Enterprise editions get expensive fast; community edition limited to single branch; SAST depth is lighter than Checkmarx/Veracode.

---

### 2. Snyk

| | |
|---|---|
| **Website** | [snyk.io](https://snyk.io/) |
| **Category** | SCA + SAST + Container + IaC |
| **Known Customers** | Google, Salesforce, Atlassian, Twilio, MongoDB, Datadog, Revolut, Intuit, DocuSign |

**Pricing:**
| Plan | Cost (USD) | Notes |
|------|-----------|-------|
| Free | $0 | Up to 200 tests/month, limited projects |
| Team | ~$522/year per developer | Unlimited tests, fix PRs |
| Enterprise | ~$25,000+/year | SSO, custom policies, reporting |

**Pros:** Best-in-class dependency vulnerability database; auto-fix PRs; fast CI integration; developer-friendly UX.
**Cons:** SAST capabilities less mature than dedicated SAST tools; cost scales quickly with team size; some false positives in SCA.

---

### 3. Checkmarx (CxOne)

| | |
|---|---|
| **Website** | [checkmarx.com](https://checkmarx.com/) |
| **Category** | SAST + SCA + API Security |
| **Known Customers** | SAP, Siemens, Samsung, Adidas, Rabobank, NTT Data, Priceline, Informatica |

**Pricing:**
| Plan | Cost (USD/year) | Notes |
|------|----------------|-------|
| CxOne | ~$30,000 – $150,000+ | Based on # of developers, LOC, modules |

**Pros:** Deep SAST analysis — traces tainted data flows through code; strong compliance reporting (PCI-DSS, HIPAA); broad language support.
**Cons:** Expensive; scans can be slow on large codebases; significant tuning required to reduce false positives; steep learning curve.

---

### 4. Veracode

| | |
|---|---|
| **Website** | [veracode.com](https://www.veracode.com/) |
| **Category** | SAST + DAST + SCA |
| **Known Customers** | Barclays, Aetna (CVS Health), Greenway Health, PTC, Liberty Mutual, DocuSign, Zoom |

**Pricing:**
| Plan | Cost (USD/year) | Notes |
|------|----------------|-------|
| Standard | ~$24,000 – $60,000 | Per-app pricing, limited scans |
| Enterprise | ~$60,000 – $120,000+ | Unlimited apps, full platform |

**Pros:** Combined SAST + DAST + SCA in one platform; good compliance posture for regulated industries; developer training (Veracode Security Labs).
**Cons:** Binary/bytecode analysis model — can be slower; costly for startups; UI can feel dated; lock-in due to proprietary analysis.

---

### 5. GitHub Advanced Security (GHAS)

| | |
|---|---|
| **Website** | [github.com/features/security](https://github.com/features/security) |
| **Category** | SAST (CodeQL) + SCA (Dependabot) + Secret Scanning |
| **Known Customers** | Microsoft, Stripe, Shopify, Mercedes-Benz, Spotify, Ford, NASA, 3M, Telus |

**Pricing:**
| Plan | Cost (USD) | Notes |
|------|-----------|-------|
| Public repos | Free | Full GHAS features |
| Private repos | $49/committer/month | ~$588/committer/year |

**Pros:** Native GitHub integration — zero setup in Actions; CodeQL is extremely powerful for semantic analysis; Dependabot auto-fix PRs; secret scanning built-in.
**Cons:** Only available on GitHub; per-committer pricing can be costly for large teams; CodeQL scans can be slow; limited language support compared to Checkmarx.

---

### 6. Semgrep

| | |
|---|---|
| **Website** | [semgrep.dev](https://semgrep.dev/) |
| **Category** | SAST + Custom Rules |
| **Known Customers** | Snowflake, Dropbox, Slack, HashiCorp, Figma, Lyft, Notion, Trail of Bits |

**Pricing:**
| Plan | Cost (USD/year) | Notes |
|------|----------------|-------|
| Community (OSS) | Free | CLI, basic rules |
| Team | ~$40/developer/month | Managed platform, pro rules |
| Enterprise | ~$40,000+ | SSO, custom policies, support |

**Pros:** Lightweight and fast; write custom rules in minutes (pattern-based, not regex); great for enforcing internal coding standards; open-source core.
**Cons:** Less deep than full taint-tracking SAST (Checkmarx/Fortify); rule quality depends on community/custom effort; managed platform adds cost.

---

### 7. Fortify (OpenText / Micro Focus)

| | |
|---|---|
| **Website** | [opentext.com/fortify](https://www.opentext.com/products/fortify-static-code-analyzer) |
| **Category** | SAST + DAST |
| **Known Customers** | US Department of Defense, Lockheed Martin, JPMorgan Chase, Deloitte, HSBC, Booz Allen Hamilton, Raytheon |

**Pricing:**
| Plan | Cost (USD/year) | Notes |
|------|----------------|-------|
| On-Prem | ~$30,000 – $200,000+ | Per-user or per-app licensing |
| Fortify on Demand (SaaS) | ~$2,000 – $10,000+ per app | Scan credits model |

**Pros:** Industry veteran — deepest vulnerability database; strong in regulated environments (government, finance); comprehensive language support.
**Cons:** Very expensive; slow scan times; heavy infrastructure requirements for on-prem; dated developer experience.

---

### 8. Trivy (Aqua Security)

| | |
|---|---|
| **Website** | [trivy.dev](https://trivy.dev/) |
| **Category** | SCA + Container + IaC + SBOM |
| **Known Customers** | GitLab (built-in scanner), Yahoo Japan, Mercari, Aqua Security customers broadly; widely adopted in CNCF/Kubernetes ecosystem |

**Pricing:** **Free and open-source**

**Pros:** Fast, single-binary scanner; covers OS packages, language dependencies, container images, IaC (Terraform, CloudFormation), and Kubernetes; SBOM generation; excellent CI/CD integration.
**Cons:** Not a SAST tool — no source code analysis; vulnerability database can lag CVE publications; enterprise features require Aqua Platform (paid).

---

### 9. GitLeaks / TruffleHog

| | |
|---|---|
| **Website** | [gitleaks.io](https://gitleaks.io/) / [trufflesecurity.com](https://trufflesecurity.com/) |
| **Category** | Secret Detection |
| **Known Customers** | **GitLeaks:** Widely used in OSS/startup ecosystem (Uber, Shopify reported usage). **TruffleHog:** Palantir, GitLab, Trail of Bits; used by numerous security teams for pre-commit scanning |

**Pricing:**
| Tool | Cost | Notes |
|------|------|-------|
| GitLeaks | Free (OSS) | CLI, pre-commit hooks |
| TruffleHog OSS | Free | Scans git history, S3, etc. |
| TruffleHog Enterprise | ~$10,000+/year | Managed, verification of live secrets |

**Pros:** Catches API keys, tokens, passwords committed to repos; runs in pre-commit hooks (shift-left); TruffleHog verifies if detected secrets are still active.
**Cons:** Only detects secrets — not code vulnerabilities; false positives on high-entropy strings; needs complementary SAST/SCA tools.

---

### 10. OWASP Dependency-Check

| | |
|---|---|
| **Website** | [owasp.org/dependency-check](https://owasp.org/www-project-dependency-check/) |
| **Category** | SCA |
| **Known Customers** | Used across government agencies (NIST-aligned), European Commission, and enterprises running Java/.NET stacks; common in regulated industries as a free baseline scanner |

**Pricing:** **Free and open-source**

**Pros:** Checks dependencies against NVD (National Vulnerability Database); supports Java, .NET, Python, Node.js, Ruby; easy CI integration; no vendor lock-in.
**Cons:** Slower than Snyk/Trivy; higher false positive rate; no auto-fix capability; NVD database updates can lag.

---

## Recommended Stack by Budget

### Startup / Small Team (< $5K/year)
| Layer | Tool | Cost |
|-------|------|------|
| SAST | **SonarCloud** (free for public) or **Semgrep OSS** | Free |
| SCA | **Snyk Free** or **Trivy** | Free |
| Secrets | **GitLeaks** | Free |
| Container | **Trivy** | Free |

### Mid-size Team ($5K – $50K/year)
| Layer | Tool | Cost |
|-------|------|------|
| SAST + Quality | **SonarQube Developer** | ~$5,000 – $15,000 |
| SCA | **Snyk Team** | ~$5,000 – $15,000 |
| Secrets | **GitHub Advanced Security** or **TruffleHog Enterprise** | ~$10,000 |
| Container | **Trivy** | Free |

### Enterprise ($50K+/year)
| Layer | Tool | Cost |
|-------|------|------|
| SAST | **Checkmarx CxOne** or **Veracode** | $30,000 – $150,000 |
| SCA | **Snyk Enterprise** or **Black Duck** | $25,000 – $100,000 |
| Quality | **SonarQube Enterprise** | $20,000 – $45,000 |
| Secrets | **GitHub Advanced Security** | $49/committer/month |
| Container + IaC | **Trivy** + **Aqua Platform** | $30,000+ |

---

## CI/CD Integration Quick Reference

```yaml
# Example: GitHub Actions daily build with scanning
name: Daily Security Scan
on:
  schedule:
    - cron: '0 6 * * *'  # 6 AM UTC daily

jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
      - name: Semgrep
        uses: returntocorp/semgrep-action@v1

  sca:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Snyk Test
        uses: snyk/actions/node@master
      - name: Trivy FS Scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'

  secrets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: GitLeaks
        uses: gitleaks/gitleaks-action@v2
```

---

## Customer Reference Summary

| Tool | Notable Customers / Adopters |
|------|-----------------------------|
| **SonarQube** | Cisco, BMW, T-Mobile, Samsung, Airbus, Siemens, Deutsche Bank, Toyota |
| **Snyk** | Google, Salesforce, Atlassian, Twilio, MongoDB, Datadog, Revolut, Intuit |
| **Checkmarx** | SAP, Siemens, Samsung, Adidas, Rabobank, NTT Data, Informatica |
| **Veracode** | Barclays, CVS Health (Aetna), Liberty Mutual, DocuSign, Zoom, PTC |
| **GitHub Advanced Security** | Microsoft, Stripe, Shopify, Mercedes-Benz, Spotify, Ford, NASA |
| **Semgrep** | Snowflake, Dropbox, Slack, HashiCorp, Figma, Lyft, Notion |
| **Fortify** | US DoD, Lockheed Martin, JPMorgan Chase, Deloitte, HSBC, Raytheon |
| **Trivy** | GitLab, Yahoo Japan, Mercari, broad CNCF/Kubernetes ecosystem |
| **GitLeaks / TruffleHog** | Uber, Shopify (GitLeaks); Palantir, GitLab (TruffleHog) |
| **OWASP Dep-Check** | Government agencies (NIST-aligned), European Commission, regulated industries |
| **Mend** | Microsoft, GE, Comcast, Capital One, SAP |
| **Black Duck** | Samsung, Qualcomm, Siemens, Panasonic, Bosch, used heavily in M&A due diligence |

---

*Pricing is approximate as of early 2026 and varies by contract size, LOC count, number of developers, and negotiation. Always request vendor quotes for accurate pricing.*
