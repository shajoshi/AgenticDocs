# Agentic AI & LLM Technology Reference

> Reference guide covering technologies discussed in the GoDaddy executive session.

---

## 1. ElevenLabs

### What it does
AI voice synthesis platform that converts text to highly realistic, human-like speech. Used to power voice agents with expressive, low-latency audio output.

### Typical Applications
- Voice-based AI assistants and customer support bots
- Text-to-speech for content and media
- Real-time voice cloning for personalized agents

### Pros
- Best-in-class voice quality and naturalness
- Voice cloning with minimal audio samples
- Low latency streaming audio

### Cons
- Does **not** handle telephony/telecom routing — needs a separate layer (e.g., Telnyx)
- Cost scales with audio generation volume
- Limited control over underlying telecom nuances (background noise, PSTN, multi-country numbers)

### Competing Technologies
| Tool | Notes |
|------|-------|
| **OpenAI TTS** | Native, tight integration with GPT; less expressive |
| **Azure Neural TTS** | Enterprise-grade, broad language support |
| **Google Cloud TTS** | Wide language coverage, WaveNet voices |
| **Deepgram Aura** | Optimized for real-time, low-latency voice |
| **PlayHT** | Voice cloning competitor to ElevenLabs |

---

## 2. Telnyx

### What it does
A cloud communications platform (CPaaS) that abstracts telecom infrastructure — SIP trunking, phone numbers, PSTN routing — across multiple countries. In AI contexts, it acts as the telephony backbone connecting voice agents to real phone calls.

### Typical Applications
- Providing a single phone number accessible globally
- Routing voice agent calls over PSTN
- Adding context-aware background noise for natural-sounding calls
- Telecom-layer tracing/observability for voice AI pipelines

### Pros
- True multi-country abstraction with a single number
- Context-based background noise injection
- Supports MCP server integration (share only embeddings, fetch context on demand)
- Nested tracing capabilities for debugging voice call flows
- Carrier-grade reliability

### Cons
- Adds infrastructure complexity vs. simpler SaaS options
- Pricing model can be complex at scale
- Developer setup requires understanding of SIP/telecom concepts

### Competing Technologies
| Tool | Notes |
|------|-------|
| **Twilio** | Most widely used CPaaS; mature ecosystem but more expensive |
| **Vonage (Vonage AI Studio)** | Conversational AI + telephony combined |
| **Bandwidth** | Carrier-grade CPaaS, strong in North America |
| **Plivo** | Cost-effective Twilio alternative |
| **SignalWire** | Open-source friendly, FreeSWITCH based |

---

## 3. RAG — Retrieval-Augmented Generation

### What it does
A pattern where an LLM retrieves relevant documents/chunks from an external knowledge base at query time, instead of relying solely on trained weights. The retrieved context is injected into the prompt before generating a response.

### Typical Applications
- Enterprise document Q&A (legal, compliance, contracts)
- Customer support over proprietary knowledge bases
- Reducing hallucination on factual, domain-specific queries

### Pros
- Dramatically reduces hallucination on grounded facts
- Knowledge can be updated without retraining the model
- Reduces context window usage by fetching only relevant chunks
- Cost-effective vs. fine-tuning for knowledge updates

### Cons
- Retrieval quality directly limits answer quality (garbage in, garbage out)
- Requires careful chunking strategy (see Custom Chunking below)
- Adds latency from retrieval step
- Irrelevant chunks in context can degrade responses

### Competing / Complementary Approaches
| Approach | Notes |
|----------|-------|
| **Fine-tuning** | Bakes knowledge into model weights; expensive, harder to update |
| **Long-context LLMs** | Pass entire corpus (e.g., Gemini 1M token); costly, less precise |
| **GraphRAG** | Uses knowledge graphs instead of vector similarity |
| **CAG (Cache-Augmented Generation)** | Pre-caches KV state; faster but less flexible |

---

## 4. Custom Chunking

### What it does
A strategy for splitting documents into semantically meaningful segments before embedding and indexing into a vector store. Unlike naive fixed-size chunking, custom chunking groups content by category, section, or semantic boundary — especially critical for legal and structured documents.

### Typical Applications
- Legal document processing (contracts, clauses grouped by type)
- Large-scale enterprise knowledge bases
- Deduplication of overlapping/redundant content at ingest time

### Pros
- Keeps related content together → better retrieval precision
- Reduces irrelevant context being passed to LLM
- Lowers hallucination, cost, and token usage
- Enables deduplication at the source level

