# ---------------------------------
# agents.jac
#
# Defines all the walkers (agents).
# ---------------------------------

# --- THIS IS THE FIX ---
# This is the correct Jaclang (Python-style)
# syntax for importing Python modules.
import git;
import os;

# This is the correct syntax for importing
# from our other 'graph.jac' module.
from graph import DirNode, FileNode, Contains;


# --- Agent 1: The Repo Mapper ---
walker RepoMapper {
    has repo_url: str;
    has target_dir: str = "./temp_repo";

    can clone_repo {
        if os.path.exists(self.target_dir):
            print(f"Directory {self.target_dir} already exists. Skipping clone.");
        else:
            print(f"Cloning {self.repo_url} into {self.target_dir}...");
            try {
                git.Repo.clone_from(self.repo_url, self.target_dir);
                print("...Clone complete.");
            } catch by Exception as e {
                print(f"Error cloning repo: {e}");
            }
        }
    }
}