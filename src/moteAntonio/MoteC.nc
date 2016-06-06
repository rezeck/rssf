#include "Mote.h"

module MoteC{
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		
		interface AMSend as RadioSend[am_id_t id];
	    interface Receive as RadioReceive[am_id_t id];
	    interface Packet as RadioPacket;
	    interface AMPacket as RadioAMPacket;		
		interface ActiveMessageAddress as RadioAMAddress;
	}
}
implementation{

	am_addr_t parent_addr; // parent node to send responses
	nx_uint16_t lastQuestionVersion; // version of last question processed
	message_t radioSendQuestion; // buffer to send questions
	message_t radioSendAnswer; // buffer to send answers
	bool sending = FALSE; // avoid send messages while radio is busy
	bool hasAnswerToSend = FALSE; // used to check if has an answer to send
	
	task void radioSendQuestionTask();
	task void radioSendAnswerTask();
	
	event void Boot.booted(){
		dbg("Boot", "Mote booted. ID is: %d.\n", TOS_NODE_ID);
		// define mote address
		call RadioAMAddress.setAddress(MOTE_GROUP, MOTE_ADDRESS+TOS_NODE_ID);
	}

	async event void RadioAMAddress.changed(){
		dbg("Boot", "The address is now: %d.\n", (call RadioAMAddress.amAddress()));
		// start radio after define address
		call RadioControl.start();
	}
	
	/**
	 * @param msg pointer to received packeet
	 * @param payload pointer to payload of the packet pointed by msg
	 * @param len payload's size
	 * @return a message_t pointer to store next received message/packet
	 */
	event message_t * RadioReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len){
		dbg("Radio", "Received a message of type %d from %d.\n", id, call RadioAMPacket.source(msg));
		
		// check if the message has a valid type (question or answer)
		if (id != AM_QUESTION && id != AM_ANSWER){
			dbg("Radio", "The type %d is unknown. Ignoring message.\n", id);
			return msg;
		}
		
		if (len == sizeof(MoteMsg)){
			// cast msg to read values
			MoteMsg* motemsg = (MoteMsg*)payload;
			
			dbg("Radio", "Payload values on receive: Version %d, Size %d.\n", motemsg->version, motemsg->size);
			
			// if the message is a question...
			if (id == AM_QUESTION){
				
				// if is a duplicated question, ignore
				if (motemsg->version == lastQuestionVersion){
					dbg("Radio", "Duplicated question version %d. Ignoring.\n", motemsg->version);
					return msg;
				}
				
				// only a new question reach to here		
				lastQuestionVersion = motemsg->version;
				parent_addr = call RadioAMPacket.source(msg);
				
				// if this question is for me
				if (call RadioAMPacket.isForMe(msg)){
					dbg("Radio", "Msg is for me. Preparing to answer.\n");
					radioSendAnswer = *msg;
					motemsg = (MoteMsg*)(call RadioPacket.getPayload(&radioSendAnswer, sizeof(MoteMsg)));
					motemsg->src = call RadioAMAddress.amAddress();
					motemsg->parent_node = parent_addr;
					motemsg->size = 2;
					motemsg->temperature = 20;
					motemsg->luminosity = 1000;
					hasAnswerToSend = TRUE; // send command will be called by sendDone in future
				}
				
				dbg("Radio", "Preparing to resend question.\n");
				radioSendQuestion = *msg;
				post radioSendQuestionTask();
				
				
			// otherwise, it will be an answer, so, retransmit as is
			} else {
				dbg("Radio", "Routing answer. Version: %d, Size: %d, Src: %d, Parent: %d, Temperature: %d, Luminosity: %d.\n",
					motemsg->version, motemsg->size, motemsg->src, motemsg->parent_node, motemsg->temperature, motemsg->luminosity);
				radioSendAnswer = *msg;
				post radioSendAnswerTask();
			}
		}
		return msg;
	}
	
	task void radioSendQuestionTask(){
		dbg("Radio", "Trying to send question.\n");
		if (!sending){
			dbg("Radio", "Sending question.\n");
			if (call RadioSend.send[AM_QUESTION](AM_BROADCAST_ADDR, &radioSendQuestion, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;
		} else {
			dbg("Radio", "Radio is busy.\n");
		}
	}
	
	task void radioSendAnswerTask(){
		dbg("Radio", "Trying to send answer.\n");
		if (!sending){
			dbg("Radio", "Sending answer.\n");
			if (call RadioSend.send[AM_ANSWER](parent_addr, &radioSendAnswer, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;		
		} else {
			dbg("Radio", "Radio is busy.\n");
		}
	}
	
	event void RadioSend.sendDone[am_id_t id](message_t *msg, error_t error){
		MoteMsg* motemsg = (MoteMsg*)(call RadioPacket.getPayload(msg, sizeof(MoteMsg)));
		dbg("Radio", "Send done. Type: %d, Source: %d, Destination: %d, Version %d, Size: %d. Free radio.\n",
			id, call RadioAMPacket.source(msg), call RadioAMPacket.destination(msg), motemsg->version, motemsg->size);
		sending = FALSE;
		if (hasAnswerToSend){
			post radioSendAnswerTask();
			hasAnswerToSend = FALSE;
		}
	}	

	event void RadioControl.startDone(error_t error){
		// Radio started. Nothing to do.
	}

	event void RadioControl.stopDone(error_t error){
		// Radio stopped. Nothing to do.
	}
}