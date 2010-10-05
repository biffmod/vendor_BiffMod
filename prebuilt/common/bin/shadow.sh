##!/system/bin/sh
# author:	
#	Piotr Karbowski <jabberuser@gmail.com>
#	http://twitter.com/slashbeast

## conf.
targets="com.android.phone"
target_prio="-18"

for process in $targets; do
	count='1'
	while [ $count -le 24 ]; do
		sleep 5
		target_pid="$(pidof $process)"
		if [[ ! -z $target_pid ]]; then
			renice $target_prio $target_pid	&& count='24'
		fi	
		count=$((count+1))
	done
done
