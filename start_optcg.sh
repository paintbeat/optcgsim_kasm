#!/bin/bash
# Launch virtual X display
Xvfb :1 -screen 0 1280x720x16 &
sleep 2
export DISPLAY=:1
# Run OPTCG Sim
wine "/opt/optcg/OPTCG-Sim.exe"
