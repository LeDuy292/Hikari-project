package utils;

import java.io.*;
import java.util.*;
import java.util.regex.Pattern;

public class ImprovedQADatabase {
    private Map<String, String> qaMap;
    private Map<String, Set<String>> synonymMap;
    private List<String> questions;
    private static ImprovedQADatabase instance;
    
    private ImprovedQADatabase() {
        qaMap = new HashMap<>();
        synonymMap = new HashMap<>();
        questions = new ArrayList<>();
        initializeSynonyms();
        loadQADatabase();
    }
    
    public static ImprovedQADatabase getInstance() {
        if (instance == null) {
            instance = new ImprovedQADatabase();
        }
        return instance;
    }
    
    private void initializeSynonyms() {
        // Từ đồng nghĩa cho học phí
        addSynonyms("học phí", "hoc phi", "chi phí", "chi phi", "giá", "gia", "tiền học", "tien hoc", "phí học", "phi hoc");
        addSynonyms("khóa học", "khoa hoc", "lớp học", "lop hoc", "course", "class");
        addSynonyms("như thế nào", "nhu the nao", "ra sao", "thế nào", "the nao", "như nào", "nhu nao");
        addSynonyms("bao nhiêu", "bao nhieu", "giá bao nhiêu", "gia bao nhieu", "chi phí bao nhiêu", "chi phi bao nhieu");
        
        // JLPT synonyms
        addSynonyms("jlpt", "thi jlpt", "kỳ thi", "ky thi", "thi cử", "thi cu");
        addSynonyms("n5", "n 5", "cấp 5", "cap 5", "trình độ 5", "trinh do 5");
        addSynonyms("n4", "n 4", "cấp 4", "cap 4", "trình độ 4", "trinh do 4");
        addSynonyms("n3", "n 3", "cấp 3", "cap 3", "trình độ 3", "trinh do 3");
        addSynonyms("n2", "n 2", "cấp 2", "cap 2", "trình độ 2", "trinh do 2");
        addSynonyms("n1", "n 1", "cấp 1", "cap 1", "trình độ 1", "trinh do 1");
        
        // Hikari synonyms
        addSynonyms("hikari", "hệ thống hikari", "he thong hikari", "nền tảng hikari", "nen tang hikari");
        
        // Kanji synonyms
        addSynonyms("kanji", "chữ hán", "chu han", "chữ kanji", "chu kanji");
        
        // Grammar synonyms
        addSynonyms("ngữ pháp", "ngu phap", "grammar", "văn phạm", "van pham");
        
        // Vocabulary synonyms
        addSynonyms("từ vựng", "tu vung", "vocabulary", "vocab", "từ ngữ", "tu ngu");
    }
    
    private void addSynonyms(String mainWord, String... synonyms) {
        Set<String> synSet = new HashSet<>();
        synSet.add(mainWord.toLowerCase());
        for (String syn : synonyms) {
            synSet.add(syn.toLowerCase());
        }
        
        // Add all combinations
        for (String word : synSet) {
            synonymMap.put(word, new HashSet<>(synSet));
        }
    }
    
