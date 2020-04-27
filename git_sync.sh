mkdir -p settings > /dev/null 2>&1
# If there is a git repo, then attempt to update
if [ -d settings/.git/ ]; then
  mkdir -p settings/.git/hooks/ > /dev/null 2>&1
  cp git_sync_pre_commit settings/.git/hooks/pre-commit
  chmod +x settings/.git/hooks/pre-commit
  cd settings
  echo "[38;5;208mGit Sync: [0m"
  git pull
  git add * > /dev/null
  git commit -a -m "Settings update"
  git push > /dev/null
fi