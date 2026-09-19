#!/usr/bin/env bash
echo "Stopping all Fem Chain validators..."
pkill -f "polygon-edge server" 2>/dev/null && echo "Done." || echo "No nodes were running."
