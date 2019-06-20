package foodxpress;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {
    public static String capitalize(String s) {
        return s.length() > 1
                ? s.toUpperCase().charAt(0) + s.substring(1).toLowerCase()
                : s.toUpperCase();
    }
    public static String toOneDecimalPlaces(double d) {
        return String.format("%.1f", d);
    }
    public static String toTwoDecimalPlaces(double d) {
        return String.format("%.2f", d);
    }
    public static String printDate(Date datetime) {
        return new SimpleDateFormat("yyyy-MM-dd '@' hh:mma").format(datetime);
    }
    public static String printTime(Time time) {
        return new SimpleDateFormat("hh:mma").format(time);
    }
    public static String printHourMinute(int minute) {
        int min = minute % 60;
        int h = (minute - min) / 60;
        String res = "";
        if (h > 0) {
            res += h + "h";
            if (minute > 0) {
                res += " " + min + "min";
            }
        } else if (minute > 0) {
            res += min + "min";
        }
        return res;
    }
}
