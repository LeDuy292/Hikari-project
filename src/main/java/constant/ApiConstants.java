package constant;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ApiConstants {
    private static final Properties properties = new Properties();

    static {
        try (InputStream input = ApiConstants.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new RuntimeException("Không tìm thấy file cấu hình application.properties");
            }
            properties.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Lỗi khi load config.properties", e);
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }

    // Ví dụ truy cập cụ thể
    public static final String SIGHTENGINE_API_USER = get("sightengine.api_user");
    public static final String SIGHTENGINE_API_SECRET = get("sightengine.api_secret");
}
