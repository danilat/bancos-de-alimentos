import mechanize
from bs4 import BeautifulSoup
import csv

def bank(br, href):
	resp = br.open("http://www.bancodealimentos.es" + href)
	html = resp.read()
	soup = BeautifulSoup(html)
	item = soup.find('div', class_= "item")
	street = item.find(class_= "street").get_text()
	suburb = item.find(class_= "suburb").get_text()
	print suburb
	state = item.find(class_= "state").get_text() if item.find(class_= "state") else ""
	postcode = item.find(class_= "postcode").get_text() if item.find(class_= "postcode") else ""
	country = item.find(class_= "country").get_text() if item.find(class_= "country") else ""
	full_address = "%s, %s, %s, %s, %s" % (street, postcode, suburb, state, country)
	contact = item.find('div', class_= "contact")
	phones = []
	if contact:
		for li in contact.find_all('li'):
			phones.append(li.get_text())
	else:
		phones.append("")

	return [full_address.encode('utf8'), phones[0].encode('utf8')]


br = mechanize.Browser()
urls = ["http://www.bancodealimentos.es/bancos/fesbal/directorio",
		"http://www.bancodealimentos.es/bancos/fesbal/directorio?start=20",
		"http://www.bancodealimentos.es/bancos/fesbal/directorio?start=40"]
banks = [['full_address', 'phone']]

for url in urls:
	resp = br.open(url)
	html = resp.read()
	soup = BeautifulSoup(html)
	for item in soup.find_all('td', class_= "item-title"):
		href = item.a.get('href')
		banks.append(bank(br, href))

with open('fesvbal.csv', 'w') as fp:
    a = csv.writer(fp, delimiter=',', quoting=csv.QUOTE_ALL)
    a.writerows(banks)
