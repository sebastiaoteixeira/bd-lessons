#!/bin/bash
# Define function to gracefully handle SIGINT
cleanup() {
    echo "Exiting..."
    exit 0
}

# Register cleanup function to handle SIGINT
trap cleanup SIGINT

# Main loop
while true; do
	find src/ -type f | entr -d python run.py 
done
