package utils;

import java.io.*;
import java.util.*;
import java.util.regex.Pattern;

public class QADatabase {
    private Map<String, String> qaMap;
    private List<String> questions;
    private static QADatabase instance;
    
    private QADatabase() {
        qaMap = new HashMap<>();
        questions = new ArrayList<>();
        loadQADatabase();
    }
    
    public static QADatabase getInstance() {
        if (instance == null) {
            instance = new QADatabase();
        }
        return instance;
    }
    
    private void loadQADatabase() {
        try {
            // Load from classpath or web-inf
            InputStream is = getClass().getClassLoader().getResourceAsStream("qa_database.txt");
            if (is == null) {
                // Fallback to file system
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
                    // Skip comments and empty lines
                    if (line.startsWith("#") || line.isEmpty()) {
                        continue;
                    }
                    
                    // Parse Q: question | A: answer format
                    if (line.startsWith("Q:") && line.contains("|") && line.contains("A:")) {
                        String[] parts = line.split("\\|", 2);
                        if (parts.length == 2) {
                            String question = parts[0].substring(2).trim(); // Remove "Q: "
                            String answer = parts[1].substring(2).trim();   // Remove "A: "
                            
                            qaMap.put(question.toLowerCase(), answer);
                            questions.add(question);
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
    
    public String findAnswer(String question) {
        if (question == null || question.trim().isEmpty()) {
            return null;
        }
        
        String normalizedQuestion = normalizeText(question);
        
        // 1. Exact match
        String exactAnswer = qaMap.get(normalizedQuestion);
        if (exactAnswer != null) {
            return exactAnswer;
        }
        
        // 2. Fuzzy matching - find best match
        String bestMatch = findBestMatch(normalizedQuestion);
        if (bestMatch != null) {
            return qaMap.get(bestMatch);
        }
        
        // 3. Keyword matching
        return findByKeywords(normalizedQuestion);
    }
    
    private String normalizeText(String text) {
        return text.toLowerCase()
                  .replaceAll("[\\s\\p{Punct}]+", " ")
                  .trim();
    }
    
    private String findBestMatch(String question) {
        double bestScore = 0.0;
        String bestMatch = null;
        
        for (String dbQuestion : qaMap.keySet()) {
            double similarity = calculateSimilarity(question, dbQuestion);
            if (similarity > bestScore && similarity > 0.7) { // 70% similarity threshold
                bestScore = similarity;
                bestMatch = dbQuestion;
            }
        }
        
        return bestMatch;
    }
    
    private double calculateSimilarity(String s1, String s2) {
        String[] words1 = s1.split("\\s+");
        String[] words2 = s2.split("\\s+");
        
        Set<String> set1 = new HashSet<>(Arrays.asList(words1));
        Set<String> set2 = new HashSet<>(Arrays.asList(words2));
        
        Set<String> intersection = new HashSet<>(set1);
        intersection.retainAll(set2);
        
        Set<String> union = new HashSet<>(set1);
        union.addAll(set2);
        
        return union.isEmpty() ? 0.0 : (double) intersection.size() / union.size();
    }
    
    private String findByKeywords(String question) {
        String[] keywords = question.split("\\s+");
        Map<String, Integer> matchCounts = new HashMap<>();
        
        for (String keyword : keywords) {
            if (keyword.length() < 3) continue; // Skip short words
            
            for (String dbQuestion : qaMap.keySet()) {
                if (dbQuestion.contains(keyword)) {
                    matchCounts.put(dbQuestion, matchCounts.getOrDefault(dbQuestion, 0) + 1);
                }
            }
        }
        
        // Find question with most keyword matches
        String bestMatch = null;
        int maxMatches = 0;
        
        for (Map.Entry<String, Integer> entry : matchCounts.entrySet()) {
            if (entry.getValue() > maxMatches && entry.getValue() >= 2) { // At least 2 keyword matches
                maxMatches = entry.getValue();
                bestMatch = entry.getKey();
            }
        }
        
        return bestMatch != null ? qaMap.get(bestMatch) : null;
    }
    
    public List<String> getSuggestedQuestions(int limit) {
        List<String> suggested = new ArrayList<>();
        Random random = new Random();
        
        // Get random questions from database
        for (int i = 0; i < Math.min(limit, questions.size()); i++) {
            int randomIndex = random.nextInt(questions.size());
            String question = questions.get(randomIndex);
            if (!suggested.contains(question)) {
                suggested.add(question);
            }
        }
        
        return suggested;
    }
    
    public int getQACount() {
        return qaMap.size();
    }
}
