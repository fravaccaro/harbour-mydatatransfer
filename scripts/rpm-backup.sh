#!/bin/bash
TEMP=`getopt -o ro:lLdvtRsS: --long refresh,output:,list-packages,list-repos,download,verbose,trim-repos,refresh-cache,skip-repos,settings-dir: -n 'rpm-backup' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

REFRESH=false
LREPOS=false
LPACKAGES=false
OUTPUT="/home/nemo/Backup"
DOWNLOAD=false
SETTINGS="/home/nemo"
JOLLAREPO=`ssu lr | awk '/http.*store.*jolla.*/ {print $2,$4}'`
VERBOSE=false
TRIM=false
PKCON=false
SKIP_REPOS=false

while true; do
  case "$1" in
    -r | --refresh ) REFRESH=true; shift ;;
    -o | --output ) OUTPUT="$2"; shift 2 ;;
    -l | --list-packages ) LPACKAGES=true; shift ;;
    -L | --list-repos ) LREPOS=true; shift ;;
    -d | --download ) DOWNLOAD=true; shift ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -t | --trim-repos ) TRIM=true; shift ;;
    -R | --refresh-cache ) PKCON=true; shift ;;
    -s | --skip-repos ) SKIP_REPOS=true; shift ;;
    -S | --settings-dir ) SETTINGS="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

parse_package_name(){
  local name

  while read line; do
    echo $line | awk '/i\+ \| ([A-Za-z0-9]+-*[A-Za-z0-9]*)/ {print $3}'
  done
}

get_user_repos(){
  local record
  record=false
  ssu lr | while read line; do
    if [[ $line == "Enabled repositories (user):" ]] ; then
      record=true
    elif [[ `echo $line | awk '/store.*jolla/ {print $2}'` == "store" ]] ; then
      continue
    elif [[ `echo $line | awk '/cbeta/ {print $4}'` == *"cbeta"* ]] ; then
      continue
    elif [[ $record == true && `echo $line | awk '/-/ {print $1}'` != "-" ]] ; then
      record=false
    fi
    if [[ $record == true ]] ; then
      echo $line | awk '/http/ {print $2,$4}'
    fi
  done
}

add_repo_packages(){
  packages=$(parse_package_name < <(zypper search -i -r $(echo $1 | awk '{print $1}')))
  if [[ $packages == "" ]] ; then
    $VERBOSE && echo "No packages found"
    if [[ $TRIM == true ]] ; then
      $VERBOSE && echo "Removing repo $(echo $1 | awk '{print $1}')"
      sed -i '/$1/d' ${SETTINGS}/repos.conf
      ssu rr $(echo $1 | awk '{print $1}')
      ssu ur
    fi
  else
    $VERBOSE && printf "Adding packages:\n$packages\n"
    echo $packages | sed 's/ /\n/g' >> ${SETTINGS}/packages.conf
  fi  
}

restore_user_repos(){
  cat $SETTINGS/repos.conf | while read a b; do
    $VERBOSE && echo "Adding repo $a"
    ssu ar $a $b
    $VERBOSE && echo "Enabling repo $a"
    ssu er $a
  done
  $VERBOSE && echo "Updating repos list"
  ssu ur
  $VERBOSE && echo "Refreshing zypper cache"
  zypper refresh
}

remove_user_repos(){
  cat $SETTINGS/repos.conf | while read a b; do
    $VERBOSE && echo "Removing repo $a"
    ssu rr $a
  done
  $VERBOSE && echo "Updating repos"
  ssu ur
}

EXIT=false

if [[ ${LREPOS} == true ]] ; then
  printf "Installed Repositories:\n\n"
  cat ${SETTINGS}/repos.conf
  EXIT=true
fi

if [[ ${LREPOS} == true && ${LPACKAGES} == true ]] ; then
  printf "\n"
fi

if [[ ${LPACKAGES} == true ]] ; then
  printf "Installed packages:\n\n"
  cat ${SETTINGS}/packages.conf
  EXIT=true
fi

$EXIT && (printf "\nExiting..." && exit)

if [[ ! -f ${SETTINGS}/repos.conf || ! -f ${SETTINGS}/packages.conf ]] ; then
  $VERBOSE && echo "Missing repos or package lists. Refreshing..."
  REFRESH=true
fi

if [[ ${REFRESH} == true ]] ; then
  $VERBOSE && echo "Refreshing repos list"
  get_user_repos > ${SETTINGS}/repos.conf

  rm ${SETTINGS}/packages.conf

  $VERBOSE && echo "Refreshing packages list"
  while read line; do
    $VERBOSE && echo "Scanning packages from repo $(echo $line | awk '{print $1}')"
    add_repo_packages $line
  done <${SETTINGS}/repos.conf
  $VERBOSE && echo "Scanning packages from Jolla Store"
  add_repo_packages $JOLLAREPO
fi

if [[ $1 == "backup" || $1 == "bu" ]] ; then
  timestamp="$(date +'%Y-%m-%d_%H-%M')"
  $VERBOSE && echo "Creating temporary directories"
  mkdir -p ${OUTPUT}/${timestamp}
  $VERBOSE && echo "Copying repos list to ${OUTPUT}/${timestamp}"
  /bin/cp -r ${SETTINGS}/repos.conf ${OUTPUT}/${timestamp}/
  $VERBOSE && echo "Copying packages list to ${OUTPUT}/${timestamp}"
  /bin/cp -r ${SETTINGS}/packages.conf ${OUTPUT}/${timestamp}/
  cd ${OUTPUT}
  if [[ $DOWNLOAD == true ]] ; then
    $VERBOSE && echo "Download mode enabled. Preparing RPM download"
    cd ${timestamp}
    mkdir -p rpms
    if [[ $PKCON == true ]] ; then
      $VERBOSE && echo "Keep calm and pkcon refresh"
      pkcon refresh
    fi
    #$VERBOSE && echo "Downloading RPMS"
    #pkcon download rpms $(${SETTINGS}/packages.conf)
    while read line; do
      $VERBOSE && echo "Downloading $line"
      echo "1" | pkcon download rpms $line
    done <${SETTINGS}/packages.conf
    $VERBOSE && echo "RPM Downloads complete"
    cd ..
  else
    $VERBOSE && echo "Download mode disabled. Skipping RPM download"
    touch ${timestamp}/.norpms
  fi
  $VERBOSE && echo "Compressing backup file to ${OUTPUT}/${timestamp}_rpm.tar.gz"
  tar zcvf ${timestamp}_rpm.tar.gz ${timestamp}
  cd ..
  $VERBOSE && echo "Cleaning up..."
  /bin/rm -rf ${OUTPUT}/${timestamp}
fi

if [[ $1 == "restore" || $1 == "re" ]] ; then
  [[ $2 == "" ]] && (printf "Missing file argument\n  Example: rpm-backup restore /home/nemo/2019-12-18_00-00_rpm.tar.gz\n"; exit)
  [ ! -f "$2" ] && (echo "Could not find file"; exit)
  if [[ -d "${OUTPUT}/.backuptmp" ]] ; then
    $VERBOSE && echo "Cleaning up old temp files..."
    /bin/rm -rf ${OUTPUT}/.backuptmp
  fi

  $VERBOSE && echo "Creating temp directory"
  mkdir -p ${OUTPUT}/.backuptmp
  $VERBOSE && echo "Extracting backup file"
  tar zxvf $2 -C ${OUTPUT}/.backuptmp

  $VERBOSE && echo "Restoring repos list"
  /bin/cp -rf ${OUTPUT}/.backuptmp/*/repos.conf ${SETTINGS}/repos.conf
  $VERBOSE && echo "Restoring packages list"
  /bin/cp -rf ${OUTPUT}/.backuptmp/*/packages.conf ${SETTINGS}/packages.conf
  
  if [[ $SKIP_REPOS != true ]] ; then
    $VERBOSE && echo "Restoring user repos"
    restore_user_repos
  fi

  if [[ $PKCON == true ]] ; then
    $VERBOSE && echo "Keep calm and pkcon refresh"
    pkcon refresh
  fi
  
  if [[ -f ${OUTPUT}/.backuptmp/.norpms || ${DOWNLOAD} == true ]] ; then
    if [[ ${DOWNLOAD} == true ]] ; then
      $VERBOSE && echo "Download mode enabled. Installing packages from repositories"
    else
      $VERBOSE && echo "No rpms found. Installing packages from repositories"
    fi
    
    #zypper in $(cat ${SETTINGS}/packages.conf)
    cat ${SETTINGS}/packages.conf | while read line; do
      $VERVOSE && echo "Installing $line"
      pkcon install $line -y
    done
  else
    $VERBOSE && echo "`ls -l ${OUTPUT}/.backuptmp/*/rpms/*.rpm | wc -l` Rpms found. Installing..."
    pkcon install-local ${OUTPUT}/.backuptmp/*/rpms/*.rpm -y
  fi
  
  $VERBOSE && echo "Cleaning up..."
  rm -rf ${OUTPUT}/.backuptmp
fi

if [[ $1 == "test" ]] ; then
  get_user_repos
fi
#!/bin/bash
