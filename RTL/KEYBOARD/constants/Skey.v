// megafunction wizard: %LPM_CONSTANT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_CONSTANT 

// ============================================================
// File Name: Skey.v
// Megafunction Name(s):
// 			LPM_CONSTANT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 17.0.0 Build 595 04/25/2017 SJ Lite Edition
// ************************************************************


//Copyright (C) 2017  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Intel and sold by Intel or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module Skey (
	result);

	output	[8:0]  result;

	wire [8:0] sub_wire0;
	wire [8:0] result = sub_wire0[8:0];

	lpm_constant	LPM_CONSTANT_component (
				.result (sub_wire0));
	defparam
		LPM_CONSTANT_component.lpm_cvalue = 27,
		LPM_CONSTANT_component.lpm_hint = "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=NONE",
		LPM_CONSTANT_component.lpm_type = "LPM_CONSTANT",
		LPM_CONSTANT_component.lpm_width = 9;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "1"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: Radix NUMERIC "16"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: Value NUMERIC "27"
// Retrieval info: PRIVATE: nBit NUMERIC "9"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "27"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=NONE"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "9"
// Retrieval info: USED_PORT: result 0 0 9 0 OUTPUT NODEFVAL "result[8..0]"
// Retrieval info: CONNECT: result 0 0 9 0 @result 0 0 9 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Skey_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
