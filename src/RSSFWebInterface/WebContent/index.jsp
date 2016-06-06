<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Estação base de RSSF</title>
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
	<script type="text/javascript" src="js/jquery-1.12.4.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/cytoscape.min.js"></script>
	<script type="text/javascript" src="js/dagre.js"></script>
	<script type="text/javascript" src="js/cytoscape-dagre.js"></script>
	<style type="text/css">
	
	body {
		min-height: 2000px;
	}
	#gui {
		width: 1002px;
		height: 600px;
	}
	#comandos {
		width: 500px;
		text-align: center;
		position: absolute;
		top: 0;
		left: 0;
	}
	
	#topologia {
		width: 100%;
		height: 100%; */
		position: absolute;
		left: 500px;
		top: 0;
	}
	</style>
</head>
<body>
	<script>
        $(function(){
        	var webSocket;
    		var teste = 0;
        		
       		var topologia = window.topologia = cytoscape({
               	container: document.getElementById('topologia'),
               	boxSelectionEnabled: false,
               	autounselectify: true,
               	layout: {
               		name: 'dagre'
               	},
				style: [
				        {
			                selector: 'node',
			                style: {
		                        'content': 'data(id)',
		                        'text-opacity': 0.5,
		                        'text-valign': 'center',
		                        'text-halign': 'right',
		                        'background-color': '#11479e'
			                }
				        },
				        {
			                selector: 'edge',
			                style: {
		                        'width': 4,
		                        //'target-arrow-shape': 'triangle',
		                        'line-color': '#9dbaea'
		                        //'target-arrow-color': '#9dbaea'
			                }
				        }
				],                	
			    elements: {
			        nodes: [
			                { data: { id: 'n0' } },
			                { data: { id: 'n1' } },
			                { data: { id: 'n2' } },
			                { data: { id: 'n3' } },
			                { data: { id: 'n4' } },
			                { data: { id: 'n5' } }
			        ],
			        edges: [
			                { data: { source: 'n0', target: 'n1' } },
			                { data: { source: 'n1', target: 'n2' } },
			                { data: { source: 'n1', target: 'n3' } },
			                { data: { source: 'n2', target: 'n4' } },
			                { data: { source: 'n3', target: 'n5' } }
			        ]
				}
			});
        		
       		function openSocket(){
       			if (webSocket != undefined && webSocket.readyState != WebSocket.CLOSED){
       				//writeResponse("WebSocket ja esta aberto.");
       				return;
       			}
       			webSocket = new WebSocket("ws://" + location.host + "/RSSFWebInterface/actions");
       			
       			webSocket.opened = function(event){
       				if (event.data == undefined){
       					alert("caiu aqui...");
       					return;
       				}
       				writeResponse(event.data);
       			}
       			
       			webSocket.onmessage = function(event){
       				writeResponse(event.data);
       				topologia.add({group:"nodes", data:{id:"teste"+ ++teste}});
       				topologia.add({group:"edges", data:{source:"n0", target:"teste"+teste}});
       				topologia.layout({name:"dagre"});
       			}
       			
       			webSocket.onclose = function(event){
       				writeResponse("Conexao fechada");
       			}
       		}
        		
       		function writeResponse(text){
       			$("#messages").text(text);
       		}
       		
       		function closeSocket(){
       			webSocket.close();
       		}
       		
       		function sendMessage(){
       			openSocket();
       			webSocket.send("msg");
       		}
       		
			$("#boxAllSensors").change(function(){
			        if (this.checked){
			                $("#idSensor").prop('disabled', true);
			        } else {
			                $("#idSensor").prop('disabled', false);
			        }
			});

			$("#btnColetar").click(function(){
			        $(".table-responsive").show();
			        sendMessage();	
			});
        });
                      
	</script>
	<div id="gui" class="row">
		<div id="comandos" class="col-lg-4">
			<p><b>Trabalho Prático 2 - Redes de Sensores Sem Fio</b></p>
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h3 class="panel-title">Coleta de dados</h3>
				</div>
				<div class="panel-body">
					<label><input id="boxAllSensors" name="allSensors" type="checkbox">Todos os sensores</label><br>
					<label>Sensor de endereço: <input id="idSensor" name="idSensor" type="text" size="5"></label><br>
					<input id="btnColetar" type="button" class="btn btn-sm btn-primary" value="Coletar dados">
				</div>
			</div>
	        <div id="messages" class="well">
	        </div>
			<div class="table-responsive" style="display: none;">
				<p>Dados recebidos:</p>
				<table class="table table-striped">
					<thead>
		                <tr>
		                    <td>Endereço do sensor</td>
		                    <td>Temperatura</td>
		                    <td>Luminusidade</td>
		                    <td>Outros dados</td>
		                </tr>
	                 </thead>
	                 <tbody>
		                 <tr>
		                     <td>110</td>
		                     <td>29</td>
		                     <td>XX</td>
		                     <td>19.892089, 43.998958</td>
		                 </tr>
					</tbody>
				</table>
			</div>
		</div>
		<div id="topologia" class="col-lg-4">
		</div>
	</div>
</body>
</html>