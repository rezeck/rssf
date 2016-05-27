/************************************************************
	Top-level configuration	file
************************************************************/

/************************************************************/	
#include <Timer.h>
#include "Station.h"
/************************************************************/

/************************************************************/	
configuration StationAppC {
}
implementation {
  components MainC;
  components LedsC;
  components StationC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_QUESTION) as sendQuestion;
  components new AMReceiverC(AM_QUESTION) as receiveQuestion;
  components new AMSenderC(AM_ANSWER) as sendAnswer;
  components new AMReceiverC(AM_ANSWER) as receiveAnswer;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
}
/************************************************************
END OF CODE
************************************************************/