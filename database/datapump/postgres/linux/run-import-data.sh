#!/bin/bash

P_SCHEMA="$1"

. ./run.conf

S_DATADIR=
S_LOGDIR=

function f_execute_db() {
	local P_DBNAME=$1

	echo load data schema=$P_SCHEMA dbname=$P_DBNAME ...

	# get table set
	F_TABLES=`cat tableset.txt | grep ^$P_DBNAME/ | cut -d "/" -f2 | tr "\n" " "`
	F_TABLES=${F_TABLES% }
	F_TABLES=${F_TABLES# }
	if [ "$F_TABLES" = "" ]; then
		echo data schema=$P_SCHEMA due to empty tableset. Skipped.
		echo "IMPORT-EMPTY"
		exit 2
	fi

	F_TABLEFILTER=
	if [ "$F_TABLES" != "*" ]; then
		echo load selected tables ...
		for table in $F_TABLES; do
			F_TABLEFILTER="$F_TABLEFILTER -t \"$table\""
		done
	else
		echo load all schema tables ...
	fi

	F_CMD="pg_restore -v -a -j 4 --disable-triggers -d $P_DBNAME $F_TABLEFILTER $S_DATADIR/data-$P_SCHEMA-all.dump"
	echo "run: $F_CMD ..."
	$F_CMD > $S_LOGDIR/data-$P_SCHEMA-all.dump.log 2>&1
	F_STATUS=$?

	if [ "$F_STATUS" != "0" ]; then
		echo pg_restore failed with status=$F_STATUS. Exiting
		exit 1
	fi

	echo IMPORT-FINISHED
}

function f_execute_all() {
	if [ "$CONF_NFS" = "yes" ]; then
		S_DATADIR=$CONF_NFSDATA
		S_LOGDIR=$CONF_NFSLOG
	else
		S_DATADIR=../data
		S_LOGDIR=../log
	fi

	echo "prepare import data from $S_DATADIR, logs to $S_LOGDIR ..."
	mkdir -p $S_DATADIR
	mkdir -p $S_LOGDIR

	# get schema name
	local F_DBNAME=`echo "$CONF_MAPPING" | tr " " "\n" | grep ^$P_SCHEMA= | cut -d "=" -f2`
	if [ "$F_DBNAME" = "" ]; then
		echo unable to find schema=$P_SCHEMA in run.conf in CONF_MAPPING variable. Exiting
		exit 1
	fi

	f_execute_db "$F_DBNAME"
}

f_execute_all
