package geoloc

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class GeoLocControllerSpec extends Specification implements ControllerUnitTest<GeoLocController> {

    def setup() {
    }

    def cleanup() {
    }

    void "test llamado index"() {
        when:
        request.method=='GET'
        request.requestMethod='GET'
        controller.index()

        then:
            response.status == 200
    }
}
