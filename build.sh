export PATH=$PATH:~/.swiftyrobot

# ensure working dir is local to this script (when being called by another script)
cd "$(dirname "$0")"

# build Swift Package with Swifty Robot
sr build  | sed 's/\/root\/host_fs//g'
exit ${PIPESTATUS[0]}
