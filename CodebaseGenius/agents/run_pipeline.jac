# ===============================================
# run_pipeline.jac
# Full workflow orchestration
# ===============================================

import repo_mapper;
import code_analyzer;
import doc_genie;

with entry {
    print("🧭 Starting full Codebase Genius workflow...");

    # Map repo
    let mapper = repo_mapper.RepoMapper();
    mapper.repo_path = input("Enter local repo path to map: ");
    mapper.map_repo();
    # Analyze repo
    let analyzer = code_analyzer.CodeAnalyzer();
    analyzer.repo_path = mapper.repo_path;
    analyzer.analyze_repo();

    # Generate documentation
    let docgenie = doc_genie.DocGenie();
    docgenie.repo_path = mapper.repo_path;
    docgenie.generate_docs();

    print("✅ Full workflow completed successfully!");
}
