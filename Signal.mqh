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
private:
    //--- Functions to controlling work with signal
    int              Move(SSubSignal &dst_settings[],SSubSignal &src_settings[],const int src_start);
    bool             CheckOpen(void);
    bool             Open(void);
    int              CheckCloses(int &array[]);
    bool             Closes(int &array[]);
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
    //--- Functions to controlling work with signal
    bool             Create(const string symbol_name,const ENUM_ORDER_TYPE type,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             Buy(const string symbol_name,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             Sell(const string symbol_name,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             BuyStop(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             BuyLimit(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             SellStop(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    bool             SellLimit(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj);
    int              Sub(const double volume,const double sl,const double tp,CTrailing &obj);
    int              Sub(const double volume,const int sl,const int tp,CTrailing &obj);
    bool             SubPositionClose(const int index);
    bool             Opening(void);
    bool             Trailing(void);
    bool             Closing(void);
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
//| Create signal                                                    |
//+------------------------------------------------------------------+
bool CSignal::Create(const string symbol_name,const ENUM_ORDER_TYPE type,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
//--- check mode
    if(m_mode == TYPE_SIGNAL)
       {
        //--- update data signal
        m_mode = TYPE_SIGNAL;
        m_chart_data = obj;
        m_symbol = symbol_name;
        m_type = type;
        m_volume = 0;
        m_time = m_chart_data.Time();
        m_price = price;
        m_spread = max_spread;
        m_slip = max_slip;
        m_swap = 0;
        m_commission = 0;
        m_profit_opened = 0;
        m_profit_closed = 0;
        m_comment = comment;
        ArrayResize(m_sub_signals,0);
        ArrayResize(m_sub_positions,0);
        ArrayResize(m_sub_history,0);
        m_sub_signals_total = 0;
        m_sub_positions_total = 0;
        m_sub_history_total = 0;
        return(true);
       }
    return(false);
   }
//+------------------------------------------------------------------+
//| Create buy signal                                                |
//+------------------------------------------------------------------+
bool CSignal::Buy(const string symbol_name,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_BUY,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Create sell signal                                               |
//+------------------------------------------------------------------+
bool CSignal::Sell(const string symbol_name,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_SELL,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Create buy stop signa                                            |
//+------------------------------------------------------------------+
bool CSignal::BuyStop(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_BUY_STOP,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Create buy limit signal                                          |
//+------------------------------------------------------------------+
bool CSignal::BuyLimit(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_BUY_LIMIT,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Create sell stop signal                                          |
//+------------------------------------------------------------------+
bool CSignal::SellStop(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_SELL_STOP,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Create sell limit signal                                         |
//+------------------------------------------------------------------+
bool CSignal::SellLimit(const string symbol_name,const double price,const int max_spread,const int max_slip,const string comment,CChartData *obj)
   {
    return(Create(symbol_name,ORDER_TYPE_SELL_LIMIT,obj.Bid(),max_slip,max_slip,comment,obj));
   }
//+------------------------------------------------------------------+
//| Add new sub signal                                               |
//+------------------------------------------------------------------+
int CSignal::Sub(const double volume,const double sl,const double tp,CTrailing &obj)
   {
//--- resize sub signals
    ArrayResize(m_sub_signals,m_sub_signals_total + 1);
//--- set values to sub signals
    m_sub_signals[m_sub_signals_total].Open_Time = 0;
    m_sub_signals[m_sub_signals_total].Open_Price = 0;
    m_sub_signals[m_sub_signals_total].Open_Spread = 0;
    m_sub_signals[m_sub_signals_total].Open_Slip = 0;
    m_sub_signals[m_sub_signals_total].Volume = volume;
    m_sub_signals[m_sub_signals_total].SL = sl;
    m_sub_signals[m_sub_signals_total].TP = tp;
    m_sub_signals[m_sub_signals_total].Commission = 0;
    m_sub_signals[m_sub_signals_total].Swap = 0;
    m_sub_signals[m_sub_signals_total].Profit = 0;
    m_sub_signals[m_sub_signals_total].Close_Time = 0;
    m_sub_signals[m_sub_signals_total].Close_Price = 0;
    m_sub_signals[m_sub_signals_total].Close_Spread = 0;
    m_sub_signals[m_sub_signals_total].Close_Slip = 0;
    m_sub_signals[m_sub_signals_total].Close_Type = CLOSE_NONE;
    m_sub_signals[m_sub_signals_total].Trail = obj;
//--- update sub signals total
    m_sub_signals_total ++;
//--- update volume size
    m_volume += volume;
    return(m_sub_signals_total - 1);
   }
//+------------------------------------------------------------------+
//| Add new sub signal                                               |
//+------------------------------------------------------------------+
int CSignal::Sub(const double volume,const int sl,const int tp,CTrailing &obj)
   {
//--- check type
    if(m_type == ORDER_TYPE_BUY ||
       m_type == ORDER_TYPE_BUY_STOP ||
       m_type == ORDER_TYPE_BUY_LIMIT)
       {
        return(Sub(volume,m_price - (sl * Point()),m_price + (tp * Point()),obj));
       }
//--- check type
    if(m_type == ORDER_TYPE_SELL ||
       m_type == ORDER_TYPE_SELL_STOP ||
       m_type == ORDER_TYPE_SELL_LIMIT)
       {
        return(Sub(volume,m_price + (sl * Point()),m_price - (tp * Point()),obj));
       }
    return(-1);
   }
//+------------------------------------------------------------------+
//| Close sub position                                               |
//+------------------------------------------------------------------+
bool CSignal::SubPositionClose(const int index)
   {
//--- check index
    if(index >= m_sub_positions_total)
        return(false);
//--- update sub position
    m_sub_positions[index].Close_Type = CLOSE_MANUAL;
    return(true);
   }
//+------------------------------------------------------------------+
//| Move sub signal struc                                            |
//+------------------------------------------------------------------+
int CSignal::Move(SSubSignal &dst_settings[],SSubSignal &src_settings[],const int src_start)
   {
//--- check src start
    if(src_start >= ArraySize(src_settings))
        return(-1);
//--- resize dst settings array
    int size = ArraySize(dst_settings);
    ArrayResize(dst_settings,size + 1);
//--- set value to dst settings array from src settings array
    dst_settings[size] = src_settings[src_start];
    ArrayRemove(src_settings,src_start,1);
    return(size);
   }
//+------------------------------------------------------------------+
//| Check signal is opening                                          |
//+------------------------------------------------------------------+
bool CSignal::CheckOpen(void)
   {
//--- check spread
    if(m_chart_data.Spread() > m_spread)
        return(false);
//--- check order type
    switch(m_type)
       {
        case ORDER_TYPE_BUY:
        case ORDER_TYPE_SELL:
           {
            //--- check bid price is between price and max slip
            if(m_chart_data.Bid() <= (m_price + (m_slip * Point())) &&
               m_chart_data.Bid() >= (m_price - (m_slip * Point())))
               {
                return(true);
               }
            break;
           }
        case ORDER_TYPE_BUY_STOP:
        case ORDER_TYPE_SELL_LIMIT:
           {
            //--- check bid price is between price and max slip
            if(m_chart_data.Bid() >= m_price &&
               m_chart_data.Bid() <= (m_price + (m_slip * Point())))
               {
                return(true);
               }
            break;
           }
        case ORDER_TYPE_SELL_STOP:
        case ORDER_TYPE_BUY_LIMIT:
           {
            //--- check bid price is between price and max slip
            if(m_chart_data.Bid() <= m_price &&
               m_chart_data.Bid() >= (m_price - (m_slip * Point())))
               {
                return(true);
               }
            break;
           }
       }
    return(false);
   }
//+------------------------------------------------------------------+
//| Opening signal                                                   |
//+------------------------------------------------------------------+
bool CSignal::Open(void)
   {
//--- check order type
    switch(m_type)
       {
        case ORDER_TYPE_BUY:
        case ORDER_TYPE_BUY_STOP:
        case ORDER_TYPE_BUY_LIMIT:
           {
            //--- opening buy position
            if(m_trade.Buy(m_volume,m_symbol))
                m_ticket = m_trade.ResultOrder();
            break;
           }
        case ORDER_TYPE_SELL:
        case ORDER_TYPE_SELL_STOP:
        case ORDER_TYPE_SELL_LIMIT:
           {
            //--- opening sell position
            if(m_trade.Sell(m_volume,m_symbol))
                m_ticket = m_trade.ResultOrder();
            break;
           }
       }
//--- check ticket
    if(m_ticket > 0)
       {
        //--- select position
        if(PositionSelectByTicket(m_ticket))
           {
            m_mode = TYPE_POSITION;
            //--- get data position
            if(HistorySelectByPosition(m_ticket))
               {
                for(int i = 0; i < HistoryDealsTotal(); i++)
                   {
                    ulong ticket_deal = HistoryDealGetTicket(i);
                    m_commission += HistoryDealGetDouble(ticket_deal, DEAL_COMMISSION);
                   }
               }
            ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            datetime time = (datetime)PositionGetInteger(POSITION_TIME);
            double price = PositionGetDouble(POSITION_PRICE_OPEN);
            double commission = m_commission / m_volume;
            //--- update sub signals and moveing to sub positions
            for(int i = m_sub_signals_total - 1; i >= 0; i--)
               {
                m_sub_signals[i].Open_Time = time;
                m_sub_signals[i].Open_Price = price;
                m_sub_signals[i].Open_Spread = pos_type == POSITION_TYPE_BUY ? m_chart_data.Spread() : 0;
                m_sub_signals[i].Open_Slip = (int)(MathAbs(price - (m_sub_signals[i].Open_Spread / Point()) - m_price) / Point());
                m_sub_signals[i].Commission = m_commission * m_sub_signals[i].Volume;
                Move(m_sub_positions,m_sub_signals,i);
               }
            return(true);
           }
       }
    return(false);
   }
//+------------------------------------------------------------------+
//| Check positions is closing                                       |
//+------------------------------------------------------------------+
int CSignal::CheckCloses(int &array[])
   {
//--- check order type
    switch(m_type)
       {
        case ORDER_TYPE_BUY:
        case ORDER_TYPE_BUY_STOP:
        case ORDER_TYPE_BUY_LIMIT:
           {
            for(int i = 0;i < m_sub_positions_total;i++)
               {
                //--- check close type is manual
                if(m_sub_positions[i].Close_Type == CLOSE_MANUAL)
                   {
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                //--- check close is toched tp
                if(m_chart_data.Bid() >= m_sub_positions[i].TP &&
                   m_sub_positions[i].TP > 0)
                   {
                    m_sub_positions[i].Close_Type = CLOSE_TP;
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                //--- check close is toched sl
                if(m_chart_data.Bid() <= m_sub_positions[i].SL &&
                   m_sub_positions[i].SL > 0)
                   {
                    m_sub_positions[i].Close_Type = CLOSE_SL;
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                m_sub_positions[i].Close_Type = CLOSE_NONE;
               }
            break;
           }
        case ORDER_TYPE_SELL:
        case ORDER_TYPE_SELL_STOP:
        case ORDER_TYPE_SELL_LIMIT:
           {
            for(int i = 0;i < m_sub_positions_total;i++)
               {
                //--- check close type is manual
                if(m_sub_positions[i].Close_Type == CLOSE_MANUAL)
                   {
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                //--- check close is toched tp
                if(m_chart_data.Bid() <= m_sub_positions[i].TP &&
                   m_sub_positions[i].TP > 0)
                   {
                    m_sub_positions[i].Close_Type = CLOSE_TP;
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                //--- check close is toched sl
                if(m_chart_data.Bid() >= m_sub_positions[i].SL &&
                   m_sub_positions[i].SL > 0)
                   {
                    m_sub_positions[i].Close_Type = CLOSE_SL;
                    int size = ArraySize(array);
                    ArrayResize(array,size + 1);
                    array[size] = i;
                    continue;
                   }
                m_sub_positions[i].Close_Type = CLOSE_NONE;
               }
            break;
           }
       }
    return(ArraySize(array));
   }
//+------------------------------------------------------------------+
//| Closing Positions                                                |
//+------------------------------------------------------------------+
bool CSignal::Closes(int &array[])
   {
//--- array sort
    ArraySort(array);
//--- size of array
    int size = ArraySize(array);
//--- get volume for closing
    double volume = 0;
    for(int i = 0; i < size; i++)
       {
        volume += m_sub_positions[array[i]].Volume;
       }
    if(PositionSelectByTicket(m_ticket))
       {
        ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        //--- get swap per lot
        m_swap = PositionGetDouble(POSITION_SWAP);
        double swap = PositionGetDouble(POSITION_SWAP) / PositionGetDouble(POSITION_VOLUME);
        if(m_trade.PositionClosePartial(m_ticket,volume))
           {
            //--- updating volume size
            m_volume -= volume;
            //--- get price positions closed
            double price = m_trade.ResultPrice();
            for(int i = ArraySize(array) - 1;i >= 0 ;i--)
               {
                //--- updating values sub position
                m_sub_positions[array[i]].Close_Time = m_chart_data.Time();
                m_sub_positions[array[i]].Close_Price = price;
                m_sub_positions[array[i]].Close_Spread = pos_type == POSITION_TYPE_SELL ? m_chart_data.Spread() : 0;
                if(m_sub_positions[array[i]].Close_Type == CLOSE_TP)
                   {
                    m_sub_positions[array[i]].Close_Slip = (int)(MathAbs(price - (m_sub_positions[array[i]].Close_Spread * Point()) - m_sub_positions[array[i]].TP) / Point());
                   }
                else
                    if(m_sub_positions[array[i]].Close_Type == CLOSE_SL)
                       {
                        m_sub_positions[array[i]].Close_Slip = (int)(MathAbs(price - (m_sub_positions[array[i]].Close_Spread * Point()) - m_sub_positions[array[i]].SL) / Point());
                       }
                    else
                        m_sub_positions[array[i]].Close_Slip = 0;
                m_sub_positions[array[i]].Swap = NormalizeDouble(swap * m_sub_positions[array[i]].Volume,2);
                m_sub_positions[array[i]].Profit = NormalizeDouble((MathAbs(m_sub_positions[array[i]].Close_Price - m_price) / Point()) * m_sub_positions[array[i]].Volume,2);
                m_profit_closed += m_sub_positions[array[i]].Profit;
                Move(m_sub_history,m_sub_positions,array[i]);
               }
            return(true);
           }
       }
    return(false);
   }
//+------------------------------------------------------------------+
//| Opening                                                          |
//+------------------------------------------------------------------+
bool CSignal::Opening(void)
   {
//--- checking is open signal
    if(CheckOpen())
        //--- opening signal
        if(Open())
            return(true);
    return(false);
   }
//+------------------------------------------------------------------+
//| Trailing sl and tp with settings                                 |
//+------------------------------------------------------------------+
bool CSignal::Trailing(void)
   {
    bool change = false;
    m_profit_opened = 0;
//--- trailing sub positions
    for(int i = 0; i < m_sub_positions_total; i++)
       {
        m_profit_opened += m_sub_positions[i].Profit;
        //--- trailing sub postion
        if(m_sub_positions[i].Trail.Trailing(m_chart_data.Bid(),m_chart_data.Bid(1)))
           {
            //--- updating sl and tp sub position
            m_sub_positions[i].SL += m_sub_positions[i].Trail.SL();
            m_sub_positions[i].TP += m_sub_positions[i].Trail.TP();
            //--- reseting sl and tp trailing
            m_sub_positions[i].Trail.SLReset();
            m_sub_positions[i].Trail.TPReset();
            change = true;
           }
       }
    return(change);
   }
//+------------------------------------------------------------------+
//| Closing sub postions                                             |
//+------------------------------------------------------------------+
bool CSignal::Closing(void)
   {
    int array[];
//--- check sub positions is close
    if(CheckCloses(array) > 0)
       {
        //--- closes sub positions
        if(Closes(array))
           {
            if(m_sub_positions_total == 0)
                m_mode = TYPE_HISTORY;
            return(true);
           }
       }
    return(false);
   }
//+------------------------------------------------------------------+
