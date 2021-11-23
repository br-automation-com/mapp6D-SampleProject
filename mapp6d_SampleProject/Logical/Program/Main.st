
PROGRAM _INIT
	MC_BR_AsmGetInfo_Acp6D_0.Assembly 		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_Acp6D_0.Assembly 	:= ADR(gAssembly6D_1);
	MC_BR_AsmPowerOn_Acp6D_0.Assembly 		:= ADR(gAssembly6D_1);
	MC_BR_AsmPowerOff_Acp6D_0.Assembly 		:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_Acp6D_0.Assembly 	:= ADR(gAssembly6D_1);
	MC_BR_AsmStop_Acp6D_0.Assembly			:= ADR(gAssembly6D_1);
	MC_BR_AsmHalt_Acp6D_0.Assembly			:= ADR(gAssembly6D_1);
	MC_BR_AsmLevitation_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmBuffer_Acp6D_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmReboot_Acp6D_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetErrCode_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmGetSegment_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReset_Acp6D_0.Assembly			:= ADR(gAssembly6D_1);
	MC_BR_AsmReadInfo_Acp6D_0.Assembly			:= ADR(gAssembly6D_1);
	MC_BR_ShStereotypeDelete_Acp6D_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_ZoneCreate_0.Assembly			:= ADR(gAssembly6D_1);
	MC_BR_ShStereotypeDefine_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmGetZone_0.Assembly				:= ADR(gAssembly6D_1);
	MC_BR_MoveInPlaneAsync_0.Assembly		:= ADR(gAssembly6D_1);
	
	
	
	
	
	
	
	FBin;
	FBout;

	cycle_time := 0.001;
	frequnecy := 1;
	amplitude := 1;
END_PROGRAM

PROGRAM _CYCLIC
	
	IF(GetShuttle)THEN
		MC_BR_AsmGetShuttle_Acp6D_0.Enable := TRUE;
		ShRef := MC_BR_AsmGetShuttle_Acp6D_0.Shuttle;
	ELSE
		MC_BR_AsmGetShuttle_Acp6D_0.Enable := FALSE;
	END_IF;
	
	IF(GetSegment)THEN
		MC_BR_AsmGetSegment_Acp6D_0.Enable := TRUE;
		SegRef := MC_BR_AsmGetSegment_Acp6D_0.Segment;
	ELSE
		MC_BR_AsmGetSegment_Acp6D_0.Enable	:= FALSE;
	END_IF;
	
	IF(GetAllShuttles)THEN
		MC_BR_AsmGetShuttle_Acp6D_0.Enable := TRUE;
		IF(MC_BR_AsmGetShuttle_Acp6D_0.Valid)THEN	
			IF(MC_BR_AsmGetShuttle_Acp6D_0.Next)THEN
				AllShRef[i] := MC_BR_AsmGetShuttle_Acp6D_0.Shuttle;
				i := i+1;
				MC_BR_AsmGetShuttle_Acp6D_0.Next := FALSE;
			ELSE
				IF(i = 0)THEN
					AllShRef[i] := MC_BR_AsmGetShuttle_Acp6D_0.Shuttle;
					i := i+1;
				END_IF;
					
				MC_BR_AsmGetShuttle_Acp6D_0.Next := TRUE;
			END_IF;
		ELSIF(MC_BR_AsmGetShuttle_Acp6D_0.Error)THEN
			MC_BR_AsmGetShuttle_Acp6D_0.Enable := FALSE;
			GetAllShuttles := FALSE;
		END_IF;
	ELSE
		i := 0;
		//	MC_BR_AsmGetShuttle_Acp6D_0.Enable := FALSE;
	END_IF;
	
	
	IF(MoveInPlaneAsync)THEN
		MC_BR_MoveInPlaneAsync_0.Parameters.Acceleration := 10;
		MC_BR_MoveInPlaneAsync_0.Parameters.Velocity		:= 1;
		MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].Shuttle := ADR(AllShRef[0]);
		MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].X		:= 0.060;
		MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].Y		:= 0.060;
		MC_BR_MoveInPlaneAsync_0.Execute := TRUE;
		IF(MC_BR_MoveInPlaneAsync_0.Done)THEN
			MC_BR_MoveInPlaneAsync_0.Execute := FALSE;
			MoveInPlaneAsync := FALSE;
		END_IF;
	END_IF;
		
	
	
	
	IF(GetZone)THEN
		MC_BR_AsmGetZone_0.Enable := TRUE;
		ZoneRef := MC_BR_AsmGetZone_0.Zone;
	ELSE
		MC_BR_AsmGetZone_0.Enable := FALSE;
	END_IF;

	MC_BR_ShReadInfo_Acp6D_0.Shuttle 	:= ADR(ShRef);
	MC_BR_MoveInPlane_Acp6D_0.Shuttle	:= ADR(ShRef);
	MC_BR_MoveShortAxis_Acp6D_0.Shuttle	:= ADR(ShRef);
	MC_BR_MoveArc_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShLevitation_Acp6D_0.Shuttle	:= ADR(ShRef);
	MC_BR_Move6D_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShBuffer_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShStop_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShHalt_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShRecover_Acp6D_0.Shuttle		:= ADR(ShRef);
	MC_BR_MoveCyclic_0.Shuttle			:= ADR(ShRef);
	MC_BR_ShStereotypeAssign_Acp6D_0.Shuttle := ADR(ShRef);
	MC_BR_ReadCyclicPosition_0.Shuttle	:= ADR(ShRef);
	MC_BR_ReadCyclicForce_0.Shuttle		:= ADR(ShRef);
	MC_BR_ShGetPayload_0.Shuttle		:= ADR(ShRef);
	MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].Shuttle := ADR(ShRef);
	MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].X := 0.060;
	MC_BR_MoveInPlaneAsync_0.Parameters.AsyncPar[0].Y := 0.060;
	MC_BR_MoveInPlaneAsync_0.Parameters.Velocity := 1;
	MC_BR_MoveInPlaneAsync_0.Parameters.Acceleration := 10;	
	
	MC_BR_SegGetInfo_Acp6D_0.Segment	:= ADR(SegRef);
	MC_BR_SegPowerOff_0.Segment			:= ADR(SegRef);
	MC_BR_SegPowerOn_0.Segment			:= ADR(SegRef);
	MC_BR_SegBarrierCommand_0.Segment	:= ADR(SegRef);
	MC_BR_SegGetBarrierInfo_0.Segment	:= ADR(SegRef);
	
	MC_BR_ZonePowerOff_0.Zone			:= ADR(ZoneRef);
	MC_BR_ZonePowerOn_0.Zone			:= ADR(ZoneRef);
	MC_BR_ZoneBarrierCommand_0.Zone		:= ADR(ZoneRef);
	MC_BR_ZoneGetBarrierInfo_0.Zone		:= ADR(ZoneRef);
	
	

	
	
