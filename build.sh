

# kernel nessary
sudo apt-get install gcc kernel-package libc6-dev tk8.6 libncurses5-dev fakeroot bin86 libssl-dev build-essential

# linuxcnc nessary
sudo apt-get install libudev-dev libmodbus-dev libusb-1.0-0-dev \
	libglib2.0-dev libgtk2.0-dev yapps2 intltool tcl8.4-dev tk8.4-dev \
       bwidget libtk-img libtk-img-dev tclx8.4-dev python-gtk2 \
       python-tk libreadline-gplv2-dev libboost-python-dev \
       libgl1-mesa-dev libglu1-mesa-dev libxmu-dev python-gi

# 1. Fetch necessary code

# Fetch xenomai
if [ ! -f xenomai-3.0.6.tar.bz2 ]; then
wget https://xenomai.org/downloads/xenomai/stable/xenomai-3.0.6.tar.bz2
fi

# Fetch ipipe
if [ ! -f ipipe-core-4.4.43-x86-8.patch ]; then
wget https://xenomai.org/downloads/ipipe/v4.x/x86/ipipe-core-4.4.43-x86-8.patch
fi

# Fetch kernel
if [ ! -f linux-4.4.43.tar.gz ]; then
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.4.43.tar.gz 
fi

# Fetch linuxcnc
if [ ! -f v2.7.14 ]; then
wget https://codeload.github.com/LinuxCNC/linuxcnc/tar.gz/v2.7.14
fi

if [ ! -d xenomai-3.0.6 ]; then
tar xjf xenomai-3.0.6.tar.bz2
fi

if [ ! -d linux-4.4.43 ]; then
tar xf linux-4.4.43.tar.gz 
fi

if [ ! -d linuxcnc-2.7.14 ]; then
tar xf v2.7.14
fi 


if [ ! linux-4.4.43/build ]; then
    mkdir linux-4.4.43/build
fi

if [ ! xeno-build ]; then
    mkdir xeno-build
fi


# 2. Compile kernel

# Patch kernel
xenomai-3.0.6/scripts/prepare-kernel.sh --linux=linux-4.4.43 --ipipe=ipipe-core-4.4.43-x86-8.patch --arch=x86

pushd linux-4.4.43
# compile kernel
#arith OK
#bufp skipped (no kernel support)
#cpu_affinity skipped (no kernel support)
#iddp skipped (no kernel support)
#leaks OK
#net_packet_dgram skipped (no kernel support)
#net_packet_raw skipped (no kernel support)
#net_udp skipped (no kernel support)
#posix-clock.c:420, assertion failed: diff < 1000000000
#posix_cond OK
#posix_fork OK
#mutex_trylock not supported
#posix_mutex OK
#posix_select OK
#rtdm skipped (no kernel support)
#sched_quota skipped (no kernel support)
#sched_tp skipped (no kernel support)
#setsched OK
#sigdebug skipped (no kernel support)
#timerfd OK
#tsc OK
#vdso_access OK
#xddp skipped (no kernel support)
# make xconfig/gconfig/menuconfig
make mrproper
#make O=build oldconfig
#make O=build bzImage modules
#make O=build dep
#sudo make O=build modules_install
#sudo make O=build install
make-kpkg clean
cp ../x86rt_config .config
fakeroot make-kpkg --initrd --append-to-version=-custom -j4 kernel_image kernel_headers
make-kpkg O=../build kernel_image kernel_headers

#pushd /lib/modules/4.4.43
#sudo update-initramfs –c –k 4.4.43
#sudo update-grub
#popd
popd
sudo dpkg -i linux-*-4.4.43-xenomai-3.0.6*.deb


# reboot enter rt-linux
# 3. compile xenomai

# --enable-dlopen-libs   allow dlopen() the libcobalt.so.2
#mkdir xeno-build
#pushd xeno-build
#../xenomai-3.0.6/configure --with-core=cobalt --enable-smp --enable-pshared --host=i686-linux --enable-dlopen-libs
#sudo make install
#update the so directory
#echo /usr/xenomai/lib > /etc/ld.so.conf.d/xenomai.conf
#sudo ldconfig
#popd


# reboot
# 4. compile linuxcnc

#pushd linuxcnc-2.7.14
#pushd debian/
#configure uspace
#popd
#dpkg-buildpackage -b -uc
#popd

#pushd linuxcnc-dev
#./autogen.sh
#./configure --with-realtime=uspace XENOMAI_CONFIG=/usr/xenomai/bin/xeno-config
#make
#sudo make setuid
#popd

#命令行参数添加孤立cpu。
#修改/boot/grub/grub.conf文件，比如孤立cpu5~8核（cpu id对应4~7），添加isolcpus=4,5,6,7至内核命令行，逗号分隔。
# isolcpus=2,3 xenomai.supported_cpus=0xc
#孤立某一个内核后，让linuxcnc的调度过程运行在此内核上面

