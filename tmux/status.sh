#!/usr/bin/env bash

DEFAULT=${DEFAULT:-default}

function ge() {
  [ $(echo "${1} >= ${2}" | bc) -eq 1 ]
}

function pcolor() {
  if ge ${1} 90; then
    echo "red"
  elif ge ${1} 70; then
    echo "orange"
  elif ge ${1} 50; then
    echo "yellow"
  elif ge ${1} 30; then
    echo "green"
  elif ge ${1} 10; then
    echo "blue"
  else
    echo ${DEFAULT}
  fi
}

function tcolor() {
  if ge ${1} 70; then
    echo "red"
  elif ge ${1} 60; then
    echo "orange"
  elif ge ${1} 50; then
    echo "yellow"
  elif ge ${1} 40; then
    echo "green"
  elif ge ${1} 30; then
    echo "blue"
  else
    echo ${DEFAULT}
  fi
}

function output() {
  echo -n "#[fg=$1]$2#[fg=${DEFAULT}]$3"
}

function cpu() {
  u=$(/bin/top -b -n 1 | rg '%Cpu' | awk '{print 100-$8}')
  output $(pcolor ${u}) ${u} "%" $1
}

function cpu_temp() {
  if type sensors > /dev/null; then
    temp=$(sensors | rg 'Tccd|Core' | cut -d ':' -f 2 | sed -e 's/[^0-9.]//g' | while read t; do output $(tcolor ${t}) ${t} " " $1; done)
    echo -n "$(echo ${temp} | tr ' ' '/')°C"
  else
    echo -n ""
  fi
}

function ram() {
  read t u < <(/bin/top -b -n 1 | rg 'MiB Mem' | tr -s ' ' | cut -d ' ' -f 4,8)
  output $(pcolor $(echo $u $t | awk '{print $1/$2 * 100}')) ${u}
  echo "/${t}MiB"
}

function sys() {
  echo $(cpu) $(ram) $(cpu_temp)
}

function get_gpu_info() {
  if type nvidia-smi > /dev/null; then
    nvidia-smi --query-gpu=$1 --format=csv,noheader
  else
    echo -n ""
  fi
}

function gpu_name() {
  case ${1} in
    "minimum") f=4;;
    "long") f=2;;
    "full") f=1;;
    *) f=3;;
  esac
  get_gpu_info name | cut -d ' ' -f ${f}-
}

function gpu_utilization() {
  u=$(get_gpu_info utilization.gpu | cut -d ' ' -f 1)
  output $(pcolor $u) ${u} "%"
}

function gpu_memory() {
  read u t < <(get_gpu_info memory.used,memory.total | cut -d ' ' -f 1,3)
  output $(pcolor $(echo $u $t | awk '{print $1/$2 * 100}')) ${u}/${t} "MiB"
}

function gpu_temp() {
  t=$(get_gpu_info temperature.gpu | cut -d ' ' -f 1)
  output $(tcolor ${t}) ${t} "°C"
}

function gpu() {
  echo $(gpu_name $1): $(gpu_utilization) $(gpu_memory) $(gpu_temp)
}

"$@"
