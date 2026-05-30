# Grill With Docs

Interview the user relentlessly about every aspect of the plan or design until
you reach a shared understanding, challenging it against the project's existing
domain model and documented decisions. Walk down each branch of the decision
tree, resolving dependencies between decisions one by one. For each question,
provide your recommended answer.

This is the documentation-aware companion to grill-me: the same relentless
questioning, but every question is grounded in what the project already says,
and resolved terminology and decisions are captured as the session goes.

## Method

- Ask one question at a time, waiting for the answer before continuing.
- Resolve dependencies in order: settle the decision a later choice rests on
  before asking about that later choice.
- For every question, state your recommended answer and the reasoning behind it.
- If a question can be answered by exploring the codebase, explore it instead of
  asking.
- Keep going until every branch is resolved and no ambiguity remains.

## Domain Awareness

While exploring the codebase, also locate the project's documentation.

Most repos have a single context: a root `CONTEXT.md` glossary, with decision
records under `docs/adr/`.

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts, and
the map points to where each one lives (typically a `CONTEXT.md` and `docs/adr/`
under each context's directory).

Create files lazily — only when there is something to write. If no `CONTEXT.md`
exists, create one when the first term is resolved. If no `docs/adr/` exists,
create it when the first ADR is needed.

## During The Session

- Challenge against the glossary: when a term conflicts with the existing
  language in `CONTEXT.md`, call it out immediately ("Your glossary defines
  'cancellation' as X, but you seem to mean Y — which is it?").
- Sharpen fuzzy language: when a term is vague or overloaded, propose a precise
  canonical term ("You're saying 'account' — do you mean the Customer or the
  User? Those are different things.").
- Discuss concrete scenarios: stress-test domain relationships with specific
  scenarios that probe edge cases and force precision about the boundaries
  between concepts.
- Cross-reference with code: when the user states how something works, check
  whether the code agrees, and surface contradictions ("Your code cancels
  entire Orders, but you just said partial cancellation is possible — which is
  right?").
- Update `CONTEXT.md` inline: capture each resolved term as it happens, don't
  batch them. Keep `CONTEXT.md` a pure glossary, free of implementation
  details — it is not a spec, a scratch pad, or a home for implementation
  decisions.
- Offer ADRs sparingly: only when the decision is hard to reverse, surprising
  without context, and the result of a real trade-off. If any of the three is
  missing, skip it.

## Reference Loading

Load the format reference when writing the corresponding file:

- `references/context-format.md`: structure and rules for `CONTEXT.md` and
  `CONTEXT-MAP.md`, plus single- vs multi-context layout.
- `references/adr-format.md`: ADR template, numbering, optional sections, and
  the criteria for when a decision deserves an ADR.
