# Mathematical Formulas and Tables — NSAM Critical Review

Scratch notes for LaTeX-complex formulas and reference tables.
These are scratch/working notes; canonical source is the DocBook XML files in src/.

---

## Curry-Howard Correspondence Table

| Logic | Type Theory | Example |
|-------|-------------|---------|
| Proposition | Type | `IsOn(A,B) : Type` |
| Proof | Term (program) | `p : IsOn(A,B)` |
| A → B (implication) | Function type A → B | `stack : Holding(x) → Clear(y) → On(x,y)` |
| A ∧ B (conjunction) | Product type A × B | `(Holding(x), Clear(y))` |
| A ∨ B (disjunction) | Sum type A + B | `Either<Holding(x), OnTable(x)>` |
| ∀x. P(x) (universal) | Π-type (dependent function) | `Π(x:Block). OnTable(x) → Clear(x) → Holding(x)` |
| ∃x. P(x) (existential) | Σ-type (dependent pair) | `Σ(x:Block). On(RedBlock, x)` |
| Proof simplification | Program evaluation (β-reduction) | Plan execution |

---

## NSAM Typing Judgment

The core formal notation for NSAM plan synthesis:

```
Γ ⊢ p : T_goal
```

Where:
- **Γ** = set of known facts (formal propositions from semantic parser)
- **p** = plan program (the proof term / sequence of actions)
- **T_goal** = goal type (the proposition to be satisfied)
- **⊢** = "yields" / "proves"

Reading: "Given context Γ, the program p has type T_goal" = "Given the facts Γ, the plan p achieves the goal T_goal"

---

## Blocks World Action Types

```
pickup : Π(x:Block). (OnTable(x) ∧ Clear(x) ∧ HandEmpty) → Holding(x)

stack  : Π(x y:Block). (Holding(x) ∧ Clear(y)) → On(x, y)
```

Plan to satisfy `On(RedBlock, BlueBlock)` from initial state `{OnTable(r), Clear(r), OnTable(b), Clear(b), HandEmpty}`:

```
p = stack RedBlock BlueBlock (pickup RedBlock (...))
  : On(RedBlock, BlueBlock)
```

Type-checks → plan is verified by construction.

---

## Logic-LM Benchmark Context Table

| Dataset | Standard Prompting | Logic-LM (GPT-3.5) | Δ (pp) |
|---------|-------------------|---------------------|--------|
| ProofWriter | ~70% | ~88% | ~18 |
| PrOntoQA | ~75% | ~92% | ~17 |
| FOLIO | 45.09% | 62.80% | 17.71 |
| LogicalDeduction | ~65% | ~90% | ~25 |
| AR-LSAT | ~30% | ~44% | ~14 |
| **Average** | | | **~39.2% over standard; ~18.4% over CoT** |

Note: The 39.2% headline is a multi-dataset average. On FOLIO specifically the gain is 17.71 pp.
A 2025 replication (arXiv:2502.17216) found 45.23% or 24.98% depending on methodology.

---

## Kautz NSAI Taxonomy (6 Patterns)

| Pattern | Neural Role | Symbolic Role | Example |
|---------|-------------|---------------|---------|
| Symbolic→Neural→Symbolic | Transform | I/O | LLMs, seq2seq |
| Symbolic[Neural] | Subroutine | Orchestrator | AlphaGo (MCTS + NN) |
| Neural[Symbolic] | Orchestrator | Tool/subroutine | LLM + calculator |
| Neural\|Symbolic | Coroutine | Coroutine | Iterative refinement |
| Neural:Symbolic→Neural | Training data source | Generator | Math data synthesis |
| Neural:Symbolic (Compiled) | Architecture substrate | Compiled into | LTN, LNN |

NSAM target pattern: **Neural\|Symbolic** (cooperative coroutines)
with a Neural[Symbolic] fallback for the REST API integration path.

---

## Hypersequent Dependence Logic (verumorphism)

verumorphism implements HDL over ternary truth values {0, 1, i}:
- **0** = refutation (negative real)
- **1** = proof (positive real)
- **i** = non-closure (zero / indeterminate)

Key rules: `con_R`, `incon_L`, `dualR`, `dualL`, `dependenceR`, `independenceL`

This is the symbolic core the NSAM paper motivates connecting to larql-to-sparql's
neural mechanistic interpretability stack.
