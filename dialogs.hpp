class ICE_DIALOG
{
   idd = 10001;
   movingenable = true;
   class Controls
   {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by Sondre Bakken, v1.063, #Namogy)
        ////////////////////////////////////////////////////////

        class IGUIBack_2200: IGUIBack
        {
          idc = 2200;

          x = 0.298906 * safezoneW + safezoneX;
          y = 0.236 * safezoneH + safezoneY;
          w = 0.165 * safezoneW;
          h = 0.528 * safezoneH;
        };
        class RscText_1000: RscText
        {
          idc = 1000;

          text = "Infantry"; //--- ToDo: Localize;
          x = 0.304062 * safezoneW + safezoneX;
          y = 0.247 * safezoneH + safezoneY;
          w = 0.154687 * safezoneW;
          h = 0.022 * safezoneH;
        };
        class RscListbox_1500: RscListBox
        {
          idc = 1500;

          x = 0.304062 * safezoneW + safezoneX;
          y = 0.269 * safezoneH + safezoneY;
          w = 0.154687 * safezoneW;
          h = 0.451 * safezoneH;
          onLBSelChanged = "[] spawn createInfantryFromGui";
        };
        class RscButtonMenuOK_2600: RscButtonMenuOK
        {
          text = "Get Infantry"; //--- ToDo: Localize;
          x = 0.304062 * safezoneW + safezoneX;
          y = 0.731 * safezoneH + safezoneY;
          w = 0.154687 * safezoneW;
          h = 0.022 * safezoneH;
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
   };

};

class HQMenu {

idd = 10001;
   movingenable = true;
   class Controls
   {
      ////////////////////////////////////////////////////////
      // GUI EDITOR OUTPUT START (by Sondre Bakken, v1.063, #Duwego)
      ////////////////////////////////////////////////////////

      class IGUIBack_2200: IGUIBack
      {
        idc = 2200;
        x = 0.298906 * safezoneW + safezoneX;
        y = 0.236 * safezoneH + safezoneY;
        w = 0.159844 * safezoneW;
        h = 0.528 * safezoneH;
      };
      class RscText_1000: RscText
      {
        idc = 1000;
        text = "HQ Menu"; //--- ToDo: Localize;
        x = 0.304062 * safezoneW + safezoneX;
        y = 0.247 * safezoneH + safezoneY;
        w = 0.149531 * safezoneW;
        h = 0.022 * safezoneH;
      };
      class RscListbox_1500: RscListbox
      {
        idc = 1500;
        x = 0.304062 * safezoneW + safezoneX;
        y = 0.28 * safezoneH + safezoneY;
        w = 0.149531 * safezoneW;
        h = 0.473 * safezoneH;
      };
      ////////////////////////////////////////////////////////
      // GUI EDITOR OUTPUT END
      ////////////////////////////////////////////////////////
  };
};

