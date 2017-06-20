version=$1

if [ $# -eq 0 ]
  then
    folders=($(ls -vdr */ | grep -Po "(?<=jodel-).+(?=/)"))
    version=${folders[0]}
    echo "No version specified, using $version"
fi

if [ ! -f ~/jodeldecompile/jodel-$version/libhmac.c ]; then
    decompiler -k beb457e9-bf5d-4572-a03c-970ef05ff95c -o ~/jodeldecompile/jodel-$version/ ~/jodeldecompile/jodel-$version/apktool/lib/x86/libhmac.so
fi

grep -n "void function_4b7f(void) {" jodel-$version/libhmac.c  -A 30
read -p "enter start and end line number: " start end

key=$(sed -n ${start},${end}p jodel-$version/libhmac.c | tools/ojoc-keyhack/x86/decrypt.sh)
#key=$(sed -n 1157,1172p jodel-$version/libhmac.c | tools/ojoc-keyhack/x86/decrypt.sh)
echo "$key" > jodel-$version/key.txt

