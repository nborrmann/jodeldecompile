folders=($(ls -vdr */ | grep -Po "(?<=jodel-).+(?=/)"))
newj=${folders[0]}
echo $newj

decompiler -k beb457e9-bf5d-4572-a03c-970ef05ff95c -o ~/jodeldecompile/ ~/jodeldecompile/jodel-$newj/apktool/lib/x86/libhmac.so
key=$(sed -n 1128,1143p libhmac.c | tools/ojoc-keyhack/x86/decrypt.sh)
echo "$key" > key_$newj.txt

rm libhmac.*
