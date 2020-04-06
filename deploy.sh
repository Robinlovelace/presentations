git status

git status
git add -A
git commit -am 'Update presentations'
git push

cp -v *.html ~/blog/robinlovelace.github.io/presentations
cp -Rv libs/* ~/blog/robinlovelace.github.io/presentations/libs/
cp -Rv *_files/* ~/blog/robinlovelace.github.io/presentations/
cd ~/blog/robinlovelace.github.io/presentations
git status
git add -A
git commit -am 'Update presentations'
git push
cd -