### Cons
- Requires domain expertise to define chunk boundaries
- Higher upfront engineering effort vs. naive chunking
- Maintenance overhead as document formats evolve

### Competing / Complementary Approaches
| Approach | Notes |
|----------|-------|
| **Fixed-size chunking** | Simple, fast; loses semantic boundaries |
| **Sentence/paragraph splitting** | Better than fixed-size; still not domain-aware |
| **Semantic chunking** | Embedding-based boundary detection (e.g., LangChain SemanticChunker) |
| **Unstructured.io** | Parses complex docs (PDF, DOCX) with layout awareness |
| **LlamaIndex node parsers** | Rich set of hierarchical/structural chunking strategies |

---

## 5. Mem0

### What it does
An open-source memory layer for AI agents. Extracts and stores facts from conversations — both generic facts and user-specific context — to give agents persistent, personalized memory across sessions.

### Typical Applications
- Personalization in chatbots and voice agents
- Long-running workflows where session state needs to persist
- Extracting and recalling user preferences, history, and facts

### Pros
- Out-of-the-box fact extraction without manual engineering
- Reduces reliance on bloated unified state objects
- Supports short-term and long-term memory categorization
- Open-source with self-hosted option

### Cons
- Extracts **generic** facts — may miss domain-specific nuances (e.g., legal/compliance context)
- Memory retrieval quality depends on extraction quality
- Can introduce latency on each turn for memory read/write

### Competing Technologies
| Tool | Notes |
|------|-------|
| **Zep** | Long-term memory for AI apps; session + entity memory |
| **LangGraph state** | In-graph state management; single session focus |
| **Redis (custom)** | As noted in the doc — key-value pairs for domain-specific facts |
| **Letta (formerly MemGPT)** | Self-editing memory architecture for agents |
| **Motorhead** | Memory server for LangChain agents |

---

## 6. Redis (as Memory Store)

### What it does
An in-memory key-value store used here as a fast, lightweight persistence layer for AI agent memory — storing domain-specific facts extracted from conversations as structured key-value pairs, categorized as short-term or long-term.

### Typical Applications
- Agent short-term/long-term memory store
- Session state caching
- Fast lookup of user/entity context during inference

### Pros
- Extremely low latency reads/writes
- Flexible data structures (hashes, sorted sets, TTL for expiry)
- TTL support naturally models short-term vs. long-term memory
- Widely adopted, easy to operate

### Cons
- Memory is bounded by RAM
- Not natively a vector store (need Redis Stack/VSS for embeddings)
- Requires custom extraction logic to populate meaningfully

### Competing Technologies
| Tool | Notes |
|------|-------|
| **DynamoDB** | Serverless KV; higher latency, better scalability |
| **Upstash Redis** | Serverless Redis, great for edge/serverless agents |
| **Momento** | Serverless cache with built-in TTL management |
| **Firestore** | Document DB with real-time sync |

---

## 7. LLM Adapter Layer (Internal API Abstraction)

### What it does
A custom internal API gateway/router that abstracts direct LLM API calls. Routes requests to the appropriate LLM provider (OpenAI, Anthropic, local models, etc.) based on the data type, cost sensitivity, latency requirements, or compliance needs.

### Typical Applications
- Multi-provider LLM routing (e.g., GPT-4 for complex reasoning, cheaper model for classification)
- Compliance routing (PII-sensitive data to on-prem/local models)
- Cost optimization by tiering requests to appropriate models
- Provider failover and A/B testing

### Pros
- Provider-agnostic — swap models without touching application code
- Enables cost optimization via intelligent routing
- Central point for rate limiting, logging, and PII redaction
- Reduces vendor lock-in

### Cons
- Engineering overhead to build and maintain
- Adds a network hop / latency
- Must stay current with rapidly changing provider APIs

### Competing / Complementary Technologies
| Tool | Notes |
|------|-------|
| **LiteLLM** | Open-source proxy; 100+ LLM providers, unified API |
| **OpenRouter** | Cloud-based LLM routing with cost optimization |
| **Portkey** | LLM gateway with observability, fallbacks, caching |
| **Martian** | Intelligent router; picks cheapest model that can handle the task |
| **Vercel AI SDK** | Framework-level abstraction (see Vercel Agents section) |

---

## 8. Langfuse

### What it does
An open-source LLM engineering platform serving as a control center for prompt management, observability (tracing), and evaluation of LLM-powered applications.

### Typical Applications
- **Prompt Management**: Version-controlled prompt library with A/B testing
- **Observability**: Nested distributed tracing across agent steps, cost tracking, token usage
- **Evaluation**: LLM-as-a-judge scoring for helpfulness, accuracy, and safety

