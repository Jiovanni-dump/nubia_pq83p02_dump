#!/system/bin/sh

trace_log_dir=/data/misc/bootstat
if [ "x$(getprop persist.sys.ztelog.enable)" != "x1" ]; then
    exit 0
fi

cd ${trace_log_dir} || exit

tt=$(date +%G%m%d_%H%M%S)
reason=$(getprop sys.boot.reason)

# [2] [dbg.boot.cycle.count]: [1389] or maybe empty string
boot_cycle=$(vendorcfg -cdump  2>&1 | grep "dbg.boot.cycle.count")

# match long delete from beginning
boot_cycle=${boot_cycle##*[}

# match short delete from end
boot_cycle=${boot_cycle%%]*}

if [ -z "${boot_cycle}" ]; then
    boot_cycle="EMPTY"
fi

# fixed output file name
output_file="boot_reason_stats.txt"
output_file_bak="boot_reason_stats.bak"

printf "%s    %s    %s\n" "${tt}" "${boot_cycle}" "${reason}" >> ${output_file}

total=$(ls -l ${output_file} | awk '{print $5}')
echo "ls get ${total}"
if [ "$total" -ge "5242880" ]; then
    # over 5M, and may override the existing bak file
    mv ${output_file} ${output_file_bak}
fi

#

