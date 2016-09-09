import ldap3

connection = ldap3.Connection('ldap.columbia.edu', auto_bind=True)

import csv

with open('../signup.csv') as infile, open('results.csv', 'w') as outfile:
	reader = csv.reader(infile)
	writer = csv.writer(outfile)

	writer.writerow(['uni', 'given name', 'surname', 'department', 'title'])

	for row in reader:
		uni = row[0]

		if connection.search('o=Columbia University,c=US', '(uni={})'.format(uni), attributes=ldap3.ALL_ATTRIBUTES):

			entry = connection.entries[0]

			given_name = entry['givenName']
			surname = entry['sn']
			department = entry['ou']
			title = entry['title']

			writer.writerow([uni, given_name, surname, department, title])

		else:

			print('Could not find uni {}'.format(uni))