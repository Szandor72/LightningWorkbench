#!/bin/bash

if grep -q error ${CIRCLE_ARTIFACTS}/lightningLintReport.txt
then
  echo "#####"
  echo "FATAL: Linting errors found; Failing build;"
  echo "#####" 
  grep -C 3 error ${CIRCLE_ARTIFACTS}/lightningLintReport.txt  
  exit 1
else 
  echo "##### Linting Tests passed ####"  
fi