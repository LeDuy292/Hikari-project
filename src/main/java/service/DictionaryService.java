package service;

import com.google.gson.Gson;
import dao.DictionaryDAO;
import model.JishoEntry;
import model.SearchHistory;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

public class DictionaryService {

    private static final String JISHO_API_URL = "https://jisho.org/api/v1/search/words?keyword=";
    private static final Map<String, JishoEntry> cache = new ConcurrentHashMap<>();
    private final Gson gson = new Gson();
    private final DictionaryDAO dictionaryDAO = new DictionaryDAO();

    // Timeout configuration
    private static final int CONNECTION_TIMEOUT = 5000; // 5 seconds
    private static final int SOCKET_TIMEOUT = 8000; // 8 seconds

    private static final Pattern JAPANESE_PATTERN = Pattern.compile("[\\u3040-\\u309F\\u30A0-\\u30FF\\u4E00-\\u9FAF]");
    private static final Pattern VIETNAMESE_PATTERN = Pattern.compile("[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđĐ]");

    // Từ điển Anh-Việt để dịch kết quả từ Jisho API
    private static final Map<String, String> ENGLISH_TO_VIETNAMESE = new HashMap<>();
    
    // Từ điển Việt-Anh để tìm kiếm từ tiếng Nhật qua Jisho API
    private static final Map<String, String> VIETNAMESE_TO_ENGLISH = new HashMap<>();
    
    static {
        initializeTranslationDictionaries();
    }
    
