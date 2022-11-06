!(
    @@"pp/utils.lua"
    build = {
        branch=popen("git rev-parse --abbrev-ref HEAD"):sub(1,-2);
        hash=popen("git log -1 --format=%h"):sub(1,-2);--string_split(popen("git show-ref"),"%s")[1];
        last_commit=popen("git log -1 --format=%cd"):sub(1,-2);
        build_date=os.date("%a %b %d %X %Y");
    }
)