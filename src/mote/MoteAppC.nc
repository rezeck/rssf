/************************************************************
Mote configuration file
************************************************************/

/************************************************************/	
#include <Timer.h>
#include "Mote.h"
/************************************************************/

/************************************************************/	
configuration MoteAppC {
}
implementation {
	components MainC;
	components LedsC;
	components MoteC as App;
	components new TimerMilliC() as Timer0;

	components ActiveMessageC;

	components new AMSenderC(AM_QUESTION) as sendQuestion;
	components new AMReceiverC(AM_QUESTION) as receiveQuestion;

	components new AMSenderC(AM_ANSWER) as sendAnswer;
	components new AMReceiverC(AM_ANSWER) as receiveAnswer;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.AMControl -> ActiveMessageC;
	App.QPacket -> sendQuestion;
	App.APacket -> sendAnswer;
	App.AMPacket -> sendQuestion;
	// Active Message to send and receive questions
	App.AMSendQuestion -> sendQuestion;
	App.AMReceiveQuestion -> receiveQuestion;
	// Active Message to send and receive answers
	App.AMSendAnswer -> sendAnswer;
	App.AMReceiveAnswer -> receiveAnswer;
	
}
/************************************************************
END OF CODE
************************************************************/