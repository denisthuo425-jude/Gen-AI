# ===============================================
# 🧭 Supervisor Agent – Codebase Genius
# Compatible with JacLang v0.8.10
# Uses modern Python import and function call syntax
# ===============================================

import utils.git_tools;   # Import your Python helper module

with entry {
    print("🧭 Code Genius — starting documentation workflow...");

    # Ask user for repository URL
    let repo_url = input("Enter GitHub repository URL: ");
    print(f"📦 Cloning repo: {repo_url}");

    # Call Python function directly
    let result = utils.git_tools.clone_repo(repo_url);

    print(f"✅ Clone result: {result}");
}
