#!/bin/bash

# Shutdown the Unifi Java process gracefully, and the MongoDB it spawns
# Send a Ctrl-C command to Java.  

pkill --signal=SIGINT java
