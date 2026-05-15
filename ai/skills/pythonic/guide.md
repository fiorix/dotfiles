# Pythonic

Write modern, typed, idiomatic Python. Push work to the right engine: SQL for
sets, NumPy/pandas for vectorized data work, asyncio for I/O concurrency.

## Code

- Type public function signatures and complex data structures.
- Use dataclasses for internal structured data.
- Use Pydantic at validation boundaries when the project already uses it or the
  boundary is complex enough to justify it.
- Prefer context managers for files, sockets, database connections, and temp
  resources.
- Catch specific exceptions and re-raise with context.

## Async

- Use `asyncio.TaskGroup` on Python 3.11+ for structured concurrency.
- Track created tasks; avoid fire-and-forget.
- Do not confuse CPU-bound work with I/O concurrency.

## Data And SQL

- Validate shape and types at pipeline boundaries.
- Prefer vectorized pandas/NumPy operations over row-wise `apply`.
- Push filtering and aggregation into SQL before loading DataFrames.
- Use parameterized SQL. Never format user input into SQL strings.

## Verification

- Use project tooling first: `pytest`, `ruff`, `mypy`, `uv`, or equivalents.
- Add focused tests for bug fixes, parsing boundaries, and error paths.

