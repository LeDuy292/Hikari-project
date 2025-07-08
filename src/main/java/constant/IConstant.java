package constant;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author macbookpro
 */
public class IConstant {

    public static final String GOOGLE_CLIENT_ID;
    public static final String GOOGLE_CLIENT_SECRET;
    public static final String GOOGLE_REDIRECT_URI;
    public static final String GOOGLE_GRANT_TYPE;
    public static final String GOOGLE_LINK_GET_TOKEN;
    public static final String GOOGLE_LINK_GET_USER_INFO;

    static {
        Properties props = new Properties();
        try (InputStream input = IConstant.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                props.load(input);
                GOOGLE_CLIENT_ID = props.getProperty("GOOGLE_CLIENT_ID");
                GOOGLE_CLIENT_SECRET = props.getProperty("GOOGLE_CLIENT_SECRET");
                GOOGLE_REDIRECT_URI = props.getProperty("GOOGLE_REDIRECT_URI");
                GOOGLE_GRANT_TYPE = props.getProperty("GOOGLE_GRANT_TYPE");
                GOOGLE_LINK_GET_TOKEN = props.getProperty("GOOGLE_LINK_GET_TOKEN");
                GOOGLE_LINK_GET_USER_INFO = props.getProperty("GOOGLE_LINK_GET_USER_INFO");
            } else {
                throw new RuntimeException("application.properties not found!");
            }
        } catch (IOException e) {
            throw new RuntimeException("Error reading application.properties", e);
        }
    }
}
