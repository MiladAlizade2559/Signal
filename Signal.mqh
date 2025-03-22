//+------------------------------------------------------------------+
//|                                                       Signal.mqh |
//|                                   Copyright 2025, Milad Alizade. |
//|                   https://www.mql5.com/en/users/MiladAlizade2559 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Milad Alizade."
#property link      "https://www.mql5.com/en/users/MiladAlizade2559"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Base/CBase.mqh>
#include <../Defines.mqh>
#include <ChartData/ChartData.mqh>
#include <Trade/Trade.mqh>
//+------------------------------------------------------------------+
//| Class CSignal                                                    |
//| Usage: The work controls a signal                                |
//+------------------------------------------------------------------+
class CSignal : public CBase
   {
private:
    ENUM_SIGNAL_TYPE m_mode;                       // mode type signal
    ulong            m_ticket;                     // ticket position
    string           m_symbol;                     // symbol name
    ENUM_ORDER_TYPE  m_type;                       // order type
    double           m_volume;                     // volume size
    datetime         m_time;                       // time setting signal
    double           m_price;                      // price signal
    int              m_spread;                     // max spread for opening signal
    int              m_slip;                       // max slip for opening signal
    double           m_commission;                 // commission position
    double           m_swap;                       // swap position
    double           m_profit;                     // profit position
    string           m_comment;                    // comment signal
    SSubSignal       m_sub_signals[];              // sub signals array
    SSubSignal       m_sub_positions[];            // sub positions array
    SSubSignal       m_sub_history[];              // sub history array
    int              m_sub_signals_total;          // sub signals total
    int              m_sub_positions_total;        // sub positions total
    int              m_sub_history_total;          // sub history total
    CChartData       *m_chart_data;                // pointer chart data
    CTrade           *m_trade;                     // pointer trade
public:
                     CSignal(CTrade *obj);
                    ~CSignal(void);
    //--- Functions for controlling data variables
    virtual int      Variables(const ENUM_VARIABLES_FLAGS flag,string &array[],const bool compact_objs = false);
    ENUM_SIGNAL_TYPE Mode(void)                    {return(m_mode);     }  // get mode signal
    ulong            Ticket(void)                  {return(m_ticket);   }  // get ticket signal
    string           Symbol(void)                  {return(m_symbol);   }  // get symbol name signal
    ENUM_ORDER_TYPE  Type(void)                    {return(m_type);     }  // get order type signal
    double           Volume(void)                  {return(m_volume);   }  // get volume size signal
    datetime         Time(void)                    {return(m_time);     }  // get time setting signal
    double           Price(void)                   {return(m_price);    }  // get price opening signal
    void             Comment(const string value)   {m_comment = value;  }  // set comment signal
    string           Comment(void)                 {return(m_comment);  }  // get comment signal
    double           Profit(void)                  {return(m_profit);   }  // get profit signal
    int              SetSubSignals(SSubSignal &array[]);
    int              GetSubSignals(SSubSignal &array[]);
    int              GetSubPositions(SSubSignal &array[]);
    int              GetSubHistory(SSubSignal &array[]);
   };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignal::CSignal(CTrade *obj) : m_ticket(0),
    m_volume(0),
    m_mode(TYPE_SIGNAL)
   {
    m_trade = obj;
   }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignal::~CSignal(void)
   {
   }
//+------------------------------------------------------------------+
//| Set sub signals array                                            |
//+------------------------------------------------------------------+
int CSignal::SetSubSignals(SSubSignal &array[])
   {
//--- size of array
    int size = ArraySize(array);
//--- resize sub signals
    ArrayResize(m_sub_signals,size);
//--- reset volume size
    m_volume = 0;
//--- set sub signal and updating volume size
    for(int i = 0; i < size; i++)
       {
        m_sub_signals[i] = array[i];
        m_volume += m_sub_signals[i].Volume;
       }
//--- update sub signals total
    m_sub_signals_total = size;
    return(m_sub_signals_total);
   }
//+------------------------------------------------------------------+
//| Get sub signals array                                            |
//+------------------------------------------------------------------+
int CSignal::GetSubSignals(SSubSignal &array[])
   {
//--- resize array
    ArrayResize(array,m_sub_signals_total);
//--- set sub signals to array
    for(int i = 0; i < m_sub_signals_total; i++)
       {
        array[i] = m_sub_signals[i];
       }
    return(m_sub_signals_total);
   }
//+------------------------------------------------------------------+
//| Get sub positions array                                          |
//+------------------------------------------------------------------+
int CSignal::GetSubPositions(SSubSignal &array[])
   {
//--- resize array
    ArrayResize(array,m_sub_positions_total);
//--- set sub positions to array
    for(int i = 0; i < m_sub_positions_total; i++)
       {
        array[i] = m_sub_positions[i];
       }
    return(m_sub_positions_total);
   }
//+------------------------------------------------------------------+
//| Get sub history array                                            |
//+------------------------------------------------------------------+
int CSignal::GetSubHistory(SSubSignal &array[])
   {
//--- resize array
    ArrayResize(array,m_sub_history_total);
//--- set sub histroy to array
    for(int i = 0; i < m_sub_history_total; i++)
       {
        array[i] = m_sub_history[i];
       }
    return(m_sub_history_total);
   }
//+------------------------------------------------------------------+
