#!/bin/bash

su p3 -s /usr/bin/java -- -jar /usr/local/lib/marmotta.jar &
su p3 -s /usr/bin/java -- -jar /usr/local/lib/proxy.jar &
