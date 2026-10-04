"""Minimal queue worker used by the history fixture."""


def retry_delay(attempt: int) -> int:
    """Return the bounded retry delay in seconds."""
    return min(60, 2 ** max(0, attempt))
