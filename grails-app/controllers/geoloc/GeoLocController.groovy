package geoloc

import groovy.json.JsonSlurper

class GeoLocController {

    def index() {
        def sites = getSites()
        def paymentMethods = getPaymentMethods()
        [lista: sites, payment_methods:paymentMethods]

    }

    def getSites(){
        def url = new URL('https://api.mercadolibre.com/sites')
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()

        return json.parse(connection.getInputStream())
    }

    def getPaymentMethods(){
        def url = new URL('https://api.mercadolibre.com/sites/MLA/payment_methods')
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()
        return json.parse(connection.getInputStream())

    }


}
