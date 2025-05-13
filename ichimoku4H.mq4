//+------------------------------------------------------------------+
//|                                    H4 Ichimoku Kumo on H1.mq4   |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green   // Senkou Span A
#property indicator_color2 Orange  // Senkou Span B
#property indicator_width1 2
#property indicator_width2 2

double SenkouABuffer[];
double SenkouBBuffer[];

//--- Ichimoku parameters (default)
input int tenkan=9;
input int kijun=26;
input int senkou=52;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, SenkouABuffer);
   SetIndexBuffer(1, SenkouBBuffer);

   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);

   IndicatorShortName("H4 Ichimoku Kumo on H1");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i, limit = rates_total - prev_calculated;
   if (limit > rates_total - 100) limit = rates_total - 100; // speed up

   for(i=0; i<limit; i++)
     {
      datetime t = time[i];
      int h4_index = iBarShift(NULL, PERIOD_H4, t, true);

      if(h4_index < 0)
        {
         SenkouABuffer[i] = EMPTY_VALUE;
         SenkouBBuffer[i] = EMPTY_VALUE;
         continue;
        }

      double h4_senkouA = iIchimoku(NULL, PERIOD_H4, tenkan, kijun, senkou, MODE_SENKOUSPANA, h4_index);
      double h4_senkouB = iIchimoku(NULL, PERIOD_H4, tenkan, kijun, senkou, MODE_SENKOUSPANB, h4_index);

      SenkouABuffer[i] = h4_senkouA;
      SenkouBBuffer[i] = h4_senkouB;
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
