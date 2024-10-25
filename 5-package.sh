
# include common
source common.sh

echo
echo "package start"
echo "****************************************************"

echo
echo "1. export jfrog images"
echo "----------------------------------------------------"

JFROG_IMAGES_PATH=$DOWNLOAD_DIR_JFROG/jfrog-images.tar
echo "check exported jfrog & kube-system images"
du -sh $JFROG_IMAGES_PATH

echo "export jfrog images? (y/n)"
read -r choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "export jfrog images, please wait ..."
    # helm install jfrog helps us pull the images, no need to install docker to do that
    JFROG_IMAGES_NAME=`kubectl get pods -n jp -o jsonpath="{..image}"`
    ctr images export $JFROG_IMAGES_PATH $JFROG_IMAGES_NAME
else
    echo "not to export"
fi
du -sh $JFROG_IMAGES_PATH


KFS_PACKAGE_PATH=~/kfs.tar.gz
echo
echo "2. package kfs to $KFS_PACKAGE_PATH"
echo "----------------------------------------------------"

cd $APP_DIR
cd ..    

echo "include k3s data dir? (y/n)"
read -r choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    tar -czvf $KFS_PACKAGE_PATH $APP_DIR
else
    echo "not to include"
    tar --exclude=$K3S_DATA_DIR -czvf $KFS_PACKAGE_PATH $APP_DIR
fi

du -sh $KFS_PACKAGE_PATH

echo
echo "package end"
echo "****************************************************"

# upload to another server to test (private ip is fast)
# e.g.
# scp ~/kfs.tar.gz root@172.24.28.130:/root/




