import sys, os

# Get project root (one level up from current utils folder)
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Add to sys.path if not already present
if ROOT_DIR not in sys.path:
    sys.path.append(ROOT_DIR)

print(f"[PathSetup] Added project root to sys.path: {ROOT_DIR}")
