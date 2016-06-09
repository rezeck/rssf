package br.ufmg.dcc.iot;
	
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/actions")
public class WebSocketServer {
	
	private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<Session>());
	
	@OnOpen
	public void onOpen(Session session){
		System.out.println(session.getId() + " abriu ua conexao.");
		try {
			session.getBasicRemote().sendText("{\"event\":\"Conexao aberta.\"}");
		} catch (Exception e) {
			e.printStackTrace();
		}
		sessions.add(session);
	}
	
	@OnMessage
	public void onMessage(String message, Session session){
		System.out.println("Mensagem de " + session.getId() + " : " + message);
		MoteQuestionMsg moteQuestionMsg = MessageDecoder.decodeJson(message);
		BaseStationConnection.getInstance().sendMessageToMote(moteQuestionMsg);
		System.out.println("fim");
	}
	
	@OnClose
	public void onClose(Session session){
		System.out.println("Sessao " + session.getId() + " foi fechada.");
	}
	
	@OnError
	public void onError(Throwable error){
		
	}
	
	public static void sendMessageToAll(String msg){
		for (Session s : sessions){
			if (s != null && s.isOpen()){
				try {
					System.out.println(msg);
					s.getBasicRemote().sendText(msg);
				} catch (IOException e) {
					//e.printStackTrace();
					System.out.println("Falha ao enviar mensagem.");
				}
			}
		}
	}
}
