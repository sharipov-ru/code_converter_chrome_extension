## Description
Extension helps you to convert selected JS/CSS/HTML code to CoffeeScript/SASS/HAML

## Test API calls
http://html2haml.heroku.com

    curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"page":{'html': "<h1>Hello World</h1>"}}'  http://html2haml.heroku.com/api.json
