import os
import json

def scan_repo(path: str):
    """Recursively list all files and folders in a repo"""
    if not os.path.exists(path):
        return f"❌ Path not found: {path}"

    repo_structure = {}
    for root, dirs, files in os.walk(path):
        relative_path = os.path.relpath(root, path)
        repo_structure[relative_path] = {
            "dirs": dirs,
            "files": files
        }

    return json.dumps(repo_structure, indent=2)
