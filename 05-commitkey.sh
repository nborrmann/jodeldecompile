folders=($(ls -vdr */ | grep -Po "(?<=jodel-).+(?=/)"))
version=${folders[0]}
key=$(cat "jodel-$version/key.txt")

rm -r ~/jodeldecompile/jodel_api
hub clone https://github.com/nborrmann/jodel_api.git
cd jodel_api

git checkout -b api-key
sed -ri "s:version = '(.+?)':version = '$version':" src/jodel_api/jodel_api.py
sed -ri "s:secret = '[a-zA-Z]{40}':secret = '$key':" src/jodel_api/jodel_api.py
sed -ri 's:(      version=.[0-9]+\.[0-9]+\.)([0-9]+)(.):echo "\1$((\2+1))\3":ge' setup.py

hub diff

hub commit -am "api key for version $version"

branch=api-key-$(echo $version | sed -s "s/\./-/g")
echo $branch
hub push origin api-key

hub pull-request -m "api key for version $version"

rm -r ~/jodeldecompile/jodel_api
