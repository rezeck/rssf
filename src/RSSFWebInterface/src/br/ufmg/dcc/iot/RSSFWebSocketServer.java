package br.ufmg.dcc.iot;
	
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/actions")
public class RSSFWebSocketServer {
	@OnOpen
	public void onOpen(Session session){
		System.out.println(session.getId() + " abriu ua conexao.");
		try {
			session.getBasicRemote().sendText("Conexao estabelecida");
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	@OnMessage
	public void onMessage(String message, Session session){
		System.out.println("Mensagem de " + session.getId() + " : " + message);
		try {
			session.getBasicRemote().sendText("Sua mensagem e: " + message);
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
	
	@OnClose
	public void onClose(Session session){
		System.out.println("Sessao " + session.getId() + " foi fechada.");
	}
	
	@OnError
	public void onError(Throwable error){
		
	}	
}
