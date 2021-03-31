sp-sc $1 3908 8908  >/dev/null &
sleep 5
mplayer http://localhost:8908/tv.asf
killall sp-sc
