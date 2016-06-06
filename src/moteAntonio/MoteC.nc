#include "Mote.h"

module MoteC{
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface BaseStation;
		
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
#ifdef TOSSIM_BASESTATION_SIMULATION
		if (TOS_NODE_ID == 0){
			call BaseStation.startBaseStation();
			return;
		}
#endif
#ifdef RSSF_DEBUG
		dbg("Boot", "Mote booted. ID is: %d.\n", TOS_NODE_ID);
#endif		
		// define mote address
		call RadioAMAddress.setAddress(MOTE_GROUP, MOTE_ADDRESS+TOS_NODE_ID);
	}

	async event void RadioAMAddress.changed(){
#ifdef TOSSIM_BASESTATION_SIMULATION		
		if (TOS_NODE_ID == 0) return;
#endif
#ifdef RSSF_DEBUG
		dbg("Boot", "The address is now: %d.\n", (call RadioAMAddress.amAddress()));
#endif
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
#ifdef TOSSIM_BASESTATION_SIMULATION		
		if (TOS_NODE_ID == 0) return msg;
#endif
#ifdef RSSF_DEBUG
		dbg("Radio", "Received a message of type %d from %d.\n", id, call RadioAMPacket.source(msg));
#endif		
		// check if the message has a valid type (question or answer)
		if (id != AM_QUESTION && id != AM_ANSWER){
#ifdef RSSF_DEBUG
			dbg("Radio", "The type %d is unknown. Ignoring message.\n", id);
#endif
			return msg;
		}
		
		if (len == sizeof(MoteMsg)){
			// cast msg to read values
			MoteMsg* motemsg = (MoteMsg*)payload;
#ifdef RSSF_DEBUG			
			dbg("Radio", "Payload values on receive: Version %d, Size %d.\n", motemsg->version, motemsg->size);
#endif			
			// if the message is a question...
			if (id == AM_QUESTION){
				
				// if is a duplicated question, ignore
				if (motemsg->version == lastQuestionVersion){
#ifdef RSSF_DEBUG
					dbg("Radio", "Duplicated question version %d. Ignoring.\n", motemsg->version);
#endif
					return msg;
				}
				
				// only a new question reach to here		
				lastQuestionVersion = motemsg->version;
				parent_addr = call RadioAMPacket.source(msg);
				
				// if this question is for me
				if (call RadioAMPacket.isForMe(msg)){
#ifdef RSSF_DEBUG
					dbg("Radio", "Msg is for me. Preparing to answer.\n");
#endif
					radioSendAnswer = *msg;
					motemsg = (MoteMsg*)(call RadioPacket.getPayload(&radioSendAnswer, sizeof(MoteMsg)));
					motemsg->src = call RadioAMAddress.amAddress();
					motemsg->parent_node = parent_addr;
					motemsg->size = 2;
					motemsg->temperature = 20;
					motemsg->luminosity = 1000;
					hasAnswerToSend = TRUE; // send command will be called by sendDone in future
				}
#ifdef RSSF_DEBUG				
				dbg("Radio", "Preparing to resend question.\n");
#endif
				radioSendQuestion = *msg;
				post radioSendQuestionTask();
				
				
			// otherwise, it will be an answer, so, retransmit as is
			} else {
#ifdef RSSF_DEBUG
				dbg("Radio", "Routing answer. Version: %d, Size: %d, Src: %d, Parent: %d, Temperature: %d, Luminosity: %d.\n",
					motemsg->version, motemsg->size, motemsg->src, motemsg->parent_node, motemsg->temperature, motemsg->luminosity);
#endif
				radioSendAnswer = *msg;
				post radioSendAnswerTask();
			}
		}
		return msg;
	}
	
	task void radioSendQuestionTask(){
#ifdef RSSF_DEBUG
		dbg("Radio", "Trying to send question.\n");
#endif
		if (!sending){
#ifdef RSSF_DEBUG
			dbg("Radio", "Sending question.\n");
#endif
			if (call RadioSend.send[AM_QUESTION](AM_BROADCAST_ADDR, &radioSendQuestion, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;
		} else {
#ifdef RSSF_DEBUG
			dbg("Radio", "Radio is busy.\n");
#endif			
		}
	}
	
	task void radioSendAnswerTask(){
#ifdef RSSF_DEBUG
		dbg("Radio", "Trying to send answer.\n");
#endif
		if (!sending){
#ifdef RSSF_DEBUG
			dbg("Radio", "Sending answer.\n");
#endif
			if (call RadioSend.send[AM_ANSWER](parent_addr, &radioSendAnswer, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;		
		} else {
#ifdef RSSF_DEBUG
			dbg("Radio", "Radio is busy.\n");
#endif
		}
	}
	
	event void RadioSend.sendDone[am_id_t id](message_t *msg, error_t error){
#ifdef RSSF_DEBUG
		MoteMsg *motemsg;
#endif		
#ifdef TOSSIM_BASESTATION_SIMULATION		
		if (TOS_NODE_ID == 0){return;}
#endif
#ifdef RSSF_DEBUG
		motemsg = (MoteMsg*)(call RadioPacket.getPayload(msg, sizeof(MoteMsg)));
		dbg("Radio", "Send done. Type: %d, Source: %d, Destination: %d, Version %d, Size: %d. Free radio.\n",
			id, call RadioAMPacket.source(msg), call RadioAMPacket.destination(msg), motemsg->version, motemsg->size);
#endif
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