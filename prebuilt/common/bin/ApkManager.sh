#!/system/bin/sh
# ApkManager.sh v0.5
me=$0
applist=/dev/appslist.txt
printmsg ()
{
ml=`echo -e $1|wc -L`
hf=""
for i in `seq $ml`;do
        hf="${hf}="
done
echo -e $1|busybox awk -v hf=$hf 'BEGIN{print hf};END{print hf};{print $0};'
###########^^^^^^^ keep that, makes testing on pc easy
return
}
recoverycheck ()
{
if [ "`ls /sbin|grep -q recovery;echo $?`" = "0" ];
then
    mount -a > /dev/null
    recoverymode=y
else
    recoverymode=n
        rootcheck
fi
return
}
rootcheck ()
{
if [ "`busybox id -u`" != "0" ];
then
    echo -e "root is required to run this script\ntype\nsu\nand then run again"
    exit 1
fi
return
}
internallinks ()
{
# make sure we have dir and links for internel apps
for dir in app_i app-private_i;do
        if [ ! -e /data/${dir} ];
        then
                install -m 771 -o 1000 -g 1000 -d /data/${dir}
        fi
        for apk in `find /data/${dir} -type f`;do
                ln -sf $apk `dirname $apk|sed -e s/data/sd-ext/ -e s/_i//`/`basename $apk`
        done
done
return
}
movefroyocfg ()
{
if [ "`mount|grep -c \"/mnt/asec/\"`" != "0" ];
then
        printmsg "move FroYo FAT installed apps to /sd-ext? (y/n)\nit can be a little slow, so if your in a rush\nthen answer n, you can always run the script again later"
        read a
        if [ "$a" = "n" ];
        then
                printmsg "FroYo FAT 2 sd-ext will be skipped"
                froyo2sdext=n
        elif [ "$a" = "y" ];
        then
                printmsg "FroYo fat apps will be moved to sd-ext"
                froyo2sdext=y
        else
                printmsg "please enter y or n"
                movefroyocfg
        fi
fi
return
}
fat2ext ()
{
for apk in `find /mnt/asec/ -type d|grep -v asec/\$`;do
        echo "moving `basename ${apk}.apk`"
        if [ -e /mnt/secure/asec/smdl2tmp1.asec ];
        then
                rm /mnt/secure/asec/smdl2tmp1.asec
        fi
        time pm install -f -r ${apk}/pkg.apk
done
return
}

menu ()
{
if [ "$recoverymode" = "y" ];
then
        return
fi
find /data/app_i /data/app-private_i /sd-ext/app /sd-ext/app-private -type f -name "*apk" -exec ls -lh {} \; \
|awk 'sub(/\/sd-ext/,"sdext /sd-ext") sub(/\/data/,"Data /data") ( ++c ) {print "["c"] \t"$9"\t"$5"\t"$10};' > $applist
apkcount=`sed -n '$=' $applist`
if [ "$apkcount" = "" ];
then
        printmsg "no apps to manage yet"
        return
fi
#awk 'sub(/\/.+ap.+\//,"") sub(/-.\.apk/,"")' $applist
#show the silly froyo number thing
#awk 'sub(/\/.+ap.+\//,"") sub(/\.apk/,"")' $applist
# better formating
awk '{sub(/\/.+ap.+\//,"") sub(/\.apk/,"")};{printf "%5s %-5s %8s %s",$1,$2,$3,$4"\n"}' $applist
dataAvailable=`df |awk '/\ \/data$/ {print $4}'`
sdextAvailable=`df |awk '/\/sd-ext$/ {print $4}'`
dataAvailable4human=`echo $dataAvailable|awk '{printf "%7.1f" "%c",$1/1024,"M"}'`
sdextAvailable4human=`echo $sdextAvailable|awk '{printf "%7.1f" "%c",$1/1024,"M"}'`
printmsg "Available space on\n/data = $dataAvailable4human\t/sd-ext = $sdextAvailable4human"
printmsg "List the app numbers you wish to move\neg:10 12 45\nor use 'keyword'\ne.g. swype twit\nquit to exit"
#Toggle
BetterToggle
return
}

