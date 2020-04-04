PHONY: github data

github:
	rm -rf docs
	cp -r public docs
	git add -A
	git commit -m "update github pages"
	git push

data: 
	curl -o temp.csv "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv";
	csvgrep -c "state" -r  "Massachusetts" temp.csv | csvgrep -c "county" -r "Unknown" -i | csvcut -c "date,county,cases,deaths" > src/data/ma-nyt.csv;
	rm temp.csv