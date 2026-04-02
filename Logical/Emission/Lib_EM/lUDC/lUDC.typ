TYPE


   tHALioAi : STRUCT 
        Ai : REAL; (* ()*)
        Unfilt : REAL; (* ()*)
        GoodQual : BOOL; (* ()*)
    END_STRUCT;

   tUD_CLFlow_DBG : STRUCT 
        up : REAL; (*proportional part ()*)
        ui : REAL; (*integral part ()*)
        ud : REAL; (*derivative part ()*)
        aw : REAL; (*anti windup ()*)
    END_STRUCT;

   tUD_CLNOx_DBG : STRUCT 
        up : REAL; (*proportional part ()*)
        ui : REAL; (*integral part ()*)
        ud : REAL; (*derivative part ()*)
        aw : REAL; (*anti windup ()*)
        bFreeze : BOOL; (*Freeze controller ()*)
        bSatUpLim : BOOL; (*Controller saturated at upper limit ()*)
    END_STRUCT;

   tUD_CLNOx_PERM : STRUCT 
        rUrClKawExt : REAL; (*Anti windup gain for external output limitation  of closed loop urea injection controller (ppm*h/l)*)
        rUrClKaw : REAL; (*Anti windup gain for internal output limitation  of closed loop urea injection controller (ppm*h/l)*)
        rUrClN : REAL; (*Derivative filter bandwith of PID closed loop urea injection controller offset (1/s)*)
        rUrClKdOffs_x : ARRAY[0..4] OF REAL; (*Derivative gain of PID closed loop urea injection controller offset (degC)*)
        rUrClKdOffs_y : ARRAY[0..4] OF REAL; (*Derivative gain of PID closed loop urea injection controller offset (l*s/(h*ppm))*)
        rUrClKiOffs_x : ARRAY[0..4] OF REAL; (*Integral gain of PID closed loop urea injection controller offset (degC)*)
        rUrClKiOffs_y : ARRAY[0..4] OF REAL; (*Integral gain of PID closed loop urea injection controller offset (l/(h*ppm*s))*)
        rUrClKpOffs_x : ARRAY[0..4] OF REAL; (*proportional gain of PID closed loop urea injection controller offset (degC)*)
        rUrClKpOffs_y : ARRAY[0..4] OF REAL; (*proportional gain of PID closed loop urea injection controller offset (l/(h*ppm))*)
        rUrClD0 : REAL; (*If PID closed loop urea flow controller is reseted, its derivate filter output is reseted to this value (-)*)
        rUrClI0 : REAL; (*If PID closed loop urea flow controller is reseted, its integral output is reseted to this value (l/h)*)
        bUrClRes : BOOL; (*If TRUE,  resets the PID closed loop urea flow controller to reset value. (-)*)
    END_STRUCT;

   tUD_CLPp_PERM : STRUCT 
        rUrPpKawExt : REAL; (*External anti windup gain for urea injection control via urea pump speed (tbd)*)
        rUrPpKaw : REAL; (*Internal anti windup gain for urea injection control via urea pump speed (tbd)*)
        rUrPpN : REAL; (*1st order filter frequency for derivative gain  of pump speed based urea injection controller (PIDN) (tbd)*)
        rUrPpKdOffs : REAL; (*Derivative gain  of pump speed based urea injection controller offset (PIDN) (tbd)*)
        rUrPpKiOffs : REAL; (*Integral gain  of pump speed based urea injection controller offset (PIDN) (tbd)*)
        rUrPpKpOffs : REAL; (*Proportional gain  of pump speed based urea injection controller offset (PIDN) (tbd)*)
        rUrPpD0 : REAL; (*Initial value for derviative 1st order filter  of pump speed based urea injection controller (PIDN) (tbd)*)
        rUrPpI0 : REAL; (*Initial value for integrator of pump speed based urea injection controller (PIDN) (tbd)*)
        bUrPpRes : BOOL; (*Reset for pump speed based urea injection controller,  reset if = TRUE (-)*)
        rUrPpCntrFFMap_x : ARRAY[0..10] OF REAL; (*tbd (l/h)*)
        rUrPpCntrFFMap_y : ARRAY[0..10] OF REAL; (*tbd (au)*)
    END_STRUCT;

   tUD_CLVal_PERM : STRUCT 
        rUrValKawExt : REAL; (*External anti windup gain for urea valve closed loop controller (tbd)*)
        rUrValKaw : REAL; (*Internal anti windup gain for urea valve closed loop controller (tbd)*)
        rUrValN : REAL; (*Filter frequency constant of PIDN based urea valve closed loop controller (tbd)*)
        rUrValKdOffs : REAL; (*Derivative gain of PIDN based urea valve closed loop controller offset (tbd)*)
        rUrValKiOffs : REAL; (*Integral gain of PIDN based urea valve closed loop controller offset (tbd)*)
        rUrValKpOffs : REAL; (*Proportional gain of PIDN based urea valve closed loop controller offset (tbd)*)
        rUrValD0 : REAL; (*Initial value for derivative filter of PIDN based urea valve closed loop controller (tbd)*)
        rUrValI0 : REAL; (*Initial condition of integrator of PIDN based urea valve closed loop controller (au)*)
        bUrValRes : BOOL; (*Reset for PIDN based urea valve closed loop controller. Reset if TRUE (-)*)
        rUrValLinMap_x : ARRAY[0..10] OF REAL; (*Linearisation curve for urea dosage valve input vector; Valve output, Kv/Kvs (au)*)
        rUrValLinMap_y : ARRAY[0..10] OF REAL; (*Linearisation curve for urea dosage valve output vector; Valve output, Reference value for urea dosage valve position (au)*)
        rTiFilt_DPrVlv : REAL; (*Filter time constant for the filtered differential pressure of the urea dosing valve (s)*)
    END_STRUCT;

   tUD_DBG : STRUCT 
        SM : tUD_SM_DBG; (*Debug bus Signal Manager ()*)
        FF : tUD_FF_DBG; (*Debug bus Feed Forward ()*)
        Slip : tUD_Slip_DBG; (*Debug bus Slip Detection ()*)
        CLNOx : tUD_CLNOx_DBG; (*Debug bus Closed Loop ()*)
        CLFlow : tUD_CLFlow_DBG; (*Debug bus Closed Loop ()*)
    END_STRUCT;

   tUD_EMLine : STRUCT 
        rCO : REAL; (* (ppm)*)
        rNO : REAL; (* (ppm)*)
        rNO2 : REAL; (* (ppm)*)
        bCO : BOOL; (* (-)*)
        bNO : BOOL; (* (-)*)
        bNO2 : BOOL; (* (-)*)
        bRdy : BOOL; (* (-)*)
    END_STRUCT;

   tUD_FF_DBG : STRUCT 
        rSV : REAL; (*Space velocity through catalyst (1/h)*)
        rMdot_exh : REAL; (*Estimated exhaust mass flow [kg/s] (kg/s)*)
        rTSCRAvgEst : REAL; (*Estimated average SCR surface temperature (averaged over all cells) by observer (°C)*)
        rTSCRAvgAr : REAL; (*Arithmetic weighted average of SCR temperature using exhaust gas input and output temperature (°C)*)
        rTSCRAvg : REAL; (*Average SCR temperature used for NH3 feed forward control and urea injection start decision (°C)*)
        rNH3StDMaxAvgEst : REAL; (*Max NH3 storage capacity caluclated based on estimated average SCR temperature using temperature observer (g/m2)*)
        rNH3StDMaxAr : REAL; (*Max NH3 storage capacity calculated based on arithmetic weighted SCR temperature dervied from exhaust gas input and output temperature (g/m2)*)
        rNH3StDEst : REAL; (*Estimation of the actual NH3 storage density (mass of ammonia per m2 of active SCR surface) inside the SCR (g/m2)*)
        rNH3InFFSS : REAL; (*Ouput of the NH3 steady state feed forwward injection controller (ppm)*)
        rNH3InFF : REAL; (*Output of the feed forward NH3 injection controller (ppm)*)
        rdeltaNH3InTr : REAL; (*Ouput of the NH3 transient feed forward injection controller (ppm)*)
        rdeltaNH3InTr2 : REAL; (*Output of second transient feed forward controller based on Nox measurements ()*)
        rNH3StDEst2 : REAL; (*Actual NH3 storage estimated by second transient feed forward controller based on Nox measurements  ()*)
        iIdxFFOut : USINT; (*Urea injection feed forward idx ()*)
        rFlowUreaFF_LT : REAL; (*Urea injection FF load table dependend calculation (l/h)*)
        rFlowUreaFF_NOx : REAL; (*Urea injection FF engine  NOx based (l/h)*)
        rFlowUreaFF_Map : REAL; (*Urea injection FF map based (massflow, temp, NOx) (l/h)*)
        rFlowUreaFF_NH3 : REAL; (*Urea injection FF NH3 sensor based (l/h)*)
        rDensUrea : REAL; (*Urea density (g/l)*)
    END_STRUCT;

   tUD_FF_PERM : STRUCT 
        rNH3FFMinLim : REAL; (*Minimum limit of output of ammonia feed forward controller (ppm)*)
        rNH3FFMaxLim : REAL; (*Maximum limit of output of ammonia feed forward controller (ppm)*)
        rdNH3TrMinLim : REAL; (*Minimum limit for transient feed forward NH3 injection control (ppm)*)
        rdNH3TrMaxLim : REAL; (*Maximum limit for transient feed forward NH3 injection control (ppm)*)
        rTSCRInit : REAL; (*Initial / reset value of SCR surface temperature output (degC)*)
        bTSCRRes : BOOL; (*If TRUE,  SCR surface temperature output is reset to I0 (initial temperature) (-)*)
        rNH3SSCor : REAL; (*Correction factor for steady state feedforward controller output (-)*)
        bNH3StDRes : BOOL; (*If TRUE resets the integrator of the estimated ammonia storage density (-)*)
        rNH3InTrGainB : REAL; (*Gain B for the transient feed forward NH3 injection controller. Increasing this value makes the transient FF term initially higher and reduction over time faster. (ppm*m2/g)*)
        rNH3InTrGainA : REAL; (*Gain A for the transient feed forward NH3 injection controller. Increasing this value fades out the transient feed forward term faster over time. (g/(m2*s*ppm))*)
        rMwUr : REAL; (*Mole weight of urea (g/mol)*)
        rMwExh : REAL; (*Mole weight of exhaust gas (g/mol)*)
        rUrFFMinLim : REAL; (*Minimum limitation of output of feed forward urea injection controller including adaptation of output via master controller gain plus offset (l/h)*)
        rUrFFMaxLim : REAL; (*Maximum limitation of output of feed forward urea injection controller including adaptation of output via master controller gain plus offset (l/h)*)
        bNH3InFFSSEn : BOOL; (*Enables steady state feed forward NH3 injection calculation if = TRUE According to spec doc D1-c (-)*)
        bdeltNH3InTrEn : BOOL; (*Enables transient feed forward NH3 injection calculation if = TRUE (-)*)
        bUrInModEn : BOOL; (*Enables model based feed forward urea injection calculation if = TRUE according to spec doc D1-d (-)*)
        rNH3StorMap_x : ARRAY[0..4] OF REAL; (*Estimated SCR temperature (degC)*)
        rNH3StorMap_y : ARRAY[0..4] OF REAL; (*Estimated max NH3 storage capacity (g/m2)*)
        bTSCRObsEn : BOOL; (*Activates the SCR temperature observer and uses Observer ouput to calculate average temeprature and max NH3 storage capacity, if = TRUE; Uses arithmetic mean to calculate SCR temperature and max storage capacity if = False (-)*)
        rNOxRedRatioMap_SV : ARRAY[0..2] OF REAL; (*Maximum NOx reduction ratio based on SCR temperature and exhaust space velocity SV: input SV (1/h)*)
        rNOxRedRatioMap_T : ARRAY[0..5] OF REAL; (*Maximum NOx reduction ratio based on SCR temperature and exhaust space velocity: input T (degC)*)
        rNOxRedRatioMap_out : ARRAY[0..17] OF REAL; (*Maximum NOx reduction ratio based on SCR temperature and exhaust space velocity: output (au)*)
        bdeltNH3InTrEn2 : BOOL; (*Release of second transient feed forward Urea controller output ()*)
        rNH3InTrGainC : REAL; (*Input gain of second transient feed forward Urea controller (g/m2/s/ppm)*)
        rNH3InTrGainD : REAL; (*Output gain of second transient feed forward Urea controller (ppm*m2/g)*)
        bNH3StDRes2 : BOOL; (*Reset of second transient feed forward Urea controller integrator ()*)
        rGainDeload : REAL; (*Deloading gain of second transient feed forward Urea controller (1/s)*)
        rdNH3TrMaxLim2 : REAL; (*Maximum output limit of second transient feed forward Urea controller (ppm)*)
        rdNH3TrMinLim2 : REAL; (*Maximum output limit of second transient feed forward Urea controller (ppm)*)
        rNH3SensStepUp : REAL; (*Upwards step of NH3 Sensor based urea injection closed loop controller (ppm)*)
        rNH3SensStepDwn : REAL; (*Downwards step of NH3 Sensor based urea injection closed loop controller (ppm)*)
        rNH3SensTrDel : REAL; (*Transport delay for NH3 Sensor based urea injection closed loop controller (s)*)
        rNH3SensGain : REAL; (*Proportional gain for NH3 Sensor based urea injection closed loop controller (-)*)
        bSCR_NH3Control_Active : BOOL; (*If TRUE, NH3 sensor based Urea injection closed loop control is enabled (-)*)
        rA_SCR_CatSurfaceOuter : REAL; (*Catalyst outer surface. Used for heat transfer calculations to the ambient (m2)*)
        rT_SCR_CatHeatTrans_Coef : REAL; (*Heat transfer coefficient from catalyst surface to ambient. Consider isolation material,  therefore assume very low values. (W/m2K)*)
        rC_SCR_ExhaustGas : REAL; (*Specific heat capacity of exhaust gas at constant pressure (J/kgK)*)
        rC_SCR_Cat : REAL; (*Specific heat capacity of catalyst material (mainly of the steel carrier material) (J/kgK)*)
        rMass_SCR_Cat : REAL; (*Mass of the catalyst (kg)*)
        rTmass_SCR_Cat : REAL; (*Thermal mass of catalyst housing (kJ/K)*)
        rNRho_SCR_WetExhaust : REAL; (*Density of the wet exhaust gas in kg per norm m3  P21 measurements for typical values: wet: 1.264 kg/Nm3 dry: 1.318 kg/Nm3 (kg/Nm3)*)
        rPnorm_Thresh : REAL; (*Power (normalized) threshold for activation of SCR feed forward adjustment (-)*)
        rTiConstAvgOn : REAL; (*Time constant after which the averaging of actual FF urea mass flow and the measured urea flow starts (s)*)
        rTiConstAvgOff : REAL; (*Time constant which determines the waiting period until the new averaging of actual FF urea mass flow and the measured urea flow starts (s)*)
        rTiFiltUreaFFAdjust : REAL; (*Time constant of the PT1 filter for the actual NH3 mass flow rate (s)*)
        rUreaGainDeltaLim : REAL; (*Upper and lower limit for the urea gian delta (-)*)
        rUreaGainDeltaRamp : REAL; (*Defines the ramp rate for urea flow adjustment (%/min)*)
        rUreaCalibFact : REAL; (*Calibration factor for the FF urea flow (-)*)
        rUreaFF_NOx_Tol : REAL; (*Defines the FF Load Table based tolerance band for the FF NOx (l/h)*)
        rTiFiltNOxFF : REAL; (*Time constant for filters used for comparison of FF LT and FF Nox (s)*)
        rUrFFNOxRampUp : REAL; (*Ramp up rate of Nox based FF in case of exceeding deviation limit to LT based FF (l/s)*)
        rUrFFNOxRampDn : REAL; (*Ramp down rate of Nox based FF in case of exceeding deviation limit to LT based FF (l/s)*)
    END_STRUCT;

   tUD_IN : STRUCT 
        rT_Ch_T1LP_Avg : REAL; (*Measured ambient temperature (°C)*)
        bESCEnable : BOOL; (*Emission Supervisory Controller enabled (-)*)
        rNFlow_ESC_UreaOffs : REAL; (*Urea controller offset from Emission Supervisory Controller (ESC) controller (l/h)*)
        rCF_ESC_UreaNFlow : REAL; (*Urea controller gain correction factor send from ESC (-)*)
        rNOx_ESC_CatOut_Set : REAL; (*Reference NOx at SCR output fromm  ESC (ppm)*)
        tFlow_SCR_UreaDosingOut : tHALioAi; (*Measured urea flow (feedback signal) (l/h)*)
        tT_SCR_CatIn : tHALioAi; (*Measured exhaust gas temperature at SCR input (°C)*)
        tT_SCR_CatOut : tHALioAi; (*Measured exhaust gas temperature at SCR output (°C)*)
        rVol_Ch_Engine_Norm : REAL; (*Calculated engine volume flow (Nm3/h)*)
        rNH3_SCR_OxiIn : REAL; (*Measured ammonia (NH3) content at SCR output (ppm)*)
        tDPr_UreaDosingUnit : tHALioAi; (*Urea injection differential pressure measured (bar)*)
        rPos_SCR_UreaDosingValve : REAL; (*Urea injection valve position (%)*)
        rP_Act_Norm_Filt : REAL; (*Actual measured electric power output (% Pnom)*)
        bRel_SCR_Dosing : BOOL; (*Info from structured text to autocode that urea injection system is working and ready for operation (-)*)
        rPc_SCR_UreaDosingPump : REAL; (*Actual urea pump speed recieved from pump frequency converter in normalized speed (0..1)
Used for proper Anti-windup for urea injection control via urea pump speed control (%)*)
        tNOx_SCR_EngOut : tHALioAi; (*Measured NOx at engine output (ppm)*)
        tNOx_SCR_CatOut : tHALioAi; (*Measured NOx at SCR output (ppm)*)
        tEMLineCatOut : tUD_EMLine; (*Emissions Line (internal CEMS) Cat out (-)*)
        tEMLineOxiIn : tUD_EMLine; (*Emissions Line (internal CEMS) Oxi In (-)*)
        rNOx_SCR_CatOut_Est : REAL; (*Model based estimation of NOx at catalyst output (oxycat output) (ppm)*)
        bNOx_SCR_CatOut_Est_Ok : BOOL; (*Vailidty of model-based estimation of NOx at catalyst output (oxycat output); valid if = TRUE (-)*)
        rNOx_SCR_EngOut_Est : REAL; (*Model-based estimation of engine out NOx emissions (ppm)*)
        bNOx_SCR_EngOut_Est_Ok : BOOL; (*Validity of model-based estimation of engine out NOx emissions; valid if = True (-)*)
        rFlow_SCR_UreaDosingUnit_spMan : REAL; (*Manual command of urea flow (setpoint for UDU) (l/h)*)
        bSCR_UreaDosingUnit_Man : BOOL; (*Manual enabling/disabling of urea injection. Needs to be 1 to allow for any urea dosage controller (-)*)
        bSCR_NOxControl_Man : BOOL; (*Activate closed loop NOx control if = TRUE according to Spec Doc D2 (-)*)
        bSCR_Man : BOOL; (*G1: Manual operation mode of urea dosing system wihtout engine run Manual operation will be controlled via HMI if bSCR_Man = TRUE and autocode  dosing output will be not used in structured text. (-)*)
        bSCR_NH3SlipDetect_Blocked : BOOL; (*NH3 Slip detection blocked after 3 occurences (-)*)
        bOpModeStop : BOOL; (*Engine in stop mode (-)*)
        rHum_CatOut : REAL; (*intake air relative humiidty of humidity sensor (pu)*)
        bEMLine1_Exist : BOOL; (*SCR Emission measurement line 1 - exist (-)*)
        bEMLine2_Exist : BOOL; (*SCR Emission measurement line 2 - exist (-)*)
        rTiWaitNH3slip_fallback : REAL; (*Waiting time to switch to fallback strategy for NH3 slip detection in case of em. meas. line unavailability (s)*)
    END_STRUCT;

   tUD_OUT : STRUCT 
        rFlow_SCR_UreaDosingUnit_sp : REAL; (*Urea volume flow command from urea dosage controller to urea injection system (l/h)*)
        rFlow_SCR_NOxCtrl_Y : REAL; (*Nox closed loop controller output (l/h)*)
        bSCR_NOxCtrl_Act : BOOL; (*Nox controller active (-)*)
        rNOx_SCR_NOxCtrl_act : REAL; (*Nox closed loop controller input (ppm)*)
        rNOx_SCR_CatOut_Set : REAL; (*Nox setpoint including ESC  (ppm)*)
        bSCR_EngineSteadyState : BOOL; (*Engine steady state (-)*)
        rPc_SCR_UreaDosingUnit_sp : REAL; (*Urea valve position reference (pu)*)
        rPc_SCR_UreaDosingUnit_ff : REAL; (*Urea valve position feed forwrad (pu)*)
        rPc_SCR_UreaFlowCtrl_Y : REAL; (*Urea flow closed loop controller output (-)*)
        bSCR_UreaFlowCtrl_Act : BOOL; (*Urea flow controller active (-)*)
        rFlow_SCR_UreaDosingValve_Calc : REAL; (*Inverse calculation of urea mass flow based on the actual urea dosing set-point (l/h)*)
        bSCR_NH3SlipDetected : BOOL; (*NH3 slip out of SCR catalyst detected if = TRUE (-)*)
        bSCR_NH3SlipInterrupt : BOOL; (*NH3 slip detection routine interrupted if = TRUE (-)*)
        bSCR_EMValve1_SGbOxi_Dem : BOOL; (*Switch to sampling gas position to Oxi In (-)*)
        rFlow_SCR_UreaDosingUnit_ff : REAL; (*Urea volume flow command from urea dosage controller to urea injection system feed forward (l/h)*)
        rUreaGain_Adj : REAL; (*Adjusted gain for feedforward (-)*)
        rFlow_SCR_UreaDosing_ffNH3Cor : REAL; (*Urea volume flow command from urea dosage controller feed forward corrected with the NH3 slip correction factor (l/h)*)
    END_STRUCT;

   tUD_PARA : STRUCT 
        rPc_SCR_UreaSolution : REAL; (*Fraction of urea solution (%)*)
        rT_SCR_UreaDosingUnit_Release : REAL; (*U1: Lower temperature limit to start urea injection. If temperature of the catalyst is below this limit,  urea injection will be stopped. (°C)*)
        rVol_SCR_Cat : REAL; (*SCR catalyst volume (m3)*)
        rFlow_SCR_UreaDosingValveCoeff : REAL; (*Urea valve coefficient (l/h)*)
        bSCR_Active : BOOL; (*G0: The parameter is used to activate the relevant modules tasks (-)*)
        bSCR_UreaDosingValve_Exist : BOOL; (*Euqal to TRUE if dosing valve is used (-)*)
        rCF_SCR_UreaNFlowGain : REAL; (*Correction factor for feed forward load table based urea injection (-)*)
        iIdx_SCR_UreaNFlow_SelectFF : INT; (*Manual selection of preferred urea dosis calculation methid (-)*)
        bSCR_UreaFlowCtrl_Active : BOOL; (*Enables Urea injection control via speed control of urea pump (-)*)
        rNOx_SCR_CatOut_Set : REAL; (*Is taken instead of NOx sensor readings of engine out NOx measurement in case of fault sensor signals (ppm)*)
        rDNOx_SCR_NH3Slip_Hi : REAL; (*Maximum allowed NH3 slip (ppm)*)
        bSCR_NH3SlipDetect_Active : BOOL; (*Enables NH3 slip detection and control, enabled if = True (-)*)
        rNFlow_SCR_Urea30 : REAL; (*Urea dosing rate at engine load 30% (l/h)*)
        rNFlow_SCR_Urea50 : REAL; (*Urea dosing rate at engine load 50% (l/h)*)
        rNFlow_SCR_Urea75 : REAL; (*Urea dosing rate at engine load 75% (l/h)*)
        rNFlow_SCR_Urea100 : REAL; (*Urea dosing rate at engine load 100% (l/h)*)
        rA_SCR_CatSurfaceIntern : REAL; (*internal SCR catalyst surface area (m²)*)
        rSCR_NOxCtrl_Ymin : REAL; (*Minimum limitation of PID output of closed loop urea injection controller (l/h)*)
        rSCR_NOxCtrl_Ymax : REAL; (*Maximum limitation of PID output of closed loop urea injection controller (l/h)*)
        rSCR_NOxCtrl_Kd : REAL; (*Derivative gain of PID closed loop urea injection controller (-)*)
        rSCR_NOxCtrl_Ki : REAL; (*Integral gain of PID closed loop urea injection controller (l/h/ppm/s*1000)*)
        rSCR_NOxCtrl_Kp : REAL; (*proportional gain of PID closed loop urea injection controller (l/h/ppm*1000)*)
        rSCR_UreaFlowCtrl_Ymin : REAL; (*Urea valve position closed loop controller min output limit (%)*)
        rSCR_UreaFlowCtrl_Ymax : REAL; (*Urea valve position closed loop controller max output limit (%)*)
        rSCR_UreaFlowCtrl_Kd : REAL; (*Derivative gain of PIDN based urea valve closed loop controller (%/l/h*s)*)
        rSCR_UreaFlowCtrl_Ki : REAL; (*Integral gain of PIDN based urea valve closed loop controller (%/l/h/s)*)
        rSCR_UreaFlowCtrl_Kp : REAL; (*Proportional gain of PIDN based urea valve closed loop controller (%/l/h)*)
        rSCR_NOxControlWaiting : REAL; (*waiting time for NOx controller after Urea dosing activation (s)*)
        rNOx_SCR_EngOut_Expect : REAL; (*Expected Nox value  (ppm)*)
        bSCR_UreaNFlowAutoCorr_Active : BOOL; (*Automatic correction of FF enabled (-)*)
        rFlow_SCR_UreaDosingUnit_Hi : REAL; (*Dosing unit nominal flow rate (l/h)*)
        rNOx_SCR_CatOut_Hi : REAL; (*Maximum Nox CatOut (ppm)*)
        rTiSCR_EAC_DurationStartup : REAL; (*SCR Emission average calculation - duration for SCR startup (s)*)
        rTiSCR_NH3Slip_WaitNOxGrad_CL : REAL; (*Minimum wait time to restart the SCR NOx controller closed loop in case of NOx increase after NH3 slip detection (s)*)
        bFlow_SCR_UreaDosingOut_Exist : BOOL; (*SCR Urea flow rate after dosing active (-)*)
    END_STRUCT;

   tUD_PERM : STRUCT 
        SM : tUD_SM_PERM; (*Perm Signal Manager ()*)
        FF : tUD_FF_PERM; (*Perm Feed Forward ()*)
        Slip : tUD_Slip_PERM; (*Perm Slip Detection ()*)
        CLNOx : tUD_CLNOx_PERM; (*Perm NOx Closed loop controller ()*)
        CLVal : tUD_CLVal_PERM; (*Perm Flow Closed loop controller (Valve) ()*)
        CLPp : tUD_CLPp_PERM; (*Perm Flow Closed loop controller (Pump) ()*)
    END_STRUCT;

   tUD_SM_DBG : STRUCT 
        rNOx_SCR_CatOut_Set : REAL; (*Nox setpoint including ESC  (ppm)*)
        rNOx_EMLineCatOut : REAL; (* (ppm)*)
        bEMLineCatOut_GQ : BOOL; (* (-)*)
        rNOx_EMLineOxiIn : REAL; (* (ppm)*)
        bEMLineOxiIn_GQ : BOOL; (* (-)*)
        rNOx_SCR_NOxCtrl_act : REAL; (*Nox closed loop controller input (ppm)*)
        bFreezeCtr : BOOL; (*freeze Nox ctrl  (-)*)
        rNOx_CatOutCor : REAL; (*Nox value used for map based FF (ppm)*)
        bNOx_CatOutCor : BOOL; (* (-)*)
        rNOxEngOutCor : REAL; (* (ppm)*)
        bSCR_EngineSteadyState : BOOL; (*Steady state depending on SCR temperature and normalized electrical power (-)*)
        rTSCRAvg : REAL; (*Average SCR Cat Temperature (°C)*)
    END_STRUCT;

   tUD_SM_PERM : STRUCT 
        rTiFilt_P_Act_Norm : REAL; (*Time constant of the PT1 filter for the normalized filtered power (s)*)
        rTiFilt_T_SCR_Avg : REAL; (*Time constant of the PT1 filter for the average SCR Cat temperature (s)*)
        rThresh_SS_P : REAL; (*Threshold for steady state power related (-)*)
        rThresh_SS_T_Avg : REAL; (*Threshold for steady state temperature of SCR cat (average) related (°C)*)
        rTOnDelay_SS_P : REAL; (*On-delay for the steady state power realted in terms the conditions are met (s)*)
        rTOnDelay_SS_T : REAL; (*On-delay for the steady state SCR temp. realted in terms the conditions are met (s)*)
        rP_Act_enable : REAL; (*Normalized power to enable steady state (-)*)
    END_STRUCT;

   tUD_Slip_DBG : STRUCT 
        bSCR_NH3SlipDetected : BOOL; (*NH3 Slip detetcted ()*)
        rUrCorFactSlip : REAL; (*Urea flow correction factor being adjusted in case of NH3 slip detection.
Gets reduced down to zero again if no slip is detected anymore over time ()*)
        bFreezeCtrl : BOOL; (*Freeze Nox ctrl due to slip detection (-)*)
        bSCR_NH3SlipInterrupt : BOOL; (*NH3 slip detection routine interrupted (-)*)
        bNH3SlipCtrlEna : BOOL; (*Indicates if NH3 slip detection is currently enabled ()*)
        bSCR_EMValve1_SGbOxi_Dem : BOOL; (*Switch to sampling gas position to Oxi In (-)*)
    END_STRUCT;

   tUD_Slip_PERM : STRUCT 
        rCemsIntFiltFact : REAL; (*First order filter time constant for NOx values averaging for slip detection and control (s)*)
        bCemsIntFiltRes : BOOL; (*Reset first order filter for NOx value filtering for NH3 slip detection and control, reset integrator if = true (-)*)
        rNH3SlipActSlope : REAL; (*Slope with which the urea correction factor for NH3 slip reduction is reduced again to zero. The higher the value, the faster the urea correction factor is eliminated again after slip detection. (1/s)*)
        rTi_SlipDetectWait : REAL; (*Waiting time before slip detection is again activated after detection completed  (s)*)
        rNOxMarginSet : REAL; (*Nox_CatOut x times higher as setpoint (-)*)
        rNOxMarginFFLT : REAL; (*Nox_CatOut x times higher as feed forward load table (-)*)
        rTiNOxMarginDelay : REAL; (*Nox higher as limit or setpoint for x seconds (s)*)
        rTiNOxCLSatDelay : REAL; (*Nox ctrl for x seconds in saturation (s)*)
        rTiSwitchValve : REAL; (*Switch over EMLine valve for x seconds (s)*)
        rGainSlipCor : REAL; (*Slip correction factor E9 (with CEMS) (-)*)
        rGainSlipCorSens : REAL; (*Slip correction factor E9a (with Nox sensor) (-)*)
        rGainFreezeCtr : REAL; (*percantege of time after slip detection, when ctrl is released again (pu)*)
        rTiWaitSteadyState : REAL; (*Wait to enable slip detection after steady state (s)*)
        rTiWaitSCRMan : REAL; (*Wait to enable slip detection after SCR manual mode (s)*)
        rTiWaitSwitch : REAL; (*Wait to enable slip detection after switch valve over to OxiIn (s)*)
        rTiFilter_Nox : REAL; (*Filter constant for Nox derivative (s)*)
        rNOxGradLim : REAL; (*Nox gradient limit to unfreeze controller (ppm/s)*)
        rNOxFactorSet_CL : REAL; (*Nox_CatOut x times lower than setpoint to restart closed loop controller during NH3 slip correction routine (-)*)
    END_STRUCT;
