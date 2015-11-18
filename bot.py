#!/usr/bin/python
#-*-coding:utf-8 -*-

import socket
import sys
import os
import time
import random
import json
import requests

#init variables

reload(sys)
sys.setdefaultencoding("utf-8")

def write(text):
    c.send(json.dumps({'action':'send_msg', 'arg': text}) + "\r\n\r\n")

def img_write(text):
    c.send(json.dumps({'action':'send_img', 'arg': text}) + "\r\n\r\n")

server_address = './socket'
try:
    os.unlink(server_address)
except OSError:
    if os.path.exists(server_address):
        raise

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.bind(server_address)
sock.listen(1)

while True:
    c, ca = sock.accept()
    c.settimeout(3)

    try:
        print 'got connection'
        t = time.time()

        data = ""
        while True:
            tmp = c.recv(1)
            data += tmp
            if "\r\n\r\n" in data:
                break

        print 'received'
        data = json.loads(data)
        print time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(int(data['date'])+32400)) + " " + data['from']['print_name'] + " : " + data['text'] 
        msgArr = data['text'].split()
        #명령어들
        if msgArr[0] == "TEST":
            write("TEST")
		
        c.send(json.dumps({'action':'bye'}) + "\r\n\r\n")

    except socket.error:
        print 'socket error'
        continue
    finally:
        c.close()
