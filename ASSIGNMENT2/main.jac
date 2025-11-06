# ---------------------------------
# main.jac
#
# The main entry point for running
# Codebase Genius.
# ---------------------------------

# 'init' is a special walker that runs automatically
# when we execute `jac run main.jac`
walker init {
    has test_repo_url: str = "https://github.com/jaseci-labs/jac";

    with entry {
        print("[Simulated] Cloning repo from:", test_repo_url, "into ./temp_repo");
        print("[Simulated] Clone complete.");
    }
}