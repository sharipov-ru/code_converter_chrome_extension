## Description
Google Chrome extension helps you to convert selected CSS/HTML/JS code to SASS/SCSS/HAML/CoffeScript format.

## Installation

1. Clone repo:

    git clone git@github.com:sharipov-ru/code_converter_chrome_extension.git


1. Open Tools -> Extensions in Google Chrome or go to url

    chrome://chrome/extensions/


2. Enable Developer Mode.
3. Load cloned repo as unpacked extension.

## Development

    cake watch

## Test requests to external API services
html2haml:

    curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"page":{'html': "<h1>Hello World</h1>"}}'  http://html2haml.heroku.com/api.json

css2sass:

    curl -v -H "Accept: application/json" -H "Content-type: application/x-www-form-urlencoded" -X POST --data-urlencode  'page[css]=.content {    color: red; }' http://css2sass.heroku.com/json

js2coffee:

    curl -v -H "Accept: application/json" -H "Content-type: application/x-www-form-urlencoded" -X POST --data-urlencode 'js=$("#stop").click(function(){   $("#panel").stop(); });' http://git.rordev.ru:8080/convert

## Special thanks
to authors of html2haml, css2sass and js2coffee services:

http://html2haml.heroku.com
http://css2sass.heroku.com
http://js2coffee.org/

