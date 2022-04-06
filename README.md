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
