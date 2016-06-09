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
	<script type="text/javascript" src="js/chroma.min.js"></script>
	
	<style type="text/css">
	body {
		min-height: 1000px;
	}
	#gui {
		width: 100px; height: 100px;
	}
	#commandsPanel {
		width: 500px; text-align: center; position: absolute; top: 0; left: 0;
	}
	#topology {
		width: 60%; height: 100%; position: absolute; left: 500px; top: 0;
	}
	.well {word-wrap: break-word;}
	.table-responsive {display: none;}
	</style>
</head>
<body>
	<script type="text/javascript">
        $(function(){
        	var webSocket;
    		var currentMsgVersion = 0;
    		var requestTimes = new Array();
    		
       		var topology = window.topology = cytoscape({
               	container: document.getElementById('topology'),
               	boxSelectionEnabled: false,
               	//autounselectify: true,
               	maxZoom: 2,
               	layout: { name: 'dagre' },
               	elements: {nodes: [{ data: { id: '30010' } }]},
				style: [
				        {selector: 'node', style: {
		                        'content': 'data(id)',
		                        'text-opacity': 0.5,
		                        'text-valign': 'center',
		                        'text-halign': 'left',
		                        'background-color': '#11479e'
			                }},
				        {selector: 'edge', style: {
		                        'width': 4,
		                        'line-color': 'black'
		                        //'line-color': '#9dbaea'
			                }}
				]
			});
       		
       		function openSocket(){
       			if (webSocket != undefined && webSocket.readyState != WebSocket.CLOSED){
       				return;
       			}
       			webSocket = new WebSocket("ws://" + location.host + "/RSSFWebInterface/actions");

       			webSocket.onmessage = function(event){
       				if (event.data == undefined){
       					return;
       				}				
       				showMessage(event.data);
       				var msg = JSON.parse(event.data);
       				if (msg.node_id != undefined){
       					showOnTable(msg);
       					showOnTopology(msg);
       				}
       			}
       			
       			webSocket.onopen = function(event){
       				$("#btnConnect").val("Disconnect");
       				$("#btnConnect").removeClass("disabled").addClass("active");
       				$("#btnColetar").removeClass("disabled");
       				if (event.data == undefined){
       					return;
       				}
       				//showMessage(event.data);
       			}
       			
       			webSocket.onclose = function(event){
       				showMessage("Conexao fechada");
       				$("#btnColetar").addClass("disabled");
       				$("#btnConnect").removeClass("active").removeClass("disabled");
       				$("#btnConnect").val("Connect");
       			}
       		}
       		
       		function showOnTable(msg){
       			var rtt = requestTimes[msg.version] - Date.now();
       			// if exists a row for this node...
       			if ($("#row"+msg.node_id).length>0){
       				$(".table-responsive").show();
       				var row = $("#row"+msg.node_id);
       				row.children().eq(0).text(msg.node_id);
       				row.children().eq(1).text(msg.parent_id);
       				row.children().eq(2).text(msg.temperature);
       				row.children().eq(3).text(msg.luminosity);
       				row.children().eq(4).text(msg.version);
       				row.children().eq(5).text(rtt);
       				
       			} else {
       				$(".table-responsive").show();
       				$("#tableBody").append("<tr id=\"row"+msg.node_id+"\">" +
       						"<td>"+msg.node_id+"</td>" +
       						"<td>"+msg.parent_id+"</td>" +
       						"<td>"+msg.temperature+"</td>" +
       						"<td>"+msg.luminosity+"</td>" +
       						"<td>"+msg.version+"</td>" +
       						"<td>"+rtt+"</td>" +
       						"</tr>");
       			}
       		}
       		
       		function showOnTopology(msg){
       			var colorRange = chroma.scale(['yellow','red']);
       			var temperatureColor = colorRange(parseInt(msg.temperature)/100*1.8).toString();
       			colorRange = chroma.scale(['black','white']);
       			var luminosityColor = colorRange((parseInt(msg.luminosity)+100)/1000).toString();
   				topology.add({group:"nodes",data:{id:msg.node_id}});
   				topology.nodes("[id='"+msg.node_id+"']").style("background-color", temperatureColor);
   				topology.nodes("[id='"+msg.node_id+"']").style("border-color", luminosityColor);
   				topology.nodes("[id='"+msg.node_id+"']").style("border-width", 4);
   				topology.remove("[source='"+msg.node_id+"']");
   				topology.add({group:"edges", data:{source:msg.node_id, target:msg.parent_id}});
//   				if (msg.parent_id != undefined){
//   					var selector = "[source='"+msg.parent_id+"'][target='"+msg.node_id+"']";
//   					if (topology.edges(selector).length==0){
//   						topology.add({group:"edges", data:{source:msg.parent_id, target:msg.node_id}});
//   					}
//   				}
   				topology.layout({name:"dagre"});       			
       		}
       		
       		function sendMessage(destination){
       			openSocket();
       			requestTimes[currentMsgVersion] = Date.now();
       			webSocket.send("{\"action\":\"collect\", \"version\":"+currentMsgVersion+"}");
       			currentMsgVersion++;
       		}
       		
       		function closeSocket(){
       			if (webSocket == undefined || webSocket.readyState == WebSocket.CLOSED){
       				return;
       			}
       			webSocket.close();
       		}
        		
       		function showMessage(text){
       			$("#messages").text(text);
       		}
       		
			$("#boxAllSensors").change(function(){
			        if (this.checked){
			                $("#idSensor").prop('disabled', true);
			        } else {
			                $("#idSensor").prop('disabled', false);
			        }
			});

			$("#btnColetar").click(function(){
			        // if message is a broadcast
			        if ($("#btnColetar").hasClass("disabled")){
			        	return;
			        }
			        if ($("#boxAllSensors:checked").length>0){
			        	destination = 65535;
			        } else if ( !isNaN( parseInt($("#idSensor").val()) )){
			        	destination = $("#idSensor").val();
			        } else {
			        	showMessage("Invalid address.");
			        	return;
			        }
			        $("#messages").text("Sending request...");
			        sendMessage(destination);
			});

			$("#btnConnect").click(function(){
				// if is connecting
				if ($("#btnConnect").val() == "Connect"){
					$("#btnConnect").val("Connecting");
					$("#btnConnect").removeClass("active").addClass("disabled");
			        openSocket();
				// if is disconnecting
				} else if ($("#btnConnect").val() == "Disconnect"){
					$("#btnConnect").val("Disconnecting");
					$("#btnConnect").addClass("disabled");
					closeSocket();
				}
		});			
			
        });
                      
	</script>
	<div id="gui" class="row">
		<div id="commandsPanel" class="col-lg-4">
			<p><b>Trabalho Prático 2 - Redes de Sensores Sem Fio</b></p>
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h3 class="panel-title">Coleta de dados</h3>
				</div>
				<div class="panel-body">
					<input id="btnConnect" type="button" class="btn btn-bg btn-primary" value="Connect"><br><br>
					<label><input id="boxAllSensors" name="allSensors" type="checkbox">Broadcast</label>
					<span>ou</span>
					<label>Sensor: <input id="idSensor" name="idSensor" type="text" size="5" maxlength="5"></label><br>
					<input id="btnColetar" type="button" class="btn btn-bg btn-primary disabled" value="Collect data">
				</div>
			</div>
	        <div id="messages" class="well">
	        </div>
			<div class="table-responsive">
				<p>Dados recebidos:</p>
				<table class="table table-striped">
					<thead>
		                <tr>
		                    <td>Sensor</td>
		                    <td>Parent</td>
		                    <td>Temp</td>
		                    <td>Light</td>
		                    <td>Version</td>
		                    <td>RTT</td>
		                </tr>
	                 </thead>
	                 <tbody id="tableBody">
					</tbody>
				</table>
			</div>
		</div>
		<div id="topology" class="col-lg-4">
		</div>
	</div>
</body>
</html>