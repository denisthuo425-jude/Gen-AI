# ===============================================
# repo_mapper.jac
# Maps repository structure using Python helper
# ===============================================

import utils.repo_tools;  # Python helper for directory scanning

with entry {
    print("🧭 Running Repo Mapper...");

    let repo_path = input("Enter local repo path to map: ");
    let structure = utils.repo_tools.scan_repo(repo_path);

    print(f"✅ Repository structure:\n{structure}");
}