END_TYPE
TYPE
rtB_Cell1_UDC : STRUCT
	DiscreteTimeIntegrator : REAL;
	LookupTableDynamic : REAL;
END_STRUCT;
rtDW_Cell1_UDC : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_Filter_UDC : STRUCT
	Switch : REAL;
END_STRUCT;
rtDW_Filter_UDC : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
rtB_TON_UDC : STRUCT
	LogicalOperator3 : BOOL;
END_STRUCT;
rtDW_TON_UDC : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
rtB_TP_UDC : STRUCT
	Merge : REAL;
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TP_UDC : STRUCT
	DelayInput2_DSTATE : REAL;
	UnitDelay2_DSTATE : BOOL;
END_STRUCT;
rtB_TOF_UDC : STRUCT
	LogicalOperator1 : BOOL;
END_STRUCT;
rtDW_TOF_UDC : STRUCT
	DiscreteTimeIntegrator_DSTATE : LREAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
BlockIO_UDC : STRUCT
	BusInput2 : tUD_PERM;
	BusInput : tUD_IN;
	BusInput1 : tUD_PARA;
	Merge5 : ARRAY[0..3] OF REAL;
	UnitDelay : UDINT;
	TON_p : rtB_TON_UDC;
	TON3_p : rtB_TON_UDC;
	TON2_a : rtB_TON_UDC;
	TON1_p : rtB_TON_UDC;
	TON_fg : rtB_TON_UDC;
	TP_m : rtB_TP_UDC;
	TON_o : rtB_TON_UDC;
	Filter_OxiIn : rtB_Filter_UDC;
	Filter_CatOut : rtB_Filter_UDC;
	TP1 : rtB_TP_UDC;
	TON2 : rtB_TON_UDC;
	TON1_k : rtB_TON_UDC;
	TON_i : rtB_TON_UDC;
	TP_e : rtB_TP_UDC;
	TON3 : rtB_TON_UDC;
	TON_a : rtB_TON_UDC;
	TON1 : rtB_TON_UDC;
	TON : rtB_TON_UDC;
	Filter2 : rtB_Filter_UDC;
	Filter : rtB_Filter_UDC;
	TOF1 : rtB_TOF_UDC;
	TOF : rtB_TOF_UDC;
	TON_f : rtB_TON_UDC;
	Filter_DPr_h : rtB_Filter_UDC;
	Filter_DPr : rtB_Filter_UDC;
	TP : rtB_TP_UDC;
	TON_j : rtB_TON_UDC;
	Filter1 : rtB_Filter_UDC;
	Filter_o : rtB_Filter_UDC;
	Cell3 : rtB_Cell1_UDC;
	Cell2 : rtB_Cell1_UDC;
	Cell1 : rtB_Cell1_UDC;
