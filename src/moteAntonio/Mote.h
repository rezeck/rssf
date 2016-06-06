#ifndef MOTE_H
#define MOTE_H
#define TOSSIM_BASESTATION_SIMULATION
#define RSSF_DEBUG
enum {
	// Message type
	AM_QUESTION = 0xF0,
	AM_ANSWER = 0x0F,
	
	// Address
	MOTE_ADDRESS = 0x6001,
	MOTE_GROUP = 0x6000,
	
	// Msg type to use in TOSSIM
	AM_MOTEMSG = AM_QUESTION
};

typedef nx_struct MoteMsg {
	// Header
	nx_uint16_t version;
	nx_uint16_t size;
	
	// Required payload data
	nx_uint16_t temperature;
	nx_uint16_t luminosity;
	
	// Optional payload data
	nx_uint16_t src; // half of extra_data_1
	nx_uint16_t parent_node; // half of extra_data_1
	nx_uint32_t extra_data_2;
	nx_uint32_t extra_data_3;
	nx_uint32_t extra_data_4;
	nx_uint32_t extra_data_5;		
	
} MoteMsg;

#endif /* MOTE_H */
