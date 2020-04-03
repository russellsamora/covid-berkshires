PHONY: github aws-sync aws-cache pudding

github:
	rm -rf docs
	cp -r __sapper__/export/covid docs
	git add -A
	git commit -m "update github pages"
	git push
	
aws-sync:
	aws s3 sync __sapper__/export/year/month/name s3://pudding.cool/year/month/name --delete --cache-control 'max-age=31536000'

aws-cache:
	aws cloudfront create-invalidation --distribution-id E13X38CRR4E04D --paths '/year/month/name*'	

pudding: aws-sync aws-cache

data: 
	curl -o temp.csv "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv";
	csvgrep -c "state" -r  "Massachusetts" temp.csv | csvcut -c "date,county,cases,deaths" > src/data/ma.csv;
	rm temp.csv
	# curl -o nyt.html "https://www.nytimes.com/interactive/2020/us/massachusetts-coronavirus-cases.html"