//	IF(errInc <= MAX_ENTRIES)THEN
//		ErrIDArr[errInc] := FBin.Array[5];
//		ErrCmdIDOut[errInc] := FBout.Array[3];
//		
//		errInc := errInc +1;
//	END_IF;
		
	
	
	MC_BR_SegGetInfo_Acp6D_0();
	MC_BR_AsmGetInfo_Acp6D_0();
	MC_BR_AsmGetShuttle_Acp6D_0();
	MC_BR_AsmPowerOn_Acp6D_0();
	MC_BR_AsmPowerOff_Acp6D_0();
	MC_BR_AsmReadStatus_Acp6D_0();
	MC_BR_ShReadInfo_Acp6D_0();
	MC_BR_MoveInPlane_Acp6D_0();
	MC_BR_MoveShortAxis_Acp6D_0();
	MC_BR_MoveArc_Acp6D_0();
	MC_BR_ShLevitation_Acp6D_0();
	MC_BR_Move6D_Acp6D_0();
	MC_BR_ShBuffer_Acp6D_0();
	MC_BR_ShStop_Acp6D_0();
	MC_BR_ShHalt_Acp6D_0();
	MC_BR_AsmStop_Acp6D_0();
	MC_BR_AsmHalt_Acp6D_0();
	MC_BR_AsmLevitation_Acp6D_0();
	MC_BR_AsmBuffer_Acp6D_0();
	MC_BR_ShRecover_Acp6D_0();
	MC_BR_AsmReboot_Acp6D_0();
	MC_BR_AsmGetErrCode_Acp6D_0();
	MC_BR_AsmGetSegment_Acp6D_0();
	MC_BR_AsmReset_Acp6D_0();
	MC_BR_AsmReadInfo_Acp6D_0();
	MC_BR_ShStereotypeAssign_Acp6D_0();
	MC_BR_ShStereotypeDefine_Acp6D_0();
	MC_BR_ShStereotypeDelete_Acp6D_0();
	MC_BR_MoveCyclic_0();
	MC_BR_ReadCyclicPosition_0();
	MC_BR_ReadCyclicForce_0();
	MC_BR_SegPowerOff_0();
	MC_BR_SegPowerOn_0();
	MC_BR_SegBarrierCommand_0();
	MC_BR_SegGetBarrierInfo_0();
	MC_BR_ZoneCreate_0();
	MC_BR_AsmGetZone_0();
	MC_BR_ZonePowerOff_0();
	MC_BR_ZonePowerOn_0();
	MC_BR_ZoneBarrierCommand_0();
	MC_BR_ZoneGetBarrierInfo_0();
	MC_BR_ShGetPayload_0();
	MC_BR_MoveInPlaneAsync_0();
		
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

