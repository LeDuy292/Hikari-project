package responsitory;

import jakarta.servlet.http.Part;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class CourseReponsitory implements Responsitory {

    private static final String UPLOAD_DIR = "Courses/";
    private static final Logger LOGGER = Logger.getLogger(CourseReponsitory.class.getName());
    private final S3Client s3Client;
    private final String bucketName;
    private final String region;

    public CourseReponsitory() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                LOGGER.severe("Không tìm thấy application.properties trong classpath. Kiểm tra src/main/resources/");
                throw new RuntimeException("Không tìm thấy application.properties");
            }
            props.load(input);
            LOGGER.info("Đã tải application.properties thành công");
        } catch (IOException ex) {
            LOGGER.severe("Lỗi đọc application.properties: " + ex.getMessage());
            throw new RuntimeException("Lỗi đọc application.properties: " + ex.getMessage());
        }

        String accessKeyId = props.getProperty("aws.accessKeyId");
        String secretKey = props.getProperty("aws.secretKey");
        region = props.getProperty("aws.region");
        bucketName = props.getProperty("aws.s3.bucket");

        if (accessKeyId == null || secretKey == null || region == null || bucketName == null) {
            LOGGER.severe("Thiếu thông tin cấu hình AWS trong application.properties");
            throw new RuntimeException("Thiếu thông tin cấu hình AWS");
        }

        AwsBasicCredentials credentials = AwsBasicCredentials.create(accessKeyId, secretKey);
        s3Client = S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(credentials))
                .build();
    }

    @Override
    public String saveFile(Part part, String subDir) {
        if (part == null || part.getSize() == 0) {
            LOGGER.warning("Tệp tải lên rỗng hoặc không hợp lệ");
            return null;
        }

        String fileName = part.getSubmittedFileName().replace(" ", "_");
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        if (!extension.equals("mp4")) {
            LOGGER.warning("Chỉ hỗ trợ định dạng video MP4, nhận được: " + extension);
            throw new IllegalArgumentException("Chỉ hỗ trợ định dạng video MP4");
        }

        String key = UPLOAD_DIR + subDir + "/" + fileName;

        try {
            String contentType = part.getContentType();
            if (contentType == null || !contentType.equals("video/mp4")) {
                contentType = "video/mp4";
            }

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(contentType)
                    .acl("public-read") // Đặt quyền công khai
                    .build();
            s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(part.getInputStream(), part.getSize()));
            String fileUrl = String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
            LOGGER.info("Tải lên S3 thành công: " + fileUrl);
            return fileUrl;
        } catch (IOException ex) {
            LOGGER.severe("Lỗi tải lên S3: " + ex.getMessage());
            throw new RuntimeException("Lỗi tải lên S3: " + ex.getMessage());
        }
    }

    @Override
    public void deleteFile(String fileUrl) {
        if (fileUrl == null || fileUrl.trim().isEmpty()) {
            LOGGER.warning("URL tệp rỗng hoặc không hợp lệ");
            return;
        }
        String key = fileUrl.replace(String.format("https://%s.s3.%s.amazonaws.com/", bucketName, region), "");
        try {
            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();
            s3Client.deleteObject(deleteObjectRequest);
            LOGGER.info("Đã xóa tệp khỏi S3: " + key);
        } catch (Exception ex) {
            LOGGER.severe("Lỗi xóa tệp khỏi S3: " + ex.getMessage());
        }
    }
}