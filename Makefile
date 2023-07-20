# Packages the main files of the repository.
build:
	rm -rf package

	mkdir -p package
	cp report/output/report.pdf ./diantonioandrea_858798.pdf

	zip -r package/diantonioandrea_858798.zip tests src README.md diantonioandrea_858798.pdf

	rm -rf diantonioandrea_858798.pdf