END_STRUCT;
D_Work_UDC : STRUCT
	Delay_DSTATE : REAL;
	Delay_DSTATE_d : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_i : REAL;
	VariableIntegerDelay_DSTATE : ARRAY[0..999] OF REAL;
	UnitDelay_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE_p : REAL;
	DiscreteTimeIntegrator1_DSTATE : REAL;
	UnitDelay_DSTATE_g : REAL;
	UnitDelay4_DSTATE : REAL;
	Delay_DSTATE_k : REAL;
	Delay_DSTATE_h : REAL;
	DiscreteTimeIntegrator_DSTATE_o : REAL;
	Delay_DSTATE_f : REAL;
	DiscreteTimeIntegrator_DSTATE_d : REAL;
	DiscreteTimeIntegrator1_DSTAT_l : REAL;
	UnitDelay_DSTATE_j : REAL;
	DiscreteTimeIntegrator_DSTATE_e : REAL;
	DiscreteTimeIntegrator1_DSTAT_b : REAL;
	UnitDelay_DSTATE_n : REAL;
	UnitDelay_DSTATE_d : REAL;
	UnitDelay2_DSTATE : REAL;
	UnitDelay_DSTATE_c : UDINT;
	rNOx_EMLineCatOut_1 : REAL;
	rNOx_EMLineOxiIn_1 : REAL;
	rNOx_Act_1 : REAL;
	UnitDelay4_DSTATE_j : BOOL;
	UnitDelay_DSTATE_l : BOOL;
	DelayInput1_DSTATE : BOOL;
	UnitDelay_DSTATE_dg : BOOL;
	UnitDelay2_DSTATE_f : BOOL;
	UnitDelay2_DSTATE_i : BOOL;
	DelayInput1_DSTATE_m : BOOL;
	UnitDelay_DSTATE_jw : BOOL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_k : SINT;
	DiscreteTimeIntegrator_PrevRe_j : SINT;
	DiscreteTimeIntegrator1_PrevRes : SINT;
	DiscreteTimeIntegrator_PrevRe_e : SINT;
	DiscreteTimeIntegrator_PrevR_j5 : SINT;
	DiscreteTimeIntegrator1_PrevR_b : SINT;
	DiscreteTimeIntegrator_PrevRe_p : SINT;
	DiscreteTimeIntegrator1_PrevR_e : SINT;
	icLoad : USINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
	DiscreteTimeIntegrator1_IC_LOAD : USINT;
	icLoad_g : USINT;
	icLoad_e : USINT;
	icLoad_d : USINT;
	DiscreteTimeIntegrator_IC_LOA_e : USINT;
	DiscreteTimeIntegrator1_IC_LO_n : USINT;
	DiscreteTimeIntegrator_IC_LOA_f : USINT;
	DiscreteTimeIntegrator1_IC_LO_i : USINT;
	Memory_PreviousInput : BOOL;
	Relay1_Mode : BOOL;
	Memory_PreviousInput_k : BOOL;
	x : BOOL;
	rNOx_EMLineCatOut_1_not_empty : BOOL;
	rNOx_EMLineOxiIn_1_not_empty : BOOL;
	rNOx_Act_1_not_empty : BOOL;
	TON_p : rtDW_TON_UDC;
	TON3_p : rtDW_TON_UDC;
	TON2_a : rtDW_TON_UDC;
	TON1_p : rtDW_TON_UDC;
	TON_fg : rtDW_TON_UDC;
	TP_m : rtDW_TP_UDC;
	TON_o : rtDW_TON_UDC;
	Filter_OxiIn : rtDW_Filter_UDC;
	Filter_CatOut : rtDW_Filter_UDC;
	TP1 : rtDW_TP_UDC;
	TON2 : rtDW_TON_UDC;
	TON1_k : rtDW_TON_UDC;
	TON_i : rtDW_TON_UDC;
	TP_e : rtDW_TP_UDC;
	TON3 : rtDW_TON_UDC;
	TON_a : rtDW_TON_UDC;
	TON1 : rtDW_TON_UDC;
	TON : rtDW_TON_UDC;
	Filter2 : rtDW_Filter_UDC;
	Filter : rtDW_Filter_UDC;
	TOF1 : rtDW_TOF_UDC;
	TOF : rtDW_TOF_UDC;
	TON_f : rtDW_TON_UDC;
	Filter_DPr_h : rtDW_Filter_UDC;
	Filter_DPr : rtDW_Filter_UDC;
	TP : rtDW_TP_UDC;
	TON_j : rtDW_TON_UDC;
	Filter1 : rtDW_Filter_UDC;
	Filter_o : rtDW_Filter_UDC;
	Cell3 : rtDW_Cell1_UDC;
	Cell2 : rtDW_Cell1_UDC;
	Cell1 : rtDW_Cell1_UDC;
