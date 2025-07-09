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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ForumImageRepository {

    private static final Logger LOGGER = Logger.getLogger(ForumImageRepository.class.getName());
    private final S3Client s3Client;
    private final String bucketName;
    private final String region;

    public ForumImageRepository() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                LOGGER.severe("Không tìm thấy application.properties");
                throw new RuntimeException("Thiếu application.properties");
            }
            props.load(input);
        } catch (IOException ex) {
            LOGGER.severe("Lỗi đọc application.properties: " + ex.getMessage());
            throw new RuntimeException("Lỗi cấu hình AWS");
        }

        String accessKeyId = props.getProperty("aws.accessKeyId");
        String secretKey = props.getProperty("aws.secretKey");
        region = props.getProperty("aws.region");
        bucketName = props.getProperty("aws.s3.bucket");

        if (accessKeyId == null || secretKey == null || region == null || bucketName == null) {
            LOGGER.severe("Thiếu thông tin cấu hình AWS");
            throw new RuntimeException("Thiếu thông tin AWS");
        }

        AwsBasicCredentials credentials = AwsBasicCredentials.create(accessKeyId, secretKey);
        this.s3Client = S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(credentials))
                .build();
    }

    public String uploadPostImage(Part filePart, String userId) {
        return uploadImage(filePart, "forum/posts/" + userId + "/", 10 * 1024 * 1024, "forum-post");
    }

    public String uploadAvatarImage(Part filePart, String userId) {
        return uploadImage(filePart, "forum/avatars/" + userId + "/", 5 * 1024 * 1024, "avatar");
    }

    private String uploadImage(Part part, String keyPrefix, long maxSize, String uploadType) {
        if (part == null || part.getSize() == 0) {
            LOGGER.warning("Tệp tải lên rỗng");
            return null;
        }

        if (part.getSize() > maxSize) {
            LOGGER.warning("Kích thước tệp vượt quá giới hạn");
            return null;
        }

        String contentType = part.getContentType();
        if (!isValidImageType(contentType)) {
            LOGGER.warning("Loại tệp không hợp lệ: " + contentType);
            return null;
        }

        try {
            String originalFileName = getFileName(part);
            String fileExtension = getFileExtension(originalFileName);
            String encodedName = URLEncoder.encode(UUID.randomUUID() + fileExtension, StandardCharsets.UTF_8.toString()).replace("+", "_");
            String key = keyPrefix + encodedName;

            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(contentType)
                    .build();

            try (InputStream input = part.getInputStream()) {
                s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(input, part.getSize()));
            }

            String url = String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
            LOGGER.info("Tải lên S3 thành công: " + url);
            return url;

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Lỗi tải ảnh lên S3", ex);
            return null;
        }
    }

    public boolean deleteImage(String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            LOGGER.warning("URL ảnh không hợp lệ");
            return false;
        }

        try {
            String keyPrefix = String.format("https://%s.s3.%s.amazonaws.com/", bucketName, region);
            String key = imageUrl.replace(keyPrefix, "");

            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.deleteObject(deleteObjectRequest);
            LOGGER.info("Xóa ảnh thành công: " + key);
            return true;

        } catch (Exception ex) {
            LOGGER.severe("Lỗi xóa ảnh: " + ex.getMessage());
            return false;
        }
    }

    private boolean isValidImageType(String contentType) {
        return contentType != null && (
                contentType.equals("image/jpeg") ||
                contentType.equals("image/jpg") ||
                contentType.equals("image/png") ||
                contentType.equals("image/gif") ||
                contentType.equals("image/webp")
        );
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header != null) {
            for (String content : header.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "unknown.jpg";
    }

    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.contains(".")) {
            return fileName.substring(fileName.lastIndexOf("."));
        }
        return ".jpg";
    }

    public boolean isS3Available() {
        return s3Client != null;
    }
}
