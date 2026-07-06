# PQAN — Formula & Correspondence Reference

GitHub-Markdown quick reference for the mathematics in `src/01-pqan-report.xml`.
The canonical rendering lives in the DocBook `<mathphrase role="tex">` nodes; this
file is the human-readable scratch companion.

## Assertion degrees (quantum metalanguage)

An assertion about proposition $A$ carries amplitude $\alpha$; its orthogonal
counterpart $A^\perp$ carries amplitude $\beta$, with measurement probabilities

$$P(A) = |\alpha|^2, \qquad P(A^\perp) = |\beta|^2, \qquad |\alpha|^2 + |\beta|^2 = 1.$$

A **glut** node holds $A \wedge A^\perp$ with both amplitudes non-zero (paraconsistent,
no explosion). A **gap** node leaves the assertion undefined (paracomplete).

## Identity / para-identity

Classical (Leibniz's Law):

$$x = y \iff \forall F.\, \big(F(x) \leftrightarrow F(y)\big).$$

Non-reflexive relaxation: entities may share all *contextual* properties yet not be
strictly identical; the para-identity operator $\mathcal{I}_{\text{para}}$ encodes
"indistinguishable up to contextual properties, not necessarily identical."

## Quantum fidelity (para-identical similarity core)

$$F(\rho, \sigma) = \left( \operatorname{Tr} \sqrt{ \sqrt{\rho}\, \sigma\, \sqrt{\rho} } \right)^2.$$

## PQAN attention (replaces $QK^\top$ + softmax)

Similarity between query state $\rho_{Q_i}$ and key state $\rho_{K_j}$:

$$\mathcal{S}_{i,j} = f\!\left( \operatorname{Tr} \sqrt{ \sqrt{\rho_{Q_i}}\, \rho_{K_j}\, \sqrt{\rho_{Q_i}} } \right) \mathcal{I}_{\text{para}},$$

where $f$ is a scaling function and $\mathcal{I}_{\text{para}}$ carries the non-reflexive
identity conditions. Value update via a completely positive trace-preserving (CPTP)
channel $\mathcal{E}$ (instead of a softmax-weighted linear sum):

$$\rho_{\text{out}_i} = \mathcal{E}\!\left( \sum_j \mathcal{S}_{i,j}\, \rho_{V_j} \right).$$

## Complexity / the exponential wall

| Object | Classical cost | Notes |
| --- | --- | --- |
| Pure state of $n$ qubits | $2^n$ complex amplitudes | state vector |
| Density matrix of $n$ qubits | $2^n \times 2^n$ ($\sim 4^n$ params) | mixed states + operations |
| Matrix product state (MPS), bond dim $D$ | $\mathcal{O}(n\,d\,D^2)$ | $d$ = local (physical) dimension |

MPS makes cost **polynomial** in $n$ and $D$ rather than exponential — the core "cheat,"
valid when effective entanglement stays below the bond dimension $D$.

## Object-language / metalanguage correspondence

| Layer | Classical Transformer | PQAN |
| --- | --- | --- |
| Object language (discrete) | tokens, positions | graph nodes/labels/formulas, layers |
| Metalanguage (continuous) | weights, dot products, softmax | assertion degrees, fidelity/para-identity metrics, CPTP maps, tensor-network contractions |
| Representation | $\mathbb{R}^d$ vectors | density matrices / tensor-network states |
| Context mixing | weighted linear sum | entanglement-based (tensor products + contraction) |
| Ambiguity | averaged into one vector | explicit gluts (superposed mixed states) |
| Unknowns | forced guess | genuine paracomplete gaps until measurement |

## Substructural ↔ quantum correspondence

| Dropped structural rule | Classical reading | Quantum analogue |
| --- | --- | --- |
| Contraction | copy an assumption freely | **no-cloning** |
| Weakening | discard an assumption freely | **no-deleting** |
