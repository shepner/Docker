#!/bin/sh

sudo sh -c 'cat >> /etc/hosts << EOF
10.0.0.69 dm02
10.0.0.70 dm03
10.0.0.71 de01
10.0.0.72 de02
10.0.0.73 de03
10.0.0.74 de04
10.0.0.75 de05
10.0.0.76 de06
EOF'

