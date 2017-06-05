
version=$1

if [ $# -eq 0 ]
  then
    versions=($(ls -vr apks | grep -Po "(?<=com\.tellm\.android\.app-)(.+)(?=\.apk)"))
    version=${versions[0]}
    echo "No version specified, using $version"
fi

filename="apks/com.tellm.android.app-$version.apk"
filenamejar="com.tellm.android.app-$version.jar"

echo "### DEX2JAR #########"
tools/dex2jar-2.1-SNAPSHOT/d2j-dex2jar.sh $filename -o $filenamejar
echo "### JD-CLI ##########"
tools/jd-cli/jd-cli $filenamejar -od "jodel-$version/jd" -g ERROR
echo "### APKTOOL #########"
apktool d $filename -o "jodel-$version/apktool"
echo "### PARSE API #######"
tools/parse_api.py $version

rm $filenamejar
