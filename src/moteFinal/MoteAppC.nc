#include "Mote.h"
configuration MoteAppC{
}
implementation{
	components MainC;
	
	components MoteC as Mote;
	components ActiveMessageC as MoteAM;
	components ActiveMessageAddressC as MoteAMAddress;
	components LedsC;
	
	components new TimerMilliC() as TimerSensor;
	components new PhotoC();
	components new TempC();
	//components new DemoSensorC();
	
	// Mote wiring
	
	Mote.Boot -> MainC;

	Mote.RadioControl -> MoteAM;
	Mote.RadioSend -> MoteAM;
	Mote.RadioReceive -> MoteAM.Receive;
	Mote.RadioPacket -> MoteAM;
	Mote.RadioAMPacket -> MoteAM;
	Mote.Leds -> LedsC;
	Mote.TimerSensor -> TimerSensor;
	
	//Mote.ReadPhoto -> DemoSensorC;
	Mote.ReadPhoto ->PhotoC;
	Mote.ReadTemp -> TempC;
}