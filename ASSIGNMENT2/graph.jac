# graph.jac
node DirNode {
    has name: str;
    has path: str;
}
node FileNode {
    has name: str;
    has path: str;
    has content: str = "";
}
edge Contains { }