END_STRUCT;
PrevZCSigStates_UDC : STRUCT
	Delay_Reset_ZCE : USINT;
	Delay_Reset_ZCE_n : USINT;
	Delay_Reset_ZCE_d : USINT;
	Delay_Reset_ZCE_i : USINT;
	Delay_Reset_ZCE_b : USINT;
END_STRUCT;
rtC_Filter_UDC : STRUCT
	Conversion : REAL;
END_STRUCT;
ConstBlockIO_UDC : STRUCT
	Filter_OxiIn : rtC_Filter_UDC;
	Filter_CatOut : rtC_Filter_UDC;
	Filter2 : rtC_Filter_UDC;
	Filter : rtC_Filter_UDC;
	Filter_DPr_h : rtC_Filter_UDC;
	Filter_DPr : rtC_Filter_UDC;
	Filter1 : rtC_Filter_UDC;
	Filter_o : rtC_Filter_UDC;
END_STRUCT;
ConstParam_UDC : STRUCT
	Constant_Value : ARRAY[0..4] OF LREAL;
	InterpolationUsingPre : ARRAY[0..1] OF UDINT;
	pooled28 : ARRAY[0..15] OF BOOL;
END_STRUCT;
ExternalInputs_UDC : STRUCT
	InUD : tUD_IN;
	ParaUD : tUD_PARA;
	PermUD : tUD_PERM;
END_STRUCT;
ExternalOutputs_UDC : STRUCT
	OutUDbus : tUD_OUT;
	DebugUDbus : tUD_DBG;
END_STRUCT;
tag_RTM_UDC : STRUCT
	errorStatus : REFERENCE TO USINT;
END_STRUCT;
END_TYPE