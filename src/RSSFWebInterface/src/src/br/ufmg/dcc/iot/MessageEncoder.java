package br.ufmg.dcc.iot;

import org.json.simple.JSONObject;

public class MessageEncoder {
	
	public static String encodeToJson(MoteAnswerMsg msg){
		JSONObject json = new JSONObject();
		json.put("version", msg.get_version());
		json.put("node_id", msg.get_src());
		json.put("parent_id", msg.get_parent_node());
		json.put("temperature", msg.get_temperature());
		json.put("luminosity", msg.get_luminosity());
		return json.toString();
	}
}