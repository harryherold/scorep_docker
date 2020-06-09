
BT_DIR=/home/cherold/Downloads/NPB3.4
SCOREP_DIR=/home/cherold/scorep/scorep_master

docker run  --user $(id -u)  -v $SCOREP_DIR:/opt/scorep -v $BT_DIR:/tests -it scorep_basic

