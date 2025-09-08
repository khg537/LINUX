#!/bin/bash
# oom_risk_monitor.sh

THRESHOLD_PSS=80  # PSS 기준 80% 위험도
THRESHOLD_RSS=85  # RSS 기준 85% 위험도

TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')

echo "=== OOM Risk Assessment ==="
echo "Total Memory: $(($TOTAL_MEM/1024)) MB"

# 시스템 전체 PSS 계산
TOTAL_PSS=0
for pid in $(ps -eo pid --no-headers); do
    if [ -f "/proc/$pid/smaps" ]; then
        PSS=$(awk '/^Pss:/{pss+=$2} END{print pss}' /proc/$pid/smaps 2>/dev/null)
        TOTAL_PSS=$((TOTAL_PSS + PSS))
    fi
done

PSS_PERCENT=$((TOTAL_PSS * 100 / TOTAL_MEM))
RSS_TOTAL=$(ps --no-headers -eo rss | awk '{sum+=$1} END{print sum}')
RSS_PERCENT=$((RSS_TOTAL * 100 / TOTAL_MEM))

echo "Total PSS Usage: $PSS_PERCENT% (${TOTAL_PSS} kB)"
echo "Total RSS Usage: $RSS_PERCENT% (${RSS_TOTAL} kB)"

# 위험도 평가
if [ $PSS_PERCENT -gt $THRESHOLD_PSS ]; then
    echo "⚠️  HIGH OOM RISK (PSS > $THRESHOLD_PSS%)"
elif [ $RSS_PERCENT -gt $THRESHOLD_RSS ]; then
    echo "⚡ MODERATE OOM RISK (RSS > $THRESHOLD_RSS%, but PSS acceptable)"
else
    echo "✅ LOW OOM RISK"
fi
