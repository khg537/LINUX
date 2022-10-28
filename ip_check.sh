#!/bin/bash

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
		)

declare -a CU_EXTERNAL_IP=( "EGTPU_LOCAL_IP_ADDRESS"
		"F1AP_LOCAL_IP_ADDRESS"
		"F1U_LOCAL_IP_ADDRESS"
		"X2AP_LOCAL_IP_ADDRESS"
		"X2U_LOCAL_IP_ADDRESS"
		)     

echo "<gNodeB_CU_Configuration.cfg>"
echo ""

for IP in "${CU_INNER_IP[@]}"
do
    IPADDR=`grep $IP $CU_PATH/cfg/gNodeB_CU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$IP=$IPADDR"
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


### F1AP_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==3'`
let F1AP_LOCAL_IP_ADDRESS_LINE=$TMP-3
F1AP_LOCAL_IP_ADDRESS=`sed -n "${F1AP_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "F1AP_LOCAL_IP_ADDRESS = $F1AP_LOCAL_IP_ADDRESS"


### F1U_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==4'`
let F1U_LOCAL_IP_ADDRESS_LINE=$TMP-3
F1U_LOCAL_IP_ADDRESS=`sed -n "${F1U_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "F1U_LOCAL_IP_ADDRESS = $F1U_LOCAL_IP_ADDRESS"


### X2AP_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==5'`
let X2AP_LOCAL_IP_ADDRESS_LINE=$TMP-3
X2AP_LOCAL_IP_ADDRESS=`sed -n "${X2AP_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "X2AP_LOCAL_IP_ADDRESS = $X2AP_LOCAL_IP_ADDRESS"

### X2U_LOCAL_IP_ADDRESS ##################################

TMP=`grep -n "X_VENDOR_INTERFACE" ../cfg/TR196_gNodeB_CU_Data_Model.xml  | cut -d ":" -f1 | awk 'NR==6'`
let X2U_LOCAL_IP_ADDRESS_LINE=$TMP-3
X2U_LOCAL_IP_ADDRESS=`sed -n "${X2U_LOCAL_IP_ADDRESS_LINE}p" ../cfg/TR196_gNodeB_CU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "X2U_LOCAL_IP_ADDRESS = $X2U_LOCAL_IP_ADDRESS"

echo "====================================================================="
echo "                 DU Interface                                        "
echo "====================================================================="

declare -a DU_INNER_IP=( "DUOAM_IP_ADDRESS"
        "DUMGR_IP_ADDRESS"
        "RLC_IP_ADDRESS"
        "MAC_IP_ADDRESS"
        "DUMGR_IP_ADDRESS"
        )

declare -a CU_EXTERNAL_IP=( "CU_IP_ADDRESS"
        "DUF1AP_IP_ADDRESS"
        "DUF1U_IP_ADDRESS"
        )

echo ""
echo "<gNB_DU_Configuration.cfg>"
echo ""

for IP in "${DU_INNER_IP[@]}"
do
    IPADDR=`grep $IP $DU_PATH/cfg/gNB_DU_Configuration.cfg  | cut -d "=" -f 2`
    echo "$IP=$IPADDR"
done


echo ""
echo "<TR196_gNodeB_DU_Data_Model.xml>"
echo ""
#### CU_IP_ADDRESS ########################
CU_IP_ADDRESS=`grep F1APSigLinkServer $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "CU_IP_ADDRESS = $CU_IP_ADDRESS"

#### DUF1AP_IP_ADDRESS ########################
DUF1AP_IP_ADDRESS=`grep IPInterfaceIPAddress $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==1' | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "DUF1AP_IP_ADDRESS=$DUF1AP_IP_ADDRESS"


#### DUF1U_IP_ADDRESS ########################
DUF1U_IP_ADDRESS=`grep IPInterfaceIPAddress $DU_PATH/cfg/TR196_gNodeB_DU_Data_Model.xml | awk 'NR==2' | grep -o '\(\b[0-9]\{1,3\}.\)\{3\}\b[0-9]\{1,3\}'`
echo "DUF1U_IP_ADDRESS=$DUF1U_IP_ADDRESS"


