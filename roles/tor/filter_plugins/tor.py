#!/usr/bin/env python2

# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type


import binascii
import hashlib
import string
import random
import re


def check_pass(password, password_hash=None, **kwargs):
    return _check_pw(password, password_hash)

def hash_pass(password, salt=None, how=96, **kwargs):
    return _hash_pw(password, salt, how)

def update_pass(password, password_hash, salt='', how=96, **kwargs):
    ret = {
        'hash': None,
        'changed': None
    }
    if (_check_pw(password, password_hash) == True):
        ret['hash'] = password_hash
        ret['changed'] = False
    else:
        ret['changed'] = True
        ret['hash'] = _hash_pw(password, salt, how)
    return ret


def _check_pw(password, password_hash=None):
    if not re.match('^16:[0-9A-F]{58}$', password_hash):
      raise AssertionError("Unexpected password hash: %s" % password_hash)
 
    output_hex = binascii.a2b_hex(password_hash.strip()[3:])
    salt, how, _ = output_hex[:8], ord(output_hex[8]), output_hex[9:]

    if str(password_hash) == str(_hash_pw(password, salt, how=how)):
        return True
    else:
        return False


def _hash_pw(password, salt=None, how=96):
    #"S2K Algorithm, prefix 16:"
    
    if not salt:
        salt = ''.join(random.SystemRandom().choice(string.printable) for _ in range(8))
    assert len(salt) == 8, "Salt needs to be 8 bytes long"
    
    count = (16 + (how & 15)) << ((how >> 4) + 6)
    stuff = salt + password.encode('UTF-8')
    repetitions = count // len(stuff) + 1
    inp = (stuff * repetitions)[:count]
    pwhash = hashlib.sha1(inp).hexdigest()
    hashed = ("16:%s%0x%s" % (binascii.b2a_hex(salt), how, pwhash)).upper()
    return hashed


# ---- Ansible filters ----
class FilterModule(object):
    filter_map = {
        'tor_hash_pw': hash_pass,
        'tor_check_pw': check_pass,
        'tor_update_pw': update_pass
    }

    def filters(self):
        return self.filter_map