    private static void initializeTranslationDictionaries() {
        // Từ điển Anh-Việt cho các từ loại
        ENGLISH_TO_VIETNAMESE.put("noun", "danh từ");
        ENGLISH_TO_VIETNAMESE.put("verb", "động từ");
        ENGLISH_TO_VIETNAMESE.put("adjective", "tính từ");
        ENGLISH_TO_VIETNAMESE.put("adverb", "trạng từ");
        ENGLISH_TO_VIETNAMESE.put("particle", "trợ từ");
        ENGLISH_TO_VIETNAMESE.put("pronoun", "đại từ");
        ENGLISH_TO_VIETNAMESE.put("conjunction", "liên từ");
        ENGLISH_TO_VIETNAMESE.put("interjection", "thán từ");
        ENGLISH_TO_VIETNAMESE.put("expression", "cụm từ");
        ENGLISH_TO_VIETNAMESE.put("counter", "từ đếm");
        ENGLISH_TO_VIETNAMESE.put("prefix", "tiền tố");
        ENGLISH_TO_VIETNAMESE.put("suffix", "hậu tố");
        ENGLISH_TO_VIETNAMESE.put("auxiliary verb", "trợ động từ");
        ENGLISH_TO_VIETNAMESE.put("i-adjective", "tính từ đuôi い");
        ENGLISH_TO_VIETNAMESE.put("na-adjective", "tính từ đuôi な");
        ENGLISH_TO_VIETNAMESE.put("godan verb", "động từ nhóm 1");
        ENGLISH_TO_VIETNAMESE.put("ichidan verb", "động từ nhóm 2");
        ENGLISH_TO_VIETNAMESE.put("irregular verb", "động từ bất quy tắc");
        
        // Từ vựng cơ bản Anh-Việt
        ENGLISH_TO_VIETNAMESE.put("hello", "xin chào");
        ENGLISH_TO_VIETNAMESE.put("goodbye", "tạm biệt");
        ENGLISH_TO_VIETNAMESE.put("thank you", "cảm ơn");
        ENGLISH_TO_VIETNAMESE.put("thanks", "cảm ơn");
        ENGLISH_TO_VIETNAMESE.put("please", "xin lỗi");
        ENGLISH_TO_VIETNAMESE.put("excuse me", "xin lỗi");
        ENGLISH_TO_VIETNAMESE.put("sorry", "xin lỗi");
        ENGLISH_TO_VIETNAMESE.put("yes", "có");
        ENGLISH_TO_VIETNAMESE.put("no", "không");
        ENGLISH_TO_VIETNAMESE.put("water", "nước");
        ENGLISH_TO_VIETNAMESE.put("food", "thức ăn");
        ENGLISH_TO_VIETNAMESE.put("eat", "ăn");
        ENGLISH_TO_VIETNAMESE.put("drink", "uống");
        ENGLISH_TO_VIETNAMESE.put("house", "nhà");
        ENGLISH_TO_VIETNAMESE.put("home", "nhà");
        ENGLISH_TO_VIETNAMESE.put("school", "trường học");
        ENGLISH_TO_VIETNAMESE.put("book", "sách");
        ENGLISH_TO_VIETNAMESE.put("student", "học sinh");
        ENGLISH_TO_VIETNAMESE.put("teacher", "giáo viên");
        ENGLISH_TO_VIETNAMESE.put("friend", "bạn");
        ENGLISH_TO_VIETNAMESE.put("family", "gia đình");
        ENGLISH_TO_VIETNAMESE.put("time", "thời gian");
        ENGLISH_TO_VIETNAMESE.put("day", "ngày");
        ENGLISH_TO_VIETNAMESE.put("night", "đêm");
        ENGLISH_TO_VIETNAMESE.put("morning", "buổi sáng");
        ENGLISH_TO_VIETNAMESE.put("afternoon", "buổi chiều");
        ENGLISH_TO_VIETNAMESE.put("evening", "buổi tối");
        ENGLISH_TO_VIETNAMESE.put("go", "đi");
        ENGLISH_TO_VIETNAMESE.put("come", "đến");
        ENGLISH_TO_VIETNAMESE.put("see", "nhìn");
        ENGLISH_TO_VIETNAMESE.put("look", "xem");
        ENGLISH_TO_VIETNAMESE.put("watch", "xem");
        ENGLISH_TO_VIETNAMESE.put("hear", "nghe");
        ENGLISH_TO_VIETNAMESE.put("listen", "nghe");
        ENGLISH_TO_VIETNAMESE.put("speak", "nói");
        ENGLISH_TO_VIETNAMESE.put("talk", "nói chuyện");
        ENGLISH_TO_VIETNAMESE.put("say", "nói");
        ENGLISH_TO_VIETNAMESE.put("read", "đọc");
        ENGLISH_TO_VIETNAMESE.put("write", "viết");
        ENGLISH_TO_VIETNAMESE.put("study", "học");
        ENGLISH_TO_VIETNAMESE.put("learn", "học");
        ENGLISH_TO_VIETNAMESE.put("work", "làm việc");
        ENGLISH_TO_VIETNAMESE.put("play", "chơi");
        ENGLISH_TO_VIETNAMESE.put("sleep", "ngủ");
        ENGLISH_TO_VIETNAMESE.put("wake up", "thức dậy");
        ENGLISH_TO_VIETNAMESE.put("buy", "mua");
        ENGLISH_TO_VIETNAMESE.put("sell", "bán");
        ENGLISH_TO_VIETNAMESE.put("give", "cho");
        ENGLISH_TO_VIETNAMESE.put("take", "lấy");
        ENGLISH_TO_VIETNAMESE.put("receive", "nhận");
        ENGLISH_TO_VIETNAMESE.put("love", "yêu");
        ENGLISH_TO_VIETNAMESE.put("like", "thích");
        ENGLISH_TO_VIETNAMESE.put("hate", "ghét");
        ENGLISH_TO_VIETNAMESE.put("big", "to");
        ENGLISH_TO_VIETNAMESE.put("large", "lớn");
        ENGLISH_TO_VIETNAMESE.put("small", "nhỏ");
        ENGLISH_TO_VIETNAMESE.put("little", "nhỏ");
        ENGLISH_TO_VIETNAMESE.put("good", "tốt");
        ENGLISH_TO_VIETNAMESE.put("nice", "đẹp");
        ENGLISH_TO_VIETNAMESE.put("bad", "xấu");
        ENGLISH_TO_VIETNAMESE.put("new", "mới");
        ENGLISH_TO_VIETNAMESE.put("old", "cũ");
        ENGLISH_TO_VIETNAMESE.put("hot", "nóng");
        ENGLISH_TO_VIETNAMESE.put("cold", "lạnh");
        ENGLISH_TO_VIETNAMESE.put("warm", "ấm");
        ENGLISH_TO_VIETNAMESE.put("cool", "mát");
        ENGLISH_TO_VIETNAMESE.put("fast", "nhanh");
        ENGLISH_TO_VIETNAMESE.put("quick", "nhanh");
        ENGLISH_TO_VIETNAMESE.put("slow", "chậm");
        ENGLISH_TO_VIETNAMESE.put("beautiful", "đẹp");
        ENGLISH_TO_VIETNAMESE.put("pretty", "xinh");
        ENGLISH_TO_VIETNAMESE.put("ugly", "xấu");
        ENGLISH_TO_VIETNAMESE.put("happy", "vui");
        ENGLISH_TO_VIETNAMESE.put("sad", "buồn");
        ENGLISH_TO_VIETNAMESE.put("angry", "tức giận");
        ENGLISH_TO_VIETNAMESE.put("tired", "mệt");
        ENGLISH_TO_VIETNAMESE.put("hungry", "đói");
        ENGLISH_TO_VIETNAMESE.put("thirsty", "khát");
        ENGLISH_TO_VIETNAMESE.put("money", "tiền");
        ENGLISH_TO_VIETNAMESE.put("car", "xe hơi");
        ENGLISH_TO_VIETNAMESE.put("train", "tàu hỏa");
        ENGLISH_TO_VIETNAMESE.put("bus", "xe buýt");
        ENGLISH_TO_VIETNAMESE.put("airplane", "máy bay");
        ENGLISH_TO_VIETNAMESE.put("phone", "điện thoại");
        ENGLISH_TO_VIETNAMESE.put("computer", "máy tính");
        ENGLISH_TO_VIETNAMESE.put("television", "tivi");
        ENGLISH_TO_VIETNAMESE.put("music", "âm nhạc");
        ENGLISH_TO_VIETNAMESE.put("movie", "phim");
        ENGLISH_TO_VIETNAMESE.put("game", "trò chơi");
        ENGLISH_TO_VIETNAMESE.put("sport", "thể thao");
        ENGLISH_TO_VIETNAMESE.put("color", "màu sắc");
        ENGLISH_TO_VIETNAMESE.put("red", "đỏ");
        ENGLISH_TO_VIETNAMESE.put("blue", "xanh dương");
        ENGLISH_TO_VIETNAMESE.put("green", "xanh lá");
        ENGLISH_TO_VIETNAMESE.put("yellow", "vàng");
        ENGLISH_TO_VIETNAMESE.put("black", "đen");
        ENGLISH_TO_VIETNAMESE.put("white", "trắng");
        ENGLISH_TO_VIETNAMESE.put("brown", "nâu");
        ENGLISH_TO_VIETNAMESE.put("pink", "hồng");
        ENGLISH_TO_VIETNAMESE.put("purple", "tím");
        ENGLISH_TO_VIETNAMESE.put("orange", "cam");
        ENGLISH_TO_VIETNAMESE.put("gray", "xám");
        ENGLISH_TO_VIETNAMESE.put("grey", "xám");
        ENGLISH_TO_VIETNAMESE.put("father", "bố");
        ENGLISH_TO_VIETNAMESE.put("mother", "mẹ");
        ENGLISH_TO_VIETNAMESE.put("brother", "anh em trai");
        ENGLISH_TO_VIETNAMESE.put("sister", "chị em gái");
        ENGLISH_TO_VIETNAMESE.put("grandfather", "ông");
        ENGLISH_TO_VIETNAMESE.put("grandmother", "bà");
        ENGLISH_TO_VIETNAMESE.put("rice", "cơm");
        ENGLISH_TO_VIETNAMESE.put("bread", "bánh mì");
        ENGLISH_TO_VIETNAMESE.put("meat", "thịt");
        ENGLISH_TO_VIETNAMESE.put("fish", "cá");
        ENGLISH_TO_VIETNAMESE.put("vegetable", "rau");
        ENGLISH_TO_VIETNAMESE.put("fruit", "trái cây");
        ENGLISH_TO_VIETNAMESE.put("tea", "trà");
        ENGLISH_TO_VIETNAMESE.put("coffee", "cà phê");
        ENGLISH_TO_VIETNAMESE.put("milk", "sữa");
        ENGLISH_TO_VIETNAMESE.put("beer", "bia");
        ENGLISH_TO_VIETNAMESE.put("wine", "rượu");
        ENGLISH_TO_VIETNAMESE.put("restaurant", "nhà hàng");
        ENGLISH_TO_VIETNAMESE.put("hotel", "khách sạn");
        ENGLISH_TO_VIETNAMESE.put("hospital", "bệnh viện");
        ENGLISH_TO_VIETNAMESE.put("bank", "ngân hàng");
        ENGLISH_TO_VIETNAMESE.put("station", "ga");
        ENGLISH_TO_VIETNAMESE.put("airport", "sân bay");
        ENGLISH_TO_VIETNAMESE.put("store", "cửa hàng");
        ENGLISH_TO_VIETNAMESE.put("shop", "cửa hàng");
        ENGLISH_TO_VIETNAMESE.put("company", "công ty");
        ENGLISH_TO_VIETNAMESE.put("office", "văn phòng");
        ENGLISH_TO_VIETNAMESE.put("doctor", "bác sĩ");
        ENGLISH_TO_VIETNAMESE.put("nurse", "y tá");
        ENGLISH_TO_VIETNAMESE.put("police", "cảnh sát");
        ENGLISH_TO_VIETNAMESE.put("driver", "tài xế");
        ENGLISH_TO_VIETNAMESE.put("one", "một");
        ENGLISH_TO_VIETNAMESE.put("two", "hai");
        ENGLISH_TO_VIETNAMESE.put("three", "ba");
        ENGLISH_TO_VIETNAMESE.put("four", "bốn");
        ENGLISH_TO_VIETNAMESE.put("five", "năm");
        ENGLISH_TO_VIETNAMESE.put("six", "sáu");
        ENGLISH_TO_VIETNAMESE.put("seven", "bảy");
        ENGLISH_TO_VIETNAMESE.put("eight", "tám");
        ENGLISH_TO_VIETNAMESE.put("nine", "chín");
        ENGLISH_TO_VIETNAMESE.put("ten", "mười");
        
        // Từ điển Việt-Anh (để tìm kiếm trong Jisho API)
        VIETNAMESE_TO_ENGLISH.put("xin chào", "hello");
        VIETNAMESE_TO_ENGLISH.put("chào", "hello");
        VIETNAMESE_TO_ENGLISH.put("tạm biệt", "goodbye");
        VIETNAMESE_TO_ENGLISH.put("cảm ơn", "thank you");
        VIETNAMESE_TO_ENGLISH.put("xin lỗi", "sorry");
        VIETNAMESE_TO_ENGLISH.put("có", "yes");
        VIETNAMESE_TO_ENGLISH.put("không", "no");
        VIETNAMESE_TO_ENGLISH.put("nước", "water");
        VIETNAMESE_TO_ENGLISH.put("thức ăn", "food");
        VIETNAMESE_TO_ENGLISH.put("ăn", "eat");
        VIETNAMESE_TO_ENGLISH.put("uống", "drink");
        VIETNAMESE_TO_ENGLISH.put("nhà", "house");
        VIETNAMESE_TO_ENGLISH.put("trường", "school");
        VIETNAMESE_TO_ENGLISH.put("trường học", "school");
        VIETNAMESE_TO_ENGLISH.put("sách", "book");
        VIETNAMESE_TO_ENGLISH.put("học sinh", "student");
        VIETNAMESE_TO_ENGLISH.put("sinh viên", "student");
        VIETNAMESE_TO_ENGLISH.put("giáo viên", "teacher");
        VIETNAMESE_TO_ENGLISH.put("thầy", "teacher");
        VIETNAMESE_TO_ENGLISH.put("cô", "teacher");
        VIETNAMESE_TO_ENGLISH.put("bạn", "friend");
        VIETNAMESE_TO_ENGLISH.put("bạn bè", "friend");
        VIETNAMESE_TO_ENGLISH.put("gia đình", "family");
        VIETNAMESE_TO_ENGLISH.put("thời gian", "time");
        VIETNAMESE_TO_ENGLISH.put("ngày", "day");
        VIETNAMESE_TO_ENGLISH.put("đêm", "night");
        VIETNAMESE_TO_ENGLISH.put("buổi sáng", "morning");
        VIETNAMESE_TO_ENGLISH.put("sáng", "morning");
        VIETNAMESE_TO_ENGLISH.put("buổi chiều", "afternoon");
        VIETNAMESE_TO_ENGLISH.put("chiều", "afternoon");
        VIETNAMESE_TO_ENGLISH.put("buổi tối", "evening");
        VIETNAMESE_TO_ENGLISH.put("tối", "evening");
        VIETNAMESE_TO_ENGLISH.put("đi", "go");
        VIETNAMESE_TO_ENGLISH.put("đến", "come");
        VIETNAMESE_TO_ENGLISH.put("nhìn", "see");
        VIETNAMESE_TO_ENGLISH.put("xem", "watch");
        VIETNAMESE_TO_ENGLISH.put("nghe", "hear");
        VIETNAMESE_TO_ENGLISH.put("nói", "speak");
        VIETNAMESE_TO_ENGLISH.put("đọc", "read");
        VIETNAMESE_TO_ENGLISH.put("viết", "write");
        VIETNAMESE_TO_ENGLISH.put("học", "study");
        VIETNAMESE_TO_ENGLISH.put("làm việc", "work");
        VIETNAMESE_TO_ENGLISH.put("chơi", "play");
        VIETNAMESE_TO_ENGLISH.put("ngủ", "sleep");
        VIETNAMESE_TO_ENGLISH.put("thức dậy", "wake up");
        VIETNAMESE_TO_ENGLISH.put("mua", "buy");
        VIETNAMESE_TO_ENGLISH.put("bán", "sell");
        VIETNAMESE_TO_ENGLISH.put("cho", "give");
        VIETNAMESE_TO_ENGLISH.put("lấy", "take");
        VIETNAMESE_TO_ENGLISH.put("nhận", "receive");
        VIETNAMESE_TO_ENGLISH.put("yêu", "love");
        VIETNAMESE_TO_ENGLISH.put("thích", "like");
        VIETNAMESE_TO_ENGLISH.put("ghét", "hate");
        VIETNAMESE_TO_ENGLISH.put("to", "big");
        VIETNAMESE_TO_ENGLISH.put("lớn", "big");
        VIETNAMESE_TO_ENGLISH.put("nhỏ", "small");
        VIETNAMESE_TO_ENGLISH.put("tốt", "good");
        VIETNAMESE_TO_ENGLISH.put("đẹp", "beautiful");
        VIETNAMESE_TO_ENGLISH.put("xấu", "bad");
        VIETNAMESE_TO_ENGLISH.put("mới", "new");
        VIETNAMESE_TO_ENGLISH.put("cũ", "old");
        VIETNAMESE_TO_ENGLISH.put("nóng", "hot");
        VIETNAMESE_TO_ENGLISH.put("lạnh", "cold");
        VIETNAMESE_TO_ENGLISH.put("ấm", "warm");
        VIETNAMESE_TO_ENGLISH.put("mát", "cool");
        VIETNAMESE_TO_ENGLISH.put("nhanh", "fast");
        VIETNAMESE_TO_ENGLISH.put("chậm", "slow");
        VIETNAMESE_TO_ENGLISH.put("xinh", "pretty");
        VIETNAMESE_TO_ENGLISH.put("vui", "happy");
        VIETNAMESE_TO_ENGLISH.put("buồn", "sad");
        VIETNAMESE_TO_ENGLISH.put("tức giận", "angry");
        VIETNAMESE_TO_ENGLISH.put("mệt", "tired");
        VIETNAMESE_TO_ENGLISH.put("đói", "hungry");
        VIETNAMESE_TO_ENGLISH.put("khát", "thirsty");
        VIETNAMESE_TO_ENGLISH.put("tiền", "money");
        VIETNAMESE_TO_ENGLISH.put("xe", "car");
        VIETNAMESE_TO_ENGLISH.put("xe hơi", "car");
        VIETNAMESE_TO_ENGLISH.put("tàu", "train");
        VIETNAMESE_TO_ENGLISH.put("tàu hỏa", "train");
        VIETNAMESE_TO_ENGLISH.put("xe buýt", "bus");
        VIETNAMESE_TO_ENGLISH.put("máy bay", "airplane");
        VIETNAMESE_TO_ENGLISH.put("điện thoại", "phone");
        VIETNAMESE_TO_ENGLISH.put("máy tính", "computer");
        VIETNAMESE_TO_ENGLISH.put("tivi", "television");
        VIETNAMESE_TO_ENGLISH.put("âm nhạc", "music");
        VIETNAMESE_TO_ENGLISH.put("phim", "movie");
        VIETNAMESE_TO_ENGLISH.put("trò chơi", "game");
        VIETNAMESE_TO_ENGLISH.put("thể thao", "sport");
        VIETNAMESE_TO_ENGLISH.put("màu", "color");
        VIETNAMESE_TO_ENGLISH.put("màu sắc", "color");
        VIETNAMESE_TO_ENGLISH.put("đỏ", "red");
        VIETNAMESE_TO_ENGLISH.put("xanh", "blue");
        VIETNAMESE_TO_ENGLISH.put("xanh dương", "blue");
        VIETNAMESE_TO_ENGLISH.put("xanh lá", "green");
        VIETNAMESE_TO_ENGLISH.put("vàng", "yellow");
        VIETNAMESE_TO_ENGLISH.put("đen", "black");
        VIETNAMESE_TO_ENGLISH.put("trắng", "white");
        VIETNAMESE_TO_ENGLISH.put("nâu", "brown");
        VIETNAMESE_TO_ENGLISH.put("hồng", "pink");
        VIETNAMESE_TO_ENGLISH.put("tím", "purple");
        VIETNAMESE_TO_ENGLISH.put("cam", "orange");
        VIETNAMESE_TO_ENGLISH.put("xám", "gray");
        VIETNAMESE_TO_ENGLISH.put("bố", "father");
        VIETNAMESE_TO_ENGLISH.put("mẹ", "mother");
        VIETNAMESE_TO_ENGLISH.put("anh", "brother");
        VIETNAMESE_TO_ENGLISH.put("chị", "sister");
        VIETNAMESE_TO_ENGLISH.put("em", "younger sibling");
        VIETNAMESE_TO_ENGLISH.put("ông", "grandfather");
        VIETNAMESE_TO_ENGLISH.put("bà", "grandmother");
        VIETNAMESE_TO_ENGLISH.put("cơm", "rice");
        VIETNAMESE_TO_ENGLISH.put("bánh mì", "bread");
        VIETNAMESE_TO_ENGLISH.put("thịt", "meat");
        VIETNAMESE_TO_ENGLISH.put("cá", "fish");
        VIETNAMESE_TO_ENGLISH.put("rau", "vegetable");
        VIETNAMESE_TO_ENGLISH.put("trái cây", "fruit");
        VIETNAMESE_TO_ENGLISH.put("trà", "tea");
        VIETNAMESE_TO_ENGLISH.put("cà phê", "coffee");
        VIETNAMESE_TO_ENGLISH.put("sữa", "milk");
        VIETNAMESE_TO_ENGLISH.put("bia", "beer");
        VIETNAMESE_TO_ENGLISH.put("rượu", "wine");
        VIETNAMESE_TO_ENGLISH.put("nhà hàng", "restaurant");
        VIETNAMESE_TO_ENGLISH.put("khách sạn", "hotel");
        VIETNAMESE_TO_ENGLISH.put("bệnh viện", "hospital");
        VIETNAMESE_TO_ENGLISH.put("ngân hàng", "bank");
        VIETNAMESE_TO_ENGLISH.put("ga", "station");
        VIETNAMESE_TO_ENGLISH.put("sân bay", "airport");
        VIETNAMESE_TO_ENGLISH.put("cửa hàng", "store");
        VIETNAMESE_TO_ENGLISH.put("công ty", "company");
        VIETNAMESE_TO_ENGLISH.put("văn phòng", "office");
        VIETNAMESE_TO_ENGLISH.put("bác sĩ", "doctor");
        VIETNAMESE_TO_ENGLISH.put("y tá", "nurse");
        VIETNAMESE_TO_ENGLISH.put("cảnh sát", "police");
        VIETNAMESE_TO_ENGLISH.put("tài xế", "driver");
        VIETNAMESE_TO_ENGLISH.put("một", "one");
        VIETNAMESE_TO_ENGLISH.put("hai", "two");
        VIETNAMESE_TO_ENGLISH.put("ba", "three");
        VIETNAMESE_TO_ENGLISH.put("bốn", "four");
        VIETNAMESE_TO_ENGLISH.put("năm", "five");
        VIETNAMESE_TO_ENGLISH.put("sáu", "six");
        VIETNAMESE_TO_ENGLISH.put("bảy", "seven");
        VIETNAMESE_TO_ENGLISH.put("tám", "eight");
        VIETNAMESE_TO_ENGLISH.put("chín", "nine");
        VIETNAMESE_TO_ENGLISH.put("mười", "ten");
    }

