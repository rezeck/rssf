#include "BaseStation.h"
configuration BaseStationAppC{
}
implementation{
	components MainC;
		
	components BaseStationC as BaseStation;
	components ActiveMessageC as BaseStationAM;
	components ActiveMessageAddressC as BaseStationAMAddress;
	
	components SerialActiveMessageC;
	components LedsC;

	// BaseStation wiring
	
	BaseStation.Boot -> MainC;
	
	BaseStation.RadioControl -> BaseStationAM;
	BaseStation.RadioSend -> BaseStationAM;
	BaseStation.RadioReceive -> BaseStationAM.Receive;
	BaseStation.RadioPacket -> BaseStationAM;
	BaseStation.RadioAMPacket -> BaseStationAM;
	
	BaseStation.SerialControl -> SerialActiveMessageC;
	BaseStation.UartSend -> SerialActiveMessageC;
	BaseStation.UartReceive -> SerialActiveMessageC.Receive;
	BaseStation.UartPacket -> SerialActiveMessageC;
	BaseStation.UartAMPacket -> SerialActiveMessageC;
	
	BaseStation.Leds -> LedsC;

}