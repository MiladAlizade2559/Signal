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
    double           m_profit_opened;              // profit positions opened
    double           m_profit_closed ;             // profit positions closed
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
    ENUM_SIGNAL_TYPE Mode(void)                    {return(m_mode);              }  // get mode signal
    ulong            Ticket(void)                  {return(m_ticket);            }  // get ticket signal
    string           Symbol(void)                  {return(m_symbol);            }  // get symbol name signal
    ENUM_ORDER_TYPE  Type(void)                    {return(m_type);              }  // get order type signal
    double           Volume(void)                  {return(m_volume);            }  // get volume size signal
    datetime         Time(void)                    {return(m_time);              }  // get time setting signal
    double           Price(void)                   {return(m_price);             }  // get price opening signal
    void             Comment(const string value)   {m_comment = value;           }  // set comment signal
    string           Comment(void)                 {return(m_comment);           }  // get comment signal
    double           ProfitOpened(void)            {return(m_profit_opened);     }  // get profit positions opened
    double           ProfitClosed(void)            {return(m_profit_closed);     }  // get profit positions closed
    int              SubSignals(SSubSignal &array[]);
    int              SubPositions(SSubSignal &array[]);
    int              SubHistory(SSubSignal &array[]);
    int              SubSignal(SSubSignal &value,const int index = -1);
    bool             SubSignalDelete(const int index);
    bool             SubSignalDeletes(void);
    bool             SubPosition(SSubSignal &value,const int index);
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
//| Setting variables                                                |
//+------------------------------------------------------------------+
int CSignal::Variables(const ENUM_VARIABLES_FLAGS flag,string &array[],const bool compact_objs = false)
   {
    CBase::Variables(flag,array,compact_objs);
    _enum(m_mode);
    _ulong(m_ticket);
    _string(m_symbol);
    _enum(m_type);
    _double(m_volume);
    _datetime(m_time);
    _double(m_price);
    _int(m_spread);
    _int(m_slip);
    _double(m_commission);
    _double(m_swap);
    _double(m_profit_opened);
    _double(m_profit_closed);
    _string(m_comment);
    _struct_array(m_sub_signals);
    _struct_array(m_sub_positions);
    _struct_array(m_sub_history);
    _int(m_sub_signals_total);
    _int(m_sub_positions_total);
    _int(m_sub_history_total);
    return(CBase::Variables(array));
   }
//+------------------------------------------------------------------+
//| Get sub signals array                                            |
//+------------------------------------------------------------------+
int CSignal::SubSignals(SSubSignal &array[])
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
int CSignal::SubPositions(SSubSignal &array[])
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
int CSignal::SubHistory(SSubSignal &array[])
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
//| Set or update sub signals                                        |
//+------------------------------------------------------------------+
int CSignal::SubSignal(SSubSignal &value,const int index = -1)
   {
//--- check index
    if(index >= m_sub_signals_total)
        return(-1);
//--- check index
    if(index < 0)
       {
        //--- resize sub signals array
        ArrayResize(m_sub_signals,m_sub_signals_total + 1);
        //--- set value to sub signals array
        m_sub_signals[m_sub_signals_total] = value;
        //--- update sub signals total
        m_sub_signals_total++;
        return(m_sub_signals_total - 1);
       }
//--- update sub signal
    m_sub_signals[index] = value;
    return(index);
   }
//+------------------------------------------------------------------+
//| Delete sub signal                                                |
//+------------------------------------------------------------------+
bool CSignal::SubSignalDelete(const int index)
   {
//--- check index
    if(index >= m_sub_signals_total)
        return(false);
//--- remove sub signal
    if(!ArrayRemove(m_sub_signals,index,1))
        return(false);
    m_sub_signals_total --;
    return(true);
   }
//+------------------------------------------------------------------+
//| Delete sub signals                                               |
//+------------------------------------------------------------------+
bool CSignal::SubSignalDeletes(void)
   {
//--- remove sub signals
    if(!ArrayRemove(m_sub_signals,0,WHOLE_ARRAY))
        return(false);
    return(true);
   }
//+------------------------------------------------------------------+
//| Set or update sub positions array                                |
//+------------------------------------------------------------------+
bool CSignal::SubPosition(SSubSignal &value,const int index)
   {
//--- check index
    if(index >= m_sub_positions_total)
        return(false);
//--- update sub position
    m_sub_positions[index] = value;
    return(true);
   }
//+------------------------------------------------------------------+
