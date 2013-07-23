
all:
	coffee --compile carousel.coffee
	uglifyjs carousel.js -o carousel.min.js
	coffee --watch --compile carousel.coffee
