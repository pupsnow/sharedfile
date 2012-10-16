package com.esri.ags.utils
{
    import mx.formatters.*;

    public class DateUtil extends Object
    {

        public function DateUtil()
        {
            return;
        }// end function

        public static function parseDate(str:String) : Date
        {
            var finalDate:Date;
            var dateParts:Array;
            var day:String;
            var month:Number;
            var date:Number;
            var timeParts:Array;
            var hour:Number;
            var minute:Number;
            var second:Number;
            var timezone:String;
            var year:Number;
            var milliseconds:Number;
            var offset:Number;
            var multiplier:Number;
            var oHours:Number;
            var oMinutes:Number;
            var eStr:String;
            var str:* = str;
            try
            {
                dateParts = str.split(" ");
                day;
                if (dateParts[0].search(/\d/) == -1)
                {
                    day = dateParts.shift().replace(/\W/, "");
                }
                month = Number(DateBase.monthNamesShort.indexOf(dateParts.shift()));
                date = Number(dateParts.shift());
                timeParts = dateParts.shift().split(":");
                hour = int(timeParts.shift());
                minute = int(timeParts.shift());
                second = timeParts.length > 0 ? (int(timeParts.shift())) : (0);
                timezone = dateParts.shift();
                year = Number(dateParts.shift().replace(/\W/, ""));
                milliseconds = Date.UTC(year, month, date, hour, minute, second, 0);
                offset;
                if (timezone.search(/\d/) == -1)
                {
                    switch(timezone)
                    {
                        case "UT":
                        {
                            offset;
                            break;
                        }
                        case "UTC":
                        {
                            offset;
                            break;
                        }
                        case "GMT":
                        {
                            offset;
                            break;
                        }
                        case "EST":
                        {
                            offset = -5 * 3600000;
                            break;
                        }
                        case "EDT":
                        {
                            offset = -4 * 3600000;
                            break;
                        }
                        case "CST":
                        {
                            offset = -6 * 3600000;
                            break;
                        }
                        case "CDT":
                        {
                            offset = -5 * 3600000;
                            break;
                        }
                        case "MST":
                        {
                            offset = -7 * 3600000;
                            break;
                        }
                        case "MDT":
                        {
                            offset = -6 * 3600000;
                            break;
                        }
                        case "PST":
                        {
                            offset = -8 * 3600000;
                            break;
                        }
                        case "PDT":
                        {
                            offset = -7 * 3600000;
                            break;
                        }
                        case "Z":
                        {
                            offset;
                            break;
                        }
                        case "A":
                        {
                            offset = -1 * 3600000;
                            break;
                        }
                        case "M":
                        {
                            offset = -12 * 3600000;
                            break;
                        }
                        case "N":
                        {
                            offset = 1 * 3600000;
                            break;
                        }
                        case "Y":
                        {
                            offset = 12 * 3600000;
                            break;
                        }
                        default:
                        {
                            offset;
                            break;
                        }
                    }
                }
                else
                {
                    multiplier;
                    oHours;
                    oMinutes;
                    if (timezone.length != 4)
                    {
                        if (timezone.charAt(0) == "-")
                        {
                            multiplier;
                        }
                        timezone = timezone.substr(1, 4);
                    }
                    oHours = Number(timezone.substr(0, 2));
                    oMinutes = Number(timezone.substr(2, 2));
                    offset = (oHours * 3600000 + oMinutes * 60000) * multiplier;
                }
                finalDate = new Date(milliseconds - offset);
                if (finalDate.toString() == "Invalid Date")
                {
                    throw new ESRIError(ESRIMessageCodes.DOES_NOT_CONFIRN_TO_RFC822);
                }
            }
            catch (e:Error)
            {
                eStr = ESRIMessageCodes.getString(ESRIMessageCodes.UNABLE_TO_PARSE_STRING, "[" + str + "]");
                eStr = eStr + ("The internal error was: " + e.toString());
                throw new Error(eStr);
            }
            return finalDate;
        }// end function

    }
}
