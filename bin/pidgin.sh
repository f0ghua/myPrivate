PIDGIN_PATH=/home/fog/soft/im/pidgin/pidgin-2.8.0

#export LD_LIBRARY=${PIDGIN_PATH}/libpurple/.libs:${PIDGIN_PATH}/pidgin/plugins/.libs:${LD_LIBRARY}
export PATH=${PIDGIN_PATH}/pidgin:$PATH

#type pidgin
pidgin &
