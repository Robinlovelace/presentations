git status
git add -A
git commit -am 'Update presentations'
git push

cp -v *.html ~/robinlovelace/static/presentations
cp -Rv libs/* ~/robinlovelace/static/presentations/libs/
cp -Rv *_files ~/robinlovelace/static/presentations/
cd ~/robinlovelace/
git status
git add -A
git commit --no-verify -am 'Update presentations'
git push
cd -
