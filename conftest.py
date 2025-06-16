"""
Auto-assign the markers based on a test file's location.

✓ Any collected item whose path contains "tests/unit" → @pytest.mark.unit
✓ Any collected item whose path contains "tests/features" → @pytest.mark.bdd
"""

from pathlib import Path
import pytest

def pytest_collection_modifyitems(config, items):
    for item in items:
        path = Path(item.fspath)
        parts = {p.lower() for p in path.parts}

        if "unit" in parts:               # tests/unit/…
            item.add_marker(pytest.mark.unit)
        elif "features" in parts:         # tests/features/…
            item.add_marker(pytest.mark.bdd)
