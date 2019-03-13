#!/bin/bash
function main () {
  local module_path=`pwd`;
  local should_build=0;
  local should_reset=1;

  while getopts ':hp:bw' option; do
    case "$option" in
      h) usage
         exit
         ;;
      b) should_build=1
         ;;
      p) module_path=$OPTARG
         ;;
      w) should_reset=0;
         ;;
      :) printf "missing argument for -%s\n" "$OPTARG" >&2
         usage
         exit 1
         ;;
     \?) printf "illegal option: -%s\n" "$OPTARG" >&2
         usage
         exit 1
         ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ -z $module_path ]; then
    echo "missing the module path argument"
    usage
    exit 1
  fi

  if [ $should_build -ne 0 ]; then
    buildModule $module_path
  fi

  reloadModule $module_path $should_reset
}

function usage() { echo "$(basename "$0") [-h] [-b] [-p path_to_module]
-- script used to reload module in the openmrs demo environment

where:
    -h  show this help text
    -b  build the module before reload
    -p  path to module (the value of 'pwd' by default)
    -w  reload module without restart demo environment (module will be available on server after manually restart)"
    >&2
}

function buildModule() {
  echo "BUILDING THE $1 MODULE";
  mvn clean install -f $1
}

function reloadModule() {
  local scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";
  local moduleDir=$1;
  local omodDir=$moduleDir'/omod/target';
  local should_reset=$2;

  echo "RELOAD THE $moduleDir MODULE";
  if [ ! -d $omodDir ]; then
      echo "Directory $omodDir not found!";
      exit 1;
  fi

  local omodFile=`ls $omodDir/*.omod`;
  if [ ! -f $omodFile ]; then
      echo "Omod file not found!";
      exit 1;
  fi

  cp $omodFile $scriptDir/../modules
  sendFileToDockerContainers $omodFile

  if [ $should_reset -ne 0 ]; then
    $scriptDir/manageDemo.sh -r
  fi
}

function sendFileToDockerContainers() {
  local omodFile=$1;
  if [ `docker inspect -f '{{.State.Running}}' openmrs-web` == "true" ]; then
    docker cp $omodFile "openmrs-web:/usr/local/tomcat/.OpenMRS/modules/";
  fi
}

main "$@"
