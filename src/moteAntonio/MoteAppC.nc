#include "Mote.h"
configuration MoteAppC{
}
implementation{
	components MainC;
	
	components MoteC as Mote;
	components ActiveMessageC as MoteAM;
	components ActiveMessageAddressC as MoteAMAddress;

#ifdef TOSSIM_BASESTATION_SIMULATION	
	components BaseStationC as BaseStation;
	components ActiveMessageC as BaseStationAM;
	components ActiveMessageAddressC as BaseStationAMAddress;
	
	components SerialActiveMessageC;
#endif	
	// Mote wiring
	
	Mote.Boot -> MainC;
#ifdef TOSSIM_BASESTATION_SIMULATION	
	Mote.BaseStation -> BaseStation;
#endif	
	Mote.RadioControl -> MoteAM;
	Mote.RadioSend -> MoteAM;
	Mote.RadioReceive -> MoteAM.Receive;
	Mote.RadioPacket -> MoteAM;
	Mote.RadioAMPacket -> MoteAM;
	Mote.RadioAMAddress -> MoteAMAddress;


	// BaseStation wiring
#ifdef TOSSIM_BASESTATION_SIMULATION	
	BaseStation.RadioControl -> BaseStationAM;
	BaseStation.RadioSend -> BaseStationAM;
	BaseStation.RadioReceive -> BaseStationAM.Receive;
	BaseStation.RadioPacket -> BaseStationAM;
	BaseStation.RadioAMPacket -> BaseStationAM;
	BaseStation.RadioAMAddress -> BaseStationAMAddress;
	
	BaseStation.SerialControl -> SerialActiveMessageC;
	BaseStation.UartSend -> SerialActiveMessageC;
	BaseStation.UartReceive -> SerialActiveMessageC.Receive;
	BaseStation.UartPacket -> SerialActiveMessageC;
	BaseStation.UartAMPacket -> SerialActiveMessageC;
#endif

}