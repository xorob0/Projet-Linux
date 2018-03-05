#!/bin/bash

# Vérification des erreurs
set -e

# Vérifie qu'un package est installé
function EstInstalle {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}
