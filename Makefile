PHONY: github data prod update

github:
	rm -rf docs
	cp -r public docs
	git add -A
	git commit -m "update github pages"
	git push

data: 
	curl -o src/data/ma.csv "https://raw.githubusercontent.com/russellgoldenberg/covid-data-ma/master/covid-ma--dph.csv"

prod:
	npm run prod

update:
	make data
	make prod
	make github
	