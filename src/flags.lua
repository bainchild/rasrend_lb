!(
    build = {
        environment=os.getenv("build_environment");
        hash=popen("git show-ref")
    }
)