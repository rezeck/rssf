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
	uses interface Packet;
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

am_addr_t father_addr;
nx_uint16_t question_id;
message_t pkt;

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
		question_id = 0;
		temperature = -1;
		luminosity = -1;
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
event void AMControl.stopDone(error_t err) {}
/*********************************************************/

/*********************************************************
Timer0 event fired
*********************************************************/
event void Timer0.fired() { /*TODO*/
	// update values from sensor
	//call Leds.led0On();
}
/*********************************************************/

/*********************************************************
Sent a question event
*********************************************************/
event void AMSendQuestion.sendDone(message_t* msg, error_t err) {}
/*********************************************************/

/*********************************************************
Sent an answer event
*********************************************************/
event void AMSendAnswer.sendDone(message_t* msg, error_t err) {}
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

		// Re-send answer to my father
		call AMSendAnswer.send(father_addr, &motepkt, sizeof(MoteMsg));
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
		if (motepkt->id == question_id){
			return msg;
		}
		else{
			question_id += 1;
		}

    	// Getting father address
		father_addr = src;

		// Is Sink asking me
		if(dst == TOS_NODE_ID){
			// send answer
			// update motepkt
			motepkt->luminosity = luminosity;
			motepkt->temperature = temperature;
			call AMSendAnswer.send(father_addr, &motepkt, sizeof(MoteMsg));
			return msg;
		}

		// Sink is not asking me
		// re-send question
		call AMSendQuestion.send(dst, &motepkt, sizeof(MoteMsg));

		// Is Sink ansking in broadcast
		if (dst == AM_BROADCAST_ADDR){
			// send answer
			// update motepkt
			motepkt->luminosity = luminosity;
			motepkt->temperature = temperature;
			call AMSendAnswer.send(father_addr, &motepkt, sizeof(MoteMsg));
		}
	}
	return msg;
}
/*********************************************************/

/*********************************************************/
}
/************************************************************
END OF CODE
************************************************************/	