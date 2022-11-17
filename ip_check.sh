CU_BIN_PATH=$PWD
CU_PATH=$CU_BIN_PATH/..
DU_PATH=$CU_PATH/../gNB_DU

echo "====================================================================="
echo "                 CU Interface                                        "
echo "====================================================================="
declare -a CU_INNER_IP=( "GNB_CU_OAM_IP_ADDRESS"
        "GNB_SON_IP_ADDRESS"
		"GNB_RRM_IP_ADDRESS"
		"GNB_L3_IP_ADDRESS"
#PDCP / GTPU / F1U are the samme
		"GNB_PDCP_IP_ADDRESS"
		"GNB_NGU_IP_ADDRESS"
		"GNB_F1U_CU_IP_ADDRESS"
		)

OAM_PORT="GNB_CU_OAM_RX_PORT"

declare -a SON_PORT=( "GNB_SON_CU_OAM_RX_PORT"
		"GNB_SON_RRM_RX_PORT"
		"GNB_SON_RRC_RX_PORT"
		)     

RRM_PORT="GNB_RRM_RX_PORT"
L3_PORT="GNB_L3_RX_PORT"

declare -a PDCP_PORT=( "GNB_PDCP_RX_PORT"
		"GNB_PDCP_NGU_DL_RX_PORT"
		"GNB_PDCP_F1U_UL_RX_PORT"
		)     

declare -a NGU_PORT=("GNB_NGU_RX_PORT"
		"GNB_NGU_PDCP_RX_UL_PORT"
		"GNB_NGU_F1U_RX_UL_PORT"
		)		

declare -a F1U_PORT=("GNB_F1U_CU_RX_PORT"
			"GNB_F1U_PDCP_RX_UL_PORT"
			"GNB_F1U_NGU_RX_DL_PORT"
		)

echo "<gNodeB_CU_Configuration.cfg>"
echo ""

for IP in "${CU_INNER_IP[@]}"
do
    IPADDR=`grep $IP $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$IP=$IPADDR"
done

PORT=`grep $OAM_PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
echo "$OAM_PORT=$PORT"

for PORT in "${SON_PORT[@]}"
do
    PORTNUM=`grep $PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done

PORT=`grep $RRM_PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
echo "$RRM_PORT=$PORT"

PORT=`grep $L3_PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
echo "$L3_PORT=$PORT"

for PORT in "${PDCP_PORT[@]}"
do
    PORTNUM=`grep $PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done

for PORT in "${NGU_PORT[@]}"
do
    PORTNUM=`grep $PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done

for PORT in "${F1U_PORT[@]}"
do
    PORTNUM=`grep $PORT $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done


echo ""
echo "<Proprietary_gNodeB_CU_Data_Model.xml>"
echo ""

TMP=`grep -n du_CommInfo  $CU_PATH/cfg/Proprietary_gNodeB_CU_Data_Model.xml | cut -d ":" -f1 | awk 'NR==1'`
let result=$TMP+2

DU_INTERFACE_IP=`sed -n "${result}p" ../cfg/Proprietary_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "DU Interface IP from CU = $DU_INTERFACE_IP"


echo ""
echo "<TR196_gNodeB_CU_Data_Model.xml>"
echo ""
### EGTPU_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==2'`
let EGTPU_LOCAL_IP_ADDRESS_LINE=$TMP-3
EGTPU_LOCAL_IP_ADDRESS=`sed -n "${EGTPU_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "EGTPU_LOCAL_IP_ADDRESS = $EGTPU_LOCAL_IP_ADDRESS"

let PORT_LINE=EGTPU_LOCAL_IP_ADDRESS_LINE+4
EGTPU_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "EGTPU_LOCAL_IP_PORT = $EGTPU_LOCAL_IP_PORT"

### F1AP_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==3'`
let F1AP_LOCAL_IP_ADDRESS_LINE=$TMP-3
F1AP_LOCAL_IP_ADDRESS=`sed -n "${F1AP_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "F1AP_LOCAL_IP_ADDRESS = $F1AP_LOCAL_IP_ADDRESS"

let PORT_LINE=F1AP_LOCAL_IP_ADDRESS_LINE+4
F1AP_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "F1AP_LOCAL_IP_PORT = $F1AP_LOCAL_IP_PORT"

### F1U_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==4'`
let F1U_LOCAL_IP_ADDRESS_LINE=$TMP-3
F1U_LOCAL_IP_ADDRESS=`sed -n "${F1U_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "F1U_LOCAL_IP_ADDRESS = $F1U_LOCAL_IP_ADDRESS"

let PORT_LINE=F1U_LOCAL_IP_ADDRESS_LINE+4
F1U_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "F1U_LOCAL_IP_PORT = $F1U_LOCAL_IP_PORT"

### X2AP_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==5'`
let X2AP_LOCAL_IP_ADDRESS_LINE=$TMP-3
X2AP_LOCAL_IP_ADDRESS=`sed -n "${X2AP_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "X2AP_LOCAL_IP_ADDRESS = $X2AP_LOCAL_IP_ADDRESS"

let PORT_LINE=X2AP_LOCAL_IP_ADDRESS_LINE+4
X2AP_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "X2AP_LOCAL_IP_PORT = $X2AP_LOCAL_IP_PORT"

### X2U_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==6'`
let X2U_LOCAL_IP_ADDRESS_LINE=$TMP-3
X2U_LOCAL_IP_ADDRESS=`sed -n "${X2U_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "X2U_LOCAL_IP_ADDRESS = $X2U_LOCAL_IP_ADDRESS"

let PORT_LINE=X2U_LOCAL_IP_ADDRESS_LINE+4
X2U_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "X2U_LOCAL_IP_PORT = $X2U_LOCAL_IP_PORT"


### NGAP_LOCAL_IP_ADDRESS ##################################
TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==7'`
let NGAP_LOCAL_IP_ADDRESS_LINE=$TMP-3
NGAP_LOCAL_IP_ADDRESS=`sed -n "${NGAP_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "NGAP_LOCAL_IP_ADDRESS = $NGAP_LOCAL_IP_ADDRESS"

let PORT_LINE=NGAP_LOCAL_IP_ADDRESS_LINE+4
NGAP_LOCAL_IP_PORT=`sed -n "${PORT_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "NGAP_LOCAL_IP_PORT = $NGAP_LOCAL_IP_PORT"


