
if [ $# -eq 0 ];then
	echo "You need provide the kernel version!"
	exit
fi

version=$1
dirc=${version#linux-}
dirc=v${dirc:0:3}
#site=http://www.snowbird.lkams.kernel.org/pub/linux/
site=http://www.soc.lkams.kernel.org/pub/linux/
#ftp://ftp.cn.kernel.org/pub/linux/
echo geting the file from $dirc/$version.tar.bz2

wget -c ${site}/kernel/${dirc}/linux-${version}.tar.bz2