    private boolean isJapanese(String text) {
        return JAPANESE_PATTERN.matcher(text).find();
    }

    private boolean isVietnamese(String text) {
        return VIETNAMESE_PATTERN.matcher(text).find() || 
               (!isJapanese(text) && text.matches(".*[a-zA-ZÀ-ỹ].*"));
    }

    /**
     * Dịch từ tiếng Anh sang tiếng Việt (cho kết quả từ Jisho API)
     */
    private String translateEnglishToVietnamese(String englishText) {
        if (englishText == null || englishText.trim().isEmpty()) {
            return englishText;
        }

        String lowerText = englishText.toLowerCase().trim();
        
        // Tìm trong từ điển trực tiếp
        if (ENGLISH_TO_VIETNAMESE.containsKey(lowerText)) {
            return ENGLISH_TO_VIETNAMESE.get(lowerText);
        }

        // Tìm kiếm từng phần trong cụm từ
        for (Map.Entry<String, String> entry : ENGLISH_TO_VIETNAMESE.entrySet()) {
            if (lowerText.contains(entry.getKey())) {
                return entry.getValue();
            }
        }

        // Nếu không tìm thấy, trả về nguyên văn
        return englishText;
    }

    /**
     * Dịch từ tiếng Việt sang tiếng Anh (để tìm kiếm trong Jisho API)
     */
    private String translateVietnameseToEnglish(String vietnameseText) {
        if (vietnameseText == null || vietnameseText.trim().isEmpty()) {
            return vietnameseText;
        }

        String lowerText = vietnameseText.toLowerCase().trim();
        
        // Tìm trong từ điển trực tiếp
        if (VIETNAMESE_TO_ENGLISH.containsKey(lowerText)) {
            return VIETNAMESE_TO_ENGLISH.get(lowerText);
        }

        // Tìm kiếm từng phần trong cụm từ
        for (Map.Entry<String, String> entry : VIETNAMESE_TO_ENGLISH.entrySet()) {
            if (lowerText.contains(entry.getKey())) {
                return entry.getValue();
            }
        }

        // Nếu không tìm thấy, trả về nguyên văn để thử tìm kiếm
        return vietnameseText;
    }