### Pros
- Open-source with self-hosted option (critical for PII-sensitive workloads)
- First-class support for agentic/multi-step trace visualization
- Prompt versioning prevents regression when prompts change
- Native LLM-as-a-judge evaluation pipeline
- Integrates with LangChain, LlamaIndex, OpenAI SDK, etc.

### Cons
- Self-hosting adds infrastructure overhead
- Evaluation quality depends on judge model quality
- Dashboards can be overwhelming for simple use cases

### Competing Technologies
| Tool | Notes |
|------|-------|
| **LangSmith** | LangChain's native observability; tightly coupled to LangChain |
| **Helicone** | Lightweight LLM observability proxy |
| **Arize Phoenix** | MLOps-focused LLM monitoring and tracing |
| **Weights & Biases (W&B Weave)** | ML experiment + LLM tracing combined |
| **Braintrust** | Evaluation-first platform; strong evals framework |
| **OpenTelemetry + custom** | DIY tracing using open standards |

---

## 9. OWASP AI Security / LLM Security

### What it does
OWASP (Open Web Application Security Project) maintains the **OWASP Top 10 for LLM Applications** — a framework of the most critical security risks for LLM-powered systems, including prompt injection, insecure output handling, training data poisoning, and more.

### Typical Applications
- Security audit checklist for Agentic AI systems
- Compliance baseline for GDPR/HIPAA-regulated AI systems
- Guardrail design for voice agents and document-handling pipelines

### Pros
- Free, community-maintained, vendor-neutral
- Directly applicable to production LLM systems
- Widely recognized — useful for stakeholder communication

### Cons
- Guidance, not enforcement — requires manual implementation
- Evolves slower than the threat landscape
- Does not cover all PII/data-field level protections (see Protegrity)

### Competing / Complementary Frameworks
| Framework | Notes |
|-----------|-------|
| **NIST AI RMF** | US government AI risk management framework |
| **ISO/IEC 42001** | International AI management system standard |
| **Microsoft RAI** | Responsible AI guidelines from Microsoft |
| **Google SAIF** | Secure AI Framework from Google |

---

## 10. Protegrity

### What it does
An enterprise data security platform that provides **field-level data protection** — tokenization, encryption, anonymization, and masking — at the individual data element level. In LLM contexts, it prevents raw PII from being sent to external LLM APIs.

### Typical Applications
- Redacting or tokenizing PII before sending prompts to LLM APIs
- Compliance with GDPR, HIPAA, CCPA data handling requirements
- Protecting sensitive fields in enterprise data pipelines (ERP, CLM integrations)
- De-tokenizing LLM responses before returning to end users

### Pros
- Fine-grained, field-level protection (not just document-level)
- Supports format-preserving encryption (data looks real but is anonymized)
- Strong enterprise compliance posture
- Works across structured and unstructured data

### Cons
- Enterprise pricing — not suitable for startups
- Complex deployment and integration
- May require tokenization/de-tokenization logic in every pipeline path
- Adds latency to every data transformation

### Competing Technologies
| Tool | Notes |
|------|-------|
| **Microsoft Presidio** | Open-source PII detection & anonymization |
| **Private AI** | PII redaction API purpose-built for LLM pipelines |
| **Nightfall AI** | DLP for cloud/SaaS — detects and redacts PII |
| **AWS Macie** | PII discovery in S3/cloud storage |
| **Skyflow** | Data privacy vault with API-first design |

---

## 11. MCP Server (Model Context Protocol)

### What it does
An open protocol (introduced by Anthropic) that standardizes how AI agents/LLMs connect to external tools, data sources, and APIs. An MCP Server exposes capabilities (resources, tools, prompts) that an LLM client can dynamically discover and call.

### Typical Applications
- Read-only data access: fetching documents, database records, CRM data
- Giving agents access to internal knowledge without embedding it in the prompt
- Standardized tool calling across different LLM providers

### Pros
- Vendor-neutral, open standard
- Enables dynamic tool discovery by the LLM at runtime
- Reduces prompt bloat — fetch context only when needed
- Good for read-only, low-risk data access scenarios

### Cons
- **Over-fetching** — LLMs may call tools unnecessarily, increasing cost and reducing accuracy
- Vendor MCP implementations are still immature
- **Risky for write/action use-cases** — agent impersonation risk when taking actions on behalf of users
- Adds network hops and latency per tool call
- Observability and debugging are harder than direct API calls

