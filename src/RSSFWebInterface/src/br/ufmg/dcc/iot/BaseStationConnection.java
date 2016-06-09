package br.ufmg.dcc.iot;

import java.io.IOException;
import net.tinyos.message.*;

public class BaseStationConnection implements MessageListener {
	
	private static BaseStationConnection baseStationConnection;
	private static MoteIF moteConnection;
	
	private BaseStationConnection() {
		MoteIF mote = getMoteIFInstance();
		mote.registerListener(new MoteAnswerMsg(), this);
	}

	public static BaseStationConnection getInstance(){
		if (baseStationConnection == null){
			baseStationConnection = new BaseStationConnection();
		}
		return baseStationConnection;
	}
	
	private static MoteIF getMoteIFInstance(){
		if (moteConnection == null){
			moteConnection = new MoteIF();
		}
		return moteConnection;
	}

	@Override
	public void messageReceived(int dstAddr, Message msg) {
		if (msg instanceof MoteAnswerMsg){
			MoteAnswerMsg moteMsg = (MoteAnswerMsg)msg;
			//convert temperature
			moteMsg.set_temperature((int) convertTemperature(moteMsg.get_temperature()));
			
			String msgJson = MessageEncoder.encodeToJson(moteMsg);
			WebSocketServer.sendMessageToAll(msgJson);
			
			System.out.println("MoteMsg. Src: " + moteMsg.get_src() +
					", Parent: " + moteMsg.get_parent_node() +
					", Temperature: " + moteMsg.get_temperature() +
					", Luminosity: " + moteMsg.get_luminosity() +
					", Size: " + moteMsg.get_size() +
					" , Dst: " + dstAddr);
		}
	}
	
	public void sendMessageToMote(MoteQuestionMsg msg){
		if (msg != null){
			try {
				MoteIF mote = getMoteIFInstance();
				mote.send(MoteIF.TOS_BCAST_ADDR, msg);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("MoteMsg is null");
		}
	}
	
	public double convertTemperature(int tempRead){
		System.out.println("Converting " + tempRead + " to celsius");
		double tempCelsius = 0;
		try {
			double rthr = 10000 * (1023-tempRead)/tempRead;
			double logRthr = Math.log(rthr);
			double tempKelvin = 1 / (0.001010024+ (0.000242127 * logRthr) + (0.000000146 * Math.pow(logRthr, 3)));
			tempCelsius = tempKelvin - 273.15;
		} catch (ArithmeticException e) {
			System.out.println("Falha ao converter temperatura.");
		}
		return tempCelsius;
	}
}