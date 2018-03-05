<!DOCTYPE html>
<html>
<head>
    <title>Geolocalizacion Agencias</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <asset:stylesheet src="style.css"/>
    <asset:javascript src="application.js"/>
    <meta charset="utf-8">
</head>
<body>

<!-- Creacion de parte superior de la API, seleccionador de metodos de pago e inputs-->
<div id="main-nav-bar">
    <div class="nav-logo" href="">API Geolocalizacion de Agencias</div>
</div>
    <div id="banner">
        <div id="floating-panel">
            <select id="paymentMethodsSelector">
                <g:each in="${payment_methods}" var="p">
                    <g:if test="${p.payment_type_id == "ticket"}">
                        <option value="${p.id}">${p.name}</option>
                    </g:if>
                </g:each>
            </select>
            <input id="address" type="textbox" placeholder="Dirección">
            <input id="state" type="textbox" placeholder="Provincia">
            <input id="radio" type="textbox" placeholder="Radio">
            <input id="submit" type="button" value="Buscar">
         </div>
    </div>

<!-- Contenedores donde se almacenara la informacion a ser mostrada-->
<div id="Agencies">
</div>

<div id="modals">
</div>



<div id="map"></div>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyClfHYlgyn_nbSUecds48jq0QprRTDzitc&callback=initMap">
</script>
<script>
    // Botones para abrir y cerrar los modales de la página
    $( document ).ready(function() {
        $('body').on('click', '.btn-mdl', function () {
            var id = $(this).val()
            //$("#m"+id).css("display", "block");
            $("#m"+id).show()

        })

        $('body').on('click', '.close', function () {
            var id = $(this).val()
            $("#"+id).css('display', 'none')

        })
    })
    //Inicializacion del mapa con centro en a ciudad de cordoba
    function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 17,
            center: {lat: -31.4, lng: -64.1833}
        });
        var geocoder = new google.maps.Geocoder();

        // Al hacer click en el boton de submit, envia el mapa y geocoder para codificar la direccion
        document.getElementById('submit').addEventListener('click', function() {
            geocodeAddress(geocoder, map);

        });
    }

    function searchAgencies(lat,lng,resultsMap){
        // Armado de URL a pegar en la API de MELI
        paymentMethod=$("#paymentMethodsSelector").val();
        var radio = document.getElementById('radio').value;
        url = "https://api.mercadolibre.com/sites/MLA/payment_methods/"
            + paymentMethod + "/agencies?near_to="+lat+","+lng+","+ radio +"&limit=10";

        //Muestra en la pagina las agencias encontradas segun los parametros, marcando estas en el mapa
        $.ajax({
            url: url,
            type: "get",
            success: function (json) {
                $("#Agencies").html("");
                $("#Agencies").append("<tr><th><h2>Nombre de la agencia</h2></th><th><h2>Distancia(m)</h2></th><th><h2>Extra</h2></th></tr>");
                $(json).each(function (index, agencies) {
                    for(var i= 0; i < agencies.results.length; i++) {
                        var agencies_id = agencies.results[i].agency_code

                        $("#Agencies").append("<tr><th>" + agencies.results[i].description + "</th>" +
                            "<th>"+parseInt(agencies.results[i].distance,10)+"</th>"+"<th>"+
                            "<button type=\"button\" value='"+agencies_id+"' class=\"btn btn-info btn-lg btn-mdl\" data-toggle=\"modal\" data-target='m"+agencies_id+"'>Más info</button></th></tr><br>");

                        var auxLatLng = agencies.results[i].address.location.split(',');
                        var LatLng= new google.maps.LatLng(auxLatLng[0], auxLatLng[1]);
                        var marker = new google.maps.Marker({
                            map: resultsMap,
                            position: LatLng
                        });

                        marker.setMap(resultsMap);

                        //Creacion dinamica de los modales
                        $("#modals").append("<div id='m"+agencies_id+"' class='modal fade' role='dialog'>" +
                                                "<div class='modal-dialog'>" +
                                                        "<div class='modal-content'>" +
                                                            "<div class='modal-header'>"+
                                                                "<h4 class='modal-title'>"+agencies.results[i].description+"</h4>" +
                            "<button type='button' value='m"+agencies_id+"' class='close' data-dismiss='modal'>&times;</button>" +
                                                            "</div>" +
                                                            "<div class='modal-body'>" +
                                                                    "<p>Direccion: "+agencies.results[i].address.address_line+"</p>" +
                                                                    "<p>Ciudad: "+agencies.results[i].address.city+"</p>" +
                                                                    "<p>Pais: "+agencies.results[i].address.country+"</p>" +
                                                                    "<p>Localizacion: "+agencies.results[i].address.location+"</p>" +
                                                                    "<p>Estado: "+agencies.results[i].address.state+"</p>" +
                                                                    "<p>Codigo Postal: "+agencies.results[i].address.zip_code+"</p>" +
                                                             "</div>" +
                                                            "<div class='modal-footer'>" +
                                                        "</div>" +
                                                "</div>" +
                                            "</div>")
                    }

                })
            }
        });
    }
    //Funcion de codificacion de la direccion para utilizar con API de google para el armado del mapa
    function geocodeAddress(geocoder, resultsMap) {
        var address = document.getElementById('address').value+document.getElementById('state').value;
        geocoder.geocode({'address': address}, function(results, status) {
            if (status === 'OK') {

                resultsMap.setCenter(results[0].geometry.location);

                lat = results[0].geometry.location.lat();
                lng = results[0].geometry.location.lng();

                searchAgencies(lat,lng,resultsMap);

            } else {
                alert('La codificacion de localizacion no fue correcta por: ' + status);
            }
        });
    }
</script>
</body>
</html>


