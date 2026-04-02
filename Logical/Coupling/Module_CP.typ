
TYPE
	IN_CP_Struct : 	STRUCT 
		iMsg : ARRAY[0..9999]OF USINT; (*provides data from all alarms - BETA 2018, from CBM Version*) (*OldName:newPv; Cycle:2;*)
		tAB2CP : AmmBase2MM; (*AMM structure*) (*OldName:newPv; Cycle:2;*)
		tPB2MM : ParaBase2MM_type; (*Data exchange structure to ParaBase*) (*OldName: new structure; Cyclic:5; *)
		tCU2CP_OutData : ARRAY[0..MAX_OUT_DATA_ARRAY]OF INT; (*output data to Coupling Module*)
		tMCB_On : HALioDi_Type; (*DI mains circuit breaker closed*) (*OldName:MCB_ON;Cycle:5*)
		tGCB_On : HALioDi_Type; (*DI generator circuit breaker closed*) (*OldName:GCB_ON;Cycle:5*)
		tEng_Run : HALioDo_Type; (* engine running *) (*OldName:BTRB,M_BTRB;Cycle:5;*)
		tEng_Rdy_Rem : HALioDo_Type; (* Ready for Remote Operation *) (*OldName:BERZLT;Cycle:2;*)
		iIdx_OMSS : INT; (*Index of operation mode selector switch 0  OFF, 1  MANUAL, 2  AUTOMATIC, 3 Test (Optional)*) (*OldName: 	AUTO, MAN, …..	; Cyclic:5; *)
		iIdx_RSS : INT; (*Index of request selector switch - 0..OFF, 1..ON, 2..REMOTE *) (*OldName:FERN; Cycle:5*)
		bMsg1001 : BOOL;
		bMsg1002 : BOOL;
		bMsg1003 : BOOL;
		bMsg1004 : BOOL;
		bMsg1005 : BOOL;
		bMsg1006 : BOOL;
		bMsg1007 : BOOL;
		bMsg1008 : BOOL;
		bMsg1009 : BOOL;
		bMsg1010 : BOOL;
		bMsg1011 : BOOL;
		bMsg1012 : BOOL;
		bMsg1013 : BOOL;
		bMsg1014 : BOOL;
		bMsg1015 : BOOL;
		bMsg1016 : BOOL;
		bMsg1017 : BOOL;
		bMsg1018 : BOOL;
		bMsg1019 : BOOL;
		bMsg1020 : BOOL;
		bMsg1021 : BOOL;
		bMsg1022 : BOOL;
		bMsg1023 : BOOL;
		bMsg1024 : BOOL;
		bMsg1025 : BOOL;
		bMsg1026 : BOOL;
		bMsg1027 : BOOL;
		bMsg1028 : BOOL;
		bMsg1029 : BOOL;
		bMsg1030 : BOOL;
		bMsg1031 : BOOL;
		bMsg1032 : BOOL;
		bMsg1033 : BOOL;
		bMsg1034 : BOOL;
		bMsg1035 : BOOL;
		bMsg1036 : BOOL;
		bMsg1037 : BOOL;
		bMsg1038 : BOOL;
		bMsg1039 : BOOL;
		bMsg1040 : BOOL;
		bMsg1041 : BOOL;
		bMsg1042 : BOOL;
		bMsg1043 : BOOL;
		bMsg1044 : BOOL;
		bMsg1045 : BOOL;
		bMsg1046 : BOOL;
		bMsg1047 : BOOL;
		bMsg1048 : BOOL;
		bMsg1049 : BOOL;
		bMsg1050 : BOOL;
		bMsg1051 : BOOL;
		bMsg1052 : BOOL;
		bMsg1053 : BOOL;
		bMsg1054 : BOOL;
		bMsg1055 : BOOL;
		bMsg1056 : BOOL;
		bMsg1057 : BOOL;
		bMsg1058 : BOOL;
		bMsg1059 : BOOL;
		bMsg1060 : BOOL;
		bMsg1061 : BOOL;
		bMsg1062 : BOOL;
		bMsg1063 : BOOL;
		bMsg1064 : BOOL;
		bMsg1065 : BOOL;
		bMsg1066 : BOOL;
		bMsg1067 : BOOL;
		bMsg1068 : BOOL;
		bMsg1069 : BOOL;
		bMsg1070 : BOOL;
		bMsg1071 : BOOL;
		bMsg1072 : BOOL;
		bMsg1073 : BOOL;
		bMsg1074 : BOOL;
		bMsg1075 : BOOL;
		bMsg1076 : BOOL;
		bMsg1077 : BOOL;
		bMsg1078 : BOOL;
		bMsg1079 : BOOL;
		bMsg1080 : BOOL;
		bMsg1081 : BOOL;
		bMsg1082 : BOOL;
		bMsg1083 : BOOL;
		bMsg1084 : BOOL;
		bMsg1085 : BOOL;
		bMsg1086 : BOOL;
		bMsg1087 : BOOL;
		bMsg1088 : BOOL;
		bMsg1089 : BOOL;
		bMsg1090 : BOOL;
		bMsg1091 : BOOL;
		bMsg1092 : BOOL;
		bMsg1093 : BOOL;
		bMsg1094 : BOOL;
		bMsg1095 : BOOL;
		bMsg1096 : BOOL;
		bMsg1097 : BOOL;
		bMsg1098 : BOOL;
		bMsg1099 : BOOL;
		bMsg1100 : BOOL;
		bMsg1101 : BOOL;
		bMsg1102 : BOOL;
		bMsg1103 : BOOL;
		bMsg1104 : BOOL;
		bMsg1105 : BOOL;
		bMsg1106 : BOOL;
		bMsg1107 : BOOL;
		bMsg1108 : BOOL;
		bMsg1109 : BOOL;
		bMsg1110 : BOOL;
		bMsg1111 : BOOL;
		bMsg1112 : BOOL;
		bMsg1113 : BOOL;
		bMsg1114 : BOOL;
		bMsg1115 : BOOL;
		bMsg1116 : BOOL;
		bMsg1117 : BOOL;
		bMsg1118 : BOOL;
		bMsg1119 : BOOL;
		bMsg1120 : BOOL;
		bMsg1121 : BOOL;
		bMsg1122 : BOOL;
		bMsg1123 : BOOL;
		bMsg1124 : BOOL;
		bMsg1125 : BOOL;
		bMsg1126 : BOOL;
		bMsg1127 : BOOL;
		bMsg1128 : BOOL;
		bMsg1129 : BOOL;
		bMsg1130 : BOOL;
		bMsg1131 : BOOL;
		bMsg1132 : BOOL;
		bMsg1133 : BOOL;
		bMsg1134 : BOOL;
		bMsg1135 : BOOL;
		bMsg1136 : BOOL;
		bMsg1137 : BOOL;
		bMsg1138 : BOOL;
		bMsg1139 : BOOL;
		bMsg1140 : BOOL;
		bMsg1141 : BOOL;
		bMsg1142 : BOOL;
		bMsg1143 : BOOL;
		bMsg1144 : BOOL;
		bMsg1145 : BOOL;
		bMsg1146 : BOOL;
		bMsg1147 : BOOL;
		bMsg1148 : BOOL;
		bMsg1149 : BOOL;
		bMsg1150 : BOOL;
		bMsg1151 : BOOL;
		bMsg1152 : BOOL;
		bMsg1153 : BOOL;
		bMsg1154 : BOOL;
		bMsg1155 : BOOL;
		bMsg1156 : BOOL;
		bMsg1157 : BOOL;
		bMsg1158 : BOOL;
		bMsg1159 : BOOL;
		bMsg1160 : BOOL;
		bMsg1161 : BOOL;
		bMsg1162 : BOOL;
		bMsg1163 : BOOL;
		bMsg1164 : BOOL;
		bMsg1165 : BOOL;
		bMsg1166 : BOOL;
		bMsg1167 : BOOL;
		bMsg1168 : BOOL;
		bMsg1169 : BOOL;
		bMsg1170 : BOOL;
		bMsg1171 : BOOL;
		bMsg1172 : BOOL;
		bMsg1173 : BOOL;
		bMsg1174 : BOOL;
		bMsg1175 : BOOL;
		bMsg1176 : BOOL := FALSE; (*retired; Tinello	V4.04	1176 entfernt; *)
		bMsg1177 : BOOL;
		bMsg1178 : BOOL;
		bMsg1179 : BOOL;
		bMsg1180 : BOOL;
		bMsg1181 : BOOL;
		bMsg1182 : BOOL;
		bMsg1183 : BOOL;
		bMsg1184 : BOOL;
		bMsg1185 : BOOL;
		bMsg1186 : BOOL;
		bMsg1187 : BOOL;
		bMsg1188 : BOOL;
		bMsg1189 : BOOL;
		bMsg1190 : BOOL;
		bMsg1191 : BOOL;
		bMsg1192 : BOOL;
		bMsg1193 : BOOL;
		bMsg1194 : BOOL;
		bMsg1195 : BOOL;
		bMsg1196 : BOOL;
		bMsg1197 : BOOL;
		bMsg1198 : BOOL;
		bMsg1199 : BOOL;
		bMsg1200 : BOOL;
		bMsg1201 : BOOL;
		bMsg1202 : BOOL;
		bMsg1203 : BOOL;
		bMsg1204 : BOOL;
		bMsg1205 : BOOL;
		bMsg1206 : BOOL;
		bMsg1207 : BOOL;
		bMsg1208 : BOOL;
		bMsg1209 : BOOL;
		bMsg1210 : BOOL;
		bMsg1211 : BOOL;
		bMsg1212 : BOOL;
		bMsg1213 : BOOL;
		bMsg1214 : BOOL;
		bMsg1215 : BOOL;
		bMsg1216 : BOOL;
		bMsg1217 : BOOL;
		bMsg1218 : BOOL;
		bMsg1219 : BOOL;
		bMsg1220 : BOOL;
		bMsg1221 : BOOL;
		bMsg1222 : BOOL;
		bMsg1223 : BOOL;
		bMsg1224 : BOOL;
		bMsg1235 : BOOL;
		bMsg1236 : BOOL;
		bMsg1237 : BOOL;
		bMsg1238 : BOOL;
		bMsg1239 : BOOL;
		bMsg2001 : BOOL;
		bMsg2002 : BOOL;
		bMsg2003 : BOOL;
		bMsg2004 : BOOL;
		bMsg2005 : BOOL;
		bMsg2006 : BOOL;
		bMsg2007 : BOOL;
		bMsg2008 : BOOL;
		bMsg2009 : BOOL;
		bMsg2010 : BOOL;
		bMsg2011 : BOOL;
		bMsg2012 : BOOL;
		bMsg2013 : BOOL;
		bMsg2014 : BOOL;
		bMsg2015 : BOOL;
		bMsg2016 : BOOL;
		bMsg2017 : BOOL;
		bMsg2018 : BOOL;
		bMsg2019 : BOOL;
		bMsg2020 : BOOL;
		bMsg2021 : BOOL;
		bMsg2022 : BOOL;
		bMsg2023 : BOOL;
		bMsg2024 : BOOL;
		bMsg2025 : BOOL;
		bMsg2026 : BOOL;
		bMsg2027 : BOOL;
		bMsg2028 : BOOL;
		bMsg2029 : BOOL;
		bMsg2030 : BOOL;
		bMsg2031 : BOOL;
		bMsg2032 : BOOL;
		bMsg2033 : BOOL;
		bMsg2034 : BOOL;
		bMsg2035 : BOOL;
		bMsg2036 : BOOL;
		bMsg2037 : BOOL;
		bMsg2038 : BOOL;
		bMsg2039 : BOOL;
		bMsg2040 : BOOL;
		bMsg2041 : BOOL;
		bMsg2042 : BOOL;
		bMsg2043 : BOOL;
		bMsg2044 : BOOL;
		bMsg2045 : BOOL;
		bMsg2046 : BOOL;
		bMsg2047 : BOOL;
		bMsg2048 : BOOL;
		bMsg2049 : BOOL;
		bMsg2050 : BOOL;
		bMsg2051 : BOOL;
		bMsg2052 : BOOL;
		bMsg2053 : BOOL;
		bMsg2054 : BOOL;
		bMsg2055 : BOOL;
		bMsg2056 : BOOL;
		bMsg2057 : BOOL;
		bMsg2058 : BOOL;
		bMsg2059 : BOOL;
		bMsg2060 : BOOL;
		bMsg2061 : BOOL;
		bMsg2062 : BOOL;
		bMsg2063 : BOOL;
		bMsg2064 : BOOL;
		bMsg2065 : BOOL;
		bMsg2066 : BOOL;
		bMsg2067 : BOOL;
		bMsg2068 : BOOL;
		bMsg2069 : BOOL;
		bMsg2070 : BOOL;
		bMsg2071 : BOOL;
		bMsg2072 : BOOL;
		bMsg2073 : BOOL;
		bMsg2074 : BOOL;
		bMsg2075 : BOOL;
		bMsg2076 : BOOL;
		bMsg2077 : BOOL;
		bMsg2078 : BOOL;
		bMsg2079 : BOOL;
		bMsg2080 : BOOL;
		bMsg2081 : BOOL;
		bMsg2082 : BOOL;
		bMsg2083 : BOOL;
		bMsg2084 : BOOL;
		bMsg2085 : BOOL;
		bMsg2086 : BOOL;
		bMsg2087 : BOOL;
		bMsg2088 : BOOL;
		bMsg2089 : BOOL;
		bMsg2090 : BOOL;
		bMsg2091 : BOOL;
		bMsg2092 : BOOL;
		bMsg2093 : BOOL;
		bMsg2094 : BOOL;
		bMsg2095 : BOOL;
		bMsg2096 : BOOL;
		bMsg2097 : BOOL;
		bMsg2098 : BOOL;
		bMsg2099 : BOOL;
		bMsg2100 : BOOL;
		bMsg2101 : BOOL;
		bMsg2102 : BOOL;
		bMsg2103 : BOOL;
		bMsg2104 : BOOL;
		bMsg2105 : BOOL;
		bMsg2106 : BOOL;
		bMsg2107 : BOOL;
		bMsg2108 : BOOL;
		bMsg2109 : BOOL;
		bMsg2110 : BOOL;
		bMsg2111 : BOOL;
		bMsg2112 : BOOL;
		bMsg2113 : BOOL;
		bMsg2114 : BOOL;
		bMsg2115 : BOOL;
		bMsg2116 : BOOL;
		bMsg2117 : BOOL;
		bMsg2118 : BOOL;
		bMsg2119 : BOOL;
		bMsg2120 : BOOL;
		bMsg2139 : BOOL;
		bMsg2156 : BOOL;
		bMsg2157 : BOOL;
		bMsg2202 : BOOL;
		bMsg2203 : BOOL;
		bMsg2204 : BOOL;
		bMsg2205 : BOOL;
		bMsg2206 : BOOL;
		bMsg2207 : BOOL;
		bMsg2208 : BOOL;
		bMsg2209 : BOOL;
		bMsg2210 : BOOL;
		bMsg2211 : BOOL;
		bMsg2212 : BOOL;
		bMsg2213 : BOOL;
		bMsg2214 : BOOL;
		bMsg2215 : BOOL;
		bMsg2216 : BOOL;
		bMsg2217 : BOOL;
		bMsg2218 : BOOL;
		bMsg2219 : BOOL;
		bMsg2220 : BOOL;
		bMsg2221 : BOOL;
		bMsg2222 : BOOL;
		bMsg2223 : BOOL;
		bMsg2224 : BOOL;
		bMsg2225 : BOOL;
		bMsg2226 : BOOL;
		bMsg2227 : BOOL;
		bMsg2228 : BOOL;
		bMsg2229 : BOOL;
		bMsg2230 : BOOL;
		bMsg2231 : BOOL;
		bMsg2232 : BOOL;
		bMsg2233 : BOOL;
		bMsg2234 : BOOL;
		bMsg2235 : BOOL;
		bMsg2236 : BOOL;
		bMsg2237 : BOOL;
		bMsg2238 : BOOL;
		bMsg2239 : BOOL;
		bMsg2240 : BOOL;
		bMsg2241 : BOOL;
		bMsg2242 : BOOL;
		bMsg2243 : BOOL;
		bMsg2244 : BOOL;
		bMsg2245 : BOOL;
		bMsg2246 : BOOL;
		bMsg2247 : BOOL;
		bMsg2248 : BOOL;
		bMsg2249 : BOOL;
		bMsg2250 : BOOL;
		bMsg2251 : BOOL;
		bMsg2252 : BOOL;
		bMsg2253 : BOOL;
		bMsg2254 : BOOL;
		bMsg2255 : BOOL;
		bMsg2256 : BOOL;
		bMsg2257 : BOOL;
		bMsg2258 : BOOL;
		bMsg2259 : BOOL;
		bMsg2266 : BOOL;
		bMsg2267 : BOOL;
		bMsg2268 : BOOL;
		bMsg2269 : BOOL;
		bMsg2270 : BOOL;
		bMsg2277 : BOOL;
		bMsg2285 : BOOL;
		bMsg2286 : BOOL;
		bMsg2291 : BOOL;
		bMsg2292 : BOOL;
		bMsg2295 : BOOL;
		bMsg2296 : BOOL;
		bMsg2501 : BOOL;
		bMsg2502 : BOOL;
		bMsg2503 : BOOL;
		bMsg2504 : BOOL;
		bMsg2505 : BOOL;
		bMsg2506 : BOOL; (*retired, not used anymore- Generator Lube Oil System*)
		bMsg2507 : BOOL; (*retired, not used anymore- Generator Lube Oil System*)
		bMsg2508 : BOOL;
		bMsg2509 : BOOL; (*retired, not used anymore*)
		bMsg2514 : BOOL;
		bMsg2515 : BOOL;
		bMsg2516 : BOOL;
		bMsg2517 : BOOL;
		bMsg2518 : BOOL;
		bMsg2519 : BOOL;
		bMsg2520 : BOOL;
		bMsg2521 : BOOL;
		bMsg2522 : BOOL;
		bMsg2523 : BOOL;
		bMsg2524 : BOOL;
		bMsg2525 : BOOL;
		bMsg2526 : BOOL;
		bMsg2527 : BOOL;
		bMsg2528 : BOOL;
		bMsg2529 : BOOL;
		bMsg2530 : BOOL;
		bMsg2531 : BOOL;
		bMsg2532 : BOOL;
		bMsg2533 : BOOL;
		bMsg2534 : BOOL;
		bMsg2535 : BOOL;
		bMsg2536 : BOOL;
		bMsg2537 : BOOL;
		bMsg2538 : BOOL;
		bMsg2539 : BOOL;
		bMsg2540 : BOOL;
		bMsg2541 : BOOL;
		bMsg2542 : BOOL;
		bMsg2543 : BOOL;
		bMsg2544 : BOOL;
		bMsg2545 : BOOL;
		bMsg2546 : BOOL;
		bMsg2547 : BOOL;
		bMsg2548 : BOOL;
		bMsg2549 : BOOL;
		bMsg2550 : BOOL;
		bMsg2551 : BOOL;
		bMsg2552 : BOOL;
		bMsg2553 : BOOL;
		bMsg2554 : BOOL;
		bMsg2555 : BOOL;
		bMsg2556 : BOOL;
		bMsg2557 : BOOL;
		bMsg2558 : BOOL;
		bMsg2559 : BOOL;
		bMsg2560 : BOOL;
		bMsg2561 : BOOL;
		bMsg2562 : BOOL;
		bMsg2563 : BOOL;
		bMsg2564 : BOOL;
		bMsg2565 : BOOL;
		bMsg2566 : BOOL;
		bMsg2567 : BOOL;
		bMsg2568 : BOOL;
		bMsg2569 : BOOL;
		bMsg2570 : BOOL;
		bMsg2571 : BOOL;
		bMsg2572 : BOOL;
		bMsg2573 : BOOL;
		bMsg2574 : BOOL;
		bMsg2575 : BOOL;
		bMsg2576 : BOOL;
		bMsg2577 : BOOL;
		bMsg2578 : BOOL;
		bMsg2579 : BOOL;
		bMsg2580 : BOOL;
		bMsg2581 : BOOL;
		bMsg2582 : BOOL;
		bMsg2583 : BOOL;
		bMsg2584 : BOOL;
		bMsg2585 : BOOL;
		bMsg2586 : BOOL;
		bMsg2587 : BOOL;
		bMsg2588 : BOOL;
		bMsg2589 : BOOL;
		bMsg2590 : BOOL;
		bMsg2591 : BOOL;
		bMsg2592 : BOOL;
		bMsg2593 : BOOL; (*retired, not used anymore*)
		bMsg2594 : BOOL;
		bMsg2595 : BOOL;
		bMsg2596 : BOOL;
		bMsg2597 : BOOL;
		bMsg2598 : BOOL;
		bMsg2599 : BOOL;
		bMsg2600 : BOOL;
		bMsg2601 : BOOL;
		bMsg2602 : BOOL;
		bMsg2603 : BOOL;
		bMsg2604 : BOOL;
		bMsg2605 : BOOL;
		bMsg2606 : BOOL;
		bMsg2607 : BOOL;
		bMsg2608 : BOOL;
		bMsg2609 : BOOL;
		bMsg2610 : BOOL;
		bMsg2611 : BOOL;
		bMsg2612 : BOOL;
		bMsg2613 : BOOL;
		bMsg2614 : BOOL;
		bMsg2615 : BOOL;
		bMsg2616 : BOOL;
		bMsg2617 : BOOL;
		bMsg2618 : BOOL;
		bMsg2619 : BOOL;
		bMsg2620 : BOOL;
		bMsg2621 : BOOL;
		bMsg2622 : BOOL;
		bMsg2623 : BOOL;
		bMsg2624 : BOOL;
		bMsg2625 : BOOL;
		bMsg2626 : BOOL;
		bMsg2627 : BOOL;
		bMsg2628 : BOOL;
		bMsg2629 : BOOL;
		bMsg2630 : BOOL;
		bMsg2631 : BOOL;
		bMsg2632 : BOOL;
		bMsg2633 : BOOL;
		bMsg2634 : BOOL;
		bMsg2635 : BOOL;
		bMsg2636 : BOOL;
		bMsg2637 : BOOL;
		bMsg2638 : BOOL;
		bMsg2639 : BOOL;
		bMsg2640 : BOOL;
		bMsg2641 : BOOL;
		bMsg2642 : BOOL;
		bMsg2643 : BOOL;
		bMsg2644 : BOOL;
		bMsg2645 : BOOL;
		bMsg2646 : BOOL;
		bMsg2647 : BOOL;
		bMsg2648 : BOOL;
		bMsg2649 : BOOL;
		bMsg2650 : BOOL;
		bMsg2651 : BOOL;
		bMsg2652 : BOOL;
		bMsg2653 : BOOL;
		bMsg2654 : BOOL;
		bMsg2655 : BOOL;
		bMsg2656 : BOOL;
		bMsg2657 : BOOL;
		bMsg2658 : BOOL;
		bMsg2659 : BOOL;
		bMsg2660 : BOOL;
		bMsg2661 : BOOL;
		bMsg2662 : BOOL;
		bMsg2663 : BOOL;
		bMsg2664 : BOOL;
		bMsg2665 : BOOL;
		bMsg2666 : BOOL;
		bMsg2689 : BOOL;
		bMsg2667 : BOOL;
		bMsg2675 : BOOL;
		bMsg2676 : BOOL;
		bMsg2677 : BOOL;
		bMsg2678 : BOOL;
		bMsg2679 : BOOL;
		bMsg2680 : BOOL;
		bMsg2681 : BOOL;
		bMsg2682 : BOOL;
		bMsg2683 : BOOL;
		bMsg2684 : BOOL;
		bMsg2685 : BOOL;
		bMsg2686 : BOOL;
		bMsg2687 : BOOL;
		bMsg2688 : BOOL; (*Generator current at synchronization too high*) (*OldName:newPv;Cycle:5*)
		bMsg2700 : BOOL;
		bMsg2754 : BOOL;
		bMsg2755 : BOOL;
		bMsg2756 : BOOL;
		bMsg2757 : BOOL;
		bMsg2758 : BOOL;
		bMsg2759 : BOOL;
		bMsg2760 : BOOL;
		bMsg2761 : BOOL;
		bMsg2762 : BOOL;
		bMsg2763 : BOOL;
		bMsg2770 : BOOL;
		bMsg2771 : BOOL;
		bMsg2772 : BOOL;
		bMsg2773 : BOOL;
		bMsg2774 : BOOL;
		bMsg2775 : BOOL;
		bMsg2776 : BOOL;
		bMsg2777 : BOOL;
		bMsg2778 : BOOL;
		bMsg2781 : BOOL;
		bMsg2782 : BOOL;
		bMsg2783 : BOOL;
		bMsg2784 : BOOL;
		bMsg2785 : BOOL;
		bMsg2786 : BOOL;
		bMsg2787 : BOOL;
		bMsg2788 : BOOL;
		bMsg2789 : BOOL;
		bMsg2790 : BOOL;
		bMsg2791 : BOOL;
		bMsg2792 : BOOL;
		bMsg2793 : BOOL;
		bMsg2794 : BOOL;
		bMsg2795 : BOOL;
		bMsg2796 : BOOL;
		bMsg2797 : BOOL;
		bMsg2798 : BOOL;
		bMsg2804 : BOOL;
		bMsg2805 : BOOL;
		bMsg2806 : BOOL;
		bMsg2807 : BOOL;
		bMsg2809 : BOOL;
		bMsg2810 : BOOL;
		bMsg2821 : BOOL;
		bMsg2827 : BOOL;
		bMsg2828 : BOOL;
		bMsg2829 : BOOL;
		bMsg2830 : BOOL;
		bMsg2875 : BOOL; (*Caution: source module changed to OpState from V4.4*)
		bMsg2901 : BOOL;
		bMsg2902 : BOOL;
		bMsg2903 : BOOL;
		bMsg3001 : BOOL;
		bMsg3002 : BOOL;
		bMsg3003 : BOOL;
		bMsg3004 : BOOL;
		bMsg3005 : BOOL;
		bMsg3006 : BOOL;
		bMsg3007 : BOOL;
		bMsg3008 : BOOL;
		bMsg3009 : BOOL;
		bMsg3010 : BOOL;
		bMsg3011 : BOOL;
		bMsg3012 : BOOL;
		bMsg3013 : BOOL;
		bMsg3014 : BOOL;
		bMsg3015 : BOOL;
		bMsg3016 : BOOL;
		bMsg3017 : BOOL;
		bMsg3018 : BOOL;
		bMsg3019 : BOOL;
		bMsg3020 : BOOL;
		bMsg3021 : BOOL;
		bMsg3022 : BOOL;
		bMsg3023 : BOOL;
		bMsg3024 : BOOL;
		bMsg3025 : BOOL;
		bMsg3026 : BOOL;
		bMsg3027 : BOOL;
		bMsg3028 : BOOL;
		bMsg3029 : BOOL;
		bMsg3030 : BOOL;
		bMsg3031 : BOOL;
		bMsg3032 : BOOL;
		bMsg3033 : BOOL;
		bMsg3034 : BOOL;
		bMsg3035 : BOOL;
		bMsg3036 : BOOL;
		bMsg3037 : BOOL;
		bMsg3038 : BOOL;
		bMsg3039 : BOOL;
		bMsg3040 : BOOL;
		bMsg3041 : BOOL;
		bMsg3042 : BOOL;
		bMsg3043 : BOOL;
		bMsg3044 : BOOL;
		bMsg3045 : BOOL;
		bMsg3046 : BOOL;
		bMsg3047 : BOOL;
		bMsg3048 : BOOL;
		bMsg3049 : BOOL;
		bMsg3050 : BOOL;
		bMsg3051 : BOOL;
		bMsg3052 : BOOL;
		bMsg3053 : BOOL;
		bMsg3054 : BOOL;
		bMsg3055 : BOOL;
		bMsg3056 : BOOL;
		bMsg3057 : BOOL;
		bMsg3058 : BOOL;
		bMsg3059 : BOOL;
		bMsg3060 : BOOL;
		bMsg3061 : BOOL;
		bMsg3062 : BOOL;
		bMsg3063 : BOOL;
		bMsg3064 : BOOL;
		bMsg3065 : BOOL;
		bMsg3066 : BOOL;
		bMsg3067 : BOOL;
		bMsg3068 : BOOL;
		bMsg3069 : BOOL;
		bMsg3070 : BOOL;
		bMsg3071 : BOOL;
		bMsg3072 : BOOL;
		bMsg3073 : BOOL;
		bMsg3074 : BOOL;
		bMsg3075 : BOOL;
		bMsg3076 : BOOL;
		bMsg3077 : BOOL;
		bMsg3078 : BOOL;
		bMsg3079 : BOOL;
		bMsg3080 : BOOL;
		bMsg3081 : BOOL;
		bMsg3082 : BOOL;
		bMsg3083 : BOOL;
		bMsg3084 : BOOL;
		bMsg3085 : BOOL;
		bMsg3086 : BOOL;
		bMsg3087 : BOOL;
		bMsg3088 : BOOL;
		bMsg3089 : BOOL;
		bMsg3090 : BOOL;
		bMsg3091 : BOOL;
		bMsg3092 : BOOL;
		bMsg3093 : BOOL;
		bMsg3094 : BOOL;
		bMsg3095 : BOOL;
		bMsg3096 : BOOL;
		bMsg3097 : BOOL;
		bMsg3098 : BOOL;
		bMsg3099 : BOOL;
		bMsg3100 : BOOL;
		bMsg3101 : BOOL;
		bMsg3102 : BOOL;
		bMsg3103 : BOOL;
		bMsg3104 : BOOL;
		bMsg3105 : BOOL;
		bMsg3106 : BOOL;
		bMsg3107 : BOOL;
		bMsg3108 : BOOL;
		bMsg3109 : BOOL;
		bMsg3110 : BOOL;
		bMsg3111 : BOOL;
		bMsg3112 : BOOL;
		bMsg3113 : BOOL;
		bMsg3114 : BOOL;
		bMsg3115 : BOOL;
		bMsg3116 : BOOL;
		bMsg3117 : BOOL;
		bMsg3118 : BOOL;
		bMsg3119 : BOOL;
		bMsg3120 : BOOL;
		bMsg3121 : BOOL;
		bMsg3122 : BOOL;
		bMsg3123 : BOOL;
		bMsg3124 : BOOL;
		bMsg3125 : BOOL;
		bMsg3126 : BOOL;
		bMsg3127 : BOOL;
		bMsg3128 : BOOL;
		bMsg3129 : BOOL;
		bMsg3130 : BOOL;
		bMsg3131 : BOOL;
		bMsg3132 : BOOL;
		bMsg3133 : BOOL;
		bMsg3134 : BOOL;
		bMsg3135 : BOOL;
		bMsg3136 : BOOL;
		bMsg3137 : BOOL;
		bMsg3138 : BOOL;
		bMsg3139 : BOOL;
		bMsg3140 : BOOL;
		bMsg3141 : BOOL;
		bMsg3142 : BOOL;
		bMsg3143 : BOOL;
		bMsg3144 : BOOL;
		bMsg3145 : BOOL;
		bMsg3146 : BOOL;
		bMsg3147 : BOOL;
		bMsg3148 : BOOL;
		bMsg3149 : BOOL;
		bMsg3150 : BOOL;
		bMsg3151 : BOOL;
		bMsg3152 : BOOL;
		bMsg3153 : BOOL;
		bMsg3154 : BOOL;
		bMsg3155 : BOOL;
		bMsg3156 : BOOL;
		bMsg3157 : BOOL;
		bMsg3158 : BOOL;
		bMsg3159 : BOOL;
		bMsg3160 : BOOL;
		bMsg3161 : BOOL;
		bMsg3162 : BOOL;
		bMsg3163 : BOOL;
		bMsg3164 : BOOL;
		bMsg3165 : BOOL;
		bMsg3166 : BOOL;
		bMsg3167 : BOOL;
		bMsg3168 : BOOL;
		bMsg3169 : BOOL;
		bMsg3170 : BOOL;
		bMsg3171 : BOOL;
		bMsg3172 : BOOL;
		bMsg3173 : BOOL;
		bMsg3174 : BOOL;
		bMsg3175 : BOOL;
		bMsg3176 : BOOL;
		bMsg3177 : BOOL;
		bMsg3178 : BOOL;
		bMsg3179 : BOOL;
		bMsg3180 : BOOL;
		bMsg3181 : BOOL;
		bMsg3182 : BOOL;
		bMsg3183 : BOOL;
		bMsg3184 : BOOL;
		bMsg3185 : BOOL;
		bMsg3186 : BOOL;
		bMsg3187 : BOOL;
		bMsg3188 : BOOL;
		bMsg3189 : BOOL;
		bMsg3190 : BOOL;
		bMsg3191 : BOOL;
		bMsg3192 : BOOL;
		bMsg3193 : BOOL;
		bMsg3194 : BOOL;
		bMsg3195 : BOOL;
		bMsg3196 : BOOL;
		bMsg3197 : BOOL;
		bMsg3198 : BOOL;
		bMsg3199 : BOOL;
		bMsg3200 : BOOL;
		bMsg3201 : BOOL;
		bMsg3202 : BOOL;
		bMsg3203 : BOOL;
		bMsg3204 : BOOL;
		bMsg3205 : BOOL;
		bMsg3206 : BOOL;
		bMsg3207 : BOOL;
		bMsg3208 : BOOL;
		bMsg3209 : BOOL;
		bMsg3210 : BOOL;
		bMsg3211 : BOOL;
		bMsg3212 : BOOL;
		bMsg3213 : BOOL;
		bMsg3214 : BOOL;
		bMsg3215 : BOOL;
		bMsg3216 : BOOL;
		bMsg3217 : BOOL;
		bMsg3218 : BOOL;
		bMsg3219 : BOOL;
		bMsg3220 : BOOL;
		bMsg3221 : BOOL;
		bMsg3222 : BOOL;
		bMsg3223 : BOOL;
		bMsg3224 : BOOL;
		bMsg3253 : BOOL;
		bMsg3254 : BOOL;
		bMsg3263 : BOOL;
		bMsg3264 : BOOL;
		bMsg3265 : BOOL;
		bMsg3266 : BOOL;
		bMsg3267 : BOOL;
		bMsg3298 : BOOL;
		bMsg3299 : BOOL;
		bMsg3300 : BOOL;
		bMsg3301 : BOOL;
		bMsg3302 : BOOL;
		bMsg3303 : BOOL;
		bMsg3304 : BOOL;
		bMsg3305 : BOOL;
		bMsg3306 : BOOL;
		bMsg3307 : BOOL;
		bMsg3308 : BOOL;
		bMsg3309 : BOOL;
		bMsg3310 : BOOL;
		bMsg3311 : BOOL;
		bMsg3312 : BOOL;
		bMsg3313 : BOOL;
		bMsg3314 : BOOL;
		bMsg3315 : BOOL;
		bMsg3316 : BOOL;
		bMsg3317 : BOOL;
		bMsg3318 : BOOL;
		bMsg3319 : BOOL;
		bMsg3320 : BOOL;
		bMsg3321 : BOOL;
		bMsg3322 : BOOL;
		bMsg3323 : BOOL;
		bMsg3324 : BOOL;
		bMsg3325 : BOOL;
		bMsg3326 : BOOL;
		bMsg3327 : BOOL;
		bMsg3328 : BOOL;
		bMsg3329 : BOOL;
		bMsg3330 : BOOL;
		bMsg3331 : BOOL;
		bMsg3332 : BOOL;
		bMsg3333 : BOOL;
		bMsg3334 : BOOL;
		bMsg3335 : BOOL;
		bMsg3336 : BOOL;
		bMsg3337 : BOOL;
		bMsg3338 : BOOL;
		bMsg3339 : BOOL;
		bMsg3340 : BOOL;
		bMsg3341 : BOOL;
		bMsg3342 : BOOL;
		bMsg3343 : BOOL;
		bMsg3344 : BOOL;
		bMsg3345 : BOOL;
		bMsg3346 : BOOL;
		bMsg3347 : BOOL;
		bMsg3348 : BOOL;
		bMsg3349 : BOOL;
		bMsg3350 : BOOL;
		bMsg3351 : BOOL;
		bMsg3352 : BOOL;
		bMsg3353 : BOOL;
		bMsg3354 : BOOL;
		bMsg3355 : BOOL;
		bMsg3356 : BOOL;
		bMsg3357 : BOOL;
		bMsg3358 : BOOL;
		bMsg3359 : BOOL;
		bMsg3360 : BOOL;
		bMsg3361 : BOOL;
		bMsg3362 : BOOL;
		bMsg3363 : BOOL;
		bMsg3364 : BOOL;
		bMsg3365 : BOOL;
		bMsg3366 : BOOL;
		bMsg3367 : BOOL;
		bMsg3368 : BOOL;
		bMsg3369 : BOOL;
		bMsg3370 : BOOL;
		bMsg3371 : BOOL;
		bMsg3372 : BOOL;
		bMsg3373 : BOOL;
		bMsg3374 : BOOL;
		bMsg3375 : BOOL;
		bMsg3376 : BOOL;
		bMsg3377 : BOOL;
		bMsg3378 : BOOL;
		bMsg3379 : BOOL;
		bMsg3380 : BOOL;
		bMsg3381 : BOOL;
		bMsg3382 : BOOL;
		bMsg3383 : BOOL;
		bMsg3384 : BOOL;
		bMsg3385 : BOOL;
		bMsg3386 : BOOL;
		bMsg3387 : BOOL;
		bMsg3388 : BOOL;
		bMsg3389 : BOOL;
		bMsg3390 : BOOL;
		bMsg3391 : BOOL;
		bMsg3392 : BOOL;
		bMsg3393 : BOOL;
		bMsg3394 : BOOL;
		bMsg3395 : BOOL;
		bMsg3396 : BOOL;
		bMsg3400 : BOOL;
		bMsg3401 : BOOL;
		bMsg3402 : BOOL;
		bMsg3403 : BOOL;
		bMsg3404 : BOOL;
		bMsg3405 : BOOL;
		bMsg3406 : BOOL;
		bMsg3407 : BOOL;
		bMsg3408 : BOOL;
		bMsg3409 : BOOL;
		bMsg3410 : BOOL;
		bMsg3411 : BOOL;
		bMsg3412 : BOOL;
		bMsg3413 : BOOL;
		bMsg3414 : BOOL;
		bMsg3415 : BOOL;
		bMsg3416 : BOOL;
		bMsg3417 : BOOL;
		bMsg3418 : BOOL;
		bMsg3419 : BOOL;
		bMsg3420 : BOOL;
		bMsg3421 : BOOL;
		bMsg3422 : BOOL;
		bMsg3423 : BOOL;
		bMsg3424 : BOOL;
		bMsg3425 : BOOL;
		bMsg3426 : BOOL;
		bMsg3427 : BOOL;
		bMsg3428 : BOOL;
		bMsg3429 : BOOL;
		bMsg3430 : BOOL;
		bMsg3431 : BOOL;
		bMsg3432 : BOOL;
		bMsg3433 : BOOL;
		bMsg3434 : BOOL;
		bMsg3435 : BOOL;
		bMsg3436 : BOOL;
		bMsg3437 : BOOL;
		bMsg3438 : BOOL;
		bMsg3439 : BOOL;
		bMsg3440 : BOOL;
		bMsg3441 : BOOL;
		bMsg3442 : BOOL;
		bMsg3443 : BOOL;
		bMsg3444 : BOOL;
		bMsg3445 : BOOL;
		bMsg3446 : BOOL;
		bMsg3447 : BOOL;
		bMsg3448 : BOOL;
		bMsg3449 : BOOL;
		bMsg3450 : BOOL;
		bMsg3451 : BOOL;
		bMsg3452 : BOOL;
		bMsg3453 : BOOL;
		bMsg3454 : BOOL;
		bMsg3455 : BOOL;
		bMsg3456 : BOOL;
		bMsg3457 : BOOL;
		bMsg3458 : BOOL;
		bMsg3459 : BOOL;
		bMsg3460 : BOOL;
		bMsg3461 : BOOL;
		bMsg3462 : BOOL;
		bMsg3463 : BOOL;
		bMsg3464 : BOOL;
		bMsg3465 : BOOL;
		bMsg3466 : BOOL;
		bMsg3467 : BOOL;
		bMsg3468 : BOOL;
		bMsg3469 : BOOL;
		bMsg3470 : BOOL;
		bMsg3471 : BOOL;
		bMsg3472 : BOOL;
		bMsg3473 : BOOL;
		bMsg3474 : BOOL;
		bMsg3475 : BOOL;
		bMsg3476 : BOOL;
		bMsg3477 : BOOL;
		bMsg3478 : BOOL;
		bMsg3479 : BOOL;
		bMsg3480 : BOOL;
		bMsg3481 : BOOL;
		bMsg3482 : BOOL;
		bMsg3483 : BOOL;
		bMsg3484 : BOOL;
		bMsg3485 : BOOL;
		bMsg3486 : BOOL;
		bMsg3487 : BOOL;
		bMsg3488 : BOOL;
		bMsg3489 : BOOL;
		bMsg3490 : BOOL;
		bMsg3491 : BOOL;
		bMsg3492 : BOOL;
		bMsg3493 : BOOL;
		bMsg3494 : BOOL;
		bMsg3495 : BOOL;
		bMsg3496 : BOOL;
		bMsg3497 : BOOL;
		bMsg3498 : BOOL;
		bMsg3499 : BOOL;
		bMsg3500 : BOOL;
		bMsg3501 : BOOL;
		bMsg3502 : BOOL;
		bMsg3503 : BOOL;
		bMsg3504 : BOOL;
		bMsg3505 : BOOL;
		bMsg3506 : BOOL;
		bMsg3507 : BOOL;
		bMsg3508 : BOOL;
		bMsg3509 : BOOL;
		bMsg3510 : BOOL;
		bMsg3511 : BOOL;
		bMsg3512 : BOOL;
		bMsg3513 : BOOL;
		bMsg3514 : BOOL;
		bMsg3515 : BOOL;
		bMsg3516 : BOOL;
		bMsg3517 : BOOL;
		bMsg3518 : BOOL;
		bMsg3519 : BOOL;
		bMsg3520 : BOOL;
		bMsg3521 : BOOL;
		bMsg3522 : BOOL;
		bMsg3523 : BOOL;
		bMsg3524 : BOOL;
		bMsg3525 : BOOL;
		bMsg3526 : BOOL;
		bMsg3527 : BOOL;
		bMsg3528 : BOOL;
		bMsg3529 : BOOL;
		bMsg3530 : BOOL;
		bMsg3531 : BOOL;
		bMsg3532 : BOOL;
		bMsg3533 : BOOL;
		bMsg3534 : BOOL;
		bMsg3535 : BOOL;
		bMsg3536 : BOOL;
		bMsg3537 : BOOL;
		bMsg3538 : BOOL;
		bMsg3539 : BOOL;
		bMsg3540 : BOOL;
		bMsg3541 : BOOL;
		bMsg3542 : BOOL;
		bMsg3543 : BOOL;
		bMsg3544 : BOOL;
		bMsg3545 : BOOL;
		bMsg3546 : BOOL;
		bMsg3547 : BOOL;
		bMsg3548 : BOOL;
		bMsg3549 : BOOL;
		bMsg3550 : BOOL;
		bMsg3551 : BOOL;
		bMsg3552 : BOOL;
		bMsg3553 : BOOL;
		bMsg3554 : BOOL;
		bMsg3555 : BOOL;
		bMsg3556 : BOOL;
		bMsg3557 : BOOL;
		bMsg3558 : BOOL;
		bMsg3559 : BOOL;
		bMsg3560 : BOOL;
		bMsg3561 : BOOL;
		bMsg3562 : BOOL;
		bMsg3563 : BOOL;
		bMsg3564 : BOOL;
		bMsg3565 : BOOL;
		bMsg3566 : BOOL;
		bMsg3567 : BOOL;
		bMsg3568 : BOOL;
		bMsg3569 : BOOL;
		bMsg3570 : BOOL;
		bMsg3571 : BOOL;
		bMsg3572 : BOOL;
		bMsg3573 : BOOL;
		bMsg3574 : BOOL;
		bMsg3575 : BOOL;
		bMsg3576 : BOOL;
		bMsg3580 : BOOL;
		bMsg3581 : BOOL;
		bMsg3582 : BOOL;
		iIPC_Hardware_Variant : DINT;
		szPB1_DeviceName : STRING[40]; (*Device adress from I/O Module Profibus slave 1*)
		szPB2_DeviceName : STRING[40]; (*Device adress from I/O Module Profibus slave 1*)
		szPN_DeviceName : STRING[40]; (*Device adress from I/O Module Profinet*)
		szMBRTU_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus RTU*)
		szMBTCP_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*)
		bSimWinMOD_Active : BOOL; (*WinMode simulation active *) (*OldName:new PV; Cycle:5*)
		bSimWinMOD_withoutBus_Active : BOOL; (*WinMode simulation without Bus Hardware active *) (*OldName:new PV; Cycle:5*)
		rCustomizedCP : ARRAY[0..99]OF REAL; (*optional prepared customizable interface - BETA PHASE, use only in coordination with TPSS*)
		iMBM_FieldDevice1_Send : ARRAY[0..MODBUS_RTU_MASTER_MAX_ARRAY]OF UINT; (*Send data field device 1*)
		iModbus_SCR : ARRAY[0..MODBUS_RTU_MASTER_MAX_ARRAY]OF UINT; (*Send data field device SCR *)
		rCust_SparePara : ARRAY[0..200]OF REAL; (*SPS_REZP1 to SPS_REZP200*) (*OldName:SPS_REZP1, SPS_REZP2, SPS_REZP70; Cycle: 5;*)
		szMBTCP1_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*)
		szMBTCP2_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP*) (* OldName:new PV; Cycle:8*)
		szMBTCP3_DeviceName : STRING[40]; (*Device adress from I/O Module Modbus TCP *) (* OldName:new PV; Cycle:8*)
		bBus_Dem_OpcUa : BOOL; (*Demand via OPC UA*) (*OldName:BUS_ANF; Cycle:5;*)
		bBusPulse_OpcUa : BOOL; (*Pulse signal from customer via OPC UA*) (*OldName:newPV; Cycle:5;*)
		rP_Set_OpcUa : REAL; (*Power setpoint from OPC UA [%]*)
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT  (*OPC variables from module to VIS*)
		bMsg1147 : BOOL; (*Message*) (*OldName: M_TAKTWA; Cycle:;*)
		bMsg1099 : BOOL; (*Message*) (*OldName: M_TAKTAB; Cycle:;*)
		bMsg1150 : BOOL; (*Message*) (*OldName: M_CP; Cycle:;*)
		bMsg1151 : BOOL; (*Message*) (*OldName: M_RK; Cycle:;*)
		iMsg1150 : INT; (*Message additional info*) (*OldName: usStatus_CP1_CP2; Cycle:;*)
		iMsg1151 : INT; (*Message additional info*) (*OldName: usStatus_RK1_RK2; Cycle:;*)
		bImpClock : BOOL; (*Clock signal for OPC*) (*OldName:; Cycle:;*)
		sBC_HW_Adr_Comm1 : ARRAY[0..9]OF STRING[40]; (*Bus diagnosis, hardware adress of coupling 1*)
		sBC_HW_Adr_Comm2 : ARRAY[0..9]OF STRING[40]; (*Bus diagnosis, hardware adress of coupling 2*)
		iBC_PB1_SlaveAdr : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB1_SlaveAdr_Status : UINT; (*Bus diagnosis Profibus*)
		iBC_PB2_SlaveAdr : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB2_SlaveAdr_Status : UINT; (*Bus diagnosis Profibus*)
		iBC_PB1_Open_Status : UINT; (*Bus diagnosis Profibus*)
		iBC_PB2_Open_Status : UINT; (*Bus diagnosis Profibus*)
		iBC_PB1_Comm_ChangeState : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB1_Comm_State : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB1_Comm_Error : UDINT; (*Bus diagnosis Profibus*)
		iCnt_BC_PB1_Comm_Error : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB2_Comm_ChangeState : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB2_Comm_State : UDINT; (*Bus diagnosis Profibus*)
		iBC_PB2_Comm_Error : UDINT; (*Bus diagnosis Profibus*)
		iCnt_BC_PB2_Comm_Error : UDINT; (*Bus diagnosis Profibus*)
		bBC_PB1_SlaveAdr : BOOL; (*Bus diagnosis Profibus*)
		bBC_PB2_SlaveAdr : BOOL; (*Bus diagnosis Profibus*)
		bBC_PB1_Open : BOOL; (*Bus diagnosis Profibus*)
		bBC_PB2_Open : BOOL; (*Bus diagnosis Profibus*)
		bBC_PN1_SlaveAdr : BOOL; (*Bus diagnosis Profinet*)
		sBC_PN1_SlaveAdr : STRING[30]; (*Bus diagnosis Profinet*)
		iBC_PN1_SlaveAdr_Status : UDINT; (*Bus diagnosis Profinet*)
		bBC_PN1_Open : BOOL; (*Bus diagnosis Profinet*)
		iBC_PN1_Open_Status : UDINT; (*Bus diagnosis Profinet*)
		iBC_PN1_Comm_ChangeState : UDINT; (*Bus diagnosis Profinet*)
		iBC_PN1_Comm_State : UDINT; (*Bus diagnosis Profinet*)
		iBC_PN1_Comm_Error : UDINT; (*Bus diagnosis Profinet*)
		iCnt_BC_PN1_Comm_Error : UDINT; (*Bus diagnosis Profinet*)
		bBC_MBRTU_Open : BOOL; (*Bus diagnosis Modbus RTU*)
		iBC_MBRTU_Open_Status : UINT; (*Bus diagnosis Modbus RTU*)
		iBC_MBRTU_SlaveID : USINT; (*Bus diagnosis Modbus RTU*)
		sBC_MBRTU_Comm_Para : STRING[50]; (*Bus diagnosis Modbus RTU*)
		iBC_MBRTU_Comm_Status : UINT; (*Bus diagnosis Modbus RTU*)
		iCnt_BC_MBRTU_SendRecv : UINT; (*Bus diagnosis Modbus RTU*)
		bBC_MBTCP_IPadr : BOOL; (*Bus diagnosis Modbus TCP*)
		bBC_MBTCP_SubMask : BOOL; (*Bus diagnosis Modbus TCP*)
		bBC_MBTCP_Open : BOOL; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_IPadr : STRING[20]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_IPadr_Status : UINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_SubMask : STRING[20]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_SubMask_Status : UINT; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Open_Status : UINT; (*Bus diagnosis Modbus TCP*)
		iNum_BC_MBTCP_Client : UINT; (*Bus diagnosis Modbus TCP*)
		iNum_BC_MBTCP_ClientServed : USINT; (*Bus diagnosis Modbus TCP*)
		tiBC_MBTCP_RecvElapsed : TIME; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_FunctionCode : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Slave_Debug : STRING[100]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Slave_Status : UINT; (*Bus diagnosis Modbus TCP*)
		iCnt_BC_MBTCP_Recv : UDINT; (*Bus diagnosis Modbus TCP*)
		iCnt_BC_MBTCP_Send : UDINT; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_PortOpenRetries : USINT; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_FuB_Step : UINT; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_FuB_Status : UINT; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Client1_Port : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client1_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client1_Msg : STRING[100]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Client2_Port : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client2_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client2_Msg : STRING[100]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Client3_Port : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client3_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client3_Msg : STRING[100]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Client4_Port : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client4_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client4_Msg : STRING[100]; (*Bus diagnosis Modbus TCP*)
		iBC_MBTCP_Client5_Port : USINT; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client5_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP*)
		sBC_MBTCP_Client5_Msg : STRING[100]; (*Bus diagnosis Modbus TCP*)
		bBC_MBTCP2_IPadr : BOOL; (*Bus diagnosis Modbus TCP2*)
		bBC_MBTCP2_SubMask : BOOL; (*Bus diagnosis Modbus TCP2*)
		bBC_MBTCP2_Open : BOOL; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_IPadr : STRING[20]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_IPadr_Status : UINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_SubMask : STRING[20]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_SubMask_Status : UINT; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Open_Status : UINT; (*Bus diagnosis Modbus TCP2*)
		iNum_BC_MBTCP2_Client : UINT; (*Bus diagnosis Modbus TCP2*)
		iNum_BC_MBTCP2_ClientServed : USINT; (*Bus diagnosis Modbus TCP2*)
		tiBC_MBTCP2_RecvElapsed : TIME; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_FunctionCode : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Slave_Debug : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Slave_Status : UINT; (*Bus diagnosis Modbus TCP2*)
		iCnt_BC_MBTCP2_Recv : UDINT; (*Bus diagnosis Modbus TCP2*)
		iCnt_BC_MBTCP2_Send : UDINT; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_PortOpenRetries : USINT; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_FuB_Step : UINT; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_FuB_Status : UINT; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Client1_Port : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client1_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client1_Msg : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Client2_Port : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client2_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client2_Msg : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Client3_Port : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client3_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client3_Msg : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Client4_Port : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client4_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client4_Msg : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		iBC_MBTCP2_Client5_Port : USINT; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client5_IPaddr : STRING[18]; (*Bus diagnosis Modbus TCP2*)
		sBC_MBTCP2_Client5_Msg : STRING[100]; (*Bus diagnosis Modbus TCP2*)
		tiBC_Test_Force_Remain : TIME; (*Bus test: Force remaining time*)
		iNumBC_Test_Recv_Reg : ARRAY[0..20]OF INT; (*Bus test *)
		iNumBC_Test_Send_Reg : ARRAY[0..20]OF INT; (*Bus test *)
		iNumBC_Test_Recv_Reg_Max : INT; (*Bus test *)
		iNumBC_Test_Send_Reg_Max : INT; (*Bus test *)
		iBC_Test_Recv_Reg_Min : INT; (*Bus test*)
		iBC_Test_Recv_Reg_Max : INT; (*Bus test*)
		iBC_Test_Send_Reg_Min : INT; (*Bus test*)
		iBC_Test_Send_Reg_Max : INT; (*Bus test*)
	END_STRUCT;
	OUT_CP_Struct : 	STRUCT 
		tCP2AB : MM2AmmBase; (*AMM structure*)
		tCP2PB : MM2ParaBase_type; (*Para structure*)
		InData1 : ARRAY[0..MAX_IN_DATA_ARRAY]OF INT; (*input data from master coupling 1*)
		InData2 : ARRAY[0..MAX_IN_DATA_ARRAY]OF INT; (*input data from master coupling 2*)
		bBus_Dem : BOOL; (*Demand fieldbus*) (*OldName:BUS_ANF; Cycle:5;*)
		rN_Set_ExtBus_Norm : REAL; (*external speed setpoint via bus related to rN_Nom*)
		bN_Set_ExtBus_Enable : BOOL; (*enable external speed setpoint via bus*)
		rP_Set_ExtBus_Norm : REAL; (*external power setpoint via bus related to rP_Nom*)
		bP_Set_ExtBus_Enable : BOOL; (*enable external power setpoint via bus*)
		rP_Red_ExtBus_Norm : REAL; (*power reduction by primary control related to rP_Nom [%]*) (*OldName: ssPowerRedZLT; Cyclic:5;*)
		iP_Set_Bus : INT; (*Power setpoint from Bus [%]*)
		rCustomizedCP : ARRAY[0..99]OF REAL; (*optional prepared customizable interface - BETA PHASE, use only in coordination with TPSS*)
		iMBM_FieldDevice1_Receive : ARRAY[0..MODBUS_RTU_MASTER_MAX_ARRAY]OF UINT; (*Receive data field device 1*)
		iModbus_SCR_UINT : ARRAY[0..MODBUS_RTU_MASTER_MAX_ARRAY]OF UINT; (*Receive data field device SCR*)
		iModbus_SCR_INT : ARRAY[0..MODBUS_RTU_MASTER_MAX_ARRAY]OF INT; (*Receive data field device SCR, INT register 73,74,75*)
		bFastStartReq_Bus : BOOL; (* TRUE = Command: get ready for fast start *)
		bVeryFastStartReq_Bus : BOOL; (* TRUE = Command: get ready for very fast start *)
		bBusPulse : BOOL; (*bus pulse signal from customer*) (*OldName:newPV; Cycle:5;*)
		bBus_failure : BOOL; (*Evaluation of toggle bit and creation of bus error*)
	END_STRUCT;
	PARA_CP_Struct : 	STRUCT 
		bTJ_Exist : BOOL; (*PARA [11400]: Gas metering with Tecjet enable *) (*OldName: 	bTecJetOn	; Cyclic: ; *)
		iNum_GM : INT; (*PARA [11357]: number of gasmixer*) (*OldName: AnzGasm; Cycle: 5;*)
		rPr_EngLubOilScalMax : REAL; (*PARA [11807]: Oil pressure scale maximum*) (*OldName: MBE_ODR; Cycle: 5;*)
		rPr_ECWScalMax : REAL; (*PARA [11806]: Pressure engine cooling water scale maximum*) (*OldName: MBE_KWD; Cycle: 5;*)
		iIdx_Comm1_Interface : INT; (*PARA [10177]: Coupling 1  Interface hardware*) (*OldName:ucKopl1Schnittstelle; Cycle: 5;*)
		iIdx_Comm1_type : INT; (*PARA [10178]: Type of coupling 0 = no link 1 = reserve 2 = Modbus RTU 3 = Modbus TCP 4 = Profibus DP 5 = Profibus DP (Old data register style) 6= Profinet*) (*OldName:ucKopl1Art; Cycle: 5;*)
		iIdx_Comm2_Interface : INT; (*PARA [10179]: Coupling 2 Interface hardware *) (*OldName:ucKopl2Schnittstelle; Cycle: 5;*)
		iIdx_Comm2_type : INT; (*PARA [10180]: Type of coupling 0 = no link 1 = reserve 2 = Modbus RTU 3 = Modbus TCP 4 = Profibus DP 5 = Profibus DP (Old data register style) 6= Profinet*) (*OldName:ucKopl2Art; Cycle: 5;*)
		bComm1_Ena : BOOL; (*PARA [10165]: link 1 release data receive enabled*) (*OldName:Kopl1Empf; Cycle: 5;*)
		bComm2_Ena : BOOL; (*PARA [10166]: link 2 release data receive enabled*) (*OldName:Kopl2Empf; Cycle: 5;*)
		iComm1_Baud : INT; (*PARA [10169]: Modbus RTU Baud rate*) (*OldName:usBaudMB[0]; Cycle: 5;*)
		iComm2_Baud : INT; (*PARA [10173]: Modbus RTU Baud rate*) (*OldName:usBaudMB[1]; Cycle: 5;*)
		iComm1_Parity : INT; (*PARA [10170]: Modbus RTU Parity*) (*OldName:ucParityMB[0]; Cycle: 5;*)
		iComm2_Parity : INT; (*PARA [10174]: Modbus RTU Parity*) (*OldName:ucParityMB[1]; Cycle: 5;*)
		iComm1_Stopbit : INT; (*PARA [10172]: Modbus RTU Stopbit *) (*OldName:ucStopbitMB[0]; Cycle: 5;*)
		iComm2_Stopbit : INT; (*PARA [10176]: Modbus RTU Stopbit *) (*OldName:ucStopbitMB[0]; Cycle: 5;*)
		iComm1_SlaveID : INT; (*PARA [10171]: Modbus RTU Slave ID*) (*OldName:ucMB_ID[0]; Cycle: 5;*)
		iComm2_SlaveID : INT; (*PARA [10175]: Modbus RTU Slave ID*) (*OldName:ucMB_ID[1]; Cycle: 5;*)
		iComm_SlaveID_TCP : INT; (*PARA [10168]: Modbus TCP Slave ID*) (*OldName: new PV; Cycle: 5;*)
		iComm_PortID_TCP : INT; (*PARA [10167]: Modbus TCP Slave ID*) (*OldName: new PV; Cycle: 5;*)
		bT_Gen_Wind_Ena : BOOL; (*PARA [11492]: winding temperature monitoring enabled*) (*Oldname:wick_a; Cycle:;*)
		iComm1_PN_SlaveID1 : INT; (*PARA [12335]: Profinet communication 1, slave 1 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm2_PN_SlaveID1 : INT; (*PARA [12336]: Profinet communication 2, slave 1 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm1_PB_SlaveID1 : INT; (*PARA [12306]: Profibus DP communication 1, slave 1 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm1_PB_SlaveID2 : INT; (*PARA [12307]: Profibus DP communication 1, slave 2 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm2_PB_SlaveID1 : INT; (*PARA [12308]: Profibus DP communication 2, slave 1 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm2_PB_SlaveID2 : INT; (*PARA [12309]: Profibus DP communication 2, slave 2 adress *) (*OldName: newPV; Cycle: 5;*)
		iComm_SubMask_first_TCP : INT; (*PARA [12302]: Modbus TCP Slave Subnet mask first place. 255.xxx.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_SubMask_second_TCP : INT; (*PARA [12303]: Modbus TCP Slave Subnet mask second place. xxx.255.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_SubMask_third_TCP : INT; (*PARA [12304]: Modbus TCP Slave Subnet mask third place. xxx.xxx.255.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_SubMask_fourth_TCP : INT; (*PARA [12305]: Modbus TCP Slave Subnet mask fourth place. xxx.xxx.xxx.0*) (*OldName: new PV; Cycle: 5;*)
		iComm_IPaddr_first_TCP : INT; (*PARA [12298]: Modbus TCP Slave IP adress first place. 192.xxx.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_IPaddr_second_TCP : INT; (*PARA [12299]: Modbus TCP Slave IP adress second place. xxx.168.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_IPaddr_third_TCP : INT; (*PARA [12300]: Modbus TCP Slave IP adress third place. xxx.xxx.75.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm_IPaddr_fourth_TCP : INT; (*PARA [12301]: Modbus TCP Slave IP adress fourth place. xxx.xxx.xxx.209*) (*OldName: new PV; Cycle: 5;*)
		bOPC_Rcv_Ena : BOOL; (*PARA [12872]: OPC receive enabled*) (*OldName:opc_rcv; Cycle: 5;*)
		bSCR_BUS_Exist : BOOL; (*PARA [13858]: SCR Bus connection exist*) (*OldName: new PV; Cycle: 5;*) (*V04.05.00.00*)
		iComm_MB_Factor : INT; (*PARA [14379]: Frequency of calling Modbus RTU and Modbus TCP slave*)
		bComm_MSB_LSB : BOOL; (*PARA [14378]: Byte transmission order. High/Low Byte*)
		tiBC_Test_Force : TIME; (*PARA [14377]: Bus test. Max. force time*)
		bComm_OpcUa_Active : BOOL; (*PARA [15018]: OPC UA customer communication active*)
		iComm2_SlaveID_TCP : INT; (*PARA [15026]: Modbus 2 TCP Slave ID*) (*OldName: new PV; Cycle: 5;*)
		iComm2_PortID_TCP : INT; (*PARA [15027]: Modbus 2 TCP Port ID*) (*OldName: new PV; Cycle: 5;*)
		iComm2_SubMask_first_TCP : INT; (*PARA [15032]: Modbus 2 TCP Slave Subnet mask first place. 255.xxx.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_SubMask_second_TCP : INT; (*PARA [15033]: Modbus 2 TCP Slave Subnet mask second place. xxx.255.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_SubMask_third_TCP : INT; (*PARA [15034]: Modbus 2 TCP Slave Subnet mask third place. xxx.xxx.255.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_SubMask_fourth_TCP : INT; (*PARA [15035]: Modbus 2 TCP Slave Subnet mask fourth place. xxx.xxx.xxx.0*) (*OldName: new PV; Cycle: 5;*)
		iComm2_IPaddr_first_TCP : INT; (*PARA [15028]: Modbus 2 TCP Slave IP adress first place. 192.xxx.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_IPaddr_second_TCP : INT; (*PARA [15029]: Modbus 2 TCP Slave IP adress second place. xxx.168.xxx.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_IPaddr_third_TCP : INT; (*PARA [15030]: Modbus 2 TCP Slave IP adress third place. xxx.xxx.75.xxx*) (*OldName: new PV; Cycle: 5;*)
		iComm2_IPaddr_fourth_TCP : INT; (*PARA [15031]: Modbus 2 TCP Slave IP adress fourth place. xxx.xxx.xxx.209*) (*OldName: new PV; Cycle: 5;*)
	END_STRUCT;
	VIS2MM_Struct : 	STRUCT 
		bOPC_Dem : BOOL; (*Demand module from OPC*) (*OldName:OPC_ANF; Cycle:5;*)
		bOPC_SetClock : BOOL; (*Bus pulse signal from customer OPC*) (*OldName:OPC_TAKT; Cycle:5;*)
		rP_OPC_Set : REAL; (*Power setpoint from OPC [%]*) (*OldName:OPC_P_SOLL; Cycle:5;*)
		InData1 : ARRAY[0..MAX_IN_DATA_ARRAY]OF INT; (*input data from master coupling 1*)
		InData2 : ARRAY[0..MAX_IN_DATA_ARRAY]OF INT; (*input data from master coupling 2*)
		bBC_Test_Force_Active : BOOL; (*Bus test*)
		bBC_Test_Send_Active : BOOL; (*Bus test *)
		iBC_Test_Recv_Start_Reg : INT; (*Bus test*)
		iBC_Test_Send_Start_Reg : INT; (*Bus test*)
		bBC_Test_Recv_Reg : ARRAY[0..MAX_IN_DATA_ARRAY_BOOL]OF BOOL; (*Bus test*)
		iBC_Test_Recv_Reg : ARRAY[0..MAX_IN_DATA_ARRAY_BUSTEST]OF INT; (*output data to master*)
		bBC_Test_Recv_Reg_Forced : ARRAY[0..20]OF BOOL; (*Bus test*)
		bBC_Test_Recv_Reg_AllForced : BOOL; (*Bus test *)
		bBC_Test_Send_Reg : ARRAY[0..MAX_OUT_DATA_ARRAY_BOOL]OF BOOL; (*Bus test*)
		iBC_Test_Send_Reg : ARRAY[0..MAX_OUT_DATA_ARRAY]OF INT; (*output data to master*)
		bBC_Test_Send_Reg_Forced : ARRAY[0..20]OF BOOL; (*Bus test*)
		bBC_Test_Reg_AllForced : BOOL; (*Bus test *)
		bBC_Test_Send_Reg_AllForced : BOOL; (*Bus test *)
		bBC1_Test_Active : BOOL; (*Bus test *)
		bBC2_Test_Active : BOOL; (*Bus test *)
		bBC_Test_Recv_Active : BOOL; (*Bus test *)
		bBC_Test_Recv_Cust1_Toggle : BOOL; (*Bus test *)
		iBC_Test_Recv_Cust1_Toggle_Reg : INT; (*Bus test *)
		iBC_Test_Recv_Cust1_Toggle_Val1 : INT; (*Bus test *)
		iBC_Test_Recv_Cust1_Toggle_Val2 : INT; (*Bus test *)
		tiBC_Test_Recv_Cust1_Toggle : TIME; (*Bus test *)
		bBC_Test_Recv_Pulse : BOOL; (*Bus test *)
	END_STRUCT;
END_TYPE
