(
folders=($(ls -vdr */ | grep -Po "jodel-.+(?=/)"))
newj=${folders[0]}
oldj=${folders[1]}

echo $newj

colordiff -Nrs -C 2 <(tree "$oldj/jd/com/jodelapp/jodelandroidv3/") <(tree "$newj/jd/com/jodelapp/jodelandroidv3/")
colordiff -Nrs -C 2 <(tree "$oldj/apktool/res") <(tree "$newj/apktool/res")

echo "*** DIFF JodelApi.java ************************************"
colordiff -Nrs -C 3 "$oldj/jd/com/jodelapp/jodelandroidv3/api/JodelApi.java" "$newj/jd/com/jodelapp/jodelandroidv3/api/JodelApi.java"

echo "*** DIFF /api/model ************************************"
colordiff -Nr -C 3 "$oldj/jd/com/jodelapp/jodelandroidv3/api/model" "$newj/jd/com/jodelapp/jodelandroidv3/api/model"

echo "*** DIFF /model ************************************"
colordiff -Nr -C 3 "$oldj/jd/com/jodelapp/jodelandroidv3/model" "$newj/jd/com/jodelapp/jodelandroidv3/model"

echo "*** DIFF /events ************************************"
colordiff -Nr -C 3 "$oldj/jd/com/jodelapp/jodelandroidv3/events" "$newj/jd/com/jodelapp/jodelandroidv3/events"

echo "*** DIFF /values ************************************"
colordiff -Nr -C 3 "$oldj/apktool/res/values" "$newj/apktool/res/values" --exclude "public.xml"
) | less -R
exit $PIPESTATUS
