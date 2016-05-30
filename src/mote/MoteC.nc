/************************************************************
Mote code implementation
************************************************************/

/************************************************************/	
#include <Timer.h>
#include "Mote.h"
/************************************************************/

module MoteC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet as QPacket;
	uses interface Packet as APacket;
	uses interface AMPacket;
	uses interface AMSend as AMSendQuestion;
	uses interface Receive as AMReceiveQuestion;
	uses interface AMSend as AMSendAnswer;
	uses interface Receive as AMReceiveAnswer;
	uses interface SplitControl as AMControl;
}
implementation {
/*********************************************************
Variables
*********************************************************/
//bool question_sent = FALSE;
//bool answer_sent = FALSE;

am_addr_t parent_addr;
nx_uint16_t version;
message_t pkt;
message_t req;
MoteMsg* mtpkt;

nx_uint16_t temperature;
nx_uint16_t luminosity; 

/*********************************************************/

/*********************************************************
Boot started event
*********************************************************/
event void Boot.booted() {
	call AMControl.start();
}
/*********************************************************/

/*********************************************************
Radio started event 
*********************************************************/
event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
		version = 0;
		temperature = TOS_NODE_ID*10;
		luminosity = TOS_NODE_ID*10;
		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
	}
	else {
		call AMControl.start();
	}
}
/*********************************************************/

/*********************************************************
Radio stoped event 
*********************************************************/
event void AMControl.stopDone(error_t err) {
}
/*********************************************************/

/*********************************************************
Timer0 event fired
*********************************************************/
event void Timer0.fired() { /*TODO*/
	// update values from sensor
	
}
/*********************************************************/

/*********************************************************
Sent a question event
*********************************************************/
event void AMSendQuestion.sendDone(message_t* msg, error_t err) {
}
/*********************************************************/

/*********************************************************
Sent an answer event
*********************************************************/
event void AMSendAnswer.sendDone(message_t* msg, error_t err) {
}
/*********************************************************/

/*********************************************************
Received an answer event
*********************************************************/
event message_t* AMReceiveAnswer.receive(message_t* msg, void* payload, uint8_t len){
	if (len == sizeof(MoteMsg)) {
		// Get header information
		am_id_t id = call AMPacket.type(msg);
    	am_addr_t dst = call AMPacket.destination(msg);
    	am_addr_t src = call AMPacket.source(msg);
	
    	// Get payload
		MoteMsg* motepkt = (MoteMsg*)payload;
		mtpkt = (MoteMsg*)(call APacket.getPayload(&pkt, sizeof(MoteMsg)));
		
		// Re-send answer to my father
		mtpkt->temperature = motepkt->temperature;
		mtpkt->luminosity = motepkt->luminosity;
		mtpkt->src = motepkt->src;
		call AMSendAnswer.send(parent_addr, &pkt, sizeof(MoteMsg));
	}
	return msg;
}
/*********************************************************/

/*********************************************************
Received a question event
*********************************************************/
event message_t* AMReceiveQuestion.receive(message_t* msg, void* payload, uint8_t len){
	if (len == sizeof(MoteMsg)) {
		// Get header information
		am_id_t id = call AMPacket.type(msg);
    	am_addr_t dst = call AMPacket.destination(msg);
    	am_addr_t src = call AMPacket.source(msg);
    	
		// Get payload
		MoteMsg* motepkt = (MoteMsg*)payload;
		
		// Check if mote has already receive this question
		if (motepkt->version == version){
			return msg;
		}
		// update question version
		version += 1;
		
		mtpkt = (MoteMsg*)(call APacket.getPayload(&pkt, sizeof(MoteMsg)));
		mtpkt->version = version;
		
    	// Getting father address
		parent_addr = src;

		// Is Sink asking me (I do not know if we need it)
		//if(dst == TOS_NODE_ID){
			// send answer
			// update motepkt
		//	motepkt->luminosity = luminosity;
		//	motepkt->temperature = temperature;
		//	call AMSendAnswer.send(father_addr, &motepkt, sizeof(MoteMsg));
		//	return msg;
		//}

		// Is Sink ansking in broadcast
		if (dst == AM_BROADCAST_ADDR){
			// send answer
			// update motepkt
			mtpkt->luminosity = luminosity;
			mtpkt->temperature = temperature;
			mtpkt->src = TOS_NODE_ID;

			call AMSendAnswer.send(parent_addr, &pkt, sizeof(MoteMsg));
		}

		// Sink is not asking me
		// re-send question
		mtpkt = (MoteMsg*)(call QPacket.getPayload(&req, sizeof(MoteMsg)));
		mtpkt->version = version;
		call AMSendQuestion.send(dst, &req, sizeof(MoteMsg));
	}
	return msg;
}
/*********************************************************/

/*********************************************************/
}
/************************************************************
END OF CODE
************************************************************/	