BetterToggle ()
{
#START BetterToggle functions
BToggle ()
{
#       for app in $toggle;do
        for app in $@;do
        test=`echo $app|awk '{if ( int($1) == 0 )
            ( $1 = $1 )
        else
                ( $1 = "\\\["$1"\\\]")}
                        {print}'`
        apps2move=$(awk '/'$test'/ {print $4 };' $applist)
        if [ "`echo $apps2move |wc -w`" -gt "1" ];
        then
#               awk '/'$test'/ {print $0 };' $applist
awk '{sub(/\/.+ap.+\//,"") sub(/\.apk/,"")};/'$test'/ {printf "%5s %-5s %8s %s",$1,$2,$3,$4"\n"}' $applist
                echo "More than one app in \"$app\" filter"
                echo "do you want to toggle all of them (y/n)"
                ConfirmFilter

        elif [ "`echo $apps2move |wc -w`" = "0" ];
        then
                echo "no apps found in \"$app\" filter"
        fi
        move="$(echo $move `awk '/'$test'/ {print $4 };' $applist`)"
        done
        return
}
ConfirmFilter ()
{
        read a
        if [ "$a" = "y" ]
        then
                echo "ok, will toggle them all"
                return
        elif [ "$a" = "n" ]
        then
                RedefineFilter
        else
                echo "please Answer y or n"
                ConfirmFilter
        fi
        return
}
RedefineFilter ()
        {
        toggle=`echo toggle|sed s/$app//`
        echo "please enter numbers or new filter"
        read minitoggle
        toggle=`echo $toggle $minitoggle`
        BToggle `echo $minitoggle`
        return
}
# END BetterToggle functions
move=""
if [ "$#" = "0" ];
then
    read toggle
        if [ "$toggle" = "quit" ];
        then
                return
        fi
        BToggle `echo $toggle`
else
    BToggle `echo $toggle`
fi
toData=""
toSdext=""
for app in $toggle;do
test=`echo $app|awk '{if ( int($1) == 0 )
            ( $1 = $1 )
        else
            ( $1 = "\\\["$1"\\\]")}
            {print}'`
    toSdext="${toSdext} `awk '/'$test'/ {print $4}' $applist|grep -v \/data\/`"
    toData="${toData} `awk '/'$test'/ {print $4}' $applist|grep -v \/sd-ext\/`"
    intcount=`echo $toData|sed s/\ /"\n"/g|grep sd-ext|sed -n '$='`
done
moveapps
menu
return
}
moveapps ()
{
for i in toSdext toData;do
        eval files=\$${i}
        if [ "`echo $files|grep -q apk;echo $?`" != "0" ];
        then
                eval ${i}Size=0
        else
                eval ${i}Size=`du -c $files|awk '/total/ {print $1}'`
        fi
done
# thanks to Mister Opinion
# http://forum.cyanogenmod.com/user/34339-mister-opinion/
# for point bug out http://forum.cyanogenmod.com/topic/2636-froyo-apps2sdext-2010-08-12-new-v12-include-apkmanager/page__view__findpost__p__40320
dataAvailable=`df |awk '/\ \/data$/ {print $4}'`
sdextAvailable=`df |awk '/\/sd-ext$/ {print $4}'`

datapostmove=`expr $dataAvailable - \( $toDataSize - $toSdextSize \)`
sdextpostmove=`expr $sdextAvailable - \( $toSdextSize - $toDataSize \)`

if [ "$datapostmove" -lt "10240" ];
then
        printmsg "It looks like free space on data is going to fall below 10mb\nare you sure you want to continue? (y/n)"
        read a
        if [ "$a" = "y" ];
        then
                printmsg "OK, continuing"
        else
                printmsg "will skip moving apps to internal"
                movetointernal=n
        fi
fi

if [ "$sdextpostmove" -lt "0" ];
then
        printmsg "not going to have enough space on sd-ext\nskipping"
        movetosdext=n
fi
#make sure we don't have duplicates
for app in $move;do
        move="$app `echo $move|sed s~$app~~g`"
done
for app in $move;do
        app=`basename $app`
        location=`awk '/'$app'/ {print $2}' $applist`
        apk=`awk '/'$app'/ {print $4}' $applist`
        if [ "$location" = "Data" ];
        then
                if [ "$movetosdext" != "n" ];
                then
                        echo "moving ${apk}..."
                        find `dirname $apk|sed -e s/data/sd-ext/ -e s/_i//` -type l -name "`basename $apk`" -exec rm {} \;
                mv $apk `dirname $apk|sed -e s/data/sd-ext/ -e s/_i//`/
                        if [ "$?" != "0" ];
                        then
                                echo "moving $apk failed.. relinking."
                                ln -s $apk `dirname $apk|sed -e s/data/sd-ext/ -e s/_i//`/`basename $apk`
                        fi
                fi
        elif [ "$location" = "sdext" ];
        then
                if [ "$movetointernal" != "n" ];
        then
                        echo "moving ${apk}..."
                        mv $apk `dirname $apk|sed s/sd-ext/data/`_i/
                        if [ "$?" != "0" ];
                        then
                                echo "moving $apk failed... not preformining link"
                        else
                                ln -sf `echo $apk|sed -e 's/sd-ext/data/' -e 's~/~_i/~3'` `dirname $apk`/
                        fi
                fi
        else
                return
        fi
done
return
}
recoverycheck
if [ "$recoverymode" = "n" ];
then
        movefroyocfg
        if [ "$froyo2sdext" = "y" ];
        then
                fat2ext
        fi
else
        printmsg "FroYoFat2sdext is not available in recovery"
fi
internallinks
menu
if [ -e "$applist" ];
then
    rm $applist
fi
printmsg "use `basename $me` if you want to manage apps"

