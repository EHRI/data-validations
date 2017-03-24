#coding: utf-8
import xml.etree.ElementTree as ET

####
# This script creates a dictionary with all the <constraintsSpec> contained in an ODD file
# and exports in a CSV file the following elements=

 # 1) constraintSpec/@ident
 # 2) rule/@context
 # 3) rule/@role
 # 4) rule/@test
 # 5) rule/text()

tree = ET.parse('EHRI_broad.odd')

ns = {'tei' : 'http://www.tei-c.org/ns/1.0', 'sch' : 'http://purl.oclc.org/dsdl/schematron' }

results = []
for constraints in tree.iter('{http://www.tei-c.org/ns/1.0}constraintSpec'):
	dic = {}
	dic['ident'] = constraints.attrib['ident']
	
	rules = constraints.iter('{http://purl.oclc.org/dsdl/schematron}rule')
	for rule in rules :
		
		dic['context'] =  rule.attrib['context'].replace('\n',' ').replace('\r', '')
		if rule.find('{http://purl.oclc.org/dsdl/schematron}assert') is not None:
			for asserts in constraints.iter('{http://purl.oclc.org/dsdl/schematron}assert'):
	
				dic['test'] = asserts.attrib['test'].replace('\n',' ').replace('\r', '').replace('  ', '').strip()
		
				rav = ''.join(asserts.itertext())
				dic['text'] = rav.replace('\n',' ').replace('\r', '').replace('  ', '').strip()
				if 'role' in asserts.attrib:
					dic['role'] = asserts.attrib['role'].replace('\n',' ').replace('\r', '').replace('  ', '').strip()
				else:
					dic['role'] = ''

		elif rule.find('{http://purl.oclc.org/dsdl/schematron}report') is not None :
			for reports in constraints.iter('{http://purl.oclc.org/dsdl/schematron}report'):

				dic['test'] = reports.attrib['test'].replace('\n',' ').replace('\r', '').replace('  ', '').strip()
				rav = ''.join(reports.itertext())
				dic['text'] = rav.replace('\n',' ').replace('\r', '').replace('  ', '').strip()
				if 'role' in reports.attrib:
					dic['role'] = reports.attrib['role'].replace('\n',' ').replace('\r', '').replace('  ', '').strip()
				else:
					dic['role'] = ''

		else:
			dic['test'] = ''
			dic['text'] = ''
			dic['role'] = ''

	
	results.append(dic)

print results

import csv

keys = results[0].keys()
with open('Export_constraints.csv', 'wb') as output_file:
	dict_writer = csv.DictWriter(output_file, keys)
	dict_writer.writeheader()
	dict_writer.writerows(results)
