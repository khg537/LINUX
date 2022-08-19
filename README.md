### vim 설정
sudo vi /etc/vim/vimrc 에 아래 설정 추가

set ts=4\
set background=dark\
set showmatch\

### GUI/TEXT 전환
systemctl set-default multi-user.target
systemctl isolate multi-user.target

systemctl set-default graphical.target
systemctl isolate graphical.target

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


### Open5gs 설정 ###
<< open5gs 설정 >>
//control plane 설정
1. vi /etc/open5gs/amf.yaml
amf: 의 ngap: 에 자기 IP 설정
 
2. systemctl restart open5gs-amfd

//user plane 설정
3. vi /etc/open5gs/upf.yaml 
upf: 의 gtpu: 에 자기 IP 설정

4. systemctl restart open5gs-upfd

5. NAT port Forwarding 
sysctl -w net.ipv4.ip_forward=1 && iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE && systemctl stop ufw && iptables -I FORWARD 1 -j ACCEPT

3. 로그 보기

sudo tail -f /var/log/open5gs/amf.log
sudo tail -f /var/log/open5gs/upf.log

### UERANSIM 설정 ###
config 폴더의
open5gs-gnb.yaml 
open5gs-ue.yaml 
파일을 설정한다.

gnb start 이후 ue실행

Libxml2 (2.9.3) 

yum install -y python-devel
./configure ; make ; make install
cp ./.libs/libxml2.so /usr/lib64/

CUINT
yum install cenos-release-scl-rh
yum install CUnit-devel
cp -r /usr/include/CUnit/* /usr/include/

Libatomic
yum install libatomic

/home/rrc/220818_L1Bypass/STACK/CU/SA/FR1/bin
./execute_cu.sh


