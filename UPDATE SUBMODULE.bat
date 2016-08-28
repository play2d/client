git submodule update --recursive
git submodule foreach git pull
git add src/gui
git commit -m "updating submodules to master"
git push
pause
