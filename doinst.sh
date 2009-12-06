# Bash colors                                                                                                                                 
C_GREEN=$'\e[32;01m'                                                                                                                          
C_YELLOW=$'\e[33;01m'                                                                                                                         
C_RED=$'\e[31;01m'                                                                                                                            
C_NORMAL=$'\e[0m'

config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

config etc/operaprefs.ini.new
config etc/operaprefs_fixed.ini

if [ -x usr/bin/update-desktop-database ]; then
  echo -n "Updating desktop database... "
  usr/bin/update-desktop-database usr/share/applications >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${C_GREEN}DONE${C_NORMAL}"
  else
    echo "${C_RED}FAILURE${C_NORMAL}"
  fi
fi

if [ -x usr/bin/update-mime-database ]; then
  echo -n "Updating MIME database... "
  usr/bin/update-mime-database usr/share/mime >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${C_GREEN}DONE${C_NORMAL}"
  else
    echo "${C_RED}FAILURE${C_NORMAL}"
  fi
fi

