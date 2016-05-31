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

	components SerialActiveMessageC as Serial;

	components ActiveMessageC;
	components new AMSenderC(AM_QUESTION) as sendQuestion;
	components new AMReceiverC(AM_ANSWER) as receiveAnswer;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;

	// Serial communication	
	
	App.SerialControl ->  Serial;
	App.UartSend -> Serial.AMSend[AM_QUESTION];
  	App.UartReceive -> Serial.Receive[AM_QUESTION];
  	App.UartPacket -> Serial;
  	App.UartAMPacket -> Serial;
  	

  	// Radio communication
	App.AMControl -> ActiveMessageC;
	App.QPacket -> sendQuestion;
	App.AMQPacket -> sendQuestion;
	App.AMSendQuestion -> sendQuestion;
	App.AMReceiveAnswer -> receiveAnswer;
}
/************************************************************
END OF CODE
************************************************************/