    /**
     * Tìm kiếm từ tiếng Việt trong từ điển Nhật-Việt (qua Jisho API)
     */
    private List<JishoEntry.JishoData> searchVietnameseToJapanese(String vietnameseKeyword) throws IOException {
        // Dịch từ tiếng Việt sang tiếng Anh
        String englishKeyword = translateVietnameseToEnglish(vietnameseKeyword);
        
        // Tìm kiếm bằng từ tiếng Anh trong Jisho API
        return searchJishoAPI(englishKeyword);
    }

    /**
     * Gọi Jisho API để tìm kiếm từ
     */
    private List<JishoEntry.JishoData> searchJishoAPI(String keyword) throws IOException {
        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString());
        String apiUrl = JISHO_API_URL + encodedKeyword;

        // Configure timeout
        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(CONNECTION_TIMEOUT)
                .setSocketTimeout(SOCKET_TIMEOUT)
                .build();

        try (CloseableHttpClient httpClient = HttpClients.custom()
                .setDefaultRequestConfig(config)
                .build()) {
                
            HttpGet httpGet = new HttpGet(apiUrl);
            httpGet.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");

            try (CloseableHttpResponse httpResponse = httpClient.execute(httpGet)) {
                if (httpResponse.getStatusLine().getStatusCode() != 200) {
                    throw new IOException("Jisho API trả về mã lỗi: " + httpResponse.getStatusLine().getStatusCode());
                }

                String jsonResponse = EntityUtils.toString(httpResponse.getEntity(), StandardCharsets.UTF_8);
                JishoEntry jishoEntry = gson.fromJson(jsonResponse, JishoEntry.class);

                if (jishoEntry != null && jishoEntry.getData() != null && !jishoEntry.getData().isEmpty()) {
                    // Dịch các định nghĩa từ tiếng Anh sang tiếng Việt
                    translateDefinitionsToVietnamese(jishoEntry.getData());
                    return jishoEntry.getData();
                }
                return Collections.emptyList();
            }
        } catch (Exception e) {
            Logger.getLogger(DictionaryService.class.getName()).log(Level.SEVERE, "Lỗi khi gọi Jisho API", e);
            throw new IOException("Lỗi khi gọi Jisho API: " + e.getMessage());
        }
    }

    /**
     * Dịch các định nghĩa từ tiếng Anh sang tiếng Việt
     */
    private void translateDefinitionsToVietnamese(List<JishoEntry.JishoData> dataList) {
        for (JishoEntry.JishoData data : dataList) {
            if (data.getSenses() != null) {
                for (JishoEntry.Sense sense : data.getSenses()) {
                    if (sense.getEnglish_definitions() != null) {
                        List<String> vietnameseDefinitions = new ArrayList<>();
                        for (String englishDef : sense.getEnglish_definitions()) {
                            String vietnameseDef = translateEnglishToVietnamese(englishDef);
                            vietnameseDefinitions.add(vietnameseDef);
                        }
                        sense.setVietnamese_definitions(vietnameseDefinitions);
                    }
                }
            }
        }
    }

    /**
     * Tìm kiếm từ điển chính - hỗ trợ Nhật-Việt và Việt-Nhật qua Jisho API
     */
    public List<JishoEntry.JishoData> searchDictionary(String keyword, String userIdentifier) throws IOException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        keyword = keyword.trim();
        if (keyword.length() > 255) {
            throw new IllegalArgumentException("Từ khóa quá dài, tối đa 255 ký tự.");
        }

        // Kiểm tra cache trước
        JishoEntry cachedEntry = cache.get(keyword);
        if (cachedEntry != null && cachedEntry.getData() != null && !cachedEntry.getData().isEmpty()) {
            return cachedEntry.getData();
        }

        List<JishoEntry.JishoData> results;

        try {
            // Xác định ngôn ngữ và tìm kiếm tương ứng
            if (isJapanese(keyword)) {
                // Tìm kiếm từ tiếng Nhật → kết quả tiếng Việt (qua Jisho API)
                results = searchJishoAPI(keyword);
            } else if (isVietnamese(keyword)) {
                // Tìm kiếm từ tiếng Việt → từ tiếng Nhật (qua Jisho API)
                results = searchVietnameseToJapanese(keyword);
            } else {
                // Mặc định tìm kiếm như tiếng Anh (qua Jisho API)
                results = searchJishoAPI(keyword);
            }

            if (!results.isEmpty()) {
                // Lưu vào cache
                JishoEntry entryToCache = new JishoEntry();
                entryToCache.setData(results);
                cache.put(keyword, entryToCache);
                
                // Lưu lịch sử tìm kiếm (đồng bộ để tránh lỗi lambda)
                final String finalKeyword = keyword;
                final String finalUserIdentifier = userIdentifier;
                try {
                    SearchHistory searchHistory = new SearchHistory(finalKeyword, finalUserIdentifier);
                    dictionaryDAO.addSearchHistory(searchHistory);
                } catch (Exception e) {
                    Logger.getLogger(DictionaryService.class.getName()).log(Level.WARNING, 
                            "Lỗi khi lưu lịch sử tìm kiếm", e);
                }
            }

            return results;
        } catch (Exception e) {
            Logger.getLogger(DictionaryService.class.getName()).log(Level.SEVERE, 
                    "Lỗi khi tìm kiếm từ điển: " + keyword, e);
            throw new IOException("Lỗi khi tìm kiếm: " + e.getMessage());
        }
    }

    /**
     * Lấy lịch sử tìm kiếm gần đây
     */
    public List<SearchHistory> getRecentSearchHistory(String userIdentifier, int limit) {
        try {
            return dictionaryDAO.getRecentSearchHistory(userIdentifier, limit);
        } catch (Exception e) {
            Logger.getLogger(DictionaryService.class.getName()).log(Level.WARNING, 
                    "Lỗi khi lấy lịch sử tìm kiếm", e);
            return Collections.emptyList();
        }
    }
}
