package br.ufmg.dcc.iot;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class MessageDecoder {
	public static MoteQuestionMsg decodeJson(String msgJson){
		JSONParser parser = new JSONParser();
		MoteQuestionMsg moteMsg = new MoteQuestionMsg();
		try {
			JSONObject json = (JSONObject) parser.parse(msgJson);
			moteMsg.set_version(Integer.parseInt(json.get("version").toString()));
			moteMsg.set_size(2);
		} catch (ParseException e) {
			System.out.println("JSON invalido");
			e.printStackTrace();
		}
		return moteMsg;		
	}
}
