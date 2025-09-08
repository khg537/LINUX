#!/bin/bash
# heap_monitor_10s.sh

PROCESS_NAME=$1
INTERVAL=${2:-10}  # 기본값 10초

if [ -z "$PROCESS_NAME" ]; then
    echo "Usage: $0 <process_name> [interval_seconds]"
    echo "Example: $0 my_program 10"
    exit 1
fi

echo "=== Heap Memory Monitor (${INTERVAL}s interval) ==="
echo "Monitoring process: $PROCESS_NAME"
echo "Press Ctrl+C to stop"
echo ""

while true; do
    PID=$(pidof "$PROCESS_NAME" | awk '{print $1}')  # 첫 번째 PID만 사용
    
    if [ -z "$PID" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Process $PROCESS_NAME not found"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] PID: $PID"
        
        # 힙 메모리 정보 추출
        HEAP_INFO=$(cat /proc/$PID/maps 2>/dev/null | grep "\[heap\]")
        
        if [ ! -z "$HEAP_INFO" ]; then
            HEAP_SIZE=$(echo "$HEAP_INFO" | awk '{print $1}' | sed 's/-/ /' | awk '{
                start = strtonum("0x"$1)
                end = strtonum("0x"$2)
                size_bytes = end - start
                size_mb = size_bytes / 1024 / 1024
                printf "%.2f MB (%d bytes)", size_mb, size_bytes
            }')
            echo "  Heap Size: $HEAP_SIZE"
        else
            echo "  Heap: Not allocated or not found"
        fi
        
        # RSS 및 기타 메모리 정보
        if [ -f "/proc/$PID/status" ]; then
            RSS=$(grep "VmRSS:" /proc/$PID/status 2>/dev/null | awk '{printf "%.2f MB", $2/1024}')
            DATA=$(grep "VmData:" /proc/$PID/status 2>/dev/null | awk '{printf "%.2f MB", $2/1024}')
            PEAK=$(grep "VmPeak:" /proc/$PID/status 2>/dev/null | awk '{printf "%.2f MB", $2/1024}')
            
            echo "  RSS Memory: $RSS"
            echo "  Data Memory: $DATA" 
            echo "  Peak Memory: $PEAK"
        fi
    fi
    
    echo "----------------------------------------"
    sleep $INTERVAL
done
