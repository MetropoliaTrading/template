"""
Auto-assign the markers based on a test file's location.

✓ Any collected item whose path contains "tests/unit" → @pytest.mark.unit
✓ Any collected item whose path contains "tests/features" → @pytest.mark.bdd
"""
import os
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

def pytest_sessionfinish(session, exitstatus):
    """Cleanup after tests are done."""
    coverage_file = ".coverage"
    if os.path.exists(coverage_file):
        try:
            os.remove(coverage_file)
            print(f"Removed {coverage_file}")
        except Exception as e:
            print(f"Failed to remove {coverage_file}: {e}")