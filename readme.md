## Description
Google Chrome extension helps you to convert selected CSS/HTML code to SASS/SCSS/HAML format.

## Test API calls
html2haml:

    curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"page":{'html': "<h1>Hello World</h1>"}}'  http://html2haml.heroku.com/api.json

css2sass:

    curl -v -H "Accept: application/json" -H "Content-type: application/x-www-form-urlencoded" -X POST --data-urlencode  'page[css]=.content {    color: red; }' http://css2sass.heroku.com/json

## Special thanks
to authors of html2haml and css2sass api services:

http://html2haml.heroku.com
http://css2sass.heroku.com
