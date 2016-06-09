#include "Mote.h"

module MoteC{
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface Leds;

		interface AMSend as RadioSend[am_id_t id];
	    interface Receive as RadioReceive[am_id_t id];
	    interface Packet as RadioPacket;
	    interface AMPacket as RadioAMPacket;
	    
	    interface Timer<TMilli> as TimerSensor;
	    
	    interface Read<uint16_t> as ReadPhoto;
	    interface Read<uint16_t> as ReadTemp;
	    
	    
	}
}
implementation{

	am_addr_t parent_addr; // parent node to send responses
	nx_uint16_t lastQuestionVersion; // version of last question processed
	message_t radioSendQuestion; // buffer to send questions
	message_t radioSendAnswer; // buffer to send answers
	bool sending = FALSE; // avoid send messages while radio is busy
	bool hasAnswerToSend = FALSE; // used to check if has an answer to send
	
	uint16_t lastLuminosity;
	uint16_t lastTemperature;
	
	task void radioSendQuestionTask();
	task void radioSendAnswerTask();
	
	event void Boot.booted(){
		call Leds.led0On();
		call TimerSensor.startPeriodic(500);
		call RadioControl.start();
	}
	
	/**
	 * @param msg pointer to received packeet
	 * @param payload pointer to payload of the packet pointed by msg
	 * @param len payload's size
	 * @return a message_t pointer to store next received message/packet
	 */
	event message_t * RadioReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len){	
		// check if the message has a valid type (question or answer)
		if (id != AM_QUESTION && id != AM_ANSWER){
			return msg;
		}
		
		if (len == sizeof(MoteMsg)){
			// cast msg to read values
			MoteMsg* motemsg = (MoteMsg*)payload;	
			// if the message is a question...
			if (id == AM_QUESTION){
				
				// if is a duplicated question, ignore
				if (motemsg->version == lastQuestionVersion){
					return msg;
				}
				
				// only a new question reach to here		
				lastQuestionVersion = motemsg->version;
				parent_addr = call RadioAMPacket.source(msg);
				
				// if this question is for me
				if (call RadioAMPacket.isForMe(msg)){
					radioSendAnswer = *msg;
					motemsg = (MoteMsg*)(call RadioPacket.getPayload(&radioSendAnswer, sizeof(MoteMsg)));
					motemsg->src = TOS_NODE_ID;
					motemsg->parent_node = parent_addr;
					motemsg->size = 2;
					motemsg->temperature = lastTemperature;
					motemsg->luminosity = lastLuminosity;
					hasAnswerToSend = TRUE; // send command will be called by sendDone in future
				}
				radioSendQuestion = *msg;
				post radioSendQuestionTask();
			// otherwise, it will be an answer, so, retransmit as is
			} else {
				radioSendAnswer = *msg;
				post radioSendAnswerTask();
			}
		}
		return msg;
	}
	
	task void radioSendQuestionTask(){
		call Leds.led0Toggle();
		if (!sending){
			if (call RadioSend.send[AM_QUESTION](AM_BROADCAST_ADDR, &radioSendQuestion, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;
		}
	}
	
	task void radioSendAnswerTask(){
		call Leds.led1Toggle();
		if (!sending){
			if (call RadioSend.send[AM_ANSWER](parent_addr, &radioSendAnswer, sizeof(MoteMsg)) == SUCCESS)
				sending = TRUE;		
		}
	}
	
	event void RadioSend.sendDone[am_id_t id](message_t *msg, error_t error){
		sending = FALSE;
		call Leds.led2Toggle();
		if (hasAnswerToSend){
			post radioSendAnswerTask();
			hasAnswerToSend = FALSE;
		}
	}	

	event void ReadPhoto.readDone(error_t result, uint16_t val){
		if (result == SUCCESS){
			lastLuminosity = val;
		}
	}
	
	event void ReadTemp.readDone(error_t result, uint16_t val){
		if (result == SUCCESS){
			lastTemperature = val;
		}
	}

	event void TimerSensor.fired(){
		call ReadPhoto.read();
		call ReadTemp.read();
	}
	
	event void RadioControl.startDone(error_t error){
		// Radio started. Nothing to do.
		call Leds.led1On();
	}

	event void RadioControl.stopDone(error_t error){
		// Radio stopped. Nothing to do.
	}	

}