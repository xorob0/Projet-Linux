#!/bin/bash

function EstInstalle {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}
