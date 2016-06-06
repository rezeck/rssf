configuration MoteAppC{
}
implementation{
	components MainC;
	components MoteC as App;
	components ActiveMessageC;
	components ActiveMessageAddressC;
	
	App.Boot -> MainC;
	
	App.RadioControl -> ActiveMessageC;
	App.RadioSend -> ActiveMessageC;
	App.RadioReceive -> ActiveMessageC.Receive;
	App.RadioPacket -> ActiveMessageC;
	App.RadioAMPacket -> ActiveMessageC;
	
	App.RadioAMAddress -> ActiveMessageAddressC;
	
}