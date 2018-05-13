#!/bin/bash

echo "Login:"
read LOGIN
echo "Mot de passe:"
read -s PASS
useradd $LOGIN -p $PASS