    private void loadQADatabase() {
        try {
            InputStream is = getClass().getClassLoader().getResourceAsStream("resources/qa_database.txt");
            if (is == null) {
                File file = new File("qa_database.txt");
                if (file.exists()) {
                    is = new FileInputStream(file);
                }
            }
            
            if (is != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                String line;
                
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.startsWith("#") || line.isEmpty()) {
                        continue;
                    }
                    
                    if (line.startsWith("Q:") && line.contains("|") && line.contains("A:")) {
                        String[] parts = line.split("\\|", 2);
                        if (parts.length == 2) {
                            String question = parts[0].substring(2).trim();
                            String answer = parts[1].substring(2).trim();
                            
                            String normalizedQ = normalizeText(question);
                            qaMap.put(normalizedQ, answer);
                            questions.add(question);
                            
                            // Also add variations
                            addQuestionVariations(question, answer);
                        }
                    }
                }
                reader.close();
                System.out.println("Loaded " + qaMap.size() + " Q&A pairs from database");
            } else {
                System.err.println("QA database file not found!");
            }
        } catch (Exception e) {
            System.err.println("Error loading QA database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void addQuestionVariations(String originalQuestion, String answer) {
        String normalized = normalizeText(originalQuestion);
        
        // Add common variations
        if (normalized.contains("học phí hikari như thế nào")) {
            qaMap.put(normalizeText("Học phí các khóa học như thế nào"), answer);
            qaMap.put(normalizeText("Chi phí học tập ra sao"), answer);
            qaMap.put(normalizeText("Giá khóa học bao nhiêu"), answer);
            qaMap.put(normalizeText("Học phí từng khóa học"), answer);
            qaMap.put(normalizeText("Bảng giá khóa học"), answer);
        }
        
        if (normalized.contains("hikari có những khóa học nào")) {
            qaMap.put(normalizeText("Có những khóa học gì"), answer);
            qaMap.put(normalizeText("Danh sách khóa học"), answer);
            qaMap.put(normalizeText("Các khóa học hiện có"), answer);
        }
        
        if (normalized.contains("jlpt là gì")) {
            qaMap.put(normalizeText("JLPT nghĩa là gì"), answer);
            qaMap.put(normalizeText("Kỳ thi JLPT là gì"), answer);
            qaMap.put(normalizeText("Thi JLPT là như thế nào"), answer);
        }
    }
    
    public String findAnswer(String question) {
        if (question == null || question.trim().isEmpty()) {
            return null;
        }
        
        String normalizedQuestion = normalizeText(question);
        System.out.println("Searching for: " + normalizedQuestion);
        
        // 1. Exact match
        String exactAnswer = qaMap.get(normalizedQuestion);
        if (exactAnswer != null) {
            System.out.println("Found exact match");
            return exactAnswer;
        }
        
        // 2. Enhanced fuzzy matching with synonyms
        String bestMatch = findBestMatchWithSynonyms(normalizedQuestion);
        if (bestMatch != null) {
            System.out.println("Found fuzzy match: " + bestMatch);
            return qaMap.get(bestMatch);
        }
        
        // 3. Enhanced keyword matching
        String keywordMatch = findByEnhancedKeywords(normalizedQuestion);
        if (keywordMatch != null) {
            System.out.println("Found keyword match: " + keywordMatch);
            return qaMap.get(keywordMatch);
        }
        
        System.out.println("No match found");
        return null;
    }
    
    private String normalizeText(String text) {
        return text.toLowerCase()
                  .replaceAll("à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ", "a")
                  .replaceAll("è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ", "e")
                  .replaceAll("ì|í|ị|ỉ|ĩ", "i")
                  .replaceAll("ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ", "o")
                  .replaceAll("ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ", "u")
                  .replaceAll("ỳ|ý|ỵ|ỷ|ỹ", "y")
                  .replaceAll("đ", "d")
                  .replaceAll("[\\s\\p{Punct}]+", " ")
                  .trim();
    }
    
    private String findBestMatchWithSynonyms(String question) {
        double bestScore = 0.0;
        String bestMatch = null;
        
        for (String dbQuestion : qaMap.keySet()) {
            double similarity = calculateEnhancedSimilarity(question, dbQuestion);
            if (similarity > bestScore && similarity > 0.6) { // Lowered threshold
                bestScore = similarity;
                bestMatch = dbQuestion;
            }
        }
        
        return bestMatch;
    }
    
    private double calculateEnhancedSimilarity(String s1, String s2) {
        String[] words1 = s1.split("\\s+");
        String[] words2 = s2.split("\\s+");
        
        Set<String> expandedSet1 = expandWithSynonyms(words1);
        Set<String> expandedSet2 = expandWithSynonyms(words2);
        
        Set<String> intersection = new HashSet<>(expandedSet1);
        intersection.retainAll(expandedSet2);
        
        Set<String> union = new HashSet<>(expandedSet1);
        union.addAll(expandedSet2);
        
        return union.isEmpty() ? 0.0 : (double) intersection.size() / union.size();
    }
    
    private Set<String> expandWithSynonyms(String[] words) {
        Set<String> expanded = new HashSet<>();
        
        for (String word : words) {
            expanded.add(word);
            Set<String> synonyms = synonymMap.get(word);
            if (synonyms != null) {
                expanded.addAll(synonyms);
            }
        }
        
        return expanded;
    }
    
    private String findByEnhancedKeywords(String question) {
        String[] keywords = question.split("\\s+");
        Map<String, Double> matchScores = new HashMap<>();
        
        for (String keyword : keywords) {
            if (keyword.length() < 2) continue;
            
            // Get synonyms for keyword
            Set<String> keywordSet = new HashSet<>();
            keywordSet.add(keyword);
            Set<String> synonyms = synonymMap.get(keyword);
            if (synonyms != null) {
                keywordSet.addAll(synonyms);
            }
            
            for (String dbQuestion : qaMap.keySet()) {
                for (String kw : keywordSet) {
                    if (dbQuestion.contains(kw)) {
                        double score = matchScores.getOrDefault(dbQuestion, 0.0);
                        // Weight important keywords higher
                        double weight = getKeywordWeight(kw);
                        matchScores.put(dbQuestion, score + weight);
                    }
                }
            }
        }
        
        // Find best match
        String bestMatch = null;
        double maxScore = 0.0;
        
        for (Map.Entry<String, Double> entry : matchScores.entrySet()) {
            if (entry.getValue() > maxScore && entry.getValue() >= 1.5) { // Minimum score threshold
                maxScore = entry.getValue();
                bestMatch = entry.getKey();
            }
        }
        
        return bestMatch;
    }
    
    private double getKeywordWeight(String keyword) {
        // Give higher weights to important keywords
        if (keyword.equals("học phí") || keyword.equals("hoc phi") || keyword.equals("chi phí") || keyword.equals("chi phi")) {
            return 2.0;
        }
        if (keyword.equals("khóa học") || keyword.equals("khoa hoc")) {
            return 1.5;
        }
        if (keyword.equals("hikari")) {
            return 1.5;
        }
        if (keyword.matches("n[1-5]")) {
            return 1.5;
        }
        return 1.0;
    }
    
    public List<String> getSuggestedQuestions(int limit) {
        List<String> suggested = new ArrayList<>();
        
        // Prioritize common questions
        String[] commonQuestions = {
            "Hikari có những khóa học nào?",
            "Học phí các khóa học như thế nào?",
            "JLPT là gì?",
            "Cách đăng ký khóa học trên Hikari?",
            "Có mã giảm giá không?"
        };
        
        for (String q : commonQuestions) {
            if (suggested.size() < limit) {
                suggested.add(q);
            }
        }
        
        // Add random questions if needed
        Random random = new Random();
        while (suggested.size() < limit && suggested.size() < questions.size()) {
            String randomQ = questions.get(random.nextInt(questions.size()));
            if (!suggested.contains(randomQ)) {
                suggested.add(randomQ);
            }
        }
        
        return suggested;
    }
    
    public int getQACount() {
        return qaMap.size();
    }
}