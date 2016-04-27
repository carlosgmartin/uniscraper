#!/bin/bash

# Author: Carlos Martin
# Date: 25 April 2016

# Example usage:
# $ chmod +x ./uniscraper.sh
# $ ./uniscraper.sh unis results.csv
# $ open results.csv

unis="$1" # File where unis are stored line by line (with terminating newline)
results="$2" # File where results will be stored in CSV format

echo "uni,given name,middle name,surname,department,title,address,phone" > $results
# Clears results and sets the header for each column
# Remove if appending to existing table

while read uni
do
	# sed 's/[^:]*: //;2q;d' first removes the attribute names and then selects the first value (on the second line)
	given_name=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni givenName | sed 's/[^:]*: //;2q;d')
	if [ -z "$given_name" ] # If entry does not exist, move on to next uni
	then
		continue
	fi
	middle_name=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni cuMiddlename | sed 's/[^:]*: //;2q;d')
	surname=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni sn | sed 's/[^:]*: //;2q;d')
	department=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni ou | sed 's/[^:]*: //;2q;d')
	title=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni title | sed 's/[^:]*: //;2q;d')
	address=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni postalAddress | sed 's/[^:]*: //;2q;d')
	if [ -z "$address" ] # If postal address is empty, try home postal address instead
	then
		address=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni homePostalAddress | sed 's/[^:]*: //;2q;d')
	fi
	phone=$(ldapsearch -h ldap.columbia.edu -x -LLL uni=$uni telephoneNumber | sed 's/[^:]*: //;2q;d')
	echo "\"$uni\",\"$given_name\",\"$middle_name\",\"$surname\",\"$department\",\"$title\",\"$address\",\"$phone\"" >> $results
done < "$unis"