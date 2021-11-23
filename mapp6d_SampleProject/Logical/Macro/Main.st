
PROGRAM _INIT
	(* Insert code here *)
	
	MacroName := 'TestMacro';
	inc			:= 0;
	MC_BR_MacroCreate_Acp6D_0.Assembly := ADR(gAssembly6D_1);
	MC_BR_AsmPowerOn_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_MacroDelete_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_0.Assembly		:= ADR(gAssembly6D_1);
END_PROGRAM

PROGRAM _CYCLIC
	CASE MacroState OF
		0:
			ResetMacroFubs;	
			IF(Cmd.Start)THEN
				MacroState := MacroState+1;
				MC_BR_AsmReadStatus_0.Enable := TRUE;
			END_IF;
		
		1:
			IF(MC_BR_AsmReadStatus_0.Valid)THEN
				IF(MC_BR_AsmReadStatus_0.AssemblyDisabled)THEN
					MacroState := MacroState+1;
				ELSIF(MC_BR_AsmReadStatus_0.AssemblyReady)THEN
					MacroState := MacroState+2;
				END_IF;
			END_IF;
			
		2:
			MC_BR_AsmPowerOn_Acp6D_0.Execute := TRUE;
			IF(MC_BR_AsmPowerOn_Acp6D_0.Done)THEN
				MC_BR_AsmPowerOn_Acp6D_0.Execute := FALSE;
				MacroState := MacroState+1;
			END_IF;
			
		3:
			MC_BR_MacroCreate_Acp6D_0.Parameters.Name := MacroName;
			int_to_str := USINT_TO_STRING(inc);
			brsstrcat(ADR(MC_BR_MacroCreate_Acp6D_0.Parameters.Name),ADR(int_to_str));
			TempName := MC_BR_MacroCreate_Acp6D_0.Parameters.Name;
			MC_BR_MacroCreate_Acp6D_0.Execute := TRUE;
			
			IF(MC_BR_MacroCreate_Acp6D_0.Done)THEN
				inc := inc+1;
				MacroSh := MC_BR_MacroCreate_Acp6D_0.MacroShuttle;
				MC_BR_MacroCreate_Acp6D_0.Execute := FALSE;
				MacroState := MacroState+1;
			END_IF;
		
		4:
			MC_BR_MoveInPlane_Acp6D_0.Shuttle := ADR(MacroSh);
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Acceleration := 10;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Velocity	:= 1;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Mode		:= 1;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Path		:= 0;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Position.X := 0.120;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Position.Y	:= 0;
			MC_BR_MoveInPlane_Acp6D_0.Execute := TRUE;
		
			IF(MC_BR_MoveInPlane_Acp6D_0.Acknowledge)THEN
				MC_BR_MoveInPlane_Acp6D_0.Execute := FALSE;
				MacroState := MacroState+1;
			END_IF;
		5:
			//	IF(MC_BR_MoveInPlane_Acp6D_0.Acknowledge = FALSE)THEN
			MC_BR_MoveInPlane_Acp6D_0.Shuttle := ADR(MacroSh);
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Acceleration := 10;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Velocity	:= 1;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Mode		:= 1;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Path		:= 0;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Position.X := -0.120;
			MC_BR_MoveInPlane_Acp6D_0.Parameters.Position.Y	:= 0;
			MC_BR_MoveInPlane_Acp6D_0.Execute := TRUE;
			//END_IF;
		
			IF(MC_BR_MoveInPlane_Acp6D_0.Acknowledge)THEN
				MC_BR_MoveInPlane_Acp6D_0.Execute := FALSE;
				IF(Clear)THEN
					MacroState := MacroState+2;
				ELSE
					MacroState := MacroState+1;
				END_IF;
			END_IF;
		
		6:
			MC_BR_MacroSave_0.Shuttle := ADR(MacroSh);
			MC_BR_MacroSave_0.Execute := TRUE;
			IF(MC_BR_MacroSave_0.Done)THEN
				MC_BR_MacroSave_0.Execute := FALSE;
				MacroState := MacroState+1;
				i := 0;
			ELSIF(MC_BR_MacroSave_0.Error AND Clear)THEN
				MC_BR_MacroSave_0.Execute := FALSE;
				MacroState := 10;
			END_IF;
			
		
		7:
			MC_BR_AsmGetShuttle_0.Enable := TRUE;
			IF(MC_BR_AsmGetShuttle_0.Valid)THEN	
				IF(MC_BR_AsmGetShuttle_0.Next)THEN
					ShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
					i := i+1;
					MC_BR_AsmGetShuttle_0.Next := FALSE;
				ELSE
					IF(i = 0)THEN
						ShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
						i := i+1;
					END_IF;
					
					MC_BR_AsmGetShuttle_0.Next := TRUE;
				END_IF;
			ELSIF(MC_BR_AsmGetShuttle_0.Error)THEN
				MC_BR_AsmGetShuttle_0.Enable := FALSE;
				MacroState := MacroState+1;
			END_IF;
		
		
		8:
			MC_BR_MacroRun_0.Shuttle := ADR(ShRefArr[0]);
			MC_BR_MacroRun_0.Execute := TRUE;
			MC_BR_MacroRun_0.Name	:= TempName;
			
			IF(MC_BR_MacroRun_0.Done)THEN
				MC_BR_MacroRun_0.Execute := FALSE;
				MacroState := MacroState+1;
			END_IF;
			
			
		
		9:
			MC_BR_MacroClear_0.Shuttle := ADR(MacroSh);
			MC_BR_MacroClear_0.Execute := TRUE;
			IF(MC_BR_MacroClear_0.Done)THEN
				MC_BR_MacroClear_0.Execute := FALSE;
				MacroState := 6;
			END_IF;
					
		10:
			IF(Cmd.Reset)THEN
				MacroState := 0;
				Cmd.Start := FALSE;
				Cmd.Reset := FALSE;
				Cmd.Stop := FALSE;
				Clear := FALSE;
			END_IF;
		
	END_CASE;
	
	MC_BR_AsmPowerOn_Acp6D_0();
	MC_BR_MacroCreate_Acp6D_0();
	MC_BR_MoveInPlane_Acp6D_0();
	MC_BR_AsmReadStatus_0();
	MC_BR_MacroSave_0();
	MC_BR_MacroClear_0();
	MC_BR_MacroDelete_0();
	MC_BR_MacroRun_0();
	MC_BR_AsmGetShuttle_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

