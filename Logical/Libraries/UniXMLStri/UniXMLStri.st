	(********************************************************************************************************************
	* Code and Decode XML Data and String composition FOR UNIVERSAL IO Parameter! 
	* Copyright 2010 GE Jenbacher 
	*	
	* History:	
	* --------		
	* V0.10	12.11.10, Zengerer		generated
	* V0.20	02.12.10, Zengerer		xUniDecoString functin ok with * as wildcard
	* V0.21	16.12.10, Zengerer		unused varname warnings solved
	* V0.30	17.01.11, Zengerer		tUniCalcCheckSumm new
	* V0.40 20.01.11, Zengerer		InMemAdress and InMemLenght as alternative Inputs for tUniCalcCheckSumm
	* V0.41 25.01.11, Ze			szWildcard[1] := '/' (urgent!)
	* V0.42 01.02.11, Ze			No Error Message if characteri s not foun	
	* V0.43	04.02.11, Zengerer		Stingdeclarations from 255->300 character
	* V0.44	09.02.11, Zengerer		Errorr message	
	*
	* LEGACY CODE- DO NOT USE IN NEW IMPLEMENTATIONS!
	*
	* Description:	
	* ------------	
	* - xUniDecoXML.fun
	* read parameter from string (XML data line)		
	*
	* - xUniCodXML.fun
	* write parameter to string (XML data line)
	*
	* - tUniCalcCheckSumm
	* calculates a alternating checksumm for a string (up to 255chr)
	*
	*
	(* FUNCTION INTERFACE: VALID LIMITATIONS:	*)
	(* --------------------------------------	*)
	(*INPUTS:*)
	(*	bEnable : BOOL; (*TRUE = enable FUB*)
	(*	szConfigString : STRING[255]; (*String holding the data, in wich separatorstrings where searched. Minimum string lenght is the separator string lengt *)
	(*	szSeparator : STRING[10]; (*Enter a combination of detectable separator characters here; wildcard is the * (=position will be ignored)*)
	(*	ucStartPos : USINT; (*position of first character in string to start searching*)

	(*OUTPUTS: *)
	(*	usErrorCode : UINT; (*0=OK or ready without errors, 1=busy, other error numbers see in code*)
	(*	usFoundPos : UINT; (*position of first data character after the found separator*)
	(*	usFoundLenght : UINT; (*lenght of data in characters after the found separator*)
	(*	bLastData : BOOL; (*TRUE, if no more separators will follow afther the found one*)




	(********************************************************************************************************************)
FUNCTION_BLOCK xUniCodString	
	(****************************************************************************************************************)
	(* Decode WHOLE PARAMETERSTRUCTURE INFORMATION FROM Textstring 
	(****************************************************************************************************************)

	IF bEnable THEN	
	//  FEHLT NOCH

	(*	VAR_INPUT*)
		bEnable ;
		ulXMLDataAdress ;
		ulXMLDataSize ;

	(*VAR_OUTPUT *)
		bErrUniXMLRead ;
		usErrorCode ; (*0=OK, ready*)
		bUniAnaFileReadDone ;

	(*VAR*)
		bUniXMLWrite;
		step ;
	END_IF
	
END_FUNCTION_BLOCK

		
		
		
		
	(********************************************************************************************************************)
FUNCTION_BLOCK xUniDecoString	
	(****************************************************************************************************************)
	(* Decode WHOLE PARAMETERSTRUCTURE INFORMATION FROM Textstring 
	(****************************************************************************************************************)

	IF bEnable THEN	 
		usErrorCode := 1;				(*set state to BUSY*)
		
		szWildcard[0] := '*' ;	
		szWildcard[1] := '/' ;
//old	ucMaxNoOfWildcards := 3;	(*max. allowed number of wildcards to ignore*)

		usFoundPos 		 := 0;	
		usFoundLenght	 := 0;	
		ucFoundWildcards := 0;
		bLastData		 := FALSE;

		(*examine ConfigString*)
 		usUniStringLen 	:= LEN(szConfigString);
 		usUniSepaLen 	:= LEN(szSeparator);			
		IF usUniSepaLen < 2 OR usUniSepaLen > 16 THEN 	(*check for valid separator characters*)
			szSeparator := '|*='; 
			usUniSepaLen := 3;
			usErrorCode := 63001;		(*Error: invalid separator string recived*)
		END_IF	
  		IF usUniStringLen < usUniSepaLen+1 THEN 		(*minimum string lenght is the lenght of one separator sequenze +1*)
			CNr := usUniStringLen;		(*= exit, no more function *)
			usErrorCode := 63002;		(*Error: empty or to short string recived*)		
		END_IF
 		IF usUniStringLen >254 THEN 	(*maximum string lenght*)
			CNr := 255;					(*= exit, no more function *)
			usErrorCode := 63003;		(*Error: to long string recived*)		
		END_IF
		IF ucStartPos = 0 THEN 
			ucStartPos := 1; 
			usErrorCode := 63004;		(*Error: missing startposition entered*)		
		END_IF
		IF ucStartPos > usUniStringLen THEN 	
			CNr := 255;					(*= exit, no more function *)
			usErrorCode := 63005;		(*Error: illegal startposition entered*)		
		END_IF
		
		FOR Sepa := 1 TO usUniSepaLen DO				(*Splitt Separatorstring in single characters*)
			szSepar[Sepa] := MID(szSeparator,1,Sepa);
		END_FOR	
		
	
		(*detect known separators*)
			CNr := ucStartPos ;											(*start position in string*)
			
			WHILE CNr <= usUniStringLen DO
				szCNr := MID(szConfigString,1,CNr);						(*get single character at actual position*)

				IF szSepar[1] = szCNr THEN								(*look for 1st separator character*)
					bFound	:= TRUE;									(*start assuming, that this could be a match*)
					ucFoundSlashs := 0;
					CNr		:= CNr + 1;
					CNrStartDetailSearch := CNr;						(*Store startpoint of FollowingCharacterSearch for latrer use in case of missmatch *)
					Sepa 	:= 2;
					(*FEHLT NOCH: restlängenprüfung*)	
					
					(*IF 1ST separator is found, THEN cycle trough following characters*)
					WHILE Sepa < usUniSepaLen+1 DO  						(*check all following separator character*)
						szCNr := MID(szConfigString,1,CNr);					(*get single character at actual position*)

						IF szSepar[Sepa] = szCNr THEN
								Sepa := Sepa +1;							(*A: if matching separator character found, go on to next sepa (and next character) ...*)
								
						ELSE												(*B: if not, then check, if this separatorposition or this stringposition has a reason to be ignored...*)
							IF szSepar[Sepa] = szWildcard[0]  THEN 			(*	 B1: check, if to ignore wildcard on this separator position *)
								ucFoundWildcards := ucFoundWildcards+1;
								Sepa := Sepa +1;
								
								IF ucFoundWildcards > 3 THEN		//ucMaxNoOfWildcards THEN
									ucFoundWildcards := 0;
									usErrorCode := 65000 + Sepa;				(*Error: more than max. allowed number of wildcards to ignore*)
									bFound := FALSE; 
								END_IF	
								
								
							ELSE											(*	 B2: if not, check, if ignorable / character is in searchstring *)
								IF szCNr = szWildcard[1]  THEN 				(*ignore / in DATA to recognize XML endtag with same definition as starttag definition *)	
									ucFoundSlashs := ucFoundSlashs + 1;

									IF ucFoundSlashs > 2 THEN  		// ucMaxNoOfSlashs THEN
										Sepa := Sepa +1;										
										ucFoundSlashs := 0;
										usErrorCode := 65100 + Sepa;			(*Error: more than max. allowed number of slash characters found to ignore*)
										bFound := FALSE; 
									END_IF						
									
									CNr ; //:= 	CNr + 1;						(* do not increment here (automatic increment at end of while loop) *)
			//böse!					IF Sepa > 0 THEN Sepa := Sepa -1; END_IF	(*NEVER DO THIS! because of CNr = CNr - Sepa	*)

								ELSE										(*C: if not found, then this character is realy wrong here, so...  *)
									bFound := FALSE; 						(*   ..clear match assumption flag... *)
									CNr		:= CNrStartDetailSearch; //CNr - Sepa;		(*   ..go back in searchstring to the start of detail search...  *)
									Sepa := usUniSepaLen +1;				(*   ..and set exit condition for this while loop.  *)
								//	usErrorCode := 64000+CNr;				(*DO NOT GENERATE ERROR HERE! Error message: wrong character found at pos.*)		
									ucFoundWildcards := 0;
								END_IF
							END_IF
						END_IF
						
						CNr := 	CNr +1;									(*try next character*)
					END_WHILE	(*END INNER CYCLE*)
	
					
					IF bFound THEN
						IF usFoundPos = 0 THEN							(*This is the first valid separator*)
	 						usFoundPos := CNr;							(*=FB OUTPUT*)
							usFoundLenght := 0;
							ucFoundWildcards := 0;
							bFound := FALSE; 
						ELSE											(*This is the second valid separator*)
	 						usFoundLenght := CNr - usFoundPos - usUniSepaLen ;	(*=FB OUTPUT*)

							ucFoundWildcards := 0;
							bFound := FALSE; 
							IF CNr > usUniStringLen THEN				(*End of string reached...*)
   								bLastData := TRUE;	
   							END_IF							
							CNr := 255;									(*EXIT THE WHILE LOOP and so EXIT FUNCTION, if 2nd valid separatorstring is found *) 							
						END_IF
					ELSE		
						CNr := CNrStartDetailSearch ; //+ 1;				(*retry search for 1st Sepa with next CNr in String*)
					END_IF
				
				ELSE													(*look for 1st separator character-> NOT FOUND*)
					CNr := 	CNr +1;			(*<-YOU ARE HERE*)			(*try next character*)								(*try next character*)
				END_IF
				
			END_WHILE			(*END OUTER CYCLE OVER ALL CHARACTERS*)		
			IF CNr <> 255 THEN	
				IF usFoundPos > 0 THEN	
					usFoundLenght := usUniStringLen - usFoundPos + 1;
				END_IF							(*= only 1 valid separator was found, so all the rest of the string is data to this separator *)
												(*Detect End of string reached: if while loop has terminated without rigid setting of CNr := 255.. *)
	   			bLastData := TRUE;	
	   		END_IF							

  		IF usErrorCode = 1 THEN usErrorCode := 0;  END_IF 	(*set state from BUSY to READY, if no errors occured*)
	
		(*OLD:	ucFoundSepNr : USINT; ( *Internal*)

	END_IF 

END_FUNCTION_BLOCK


	(********************************************************************************************************************)
FUNCTION_BLOCK xUniCalcCheckSumm
	(****************************************************************************************************************)
	(* 	* calculates a alternating checksumm FOR a STRING (up TO 255chr)
	(****************************************************************************************************************)

	IF bEnable THEN	
		usErrorCode := 1;				(*set state to BUSY*)
		ssChecksumm	:= 0;
		bPair 			:= FALSE;
		
		IF InMemAdress > 0 AND InMemLenght > 0 THEN 
 			ulADRString		:=  InMemAdress;	
			usUniStringLen	:= 	InMemLenght;
		ELSE	
			ulADRString		:= ADR(InString);
			usUniStringLen	:= LEN(InString);
		END_IF
		IF usUniStringLen > 1000  THEN 
 			usErrorCode := 23456;	(*Checksumm Data array unreliable big*)
		ELSE
			CASE usChecksummMode OF
	  			0:	(*alternating character summ (11er) *)
					FOR CNr := 0 TO usUniStringLen DO
						ucByteValue ACCESS (ulADRString + CNr);
						ssByteValue := USINT_TO_INT(ucByteValue);
					
						IF bPair THEN 
							ssChecksumm := ssChecksumm + ssByteValue;
							bPair := FALSE;
						ELSE
							ssChecksumm := ssChecksumm - ssByteValue;
							bPair := TRUE;
						END_IF
					END_FOR
				1:	(*character summ (9er) *)
					FOR CNr := 0 TO usUniStringLen DO
						ucByteValue ACCESS (ulADRString + CNr);
						ssByteValue := USINT_TO_INT(ucByteValue);				
					
							ssChecksumm := ssChecksumm + ssByteValue;
					END_FOR			
				ELSE	
					ssChecksumm := 0;
					usChecksumm := 0;		(*prepared for later use*)
					usErrorCode := 12345;	(*THIS ChecksummMode IS NOT RELEASED NOW*)
			END_CASE
		END_IF
  		IF usErrorCode = 1 THEN usErrorCode := 0;  END_IF 	(*set state from BUSY to READY, if no errors occured*)	

	END_IF 

END_FUNCTION_BLOCK
