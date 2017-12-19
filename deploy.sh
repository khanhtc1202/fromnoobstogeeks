hexo generate
echo "copy travis"
rm ./public/.travis.yml
cp .travis.yml ./public
cp deploy_rsa.enc ./public
echo "deploy..."
hexo deploy
