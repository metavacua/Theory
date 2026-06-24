# Research Session Notes — NSAM Critical Review

Date: 2026-06-23
Deep research: 105 agents, 1307 tool uses, 2,247,194 subagent tokens
Workflow output: tasks/wrhx44ghb.output (25KB JSON)

---

## Key Findings Summary

1. **Logic-LM 39.2%**: Real figure but stripped of context. Per-dataset numbers range 14–25 pp.
   Paper should cite EMNLP 2023 Table 2 directly with dataset breakdown.

2. **Mamba 5x throughput**: Rejected 0-3. Primary paper doesn't state this number.
   The linear scaling claim is valid; the specific quantification is not.

3. **FNet 80% speedup**: Confirmed. But 92–97% GLUE retention is contested (rejected 1-2).
   Safe to cite speedup; drop the accuracy retention claim.

4. **Curry-Howard novelty**: The Proof-Carrying Plans paper (PPDP 2020, ACM 10.1145/3414080.3414094)
   explicitly does plans-as-functions, pre/post-conditions as types. Agda implementation predates 2019.
   The NSAM paper must cite this. Contribution should be framed as integration architecture.

5. **PyReason scalability**: Self-reported benchmarks vs. simulators, not vs. peer logic systems.
   Excluded from the 2025 comparative study (arXiv:2509.07122). Scallop is better supported.

6. **Scallop/A-NeSI**: Claims accurate but A-NeSI has provably biased gradient estimators (2024).

---

## Citation Gaps in NSAM Paper

The paper does not cite:
- Hill, Komendantskaya & Petrick 2020 (PCP) — direct prior art
- Brady & Hammond 2021 — dependent types for AI plans
- Masseron, Tollu & Vauzeilles 1990 — linear logic planning
- Kanovich & Vauzeilles 2001 — linear logic planning
- DeepProbLog (Manhaeve et al., NeurIPS 2018)
- A-NeSI (van Krieken et al., NeurIPS 2023) — only mentions Scallop
- Comparative survey arXiv:2509.07122 that excludes PyReason from empirical tables

---

## Open Questions for Follow-up

1. What IS the correct Mamba throughput number vs. Transformers? The paper cited 5x;
   the primary source didn't say that. What does Figure 8 in arXiv:2312.00752 actually show?

2. Does the PyReason LAT Logic paper (arXiv:2509.02958) actually benchmark vs. Scallop?
   The verified claim says no — only vs. AFSIM and StarCraft II simulators.

3. Is there a benchmark that covers PyReason, Scallop, DeepProbLog, LTN, and LNN on the
   same tasks? The 2025 survey (arXiv:2509.07122) deliberately excluded PyReason.

4. What would it take to wire verumorphism (HDL REST API) to larql-to-sparql (vindex neural
   substrate) as the NSAM integration? larql-probe → vindex → LQL query → HDL propositions → verumorphism?

---

## Portfolio Architecture Insight

The "NSAM architecture already exists in the portfolio, just not wired" framing:

```
[Raw data / Wikidata triples]
        ↓
[larql-to-sparql: vindex + knowledge/ pipeline]  ← NSAM neural perceptual layer
  - transformer weights decompiled to vindex
  - knowledge/ = Wikidata/DBpedia/WordNet → semantic labels
  - mechanistic interp hooks (ablation, steering, etc.)
        ↓
[Formal propositions: Is(b1,Block), Color(b1,Red), ...]
        ↓
[verumorphism REST API: HDL calculus]              ← NSAM symbolic reasoning layer
  - ProverV0.lisp / RefuterV0.lisp threads
  - HDL rules: con_R / incon_L / dualR / etc.
  - ternary logic {0,1,i} proof/refutation
        ↓
[Plan / proof term output]
        ↓
[drstrangegoo sequoia_engine (PR#4)]              ← optional: parameterized proof-search oracle
  - cut elimination, identity coherence
  - YAML-defined calculi (intuitionistic, linear)
```

subclass Proof<L,R> phantom types = type-safe reference implementation of the plans-as-proofs
paradigm, potentially useful as a Java binding layer.
