#!/bin/bash
export LANG=en_US.utf8
source ${EWOC_L8_VENV}/bin/activate
exec "$@"
#ewoc_generate_L8_ard_pid $@