echo "====================================================================="
echo "                 DU Interface                                        "
echo "====================================================================="

declare -a DU_INNER_IP=( "DUOAM_IP_ADDRESS"
        "DUMGR_IP_ADDRESS"
        "RLC_IP_ADDRESS"
        "MAC_IP_ADDRESS"
        "DUF1AP_IP_ADDRESS"
        )


declare -a DU_INNER_PORT=( "DUOAM_PORT"
			"DUMGR_PORT"
			"RLC_PORT_FOR_DUOAM"
			"RLC_PORT_FOR_DUMGR"
			"RLC_PORT_FOR_MAC"
			"RLC_PORT_FOR_DUF1U"
			"MAC_PORT_FOR_DUOAM"
			"MAC_PORT_FOR_RLC"
			"MAC_PORT_FOR_DUMGR"
			"DUF1U_PORT"
			)

echo ""
echo "<gNB_DU_Configuration.cfg>"
echo ""

for IP in "${DU_INNER_IP[@]}"
do
    IPADDR=`grep $IP $DU_PATH/cfg/gNB_DU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$IP=$IPADDR"
done

for PORT in "${DU_INNER_PORT[@]}"
do
    PORTNUM=`grep $PORT $DU_PATH/cfg/gNB_DU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done

for PORT in "${DU_EXTERNAL_PORT[@]}"
do
    PORTNUM=`grep $PORT $DU_PATH/cfg/gNB_DU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$PORT=$PORTNUM"
done


echo ""
echo "<TR196_gNodeB_DU_Data_Model.xml>"
echo ""
#### CU_IP_ADDRESS ########################
CU_IP_ADDRESS=`grep F1APSigLinkServer $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "F1APSIGLINK_IP_ADDRESS = $CU_IP_ADDRESS"

TMP=`grep -n "F1APSigLinkServer" $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | cut -d ":" -f1`
let TMP=$TMP+1
F1APSIGLINK_IP_PORT=`sed -n "${TMP}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '[0-9]*'`
echo "F1APSIGLINK_IP_PORT = $F1APSIGLINK_IP_PORT"

#### DUF1AP_IP_ADDRESS ########################
DUF1AP_IP_ADDRESS=`grep IPInterfaceIPAddress $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==1' | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "DUF1AP_IP_ADDRESS=$DUF1AP_IP_ADDRESS"

TMP=`grep -n "IPInterfaceIPAddress" $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==1' | cut -d ":" -f1`
let TMP=$TMP+11
DUF1AP_IP_PORT=`sed -n "${TMP}p" $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml  | grep -o '[0-9]*'`
echo "DUF1AP_IP_PORT = $DUF1AP_IP_PORT"

#### DUF1U_IP_ADDRESS ########################
DUF1U_IP_ADDRESS=`grep IPInterfaceIPAddress $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==2' | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "DUF1U_IP_ADDRESS=$DUF1U_IP_ADDRESS"

TMP=`grep -n "IPInterfaceIPAddress" $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==2' | cut -d ":" -f1`
let TMP=$TMP+3
DUF1AP_IP_PORT=`sed -n "${TMP}p" $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml  | grep -o '[0-9]*'`
echo "DUF1U_IP_PORT = $DUF1AP_IP_PORT"
