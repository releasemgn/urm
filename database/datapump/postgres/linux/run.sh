#!/bin/bash

P_MODE=$1
P_CMD=$2
P_SET=$3
P_SCHEMA="$4"

if [ "$P_MODE" = "" ] || [ "$P_CMD" = "" ]; then
	echo invalid params. Exiting
	exit 1
fi

function f_execute_export_data() {
	nohup ./run-export-data.sh "$P_SCHEMA" >> run.sh.log 2>&1 &
}

function f_execute_export_meta() {
	nohup ./run-export-meta.sh "$P_SCHEMA" >> run.sh.log 2>&1 &
}

function f_execute_import_data() {
	nohup ./run-import-data.sh "$P_SCHEMA" >> run.sh.log 2>&1 &
}

function f_execute_import_meta() {
	nohup ./run-import-meta.sh "$P_SCHEMA" >> run.sh.log 2>&1 &
}

function f_execute_export_start() {
	if [ "$P_SET" = "" ] || [ "$P_SCHEMA" = "" ]; then
		echo invalid params. Exiting
		exit 1
	fi

	echo EXPORT-STARTED > run.sh.log

	if [ "$P_SET" = "meta" ]; then
		f_execute_export_meta

	elif [ "$P_SET" = "data" ]; then
		f_execute_export_data
	fi
}

function f_execute_export_status() {
	if [ "`pgrep -f run-export`" != "" ]; then
		echo RUNNING
		return
	fi

	if [ -f run.sh.log ]; then
		if [ "`grep -c EXPORT-STARTED run.sh.log`" = "0" ]; then
			if [ "`grep -c EXPORT-EMPTY run.sh.log`" = "1" ]; then
				echo EMPTY
			fi

			echo UNKNOWN
			return
		fi

		# give time to write to log if just stopped
		sleep 1

		if [ "`grep -c EXPORT-FINISHED run.sh.log`" = "0" ]; then
			echo BROKEN
			return
		fi
	fi

	echo FINISHED
}

function f_execute_import_status() {
	if [ "`pgrep -f run-import`" != "" ]; then
		echo RUNNING
		return
	fi

	if [ -f run.sh.log ]; then
		if [ "`grep -c IMPORT-STARTED run.sh.log`" = "0" ]; then
			if [ "`grep -c IMPORT-EMPTY run.sh.log`" = "1" ]; then
				echo EMPTY
			fi

			echo UNKNOWN
			return
		fi

		# give time to write to log if just stopped
		sleep 1

		if [ "`grep -c IMPORT-FINISHED run.sh.log`" = "0" ]; then
			echo BROKEN
			return
		fi
	fi

	echo FINISHED
}

function f_execute_import_start() {
	if [ "$P_SET" = "" ] || [ "$P_SCHEMA" = "" ]; then
		echo invalid params. Exiting
		exit 1
	fi

	echo IMPORT-STARTED > run.sh.log

	if [ "$P_SET" = "meta" ]; then
		f_execute_import_meta

	elif [ "$P_SET" = "data" ]; then
		f_execute_import_data
	fi
}

function f_execute_all() {
	if [ "$P_MODE" = "export" ]; then
		if [ "$P_CMD" = "start" ]; then
			f_execute_export_start
		elif [ "$P_CMD" = "status" ]; then
			f_execute_export_status
		else
			echo invalid command=$P_CMD
		fi

	elif [ "$P_MODE" = "import" ]; then
		if [ "$P_CMD" = "start" ]; then
			f_execute_import_start
		elif [ "$P_CMD" = "status" ]; then
			f_execute_import_status
		else
			echo invalid command=$P_CMD
		fi

	else
		echo invalid mode=$P_MODE. Exiting
		exit 1
	fi
}

f_execute_all
