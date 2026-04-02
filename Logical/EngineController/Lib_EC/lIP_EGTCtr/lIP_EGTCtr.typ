TYPE


   tEGTCtr_In : STRUCT 
        rT_EG_MaxLim : REAL; (*Exhaust temperature shut down limit from Diane Parameter [°C]*)
        rT_EG_Max : REAL; (*Maximum actual exhaust temperature among all cylinders [°C]*)
        bReset : BOOL; (*Reset of exhaust temperature controller integrator [boolean]*)
        rCA_Init : REAL; (*Reset value of exhaust temperature controller integrator [°CA]*)
        rCA_IP_Act_Rel : REAL; (*External actual ignition timing offset [°CA]*)
    END_STRUCT;

   tEGTCtr_Out : STRUCT 
        ulim : REAL; (*Limited controller output [°CA] oldname: ITOffuLim*)
        u : REAL; (*Unlimited controller output [°CA] oldname: ITOffu*)
        up : REAL; (*Unlimited proportional controller output [°CA] oldname: ITOffup*)
        ui : REAL; (*Unlimited integral controller output [°CA] oldname: ITOffui*)
        ud : REAL; (*Unlimited derivative controller output [°CA] oldname: ITOffud*)
        e : REAL; (*Control error without anti-windup [°C] oldname: ITOffe*)
        AW : REAL; (*Anti-windup feedback error [°C] oldname: ITOffAW*)
    END_STRUCT;

   tEGTCtr_Perm : STRUCT 
        rT_EG_DltLim : REAL; (*Delta margin from exhaust temperature limit [°C] oldname: TExhLimCntMar*)
        Kp : REAL; (*Proportional gain of exhaust limit controller [°CA/°C]*)
        Ki : REAL; (*Integral gain of exhaust limit controller [°CA/°C/s]*)
        Kd : REAL; (*Derivative gain of exhaust limit controller [°CA*s/°C]*)
        N : REAL; (*Filter constant for derivative controller gain [1/s]*)
        UpLim : REAL; (*Upper limit for controller output [CAD]*)
        LoLim : REAL; (*Lower limit for controller output [°CA]*)
        KAW : REAL; (*Anti windup gain for exhaust temperature controller integrator [°C/°CA]*)
        DeadLoD : REAL; (*Lower deadband limit for derivative part [°C]*)
        DeadUpD : REAL; (*Upper deadband limit for derivative part [°C]*)
    END_STRUCT;
END_TYPE
TYPE
BlockIO_IP_EGTCtr : STRUCT
	perm : tEGTCtr_Perm;
	BusCreator : tEGTCtr_Out;
	in : tEGTCtr_In;
END_STRUCT;
D_Work_IP_EGTCtr : STRUCT
	DiscreteTimeIntegrator_DSTATE : REAL;
	DiscreteTimeIntegrator1_DSTATE : REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator1_PrevRes : SINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
END_TYPE