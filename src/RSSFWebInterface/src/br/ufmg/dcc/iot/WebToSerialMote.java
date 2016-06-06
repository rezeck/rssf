package br.ufmg.dcc.iot;

import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

import net.tinyos.message.*;
import net.tinyos.sf.SFClient;
import net.tinyos.sf.SerialForwarder;
import net.tinyos.util.*;

public class WebToSerialMote implements MessageListener {
	MoteIF mote;

	public void test(){
		mote = new MoteIF(PrintStreamMessenger.err);
		mote.registerListener(new MoteMsg(), this);
		try {
			Socket s = new Socket("127.0.0.1", 9002);
			SerialForwarder sf = new SerialForwarder(null);
			//SFClient sfc = new SFClient(s, arg1, arg2);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void messageReceived(int arg0, Message arg1) {
		// TODO Auto-generated method stub
		
	}
}
