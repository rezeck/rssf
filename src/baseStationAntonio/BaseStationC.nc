#include "BaseStation.h"

module BaseStationC{
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface SplitControl as SerialControl;
		
		interface AMSend as RadioSend[am_id_t id];
	    interface Receive as RadioReceive[am_id_t id];
	    interface Packet as RadioPacket;
	    interface AMPacket as RadioAMPacket;		
		
		interface AMSend as UartSend[am_id_t id];
		interface Receive as UartReceive[am_id_t id];
		interface Packet as UartPacket;
		interface AMPacket as UartAMPacket;
		
		interface Leds;
	}
}

implementation{

	nx_uint16_t lastQuestionVersion; // version of last question sent
	message_t radioSendQuestion; // buffer to send questions over radio
	message_t serialSendAnswer; // buffer to send answers over serial
	bool radioSending = FALSE; // avoid send messages while radio is busy
	bool uartSending = FALSE; // avoid send messages while radio is busy
	
	task void radioSendQuestionTask();
	task void serialSendAnswerTask();
	
	event void Boot.booted(){
#ifdef RSSF_DEBUG
		dbg("Boot", "BaseStation booted. ID is: %d.\n", TOS_NODE_ID);
#endif
		lastQuestionVersion = 0;
		call Leds.led0On();
		// start serial
		call SerialControl.start();
		// start radio
		call RadioControl.start();
	}
	
//	event void Boot.booted(){
//		dbg("Boot", "BaseStation booted. ID is: %d.\n", TOS_NODE_ID);
//		// define BaseStation address
//		lastQuestionVersion = 0;
//		call RadioAMAddress.setAddress(MOTE_GROUP, MOTE_ADDRESS+TOS_NODE_ID);
//	}
	
	/**
	 * @param msg pointer to received packeet
	 * @param payload pointer to payload of the packet pointed by msg
	 * @param len payload's size
	 * @return a message_t pointer to store next received message/packet
	 */
	event message_t * RadioReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len){
#ifdef RSSF_DEBUG
		dbg("Radio", "BaseStation received a message of type %d from %d.\n", id, call RadioAMPacket.source(msg));
#endif		
		// check if the message has a valid type (answer)
		if (id != AM_ANSWER){
#ifdef RSSF_DEBUG
			dbg("Radio", "The type %d is unknown. Only answers are accepted here.\n", id);
#endif
			return msg;
		}
		
		if (len == sizeof(MoteMsg)){
			// cast msg to read values
			MoteMsg* motemsg = (MoteMsg*)payload;
#ifdef RSSF_DEBUG
			dbg("Radio", "Payload values on receive: Version %d, Size %d.\n", motemsg->version, motemsg->size);
			dbg("Radio", "Preparing to route answer over serial.\n");
#endif
			// send msg over serial
			serialSendAnswer = *msg;
			post serialSendAnswerTask();
		}
		
		return msg;
	}

	/**
	 * @param msg pointer to received packeet
	 * @param payload pointer to payload of the packet pointed by msg
	 * @param len payload's size
	 * @return a message_t pointer to store next received message/packet
	 */	
	event message_t * UartReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len){
#ifdef RSSF_DEBUG
		dbg("Serial", "BaseStation received a message of type %d from %d.\n", id, call UartAMPacket.source(msg));
#endif		
		// check if the message has a valid type (question)
		if (id != AM_QUESTION){
#ifdef RSSF_DEBUG
			dbg("Serial", "The type %d is unknown. Only questions are accepted here.\n", id);
#endif
			return msg;
		}
				
		if (len == sizeof(MoteMsg)){
			// cast msg to read values
			MoteMsg* motemsg = (MoteMsg*)payload;
#ifdef RSSF_DEBUG			
			dbg("Serial", "Payload values on receive: Version %d, Size %d.\n", motemsg->version, motemsg->size);		
			dbg("Serial", "Preparing to resend question.\n");
#endif			
			// send msg over radio	
			radioSendQuestion = *msg;
			post radioSendQuestionTask();
		}
		
		return msg;	
	}	
	
	task void radioSendQuestionTask(){
#ifdef RSSF_DEBUG		
		dbg("Radio", "Trying to send question.\n");
#endif
		if (!radioSending){
#ifdef RSSF_DEBUG
			dbg("Radio", "Sending question.\n");
#endif
			if (call RadioSend.send[AM_QUESTION](
					call RadioAMPacket.destination(&radioSendQuestion),&radioSendQuestion, sizeof(MoteMsg)) == SUCCESS)
				radioSending = TRUE;
		} else {
#ifdef RSSF_DEBUG
			dbg("Radio", "Radio is busy.\n");
#endif
		}
	}
	
	task void serialSendAnswerTask(){
#ifdef RSSF_DEBUG		
		dbg("Serial", "Trying to send answer.\n");
#endif
		if (!uartSending){
#ifdef RSSF_DEBUG			
			dbg("Serial", "Sending answer.\n");
#endif			
			if (call UartSend.send[AM_ANSWER](
					call UartAMPacket.destination(&serialSendAnswer), &serialSendAnswer, sizeof(MoteMsg)) == SUCCESS)
				uartSending = TRUE;		
		} else {
#ifdef RSSF_DEBUG
			dbg("Serial", "Uart is busy.\n");
#endif			
		}
	}
	
	event void RadioSend.sendDone[am_id_t id](message_t *msg, error_t error){
#ifdef RSSF_DEBUG
		MoteMsg* motemsg;
		motemsg = (MoteMsg*)(call RadioPacket.getPayload(msg, sizeof(MoteMsg)));
		dbg("Radio", "Send done. Type: %d, Source: %d, Destination: %d, Version %d, Size: %d. Free radio.\n",
			id, call RadioAMPacket.source(msg), call RadioAMPacket.destination(msg), motemsg->version, motemsg->size);
#endif
		call Leds.led2Toggle();
		radioSending = FALSE;
	}
	
	event void UartSend.sendDone[am_id_t id](message_t *msg, error_t error){
#ifdef RSSF_DEBUG
		MoteMsg* motemsg;
		dbg("Serial", "Error status after send: %d.\n", error);

		motemsg = (MoteMsg*)(call UartPacket.getPayload(msg, sizeof(MoteMsg)));
		dbg("Serial", "Send done. Type: %d, Source: %d, Destination: %d, Version %d, Size: %d. Free uart.\n",
			id, call UartAMPacket.source(msg), call UartAMPacket.destination(msg), motemsg->version, motemsg->size);
#endif			
		uartSending = FALSE;
	}	

	event void RadioControl.startDone(error_t error){
		// Radio started. Nothing to do.
		call Leds.led1On();
	}

	event void RadioControl.stopDone(error_t error){
		// Radio stopped. Nothing to do.
	}

	event void SerialControl.startDone(error_t error){
		// Serial started. Nothing to do.
	}

	event void SerialControl.stopDone(error_t error){
		// Serial started. Nothing to do.
	}
}