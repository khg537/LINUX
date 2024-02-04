#!/usr/bin/python3

import os
import sys
import subprocess

CU_XML_PATH="TR196_gNodeB_CU_Data_Model.xml"
CU_STARTUP_XML="startup.xml"


def output(command):
    s=subprocess.getoutput(command)
    return s

def find_num(to_be_search, num, filename):
    s=output("grep '%s' %s | gawk -F '>' '{ print $2 }' | gawk -F '<' '{ print $1 }' | sed -n '%sp' " %(to_be_search, filename, num))
    return s

def replace(key,value,tag,filename):
    s=subprocess.call("sed -i -e 's/%s%s/%s%s/g' %s;" %(key,value,key,tag,filename),shell=True)
    
    return s

def get_mcc_mnc_from_startup(CU_STARTUP_XML):
    mcc =find_num('mcc',1, CU_STARTUP_XML)
    mnc =find_num('mnc',1, CU_STARTUP_XML)
    
    return mcc, mnc

def get_mcc_mnc(CU_XML_PATH):
    plmnid =find_num('PLMNID', 1, CU_XML_PATH)   

    if (len(plmnid) == 6):
        mcc = plmnid[:3]
        mnc = plmnid[3:6]
    elif (len(plmnid) == 5):
        mcc = plmnid[:3]
        mnc = plmnid[3:5]
    else:
        print("plmn error")
        
    return mcc, mnc

def get_cellid(num):
    oldcellid =find_num('<cellLocalId>', num, CU_STARTUP_XML)
    newcellid =find_num('<CellIdentity>', num, CU_XML_PATH )
        
    return oldcellid, newcellid

        
def replace_mcc_mnc():
    mcc, mnc = get_mcc_mnc_from_startup(CU_STARTUP_XML)
    new_mcc, new_mnc = get_mcc_mnc(CU_XML_PATH)
    
    replace('<mcc>', mcc, new_mcc, CU_STARTUP_XML)
    replace('<mnc>', mnc, new_mnc, CU_STARTUP_XML)    
    
def replace_cell_id():
    oldcellid, newcellid = get_cellid(1)
    
    print("cellid",oldcellid, newcellid)
    replace('<cellLocalId>', oldcellid, newcellid, CU_STARTUP_XML)

if __name__=="__main__":
  replace_mcc_mnc()
  replace_cell_id()
============================================================================
#!/bin/bash

# 변수 설정
CU_XML_PATH="TR196_gNodeB_CU_Data_Model.xml"
CU_STARTUP_XML="startup.xml"

# 함수 정의
extract_value() {
    local search_term=$1
    local file=$2
    local num=$3
    grep "$search_term" "$file" | gawk -F '>' '{ print $2 }' | gawk -F '<' '{ print $1 }' | sed -n "${num}p"
}

replace_value() {
    local key=$1
    local old_value=$2
    local new_value=$3
    local file=$4
    sed -i -e "s/${key}${old_value}/${key}${new_value}/g" "$file"
}

# MCC, MNC 값을 startup.xml에서 추출
get_mcc_mnc_from_startup() {
    local mcc=$(extract_value 'mcc' $CU_STARTUP_XML 1)
    local mnc=$(extract_value 'mnc' $CU_STARTUP_XML 1)
    echo "$mcc $mnc"
}

# MCC, MNC 값을 CU_XML_PATH에서 추출
get_mcc_mnc() {
    local plmnid=$(extract_value 'PLMNID' $CU_XML_PATH 1)
    local mcc=${plmnid:0:3}
    local mnc=${plmnid:3}
    echo "$mcc $mnc"
}

# Cell ID 값을 교체
replace_cell_id() {
    local old_cell_id=$(extract_value '<cellLocalId>' $CU_STARTUP_XML 1)
    local new_cell_id=$(extract_value '<CellIdentity>' $CU_XML_PATH 1)

    echo "$old_cell_id"

    replace_value '<cellLocalId>' "$old_cell_id" "$new_cell_id" $CU_STARTUP_XML
}

# MCC, MNC 값을 교체
replace_mcc_mnc() {
    read mcc mnc <<< $(get_mcc_mnc_from_startup)
    read new_mcc new_mnc <<< $(get_mcc_mnc)

    echo "$mcc"
    echo "$mnc"    
    replace_value '<mcc>' "$mcc" "$new_mcc" $CU_STARTUP_XML
    replace_value '<mnc>' "$mnc" "$new_mnc" $CU_STARTUP_XML
}

# 메인 실행 부
replace_mcc_mnc
replace_cell_id

