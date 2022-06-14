### vim 설정
sudo vi /etc/vim/vimrc 에 아래 설정 추가

set ts=4\
set background=dark\
set showmatch\

### ubuntu 검은화면 해결책
sudo apt-get purge lightdm

sudo apt-get update

sudo apt-get install lightdm

=> graphic 화면 에서 lightdm 선택

dpkg-reconfigure lightdm

sudo reboot

### Docker 설치
sudo apt install -y docker.io nfs-common dnsutils curl

### Docker compose 설치
sudo apt update \
OCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker} \
mkdir -p $DOCKER_CONFIG/cli-plugins \
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose \
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose \
docker compose version

