// megafunction wizard: %LPM_CONSTANT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_CONSTANT 

// ============================================================
// File Name: brik1_y.v
// Megafunction Name(s):
// 			LPM_CONSTANT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 17.0.0 Build 595 04/25/2017 SJ Standard Edition
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
module brik1_y (
	result);

	output	[10:0]  result;

	wire [10:0] sub_wire0;
	wire [10:0] result = sub_wire0[10:0];

	lpm_constant	LPM_CONSTANT_component (
				.result (sub_wire0));
	defparam
		LPM_CONSTANT_component.lpm_cvalue = 100,
		LPM_CONSTANT_component.lpm_hint = "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=bk1y",
		LPM_CONSTANT_component.lpm_type = "LPM_CONSTANT",
		LPM_CONSTANT_component.lpm_width = 11;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "1"
// Retrieval info: PRIVATE: JTAG_ID STRING "bk1y"
// Retrieval info: PRIVATE: Radix NUMERIC "10"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: Value NUMERIC "100"
// Retrieval info: PRIVATE: nBit NUMERIC "11"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "100"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=bk1y"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "11"
// Retrieval info: USED_PORT: result 0 0 11 0 OUTPUT NODEFVAL "result[10..0]"
// Retrieval info: CONNECT: result 0 0 11 0 @result 0 0 11 0
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL brik1_y_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
