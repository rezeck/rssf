/************************************************************
Base Station code implementation
************************************************************/

/************************************************************/	
#include <Timer.h>
#include "BaseStation.h"
/************************************************************/

module BaseStationC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;

	uses interface Packet as QPacket;
	uses interface AMPacket as AMQPacket;
	uses interface AMSend as AMSendQuestion;
	uses interface Receive as AMReceiveAnswer;

  	uses  interface AMSend as UartSend;
  	uses  interface Receive as UartReceive;
  	uses  interface Packet as UartPacket;
  	uses  interface AMPacket as UartAMPacket;

	uses interface SplitControl as AMControl;
	uses interface SplitControl as SerialControl;
}
implementation {
/*********************************************************
Variables
*********************************************************/
bool busy = FALSE;
nx_uint16_t version;
message_t pkt;
/*********************************************************/

/*********************************************************
Boot event init
*********************************************************/
event void Boot.booted() {
	call AMControl.start();
	call SerialControl.start();
}
/*********************************************************/

/*********************************************************
Serial started event 
*********************************************************/
event void SerialControl.startDone(error_t error) {
    if (error == SUCCESS) {
      //uartFull = FALSE;
    }
}
/*********************************************************/

/*********************************************************
Serial stoped event 
*********************************************************/
event void SerialControl.stopDone(error_t error) {}
/*********************************************************/

/*********************************************************
Radio started event 
*********************************************************/
event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
		version = 0;
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
Sent a question event
*********************************************************/
event void AMSendQuestion.sendDone(message_t* msg, error_t err) {
}
/*********************************************************/

/*********************************************************
Received an answer from radio event
*********************************************************/
event message_t* AMReceiveAnswer.receive(message_t* msg, void* payload, uint8_t len){
	if (len == sizeof(MoteMsg)) {
		// Get header information
		am_id_t id = call AMQPacket.type(msg);
    	am_addr_t dst = call AMQPacket.destination(msg);
    	am_addr_t src = call AMQPacket.source(msg);
	
    	// Get payload
		MoteMsg* motepkt = (MoteMsg*)payload;
		
	}
	return msg;
}
/*********************************************************/

/*********************************************************
Received an question from serial event
*********************************************************/
event message_t *UartReceive.receive(message_t *msg, void *payload, uint8_t len){

}
/*********************************************************/

/*********************************************************
Sent a question event
*********************************************************/
event void UartSend.sendDone(message_t* msg, error_t error) {}
/*********************************************************/

/*********************************************************
Timer0 event fired
*********************************************************/
event void Timer0.fired() {
	if (!busy){

	}
}
/*********************************************************/
}
/************************************************************
END OF CODE
************************************************************/	