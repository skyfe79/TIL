package kr.pe.burt;


// @see http://www.geeksforgeeks.org/convert-floating-point-number-string/
// You should set VM options to "-ea" for using assert expression
public class Main {

    public static void main(String[] args) {

        assert intToString(1234567890).equalsIgnoreCase("1234567890");
        assert intToString(0001).equalsIgnoreCase("1");
        assert floatToString(1.5f, 1).equalsIgnoreCase("1.5");
        assert floatToString(1.5f, 3).equalsIgnoreCase("1.500");
        assert floatToString(1.512385f, 6).equalsIgnoreCase("1.512385");

        System.out.println("OK");
    }


    public static String floatToString(float number, int afterPoint) {

        //우선 float에서 정수부분과 소수점 부분을 분리한다.
        int n = (int)number;
        float s = number - n;

        //정수 n을 문자열로 변경한다.
        StringBuffer sb = new StringBuffer();
        String nString = intToString(n);
        sb.append(nString);

        if(afterPoint > 0) {
            sb.append(".");
            int sn = (int) ( s * Math.pow(10, afterPoint) );
            String snString = intToString(sn);
            sb.append(snString);
        }
        return sb.toString();
    }

    private static String intToString(int number) {

        StringBuffer result = new StringBuffer();
        while(number > 0) {
            int d = number % 10;
            result.insert(0, d);
            number = number / 10;
        }

        return result.toString();
    }

}