### Competing / Complementary Approaches
| Approach | Notes |
|----------|-------|
| **Direct API tool calls** | Recommended for write/action use-cases; explicit, auditable |
| **OpenAI function calling** | Provider-specific tool calling standard |
| **LangChain tools** | Framework-level tool abstraction |
| **LlamaIndex query tools** | Data-centric tool calling for RAG agents |
| **OpenAPI-based tool specs** | Standard REST API specs as agent tools |

---

## 12. Vercel AI SDK / Vercel Agents

### What it does
An open-source TypeScript SDK from Vercel that provides a unified, provider-agnostic interface for building AI-powered applications and agents. Allows writing agent logic once and switching between OpenAI, Anthropic, Google, Mistral, or local models (Ollama) without code changes.

### Typical Applications
- Building cloud-agnostic AI agents and chatbots
- Streaming LLM responses in web applications
- Multi-step agentic workflows with tool use
- Rapid prototyping with easy model swapping

### Pros
- **Cloud-agnostic** — swap LLM providers with a config change
- First-class streaming support
- Native Next.js/React integration
- Open-source, no vendor lock-in
- Supports structured outputs, tool calling, and multi-step agents
- Works with local models via Ollama

### Cons
- Primarily TypeScript/JavaScript ecosystem
- Less mature than LangChain for complex multi-agent orchestration
- Fewer built-in integrations compared to LangChain/LlamaIndex
- Vercel hosting is not required but the SDK is most ergonomic in that ecosystem

### Competing Technologies
| Tool | Notes |
|------|-------|
| **LangChain** | Most feature-rich; Python + JS; complex for simple cases |
| **LlamaIndex** | Data-centric agent framework; strong RAG focus |
| **OpenAI Agents SDK** | OpenAI-native, cloud-locked |
| **CrewAI** | Multi-agent role-based orchestration |
| **AutoGen (Microsoft)** | Research-focused multi-agent framework |
| **Haystack** | Production-focused NLP/LLM pipeline framework |

---

## 13. Claude Code

### What it does
An agentic AI coding assistant from Anthropic (Claude) that operates in the terminal/IDE, capable of reading codebases, writing and editing code, running commands, and performing multi-step software engineering tasks autonomously.

### Typical Applications
- Automated code review before human review cycles
- Architecture and design-level discussions
- Refactoring, test generation, and documentation
- Onboarding teams to AI-assisted development workflows

### Pros
- Strong reasoning and code comprehension on large codebases
- Agentic — can read files, run commands, make multi-step changes
- Improves team productivity and code review quality
- Pro license unlocks higher usage limits

### Cons
- Requires team training to use effectively
- Risk of over-trusting AI suggestions without review
- Pro license cost per developer
- Outputs require human review — not fully autonomous

### Competing Technologies
| Tool | Notes |
|------|-------|
| **GitHub Copilot** | Inline code completion; less agentic |
| **Cursor** | AI-native IDE with strong codebase context |
| **Windsurf (Codeium)** | AI IDE with agentic Cascade assistant |
| **Devin (Cognition)** | Fully autonomous software engineer agent |
| **OpenHands (OpenDevin)** | Open-source autonomous coding agent |
| **Antigravity** | Free AI dev tool (noted as good free alternative) |

---

## 14. LLM-as-a-Judge

### What it does
An evaluation technique where a capable LLM (the "judge") is used to automatically score and assess the outputs of another LLM or AI system — measuring dimensions like helpfulness, accuracy, safety, coherence, and relevance.

### Typical Applications
- Automated quality scoring of RAG pipeline outputs
- Evaluating voice agent response quality at scale
- A/B testing prompts and measuring regression
- Replacing or augmenting human evaluation in CI/CD pipelines

### Pros
- Scalable — evaluates thousands of outputs automatically
- Flexible — judge criteria are defined in natural language
- Lower cost than human labeling at scale
- Can catch regressions in prompt changes quickly

### Cons
- Judge model can inherit biases (e.g., prefers verbose answers)
- "Self-enhancement bias" — models rate themselves higher
- Not a replacement for human evaluation on high-stakes outputs
- Judge quality is bounded by the judge model's capabilities

### Competing / Complementary Approaches
| Approach | Notes |
|----------|-------|
| **Human evaluation** | Gold standard; expensive and slow |
| **RAGAS** | RAG-specific evaluation metrics (faithfulness, relevancy) |
| **DeepEval** | Open-source LLM evaluation framework |
| **Braintrust Evals** | Evaluation-first platform with human + LLM judges |
| **Promptfoo** | Open-source prompt testing and red-teaming |

---

*Generated from executive session notes — GoDaddy Agentic AI discussion.*
