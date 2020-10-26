#!/usr/bin/python
import re, subprocess, argparse, os
dir_path = os.path.dirname(os.path.realpath(__file__))

parser = argparse.ArgumentParser(description='Expecting a --list argument')
parser.add_argument('--list', help='Return json with dynamicaly requested hosts addresses', action="store_true")
args = parser.parse_args()
if args.list:
    os.chdir(os.path.join(dir_path, '..', 'terraform', 'stage'))
    output = subprocess.check_output(['terraform', 'show'])
    app_host = re.search("external_ip_address_app = \"([0-9.]+)\"", output).group(1)
    db_host = re.search("external_ip_address_db = \"([0-9.]+)\"", output).group(1)
    db_intra_host = re.search("internal_ip_address_db = \"([0-9.]+)\"", output).group(1)

    inventory_template = str()
    with open(os.path.join(dir_path, 'inventory.json')) as file:
        inventory_template = file.read()

    inventory = inventory_template.replace("${app_host}", app_host)
    inventory = inventory.replace("${db_host}", db_host)
    inventory = inventory.replace("${db_intra_host}", db_intra_host)
    print inventory
    exit(0)
else:
    print 'No --list argument was provided'
    exit(-1)
