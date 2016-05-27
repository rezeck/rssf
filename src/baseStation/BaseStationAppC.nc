/************************************************************
Base Station configuration file
************************************************************/

/************************************************************/	
#include <Timer.h>
#include "BaseStation.h"
/************************************************************/

/************************************************************/	
configuration BaseStationAppC {
}
implementation {
	components MainC;
	components LedsC;
	components BaseStationC as App;
	components new TimerMilliC() as Timer0;

	//components ActiveMessageC;
	//components new AMSenderC(AM_QUESTION);
	//components new AMReceiverC(AM_QUESTION) as receiveQuestion;
	//components new AMSenderC(AM_ANSWER) as sendAnswer;
	//components new AMReceiverC(AM_ANSWER) as receiveAnswer;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	//App.Packet -> AMSenderC;
	//App.AMControl -> ActiveMessageC;
	//App.AMSendQuestion -> AMSenderC;
	//App.ReceiveQuestion -> AMReceiverC;
	//App.AMPacket -> AMSenderC;

  	
}
/************************************************************
END OF CODE
************************************************************/