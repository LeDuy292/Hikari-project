package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.*;
import java.net.URI;
import java.net.http.*;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import constant.ApiConstants;

public class SightengineClientService {

    private static final String API_USER = ApiConstants.SIGHTENGINE_API_USER;
    private static final String API_SECRET = ApiConstants.SIGHTENGINE_API_SECRET;

    public static class ImageSafetyResult {

        public boolean isSafe;
        public List<String> violations;

        public ImageSafetyResult(boolean isSafe, List<String> violations) {
            this.isSafe = isSafe;
            this.violations = violations;
        }
    }

    public ImageSafetyResult isImageSafe(byte[] imageBytes, String contentType) throws IOException, InterruptedException {
        File tempFile = File.createTempFile("upload-", ".img");
        Files.write(tempFile.toPath(), imageBytes);

        String boundary = "Boundary-" + System.currentTimeMillis();
        var byteArrays = new ByteArrayOutputStream();
        var writer = new PrintWriter(new OutputStreamWriter(byteArrays));

        writer.append("--" + boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"media\"; filename=\"" + tempFile.getName() + "\"\r\n");
        writer.append("Content-Type: " + contentType + "\r\n\r\n").flush();

        Files.copy(tempFile.toPath(), byteArrays);
        byteArrays.write("\r\n".getBytes());
        writer.append("--" + boundary + "--").append("\r\n").flush();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.sightengine.com/1.0/check.json"
                        + "?models=nudity,wad,offensive"
                        + "&api_user=" + API_USER
                        + "&api_secret=" + API_SECRET))
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofByteArray(byteArrays.toByteArray()))
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(response.body());

        double nudity = root.path("nudity").path("raw").asDouble(0);
        double weapon = root.path("weapon").asDouble(0.0);
        double alcohol = root.path("alcohol").asDouble(0.0);
        double drugs = root.path("drugs").asDouble(0.0);

        List<String> violations = new ArrayList<>();
        if (nudity >= 0.5) {
            violations.add("Phát hiện nội dung khỏa thân");
        }
        if (weapon >= 0.5) {
            violations.add("Phát hiện vũ khí");
        }
        if (alcohol >= 0.5) {
            violations.add("Phát hiện rượu bia");
        }
        if (drugs >= 0.5) {
            violations.add("Phát hiện ma túy");
        }

        boolean isSafe = violations.isEmpty();
        return new ImageSafetyResult(isSafe, violations);
    }
}
