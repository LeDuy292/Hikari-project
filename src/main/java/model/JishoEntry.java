package model;

import java.util.List;

public class JishoEntry {
    private List<JishoData> data;

    public List<JishoData> getData() {
        return data;
    }

    public void setData(List<JishoData> data) {
        this.data = data;
    }

    public static class JishoData {
        private List<JapaneseWord> japanese;
        private List<Sense> senses;

        public List<JapaneseWord> getJapanese() {
            return japanese;
        }

        public void setJapanese(List<JapaneseWord> japanese) {
            this.japanese = japanese;
        }

        public List<Sense> getSenses() {
            return senses;
        }

        public void setSenses(List<Sense> senses) {
            this.senses = senses;
        }
    }

    public static class JapaneseWord {
        private String word;
        private String reading;

        public String getWord() {
            return word;
        }

        public void setWord(String word) {
            this.word = word;
        }

        public String getReading() {
            return reading;
        }

        public void setReading(String reading) {
            this.reading = reading;
        }
    }

    public static class Sense {
        private List<String> english_definitions;
        private List<String> vietnamese_definitions; // Thêm trường mới
        private List<String> parts_of_speech;

        public List<String> getEnglish_definitions() {
            return english_definitions;
        }

        public void setEnglish_definitions(List<String> english_definitions) {
            this.english_definitions = english_definitions;
        }

        // Thêm getter và setter cho vietnamese_definitions
        public List<String> getVietnamese_definitions() {
            return vietnamese_definitions;
        }

        public void setVietnamese_definitions(List<String> vietnamese_definitions) {
            this.vietnamese_definitions = vietnamese_definitions;
        }

        public List<String> getParts_of_speech() {
            return parts_of_speech;
        }

        public void setParts_of_speech(List<String> parts_of_speech) {
            this.parts_of_speech = parts_of_speech;
        }
    }

    public static class Attribution {
        private boolean jmdict;
        private boolean jmnedict;
        private boolean dbpedia;

        public boolean isJmdict() {
            return jmdict;
        }

        public void setJmdict(boolean jmdict) {
            this.jmdict = jmdict;
        }

        public boolean isJmnedict() {
            return jmnedict;
        }

        public void setJmnedict(boolean jmnedict) {
            this.jmnedict = jmnedict;
        }

        public boolean isDbpedia() {
            return dbpedia;
        }

        public void setDbpedia(boolean dbpedia) {
            this.dbpedia = dbpedia;
        }
    }
}
