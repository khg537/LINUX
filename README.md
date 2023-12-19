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

##문자열 치환시 매번 확인하는 옵션 (c)

:%s/apple/banana/c

## IP 포트 출력
    /*Bind created socket_desc to SCTP Port*/
	char ipbuf[INET_ADDRSTRLEN] = {0,};
	memset(ipbuf, 0x00, sizeof(char)*INET_ADDRSTRLEN);
	//inet_ntop(AF_INET, &(selfENBServerAddr.sin_addr), ipbuf, INET_ADDRSTRLEN);
	strcpy(ipbuf, inet_ntoa(selfENBServerAddr.sin_addr));
	RRC_F1AP_TRACE(F1AP_INFO, " Server bind ip address: %s", ipbuf);		
	RRC_F1AP_TRACE(F1AP_INFO, " Server bind addr , port: %d", ntohs(selfENBServerAddr.sin_port));


23:31:17.103110 Info     0   65535 f1ap_open_sctp_server_ipv4(693):  Server bind ip address: 172.16.255.255
23:31:17.103111 Info     0   65535 f1ap_open_sctp_server_ipv4(694):  Server bind addr , port: 38473

============================
01:35:41.495610 Info     0   0     duoam_mac_intf_msg_handler(9325): Received MAC_DUOAM_SCHEDULER_PARAMS_RESP
01:35:41.495615 Info     0   0     duoam_mac_intf_msg_handler(9372): Cell Index is 0
01:35:41.495682 Info     0   0     gnb_duoam_il_send_duoam_dumgr_cell_config_req(5688): Src(20)->Dst(21):DUOAM_DUMGR_CELL_CONFIG_REQ
01:35:41.496108 Info     0   0     dumgr_check_cspl_header(660): [RECV] [MODULE:DUOAM_MODULE_ID(20)] [API:DUOAM_DUMGR_CELL_CONFIG_REQ(4)] [SIZE:2309] [CELL_INDEX:0]
01:35:41.496758 Info     0   0     dumgr_dcpm_duoam_process_msg(8089): Received DUOAM_DUMGR_CELL_CONFIG_REQ: cell_index=0 nrCellID=00 00 00 d0 50
01:35:41.516994 Detailed 0   0     dcellm_fsm_cell_config_req_handler(14216): Successfully sent DUMGR_MAC_CELL_CONFIG_REQ to MAC
01:35:41.516999 Info     0   0     dumgr_send_message(351): [SEND] [MODULE:RLC_MODULE_ID(23)] [API:DUMGR_RLC_CELL_CONFIG_REQ(0)] [SIZE:39] [CELL_INDEX:0]
01:35:41.516994 Detailed 0   0     dcellm_fsm_cell_config_req_handler(14217): Sending DUMGR_RLC_CELL_CONFIG_REQ to RLC
01:35:41.536668 Info     0   0     dumgr_check_cspl_header(660): [RECV] [MODULE:RLC_MODULE_ID(23)] [API:RLC_DUMGR_CELL_CONFIG_RESP(1)] [SIZE:35] [CELL_INDEX:0]
01:35:41.697032 Detailed 0   0     dumgr_dcpm_mac_process_msg(8848): Received MAC_DUMGR_CELL_CONFIG_RESP
01:35:41.697044 Info     0   0     gnb_duoam_il_send_dumgr_duoam_cell_config_resp(29905): Src(21)->Dst(20):DUMGR_DUOAM_CELL_CONFIG_RESP
01:35:41.697106 Info     0   0     dumgr_check_cspl_header(660): [RECV] [MODULE:DUMGR_DCPM_MODULE_ID(11)] [API:DCPM_DF1AP_F1_SETUP_REQ(65)] [SIZE:45960] [CELL_INDEX:0]
01:35:46.738446 Detailed 0   0     df1ap_fsm_process_event(3466): Calling CellM FSM with State[DF1AP_W_FOR_F1_SETUP_RESP] and Event[DF1AP_F1_SETUP_RESP_RCVD]
01:35:46.880990 Info     0   0     dumgr_f1ap_handle_messages_from_cu(2470): GNB_CU_CONFIGURATION_UPDATE received from CU
01:35:46.897414 Info     0   0     dumgr_send_message(351): [SEND] [MODULE:MAC_MODULE_ID(22)] [API:DUMGR_MAC_CELL_START_(19)] [SIZE:554] [CELL_INDEX:0]
01:35:46.909500 Info     0   0     dumgr_check_cspl_header(660): [RECV] [MODULE:MAC_MODULE_ID(22)] [API:MAC_DUMGR_CELL_START_RESP(3)] [SIZE:36] [CELL_INDEX:0]
01:35:46.909533 Info     0   0     dumgr_send_message(351): [SEND] [MODULE:DUMGR_DF1AP_MODULE_ID(12)] [API:DCPM_DF1AP_CU_CONFIG_UPDATE_RESP(75)] [SIZE:236] [CELL_INDEX:0]
01:35:46.910261 Info     0   0     dumgr_df1ap_dcpm_process_msg(1146):  Received API: DCPM_DF1AP_DU_CONFIG_UPDATE_REQ from DCPM
01:35:47.004077 Brief    0   0     df1ap_fsm_du_config_update_resp_handler(2273): DU_CONFIGURATION_UPDATE_ACK decoded Successfully
==============================


 libyang, sysrepo, libnetconf2, netopeer2-server 순으로 설치한다

