# This is a script for uncompress compressed files with various tools
#!/bin/sh

compress_f=$1
suffix=`expr match "$compress_f" '.*\(\..*\)'`

case $suffix in
    .gz)
        suffix=`expr match "$compress_f" '.*\(\..*\..*\)'`
        if [[ "$suffix" == ".tar.gz" ]];then
            tar -zxvf ${compress_f}
        else
            gunzip ${compress_f}
        fi;;
    .tgz)
        tar -zxvf ${compress_f};;
    .tar)
        tar -xvf ${compress_f};;
    .bz|.bz2)
        suffix=`expr match "$compress_f" '.*\(\..*\..*\)'`
        if [[ "$suffix" == ".tar.bz2" ]];then
            tar -jxvf ${compress_f}
        else
            bunzip2 ${compress_f}
        fi;;
    .Z)
        suffix=`expr match "$compress_f" '.*\(\..*\..*\)'`
        if [[ "$suffix" == ".tar.Z" ]];then
            tar -Zxvf ${compress_f}
        else
            uncompress ${compress_f}
        fi;;
    .zip)
        unzip ${compress_f};;
    .rar)
        rar a ${compress_f};;
    .lha)
        lha -e ${compress_f};;
    .rpm)
        rpm2cpio ${compress_f} | cpio -div;;
    .deb)
        ar p ${compress_f} data.tar.gz | tar zxf - ;;
    *)
        echo "The compress type is unknown!";;
esac

exit 0
