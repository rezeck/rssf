/************************************************************ 
		Definition of our Communication Protocol
************************************************************/
#ifndef STATION_H
#define STATION_H
/************************************************************/


/************************************************************
	Message and addresses values 
************************************************************/
enum {
	// Message type
	AM_QUESTION = 0x0F,
	AM_ANSWER 	= 0xF0,

	// Nodes Address (24.576, 32.767)
	ADDRESS_SINK 		= 0x5E88,
	ADDRESS_NODE_1 		= 0x607C,
	ADDRESS_NODE_2 		= 0x60E0,
	ADDRESS_NODE_3 		= 0x6144,
	ADDRESS_BROADCAST 	= 0xFFFF,

	// Sender Interval
	TIMER_PERIOD_MILLI = 250 
};
/************************************************************/


/************************************************************
	Structure from our message

	@id - Defined by a cyclic counter from (0, 65535).
	Every question msg become a ID and must be answered
	with the same ID.

	@size - Defined by values from (2, 7). They represent the
	quantity of payload information. At least temperature and 
	luminosity values must be send for every question.

	@temperature - Current temperature around the station.

	@luminosity - Current luminosity around the station.

	@data_# - Another sensors.
************************************************************/
typedef nx_struct StationMsg {
	// Header
	nx_uint16_t id;
	nx_uint16_t size; 

	// Payload
	nx_uint16_t temperature;
	nx_uint16_t luminosity;
	//nx_uint32_t data_1;
	//nx_uint32_t data_2;
	//nx_uint32_t data_3;
	//nx_uint32_t data_4;
	//nx_uint32_t data_5;
	
} StationMsg;
/************************************************************/

/************************************************************/
#endif
/************************************************************/
