//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                                   Copyright 2025, Milad Alizade. |
//|                   https://www.mql5.com/en/users/MiladAlizade2559 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Milad Alizade."
#property link      "https://www.mql5.com/en/users/MiladAlizade2559"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Base/SBase.mqh>
#include <Trailing/Trailing.mqh>
//+------------------------------------------------------------------+
//| Enumes                                                           |
//+------------------------------------------------------------------+
enum ENUM_SIGNAL_TYPE
   {
    TYPE_SIGNAL,
    TYPE_POSITION,
    TYPE_HISTORY,
   };
enum ENUM_CLOSE_TYPE
   {
    CLOSE_NONE,
    CLOSE_SL,
    CLOSE_TP,
    CLOSE_MANUAL,
   };
//+------------------------------------------------------------------+
//| Structs                                                          |
//+------------------------------------------------------------------+
struct SSubSignal : public SBase
   {
    datetime         Open_Time;
    double           Open_Price;
    int              Open_Spread;
    int              Open_Slip;
    double           Volume;
    double           SL;
    double           TP;
    double           Commission;
    double           Swap;
    double           Profit;
    datetime         Close_Time;
    double           Close_Price;
    int              Close_Spread;
    int              Close_Slip;
    ENUM_CLOSE_TYPE  Close_Type;
    CTrailing        Trail;
    int              Variables(const ENUM_VARIABLES_FLAGS flag,string &array[],const bool compact_objs = false);
   };
//+------------------------------------------------------------------+
//| Setting variables                                                |
//+------------------------------------------------------------------+
int SSubSignal::Variables(const ENUM_VARIABLES_FLAGS flag,string &array[],const bool compact_objs = false)
   {
    SBase::Variables(flag,array,compact_objs);
    _datetime(Open_Time);
    _double(Open_Price);
    _int(Open_Spread);
    _int(Open_Slip);
    _double(Volume);
    _double(SL);
    _double(TP);
    _double(Commission);
    _double(Swap);
    _double(Profit);
    _datetime(Close_Time);
    _double(Close_Price);
    _int(Close_Spread);
    _int(Close_Slip);
    _enum(Close_Type);
    _struct(Trail);
    return(SBase::Variables(array));
   }
//+------------------------------------------------------------------+
