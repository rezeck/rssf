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
bool question_sent = FALSE;
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
	dbg("Mote", "Application booted.\n");
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
		dbg("Mote", "AMControl started.\n");
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
	dbg("Mote", "AMControl stopped.\n");
}
/*********************************************************/

/*********************************************************
Timer0 event fired
*********************************************************/
event void Timer0.fired() { /*TODO*/
	// update values from sensor
	//dbg("Mote", "Time.\n");
	//simulation to sink
	if (TOS_NODE_ID == 1 && !question_sent){
	 	mtpkt = (MoteMsg*)(call QPacket.getPayload(&req, sizeof(MoteMsg)));
	 	if (mtpkt == NULL)
	 		return;
	 	version += 1;
	 	mtpkt->version = version;

		if (call AMSendQuestion.send(AM_BROADCAST_ADDR, &req, sizeof(MoteMsg)) == SUCCESS){
			question_sent = TRUE;
			dbg("Mote", "Sink send question.\n");
		}

	}
}
/*********************************************************/

/*********************************************************
Sent a question event
*********************************************************/
event void AMSendQuestion.sendDone(message_t* msg, error_t err) {
	if (msg == &pkt){
		//question_sent = FALSE;
		//dbg("Mote", "Question was sent.\n");
	}
}
/*********************************************************/

/*********************************************************
Sent an answer event
*********************************************************/
event void AMSendAnswer.sendDone(message_t* msg, error_t err) {
	if (msg == &pkt){
		//dbg("Mote", "Answer was sent.\n");
	}
}
/*********************************************************/

/*********************************************************
Received an answer event
*********************************************************/
event message_t* AMReceiveAnswer.receive(message_t* msg, void* payload, uint8_t len){
	dbg("Mote", "Receive answer.\n");
	if (len == sizeof(MoteMsg)) {
		// Get header information
		am_id_t id = call AMPacket.type(msg);
    	am_addr_t dst = call AMPacket.destination(msg);
    	am_addr_t src = call AMPacket.source(msg);
	
    	// Get payload
		MoteMsg* motepkt = (MoteMsg*)payload;
		mtpkt = (MoteMsg*)(call APacket.getPayload(&pkt, sizeof(MoteMsg)));
		dbg("Mote", "answer is ok.\n");
		// Re-send answer to my father
		if (TOS_NODE_ID != 1){
			mtpkt->temperature = motepkt->temperature;
			mtpkt->luminosity = motepkt->luminosity;
			mtpkt->src = motepkt->src;
			call AMSendAnswer.send(parent_addr, &pkt, sizeof(MoteMsg));
			dbg("Mote", "mote receive answer from %hu - repassing to %hu...\n", src, parent_addr);
		}else{
			dbg("Mote", "sink receive answer from %hu(%hu, %hu)\n", motepkt->src, motepkt->temperature, motepkt->luminosity);
		}
	}
	return msg;
}
/*********************************************************/

/*********************************************************
Received a question event
*********************************************************/
event message_t* AMReceiveQuestion.receive(message_t* msg, void* payload, uint8_t len){
	dbg("Mote", "Receive a question.\n");
	if (len == sizeof(MoteMsg)) {
		// Get header information
		am_id_t id = call AMPacket.type(msg);
    	am_addr_t dst = call AMPacket.destination(msg);
    	am_addr_t src = call AMPacket.source(msg);
    	
		// Get payload
		MoteMsg* motepkt = (MoteMsg*)payload;
		
		dbg("Mote", "Question is ok.\n");
		// Check if mote has already receive this question
		
		if (motepkt->version == version){
			dbg("Mote", "Question version %hu from %hu is not ok.\n", version, motepkt->version);
			dbg("Mote", "Discart question.\n");
			return msg;
		}
		version += 1;
		dbg("Mote", "Question version %hu is ok.\n", version);
		
		
		mtpkt = (MoteMsg*)(call APacket.getPayload(&pkt, sizeof(MoteMsg)));
		
		mtpkt->version = version;
		

    	// Getting father address
		parent_addr = src;

		// Is Sink asking me
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

			//dbg("Mote", "Enter Receive msg send answer.1\n");
			call AMSendAnswer.send(parent_addr, &pkt, sizeof(MoteMsg));
			dbg("Mote", "Answering question (%hu, %hu)\n", luminosity, temperature);
			//dbg("Mote", "Enter Receive msg send answer.2\n");
		}
		mtpkt = (MoteMsg*)(call QPacket.getPayload(&req, sizeof(MoteMsg)));
		mtpkt->version = version;
		// Sink is not asking me
		// re-send question
		call AMSendQuestion.send(dst, &req, sizeof(MoteMsg));
		dbg("Mote", "reply question\n");
	}
	return msg;
}
/*********************************************************/

/*********************************************************/
}
/************************************************************
END OF CODE
************************************************************/	