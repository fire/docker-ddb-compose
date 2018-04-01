```bash
# https://stackoverflow.com/questions/1683531/how-to-import-existing-git-repository-into-another
git remote add proxy_remote https://github.com/dalmatinerdb/docker-ddb_proxy.git
git fetch proxy_remote
git merge -s ours --no-commit proxy_remote/master --allow-unrelated-histories
git read-tree --prefix=proxy/ -u proxy_remote/master
git commit -m "Imported proxy as a subtree."
```